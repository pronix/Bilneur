$(document).ready(function(){
  $('.cLogo,.otherbutton,.homebutton,.downloadbutton,.donatebutton, .sellbutton').append('<span class="hover"></span>').each(function () {
    		var $span = $('> span.hover', this).css('opacity', 0);
    		$(this).hover(function () {
      		$span.stop().fadeTo(500, 1);
   		}, function () {
     	$span.stop().fadeTo(500, 0);
    		});
  });
});
