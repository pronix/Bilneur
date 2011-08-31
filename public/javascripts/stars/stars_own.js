$(function(){
    // Create stars from :radio boxes

    if (!!$("#starify").length) { $("#starify").children().not(":input").hide(); };

    $.map([1,2,3,4,5,6,7,8,9], function(item, i){
      if (!!$("#number"+item).length) {
         $('#number'+item).raty({ scoreName:	'entity.score', number:	5 });
      };
    });

});
