var maintxt = "";
var mobile = (/iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase()));
var markerImage = '/images/marker/marker9.png';
var markerKMImage = '/images/marker/markerKM.png';
/* Daum 이미지 검색 api */
var key = 'a1e3e6b58fb16d30a47947eca5a81756';
var target = 'image';
var url = 'https://apis.daum.net/search/';

// 전체 시작
$(document).ready(function() {
    // 패널열기
    $(".open-panel").click(function() {
        if ($(this).attr("href") == null) {
            var panel = "#" + $(this).parents().siblings("[data-role=panel]").attr("id");
            $(this).attr("href", panel);
        }
        $(this).trigger("click");
    });

    // 맨위로
    $(".go-top-btn").click(function() {
        scrollFavTop();
    });

    // 즐겨찾기 리스트 길게 클릭 삭제
    $('#favorite-list .ui-list-li .a-contents').longpress(function() {
        var idx = $(this).attr("value");
        delFavorite(idx, $(this));
    });
});
// 구글맵 높이 조절
$(window).resize(function() {
    resizeMap();
    $('#map_canvas_nav').css("height", $(window).height() - $(".ui-header").height());
});
