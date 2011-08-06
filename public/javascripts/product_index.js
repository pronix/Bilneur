$(document).ready(function(){
  try {
    $("#websites2").msDropDown({mainCSS:'dd2'});
    //alert($.msDropDown.version);
    //$.msDropDown.create("body select");
    $("#ver").html($.msDropDown.version);
    } catch(e) {
      alert("Error: "+e.message);
    }

  try {
    $("#websites1").msDropDown({mainCSS:'dd2'});
    //alert($.msDropDown.version);
    //$.msDropDown.create("body select");
    $("#ver").html($.msDropDown.version);
    } catch(e) {
      alert("Error: "+e.message);
    }

  try {
    $("#websites3").msDropDown({mainCSS:'dd2'});
    //alert($.msDropDown.version);
    //$.msDropDown.create("body select");
    $("#ver").html($.msDropDown.version);
    } catch(e) {
      alert("Error: "+e.message);
    }

  try {
    $("#websites20").msDropDown({mainCSS:'dd2'});
    //alert($.msDropDown.version);
    //$.msDropDown.create("body select");
    $("#ver").html($.msDropDown.version);
    } catch(e) {
      alert("Error: "+e.message);
    }

  $(".radio").dgStyle();
  $(".checkbox").dgStyle();

  var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");

  var CollapsiblePanel1 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel1");
  var CollapsiblePanel2 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel2");
  var CollapsiblePanel3 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel3");
  var CollapsiblePanel4 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel4");
  var CollapsiblePanel5 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel5");
  var CollapsiblePanel6 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel6");
  var CollapsiblePanel7 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel7");
  var CollapsiblePanel8 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel8");
  var CollapsiblePanel9 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel9");
  var CollapsiblePanel10 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel10");
  var CollapsiblePanel11 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel11");
  var CollapsiblePanel12 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel12");
})
