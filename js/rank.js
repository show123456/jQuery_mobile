

$(document).on('pageshow', '#rank', function(e, d) {
    $(".menu-ranking").addClass("ui-btn-active");
 
    $(".open-panel").click(function() {
        if ($(this).attr("href") == null) {
            var panel = "#" + $(this).parents().siblings("[data-role=panel]").attr("id");
            $(this).attr("href", panel);
        }
        $(this).trigger("click");
    });

    $(".menu-favorite").click(function() {
        location.href = "/#search?fav";
    });  

    $(".go-top-btn").click(function() {
         $('body, html').animate({scrollTop: 0}, 500);
    });

    $(".menu-logout").click(function(){
        location.replace("/out");
    });
});



// ajax loading 이미지 시작
function loadingIconStart() {
    $.mobile.loading("show", {
        text: "잠시만 기다려주세요",
        textVisible: true,
        theme: "b",
        html: ""
    });
}

// ajax loading 이미지 종료
function loadingIconEnd() {
    $.mobile.loading("hide");
}