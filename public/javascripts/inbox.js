function test_func(){
        $(".message_container").show();  
        $(".replyer").hide();
};

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
