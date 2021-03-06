(function($){
  $(document).ready(function(){
    $("[data-remove_taxon]").live('click', function(){
      var search_form = $("form#products_search");
      $.ajax({
               url: "/products.js",
              data: $(search_form).serialize()+"&"+$.param({"without_taxon": $(this).attr("data-remove_taxon")})
            })
      return false;
    });
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

    $("[data-run_search='t']").bind("change", function(){ 
      $('.blogFilters').prepend("<div class='spinner'><img src='/images/icons/spinner.gif' /></div>");
        $(this).parents("form:first").submit(); 
    
    });

    //Logo effect
      $('.cLogo,.otherbutton,.homebutton,.downloadbutton,.donatebutton, .sellbutton').append('<span class="hover"></span>').each(function () {
      		var $span = $('> span.hover', this).css('opacity', 0);
      		$(this).hover(function () {
        		$span.stop().fadeTo(500, 1);
     		}, function () {
       	$span.stop().fadeTo(500, 0);
      		});
    });

    //cros
    $('.cros').click(function() {
        $(this).parent().remove();
        return false;
    });

    //Modal window for sharing links
    $(".modalLink").click(function (e) {
	$.modal("<div>"+$(this).attr('href')+"</div>");
	return false;
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

// this allows culerity to wait until all ajax requests have finished
// jQuery(function($) {
// 	var original_ajax = $.ajax;
// 	var count_down = function(callback) {
// 		return function() {
// 			try {
// 				if(callback) {
// 					callback.apply(this, arguments);
// 				};
// 			} catch(e) {
// 				window.running_ajax_calls -= 1;
// 				throw(e);
// 			}
// 			window.running_ajax_calls -= 1;
// 		};
// 	};
// 	window.running_ajax_calls = 0;

// 	var ajax_with_count = function(options) {
// 		if(options.async == false) {
// 		  return(original_ajax(options));
// 		} else {
// 			window.running_ajax_calls += 1;
// 			options.success = count_down(options.success);
// 			options.error = count_down(options.error);
// 			return original_ajax(options);
// 		}
// 	};

// 	$.ajax = ajax_with_count;
// });
