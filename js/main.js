// page main 시작
$(document).on('pageinit', '#main', function(e, data) {
    tagCloudSetting();
}).on('pageshow', '#main', function(e, data) {
    $(".menu-main").addClass("ui-btn-active"); // 패널 버튼 활성화
    maintxt = "";
    tagCloudSetting();

    // 메인 검색창 포커스
    $("#main-search-text").on("tap", function() {
        $(this).val("");
        $(".help-word").hide();
        $("html, body").animate({
            scrollTop: $(window).height()
        }, 500);
    });
    // 메인 검색버튼
    $("#main-search-btn").click(function() {
        maintxt = $("#main-search-text").val().trim();
        if (maintxt != "") {
            $(".help-word").hide();
            $.mobile.changePage("/#search");
        } else {
            $(".help-word").show();
            $("#main-search-text").focus();
        }
    });

    // 즐겨찾기 버튼
    $(".menu-favorite").click(function() {
        location.href = "/#search?fav";
        $(".menu-search").addClass("ui-btn-active");
    });

    $(".menu-logout").click(function(){
        location.replace("/out");
    });

}).on('pagehide', '#main', function(e, data) {
    $(".menu-main").removeClass("ui-btn-active"); // 패널 버튼 비활성화
});

function tagCloudSetting() {
    $.fn.tagcloud.defaults = {
        size: {
            start: 13,
            end: 30,
            unit: 'px'
        },
        color: {
            start: '#FFFF00',
            end: '#336666'
        }
    };
    $("#tagcloud a").tagcloud();
}
