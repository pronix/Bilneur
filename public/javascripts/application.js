(function($){
  $(document).ready(function(){


    // Remove an item from the cart by setting its quantity to zero and posting the update form
    $('form#normal-updatecart a.delete').show().live('click', function(e){
      $(this).parent().find('input.txt').val(0);
      $(this).parents('form').submit();
      e.preventDefault();
    });

    // Remove an item from the cart by setting its quantity to zero and posting the update form
    $('form#virtual-updatecart a.delete').show().live('click', function(e){
      $(this).parent().find('input.txt').val(0);
      $(this).parents('form').submit();
      e.preventDefault();
    });



    // for search select category dropdown list
    try {
    $("#search_select_category").msDropDown({mainCSS:'dd2'});
    $("#ver").html($.msDropDown.version);
    } catch(e) {
      alert("Error: "+e.message);
    }

  });
})(jQuery);
