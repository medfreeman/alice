$(document).on('ready page:load',function(){
	$('.post-body').each(function(){
		var $this = $(this);
		$this.lightGallery({
			selector: $this.find('.lightgallery'),
			lang: {
          allPhotos: 'All images'
      },
      thumbnail: true,
      zoom: true,
      fullscreen: true,
      exThumbImage: 'data-responsive-src'
		});
	});
});