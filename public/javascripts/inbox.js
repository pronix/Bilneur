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
});

// $('.action_link').click(function() {
//     alert('dasdsada');
//     var multi = $(this).attr('value');
//     var state = $("stater").attr('value');
//     $("input[name=multi]").val(multi);
//     $("multi_form").submit();
// });



// $(document).ready(function(){
//     $("#reply_1").click(function(){ 
//         alert('aaaa');
//         // $(".message_container").show();  
//         // $(".replyer").hide();
//         // return false;
//     });
//     $("#websites21").change(function() {
//       if ($(this).val() != "nothing") {
//         $.ajax({ type: "POST", url: "<%= multi_dashboard_messages_path %>" + "?multi=" + $(this).val() + "&message_ids=" + "<%= @message.id %>" });
//       }
//     });
// });
