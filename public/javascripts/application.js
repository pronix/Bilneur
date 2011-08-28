(function($){
  $(document).ready(function(){
    $("button[name='to_add'][value='virtual_store']").live('click', function(){
      var form = $(this).parents("form:first");
      $(form).find("input.js-field").remove();
      $(form).append("<input type='hidden' name='to_add' value='virtual_store' class='js-field'>");
    });

    $("button[name='to_add'][value='cart']").live('click', function(){
      var form = $(this).parents("form:first");
      $(form).find("input.js-field").remove();
      $(form).append("<input type='hidden' name='to_add' value='cart' class='js-field'>");
    });

   $(".cart-form").live('ajax:loading', function(event, xhr, settings) {

    });

    $("[data-run_search='t']").bind("change", function(){ $(this).parents("form:first").submit(); })

    //Logo effect
      $('.cLogo,.otherbutton,.homebutton,.downloadbutton,.donatebutton, .sellbutton').append('<span class="hover"></span>').each(function () {
      		var $span = $('> span.hover', this).css('opacity', 0);
      		$(this).hover(function () {
        		$span.stop().fadeTo(500, 1);
     		}, function () {
       	$span.stop().fadeTo(500, 0);
      		});
    });


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
