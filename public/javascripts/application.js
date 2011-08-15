(function($){
  $(document).ready(function(){

    // Remove an item from the cart by setting its quantity to zero and posting the update form
    $('form#updatecart a.delete').show().live('click', function(e){
      $(this).parents('tr').find('input.line_item_quantity').val(0);
      $(this).parents('form').submit();
      e.preventDefault();
    });

    // Remove an item from the cart by setting its quantity to zero and posting the update form
    $('form#virtual-updatecart a.delete').show().live('click', function(e){
      $(this).parents('tr').find('input.line_item_quantity').val(0);
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
