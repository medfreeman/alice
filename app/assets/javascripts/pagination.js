$(document).ready(function(){
	$(document).on('scroll', function(){
		if(window.scrollY + window.innerHeight >= $(document).height() - 200 ){
			addNext();
		}
	});

	$(document, '.pagination .next a').on('click', addNext);
	var fetching = false;
	var addNext = function(){
		var nextUrl = $('.pagination .next a').attr('href');
		if(nextUrl && !fetching)
		{
			fetching = true;
			$.ajax({
				url: nextUrl,
				success: function(data){
					$('.pagination').remove();
					var more = $('.main.post-list', data).children();
					
					more.appendTo($('.main.post-list'));
					ALICE.apply(more);
					fetching = false;
				},
				error: function(){
					fetching = false;
				}
			})
		}
	}

});