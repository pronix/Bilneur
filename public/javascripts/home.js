$(document).ready(function(){
  var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");
  $('#carousel').infiniteCarousel({imagePath: '/images/infinitecarousel/images/'});
  $('.cLogo,.otherbutton,.homebutton,.downloadbutton,.donatebutton, .sellbutton').append('<span class="hover"></span>').each(function () {
    		var $span = $('> span.hover', this).css('opacity', 0);
    		$(this).hover(function () {
      		$span.stop().fadeTo(500, 1);
   		}, function () {
     	$span.stop().fadeTo(500, 0);
    		});
  });

});
