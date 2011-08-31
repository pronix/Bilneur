$(function(){
    $('#secret_question_secret_question_variant_id').change(function(){
        if ($(this).val() == 5){ $('#own_secret').css('visibility', 'visible') }
        else { $('#own_secret').css('visibility', 'hidden'); $('#own_question').val(''); };
        if ($(this).val() != ''){ $('#div_submit_button').css('visibility', 'visible') }
        else { $('#div_submit_button').css('visibility', 'hidden') };
    });
});
