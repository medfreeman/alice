ALICE.attach(function(context){
	$('.post-body', context).each(function(){
		var $this = $(this);
		$this.lightGallery({
			selector: $this.find('.lightgallery'),
			lang: {
          allPhotos: 'All images'
      },
      zoom: true,
      fullscreen: true,
      thumbnail: true,
      showThumbByDefault: false,
      exThumbImage: 'data-responsive-src'
		});
	});
});