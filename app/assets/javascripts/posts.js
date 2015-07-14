$(document).on('ready page:load',function(){
		$('.post-body').lightGallery({
			selector: '.lightgallery',
			mode: 'fade',
			lang: {
          allPhotos: 'All images'
      },
		});
});