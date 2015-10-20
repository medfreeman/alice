//= require froala/js/froala_editor.min.js
//= require froala/js/plugins/inline_styles.min.js
//= require froala/js/plugins/block_styles.min.js
//= require froala/js/plugins/inline_styles.min.js
//= require froala/js/plugins/lists.min.js
//= require froala/js/plugins/tables.min.js
//= require froala/js/plugins/video.min.js

$.Editable.prototype.insertLoadedImage = function(b, response) {
    this.triggerEvent("imageLoaded", [b], !1), this.processInsertImage(b, $.parseJSON(response), !1), this.browser.msie && this.$element.find("img").each(function(a, b) {
        b.oncontrolselect = function() {
            return !1
        }
    }), this.enable(), this.hide(), this.hideImageLoader(), this.wrapText(), this.cleanupLists();
    var d, e = this.$element.find("img.fr-just-inserted").get(0);
    e && (d = e.previousSibling), d && 3 == d.nodeType && /\u200B/gi.test(d.textContent) && a(d).remove(), this.triggerEvent("imageInserted", [this.$element.find("img.fr-just-inserted"), response]), setTimeout($.proxy(function() {
        this.$element.find("img.fr-just-inserted").removeClass("fr-just-inserted").trigger("touchend")
    }, this), 50)
};
$.Editable.prototype.processInsertImage = function(b, response, c) {
	void 0 === c && (c = !0), this.enable(), this.focus(), this.restoreSelection();
	var d = "";
	parseInt(this.options.defaultImageWidth, 10) && (d = ' width="' + this.options.defaultImageWidth + '"');
	var e = "fr-fin";
	"left" == this.options.defaultImageAlignment && (e = "fr-fil"), "right" == this.options.defaultImageAlignment && (e = "fr-fir"), e += " fr-di" + this.options.defaultImageDisplay[0];
	console.log("response:", response);
	var f = '<p> \
		<div class="image-wrapper"> \
			<img data-responsive-src="' + response.mobile + '" data-src="' + response.xlarge + '" class="lightgallery" class="' + e + ' fr-just-inserted lightgallery" alt="' + this.options.defaultImageTitle + '" src="' + b + '"' + d + '"> \
			<a class="link-to-original" href="' + response.original + '" target="_blank" title="See original"><i class=" fa icon zoom"></i></a> \
		</div> \
	</p>',
	g = this.getSelectionElements()[0],
	h = this.getRange(),
	i = !this.browser.msie && $.Editable.getIEversion() > 8 ? a(h.startContainer) : null;
	i && i.hasClass("f-img-wrap") ? (1 === h.startOffset ? (i.after("<" + this.options.defaultTag + '><span class="f-marker" data-type="true" data-id="0"></span><br/><span class="f-marker" data-type="false" data-id="0"></span></' + this.options.defaultTag + ">"), this.restoreSelectionByMarkers(), this.getSelection().collapseToStart()) : 0 === h.startOffset && (i.before("<" + this.options.defaultTag + '><span class="f-marker" data-type="true" data-id="0"></span><br/><span class="f-marker" data-type="false" data-id="0"></span></' + this.options.defaultTag + ">"), this.restoreSelectionByMarkers(), this.getSelection().collapseToStart()), this.insertHTML(f)) : this.getSelectionTextInfo(g).atStart && g != this.$element.get(0) && "TD" != g.tagName && "TH" != g.tagName && "LI" != g.tagName ? $(g).before("<" + this.options.defaultTag + ">" + f + "</" + this.options.defaultTag + ">") : this.insertHTML(f), this.disable()
}

$(document).on('ready page:load',function(){
	var csrf_token = $('meta[name="csrf-token"]').attr('content');
	var buttons = ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'sep', 'createLink', 'sep', 'formatBlock', 'blockStyle', 'sep',  'insertUnorderedList', 'sep', 'insertImage', 'insertVideo', 'uploadFile', 'sep', 'html']
	$('.froala').editable({
		inlineMode: false,
		plainPaste: true,
		blockTags: {
			normal: "p",
			h2: "h2",
			h3: "h3",
			h4: "h4",
		},
		blockStyles: {
			'p': {
				'caption': 'image caption',
			}
		},
		alwaysBlank: true,
		paragraphy: false,
		placeholder: "Edit Me!",
		imageLink: true,
		imageUploadURL: "/upload",
		fileUploadURL: "/upload",
		spellcheck: true,
		pasteImage:true ,
		imageMove: true,
		imageButtons: ['display', 'linkImage', 'replaceImage', 'removeImage'],
		paragraphy: true,
		defaultImageTitle: "Image " + new Date(),
		defaultImageWidth: "80%",
		headers: {
			'X-CSRF-Token': csrf_token
		},
		buttons: buttons,
		height: 300,
	})
	.on('editable.fileError editable.imageError', function (e, editor, error) {
		console.log(error);
		if(error.message.file){
			alert("Error uploading file: "+error.message.file[0]+"\n Please send along console log if you request support.");
		}
		else{
						alert("Error uploading file: "+error.message+"\n Please send along console log if you request support.");
		}
	});

	function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $('.form-image-thumb').attr('src', e.target.result);
        }
        reader.readAsDataURL(input.files[0]);
    }
	}
	$(".image-input").change(function(){
	    readURL(this);
	});

	// Prepare form for studio selection
	$('.post-year .dropdown').dropdown({
		action: 'activate',
		onChange: displayStudioInput,
	});
	$('.post-studio').hide()
	function displayStudioInput(value, text, $selectedItem){
		$('.post-studio').hide();
		$('#year-'+value).show();
	}
	$('form.post').one('submit', function(e){
		e.preventDefault();
		$('.post-studio:not(:visible)').remove();
		$(this).submit();
	});
});