$(document).ready(function(){
  var galleries = $('.ad-gallery').adGallery();
  $('#switch-effect').change(
    function() {
      galleries[0].settings.effect = $(this).val();
      return false;
    }
  );
  $('#toggle-slideshow').click(
    function() {
      galleries[0].slideshow.toggle();
      return false;
    }
  );
  galleries[0].addAnimation('wild',
    function(img_container, direction, desc) {
      var current_left = parseInt(img_container.css('left'), 10);
      var current_top = parseInt(img_container.css('top'), 10);
      if(direction == 'left') {
        var old_image_left = '-'+ this.image_wrapper_width +'px';
        img_container.css('left',this.image_wrapper_width +'px');
        var old_image_top = '-'+ this.image_wrapper_height +'px';
        img_container.css('top', this.image_wrapper_height +'px');
      } else {
        var old_image_left = this.image_wrapper_width +'px';
        img_container.css('left','-'+ this.image_wrapper_width +'px');
        var old_image_top = this.image_wrapper_height +'px';
        img_container.css('top', '-'+ this.image_wrapper_height +'px');
      };
      if(desc) {
        desc.css('bottom', '-'+ desc[0].offsetHeight +'px');
        desc.animate({bottom: 0}, this.settings.animation_speed * 2);
      };
      img_container.css('opacity', 0);
      return {old_image: {left: old_image_left, top: old_image_top, opacity: 0},
              new_image: {left: current_left, top: current_top, opacity: 1},
              easing: 'easeInBounce',
              speed: 2500};
    }
  );
  
  try{
    $(".sort_by_most_recent").msDropDown({mainCSS:'dd2'});
    $("#ver").html($.msDropDown.version);
  } catch(e) {
    alert("Error: "+e.message);
  }


  $(".CollapsiblePanel").each(function() {
    var CollapsiblePanel = new Spry.Widget.CollapsiblePanel($(this).attr('id'));
  });

  var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");
  var TabbedPanels2 = new Spry.Widget.TabbedPanels("TabbedPanels2");
});
