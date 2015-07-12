//= require froala/js/froala_editor.min.js
//= require froala/js/plugins/inline_styles.min.js
//= require froala/js/plugins/block_styles.min.js
//= require froala/js/plugins/lists.min.js
//= require froala/js/plugins/tables.min.js
//= require froala/js/plugins/video.min.js

$(document).on('ready page:load',function(){
	var csrf_token = $('meta[name="csrf-token"]').attr('content');
	var buttons = ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'sep', 'createLink', 'sep', 'formatBlock', 'sep',  'insertUnorderedList', 'sep', 'insertImage', 'insertVideo', 'uploadFile', 'sep', 'html']
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
	      'image-caption': 'image caption',
		  }
		},
		alwaysBlank: true,
		paragraphy: false,
		placeholder: "Edit Me!",
		imageUploadURL: "/upload",
		fileUploadURL: "/upload",
		spellcheck: true,
		pasteImage:true ,
		imageLink: true,
		imageMove: true,
		paragraphy: true,
		defaultImageTitle: "Image " + new Date(),
		headers: {
			'X-CSRF-Token': csrf_token
		},
		buttons: buttons,
		height: 300,
	}).on('editable.fileError editable.imageError', function (e, editor, error) {
		console.log(error);
		alert("Error uploading file... Please send along console log if you request support.");
	});
})