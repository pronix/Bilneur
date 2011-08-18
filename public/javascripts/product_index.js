$(document).ready(function(){

  $(".radio").dgStyle();
  $(".checkbox").dgStyle();

  var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");

  $(".CollapsiblePanel").each(function() {
    var CollapsiblePanel = new Spry.Widget.CollapsiblePanel($(this).attr('id'));
  });
})
