$(document).ready(function(){

  $(".radio").dgStyle();
  $(".checkbox").dgStyle();
  
  $(".qty_chooser input").change(function() {
    var avl = $(this).parent().children('.avla').text();
    if (parseInt($(this).val()) > parseInt(avl)) {
      $(this).val(avl);
    }
  });
  //var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");

  $(".CollapsiblePanel").each(function() {
    var CollapsiblePanel = new Spry.Widget.CollapsiblePanel($(this).attr('id'));
  });
  
});
