(function($){
  $(document).ready(function(){

    $(".radio").dgStyle();	
    $(".checkbox").dgStyle();
    $('#checkout_form_address').validate();

    try {
    $("#websites1").msDropDown({mainCSS:'dd2'});
    $("#ver").html($.msDropDown.version);
    } catch(e) {
    	alert("Error: "+e.message);
    }
    try {
    $("#websites2").msDropDown({mainCSS:'dd2'});
    $("#ver").html($.msDropDown.version);
    } catch(e) {
    	alert("Error: "+e.message);
    }
    try {
    $("#websites3").msDropDown({mainCSS:'dd2'});
    $("#ver").html($.msDropDown.version);
    } catch(e) {
    	alert("Error: "+e.message);
    }
    try {
    $("#websites4").msDropDown({mainCSS:'dd2'});
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

    var get_states = function(region){
      var country  = $('#' + (region == 's' ? 'ship_address' : 'bill_address') + '_country' + ' select:only-child').val();
      return state_mapper[country];
    }

    var update_state = function(region) {
      var states         = get_states(region);

      var state_select = $('#' + (region == 's' ? 'ship_address' : 'bill_address') + 'state select');
      var state_input = $('#' + (region == 's' ? 'ship_address' : 'bill_address') + 'state input');
      if(states) {
        var selected = state_select.val();
        state_select.html('');
        var states_with_blank = [["",""]].concat(states);
        $.each(states_with_blank, function(pos,id_nm) {
          var opt = $(document.createElement('option'))
                    .attr('value', id_nm[0])
                    .html(id_nm[1]);
          if(selected==id_nm[0]){
            opt.attr('selected', 'selected');
          }
          state_select.append(opt);
        });
        state_select.removeAttr('disabled').show();
        state_input.hide().attr('disabled', 'disabled');

      } else {
        state_input.removeAttr('disabled').show();
        state_select.hide().attr('disabled', 'disabled');
      }

    };

    // Show fields for the selected payment method
    $("input[type='radio'][name='order[payments_attributes][][payment_method_id]']").click(function(){
      $('#payment-methods li').hide();
      if(this.checked){ $('#payment_method_'+this.value).show(); }
    }).triggerHandler('click');

    $('p#bcountry span#bcountry select').change(function() { update_state('b'); });
    $('p#scountry span#scountry select').change(function() { update_state('s'); });

    $('#ship_address_country select').change(function() { update_state('s'); });
    update_state('b');
    update_state('s');

    $('input#order_use_billing').click(function() {
      if($(this).is(':checked')) {
        $("#shipping .inner input").attr('disabled', 'disabled');
        $("#shipping .inner select").attr('disabled', 'disabled');
        $("#shipping .inner").fadeOut();
        $("#shipping .select_address").fadeOut();
      } else {
        if ($("input[name='order[ship_address_id]']:checked").val() == '0') {
          $("#shipping .inner input").removeAttr('disabled');
          $("#shipping .inner select").removeAttr('disabled');
          $("#shipping .inner").fadeIn();
        }
        $("#shipping .select_address").fadeIn();
      }
    }).triggerHandler('click');

    $('form.edit_checkout').submit(function() {
      $(this).find(':submit, :image').attr('disabled', true).removeClass('primary').addClass('disabled');
    });


  });
})(jQuery);
