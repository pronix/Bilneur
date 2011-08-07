$(document).ready(function() {
  var TabbedPanels2 = new Spry.Widget.TabbedPanels("TabbedPanels2");

  if($("div.loginTabs").attr("signup") == "true"){
    TabbedPanels2.showPanel(1);
  }
  else{
    TabbedPanels2.showPanel(0);
  }
})
