$(document).ready(function(){
	var csrf_token = $('meta[name="csrf-token"]').attr('content');
	var buttons = ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'sep', 'createLink', 'sep', 'formatBlock', 'blockStyle', 'sep',  'insertUnorderedList', 'sep', 'insertImage', 'insertVideo', 'uploadFile', 'sep', 'html']
	$('.froala').editable({
		inlineMode: false,
		plainPaste: true,
		blockTags: {
			normal: "p",
			h1: "h1",
			h2: "h2", 
			h3: "h3", 
			h4: "h4",
		},
		blockStyles: {
	    'p': {
	      'columns-2': '2 columns',
		  }
		},
		useFrTag: true,
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