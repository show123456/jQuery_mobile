/* 검색 */
var search = {
    search: 1
};
// page search 시작
$(document).on('pageshow', '#search', function(e, d) {
    $(".menu-search").addClass("ui-btn-active");

    // page main -> 자동검색
    if (maintxt == "") {
        $("#search-text").val("");
        startMap();
        setTimeout(function() {
            $('#map_canvas').gmap('refresh');
            favoriteListScroll(); // 즐겨찾기 리스트 이동
        }, 100);
    } else {
        setTimeout(function() {
            startMap();
            $('#map_canvas').gmap('refresh');
            $("#search-text").val(maintxt);
            $("#search-btn").trigger("click");
            maintxt = "";
        }, 100);
    }

    resizeMap(); // 구글맵 높이 조절

    // 검색버튼
    $("#search-btn").click(function() {
        $("#search-text").blur();
        var term = $("#search-term :radio:checked").val();
        var txt = $("#search-text").val();
        if (txt.trim() != "") {
            search = {
                search: txt,
                term: term
            };
            $('#map_canvas').gmap('refresh');
            $('#map_canvas').gmap('clear', 'markers').bind('init', start());
        } else {
            $("#search-text").val("").focus();
            alert("검색어를 입력해주세요.");
        }
    });

    // 맵 초기화
    $("#refresh-map").click(function() {
        startMap();
    });

    // 패널 즐겨찾기 클릭
    $(".menu-favorite").click(function() {
        $("html, body").animate({
            scrollTop: $("#favorite-start").offset().top
        }, 500);
        $("#panel-search").panel("close");
    });

    if (mobile == false) {
        $('#map_wrap').resizable({
            handles: {
                's': '#sgrip'
            },
            resize: function(e, ui) {
                var h = $('#map_wrap').height();
                $("#map_canvas").css("height", h).gmap('refresh');
            }
        }).css("height", $("#map_canvas").height());
    } else {
        $("#sgrip").hide();
    }

    $(".menu-logout").click(function(){
        if(LType == "kakao"){
            Kakao.init('6b7a303f87c64aea009208da73740865');
            Kakao.Auth.logout();
        }
        location.replace("/out");
    });

}).on('pagehide', '#search', function(e, data) {
    $(".menu-search").removeClass("ui-btn-active"); // 패널 버튼 비활성화
    maintxt = ""; // 검색어 초기화
});

// 검색 시작
function start() {
    loadingIconStart();
    $.ajax({
        url: "/ac/search/search-db.jsp",
        dataType: "json",
        data: search,
        success: function(data) {
            var rec = data.records;
            if (rec == null) {
                alert("검색결과가 없습니다.");
            } else {
                $.each(rec, function(index, item) {
                    var btnGroup = "<div class='map-btn-group'>";
                    var appStart = "<a class='ui-btn app-start-btn' onclick='appStart(\"" + item.address + "\");' data-role='button'>어플검색</a>";
                    var favoriteBtn = "<a class='ui-btn favorite-btn' onclick='favor(" + item.idx + ");' data-role='button'>즐겨찾기</a>";
                    var naverSearch = "<a class='ui-btn naver-search-btn' onclick='naverSearch(\"" + item.shopname + "\",\"" + item.address + "\");'><img class='naver' src='/images/logo/naver.png'/></a>";
                    var googleSearch = "<a class='ui-btn google-search-btn' onclick='googleSearch(\"" + item.shopname + "\",\"" + item.address + "\");'><img class='google' src='/images/logo/google.png'/></a>";
                    var daumSearch = "<a class='ui-btn daum-search-btn' onclick='daumSearch(\"" + item.shopname + "\",\"" + item.address + "\");'><img class='daum' src='/images/logo/daum.png'/></a>";
                    var callBtn = "<a class='ui-btn call-btn' href='tel:" + item.tel + "'>전화걸기</a>";
                    var hiddenIdx = "<input type='hidden' id='fav" + item.idx + "' value='" + item.idx + "'/>";
                    var thumbnailImage = "<img class='thumbnail-image' />";
                    var blogGroup = '<div class="blog-btn-group">';
                    var food = "<br/>[" + item.food + "]";
                    if (item.food == null) {
                        food = "";
                    }

                    btnGroup += favoriteBtn + callBtn + appStart + hiddenIdx + "</div>";
                    blogGroup += naverSearch + daumSearch + googleSearch + "</div>";
                    var dlg = "<table class='map-table'>";
                    dlg += "	<tr><td><a class='href-view' href='javascript:location.href=\"/view/" + item.idx + "\"'><h1 class='title'>" + item.shopname + "</h1></a><span class='type'>" + food + "</span></td><td rowspan='3'>" + thumbnailImage + "</td></tr>";
                    dlg += "	<tr><td><div class='tel'>" + item.tel + "</div></td></tr>";
                    dlg += "	<tr><td><div class='addr'>" + item.address + "</div></td></tr>";
                    dlg += "	<tr><td colspan='2'>" + btnGroup + "</td></tr>";
                    dlg += "	<tr><td colspan='2'>" + blogGroup + "</td></tr>";
                    dlg += "</table>";

                    $('#map_canvas').gmap('addMarker', {
                        'position': new google.maps.LatLng(item.latitude, item.longitude),
                        'bounds': true,
                        'icon': markerImage
                    }).click(function() {
                        $('#map_canvas').gmap('openInfoWindow', {
                            'content': dlg
                        }, this);
                        thumbnail("\"" + item.shopname + "\"", "\"" + item.address + "\"");
                    });
                    if (index > 500) {
                        return false;
                    }
                });
                scrollTop();
            }
            loadingIconEnd();
        },
        error: function(data) {
            alert(JSON.stringify(data));
            loadingIconEnd();
        }
    });
}

// 즐겨찾기 추가 버튼
function favor(idx) {
    if (confirm("즐겨찾기에 추가하시겠습니까?")) {
        $.ajax({
            url: "/ac/favorite/favorite.jsp",
            data: "idx=" + $("#fav" + idx).val(),
            type: "POST",
            success: function(data) {
                var item = JSON.parse(data);
                if (item.shopname != null) {
                    $("#favorite-list").prepend("<li id='favorite-" + item.idx + "' class='ui-list-li'><a class='a-contents' value='" + idx + "' onclick='marker(" + idx + ");''><div class='list-1'><span class='list-title'>" + item.shopname + "</span></div><div class='list-2'><span class='list-addr'>" + item.address + "</span><br/><span class='list-tel'>" + item.tel + "</span></div></a><a href='tel:" + item.tel + "' class='ui-btn ui-icon-phone'>Call</a></li>").listview('refresh');
                    $("#favorite-list li:first").fadeTo('slow', 0.5).fadeTo('slow', 1.0);
                    scrollBottom(item.idx);
                } else {
                    alert("이미 추가된 맛집입니다.");
                }

            },
            error: function(data) {
                alert("즐겨찾기 등록 실패" + data);
            }
        });
    } else {
        return false;
    }
}

// 구글맵 마커 찍기
function marker(idx) {
    scrollTop();
    $('#map_canvas').gmap('clear', 'markers');
    $.ajax({
        url: "/ac/search/data.jsp",
        data: "idx=" + idx,
        type: "POST",
        success: function(data) {
            var item = JSON.parse(data);
            if (item.idx != null) {
                var pos = new google.maps.LatLng(item.latitude, item.longitude);

                var btnGroup = "<div class='map-btn-group'>";
                var appStart = "<a class='ui-btn app-start-btn' onclick='appStart(\"" + item.address + "\");'>어플검색</a>";
                var favoriteBtn = "<a class='ui-btn favorite-btn' onclick='favor(" + item.idx + ");'>즐겨찾기</a>";
                var naverSearch = "<a class='ui-btn naver-search-btn' onclick='naverSearch(\"" + item.shopname + "\",\"" + item.address + "\");'><img class='naver' src='/images/logo/naver.png'/></a>";
                var googleSearch = "<a class='ui-btn google-search-btn' onclick='googleSearch(\"" + item.shopname + "\",\"" + item.address + "\");'><img class='google' src='/images/logo/google.png'/></a>";
                var daumSearch = "<a class='ui-btn daum-search-btn' onclick='daumSearch(\"" + item.shopname + "\",\"" + item.address + "\");'><img class='daum' src='/images/logo/daum.png'/></a>";
                var callBtn = "<a class='ui-btn call-btn' href='tel:" + item.tel + "'>전화걸기</a>";
                var hiddenIdx = "<input type='hidden' id='fav" + item.idx + "' value='" + item.idx + "'/>";
                var thumbnailImage = "<img class='thumbnail-image' />";
                var blogGroup = '<div class="blog-btn-group">';
                var food = "<br/>[" + item.food + "]";
                if (item.food == null) {
                    food = "";
                }

                btnGroup += favoriteBtn + callBtn + appStart + hiddenIdx + "</div>";
                blogGroup += naverSearch + daumSearch + googleSearch + "</div>";
                var dlg = "<table class='map-table'>";
                dlg += "	<tr><td><a class='href-view' href='javascript:location.href=\"/view/" + item.idx + "\"'><h1 class='title'>" + item.shopname + "</h1></a><span class='type'>" + food + "</span></td><td rowspan='3'>" + thumbnailImage + "</td></tr>";
                dlg += "	<tr><td><div class='tel'>" + item.tel + "</div></td></tr>";
                dlg += "	<tr><td><div class='addr'>" + item.address + "</div></td></tr>";
                dlg += "	<tr><td colspan='2'>" + btnGroup + "</td></tr>";
                dlg += "	<tr><td colspan='2'>" + blogGroup + "</td></tr>";
                dlg += "</table>";

                $('#map_canvas').gmap('addMarker', {
                    'position': pos,
                    'bounds': true,
                    'icon': markerImage
                }).click(function() {
                    $('#map_canvas').gmap('openInfoWindow', {
                        'content': dlg
                    }, this);
                    thumbnail("\"" + item.shopname + "\"", "\"" + item.address + "\"");
                }).triggerEvent('click');
                $('#map_canvas').gmap('option', 'zoom', 10);
                $('#map_canvas').gmap('get', 'map').setOptions({
                    'center': pos
                });
            }
        },
        error: function(data) {
            alert(data);
        }
    });
}

// 다음 이미지 검색 api
function thumbnail(search, addr) {
    var address = addr.split(" ");
    var addressSearch = address[1].substr(0, String(address[1]).length - 1);
    var q = addressSearch + "+" + "\"" + search + "\"";
    var query = {
        apikey: key,
        q: q,
        output: 'json'
    };
    $.ajax({
        url: url + target,
        data: query,
        dataType: "jsonp",
        type: 'POST',
        success: function(data) {
            var res = "";
            if (typeof data.channel.item[0] != "undefined") {
                res = data.channel.item[0].thumbnail;
            }
            $(".thumbnail-image").attr("src", res);
        },
        error: function(data) {
            alert('실패' + data);
        }
    });
}


// ajax loading 이미지 시작
function loadingIconStart() {
    $.mobile.loading("show", {
        text: "검색 중...",
        textVisible: true,
        theme: "b",
        html: ""
    });
}

// ajax loading 이미지 종료
function loadingIconEnd() {
    $.mobile.loading("hide");
}

// 구글맵 위치로
function scrollTop() {
    $('body, html').animate({
        scrollTop: $("#map_canvas").offset().top - 55
    }, 500);
}

// 즐겨찾기 위치로
function scrollBottom(idx) {
    $("html, body").animate({
        scrollTop: $("#favorite-" + idx).offset().top - 55
    }, 500);
}

// 구글맵 초기설정
function startMap() {
    var StartLatLng = new google.maps.LatLng(36.5658333333, 126.9688888889);
    $('#map_canvas').gmap({
        'center': StartLatLng
    }).gmap('option', 'zoom', 6);
    $('#map_canvas').gmap('clear', 'markers');
}

// 구글맵 높이 조절
function resizeMap() {
    if ($(window).width() < 500) {
        $('#map_canvas').css("height", "350px");
    } else {
        $('#map_canvas').css("height", "500px");
    }
    $('#map_canvas').gmap('refresh');
}

// 모바일 geo
function appStart(addr) {
    if (mobile != true) {
        alert("모바일에서 사용할 수 있습니다.");
    } else {
        var android_url = "geo:0,0?q=" + addr;
        location.href = android_url;
    }
}

// 네이버 블로그 검색
function naverSearch(name, addr) {
    var address = addr.split(" ");
    var addressSearch = address[1].substr(0, String(address[1]).length - 1);
    var url = "http://cafeblog.search.naver.com/search.naver?where=post&sm=tab_jum&ie=utf8&query=" + addressSearch + "+" + "\"" + name + "\"";
    window.open(url, "_blank");
}

// 다음 블로그 검색
function daumSearch(name, addr) {
    var address = addr.split(" ");
    var addressSearch = address[1].substr(0, String(address[1]).length - 1);
    var url = "http://search.daum.net/search?w=blog&nil_search=btn&DA=NTB&enc=utf8&q=" + addressSearch + "+" + "\"" + name + "\"";
    window.open(url, "_blank");
}

// 구글 검색
function googleSearch(name, addr) {
    var address = addr.split(" ");
    var addressSearch = address[1].substr(0, String(address[1]).length - 1);
    var url = "https://www.google.co.kr/?gws_rd=ssl#newwindow=1&q=" + addressSearch + "+" + "\"" + name + "\"";
    window.open(url, "_blank");
}

// 즐겨찾기 스크롤
function favoriteListScroll() {
    var urlpara = location.hash.replace("#search?", "").trim();
    var num = /^[0-9]*$/;

    if (urlpara == "fav") {
        $("html, body").animate({
            scrollTop: $("#favorite-start").offset().top
        }, 500);
    } else if (num.test(urlpara)) {
        marker(urlpara);
    }
}
