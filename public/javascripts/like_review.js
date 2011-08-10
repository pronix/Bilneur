jQuery(function($){
    $(function(){
        $('.like_review').click(function(event){
            var params = {id:$(this).attr("id")}
            $.ajax({
                type: "POST",
                url: 'like_review' + '?' + jQuery.param(params),
                success: function(){
                    $('.recomends_count').html(parseInt($('.recomends_count').html())+1);
                }
               });
            $(this).remove();
        });
    });
});


