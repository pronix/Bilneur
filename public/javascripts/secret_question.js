jQuery(function($){
    $(function(){
        $('#secret_question_secret_question_variant_id').change(function(){
            if ($(this).val() == 5){ $('#own_question_div').css("display", "block") }
            else { $('#own_question_div').css("display", "none"); $('#own_question').val(''); };
        });
    });
});
