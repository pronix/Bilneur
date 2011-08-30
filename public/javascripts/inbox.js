$(function(){
    $('.reply-link').click(function(){
        $(".message_container").show();  
        $(".replyer").hide();
    });

    $('.action_link').click(function() { 
        var multi = $(this).attr('value');
        var state = $("stater").attr('value');
        $("input[name=multi]").val(multi);
        $("#multi_form").submit();
    });
    
    $("#websites21").change(function() {
      if ($(this).val() != "nothing") {
        $.ajax({ type: "POST", url: "/dashboard/inbox/multi" + "?multi=" + $(this).val() + "&message_ids=" + $(this).attr('name') });
      }
    });

});
