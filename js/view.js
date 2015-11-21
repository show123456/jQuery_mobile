var mobile = (/iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase()));
var key = 'a1e3e6b58fb16d30a47947eca5a81756';
var target = 'blog';
var url = 'https://apis.daum.net/search/';

var defaultpage = 0;
var maxpage = 0;


$(document).on('pageshow', '#view', function(e, d) {
    $(".menu-search").addClass("ui-btn-active");
    defaultpage++;
    blogSearch(shopname, address, defaultpage);
    thumbnail(shopname, address);
    $("#more").click(function() {
        blogSearch(shopname, address, defaultpage);
    });

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

    $(".btn-copy-url").click(function() {
        var longURL = window.location.href;
        var request = gapi.client.urlshortener.url.insert({
            'resource': {
                'longUrl': longURL
            }
        });
        request.execute(function(response) {
            if (response.id != null) {
                prompt("복사하세요", response.id);
            } else {
                alert("error: creating short url");
            }
        });
    });

    $("#popupMenu ul li a").click(function(){
        if(confirm("평가하시겠습니까?")){
            loadingIconStart();
            var score = $(this).html().length;
            $.ajax({
                url:"/ac/eval/eval.jsp",
                data:{i:idx, s:score},
                type:"POST",
                success:function(data){
                    var res = data.split(",");
                    $("#score").html(res[0]);
                    $("#count").html(res[1] + "명 평가");
                    loadingIconEnd();
                },
                error:function(data){
                    alert(data);
                    loadingIconEnd();
                }
            })
            $("#popupMenu").popup("close");
        }else{
            return false;
        }
    });

    $(".go-top-btn").click(function() {
         $('body, html').animate({scrollTop: 0}, 500);
    });

    startMap();
    resizeMap();

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
        location.replace("/out");
    });
});

// 구글맵 높이 조절
$(window).resize(function() {
    resizeMap();
});

function blogSearch(search, addr, page) {
    var address = addr.split(" ");
    var addressSearch = address[1].substr(0, String(address[1]).length - 1);
    var q = addressSearch + "+" + "\"" + search + "\"";
    var query = {
        apikey: key,
        q: q,
        output: 'json',
        pageno: page
    };
    $.ajax({
        url: url + target,
        data: query,
        dataType: "jsonp",
        type: 'POST',
        success: function(data) {
            var total;
            var nowpage;
            if (typeof data.channel != "undefined") {
                total = data.channel.totalCount;
            } else {
                total = 0;
            }

            if (typeof data.channel.pageCount != "undefined") {
                nowpage = data.channel.pageCount;
            } else {
                nowpage = 0;
            }

            defaultpage++;
            var now = total - (page * 10);
            if (now <= 10) {
                $("#more").hide();
            }
            if (total <= 0) {
                $(".result-wrap").html("").append('<div class="no-result">검색 결과가 없습니다.</div>');
            } else {
                for (var a = 0; a < 10; a++) {
                    var tit = data.channel.item[a].title;
                    var des = data.channel.item[a].description;
                    var lin = data.channel.item[a].link;
                    var dat = data.channel.item[a].pubDate;
                    var aut = data.channel.item[a].author;

                    tit = tit.replace(/&lt;/gi, "<").replace(/&gt;/gi, ">");
                    des = des.replace(/&lt;/gi, "<").replace(/&gt;/gi, ">");
                    dat = dat.substr(0, 8);
                    var year = dat.substr(0, 4);
                    var month = dat.substr(4, 2);
                    var day = dat.substr(6, 2);
                    var pubdate = year + ". " + month + ". " + day + ".";
                    var li = '<li class="ui-list-li">';
                    li += '<a class="a-contents" href="' + lin + '" target="_blank">';
                    li += '<div class="title">' + tit + '<span class="date">' + pubdate + '</span></div>';
                    li += '<span class="contents">' + des + '</span><br/><span class="author">출처 - ' + aut + '</span></a></li>';

                    $("#blog-list").append(li).listview('refresh');
                }
            }
        },
        error: function(data) {
            alert('실패' + data);
        }
    });
}

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
        url: url + "image",
        data: query,
        dataType: "jsonp",
        type: 'POST',
        success: function(data) {
            var res;
            var link;
            if (typeof data.channel.item[0] != "undefined") {
                var thumb = data.channel.item
                $.each(thumb, function(index, item) {
                    setTimeout(function() {
                        res = data.channel.item[index].thumbnail;
                        link = data.channel.item[index].link;
                        $("#image-thumbnail").append('<a href="' + link + '" target="_blank"><img class="thumbnail-image-view" src="' + res + '" alt=""/></a>')
                            .children(":last").hide().fadeIn(1000);
                    }, index * 150);
                });
            } else {
                $("#image-thumbnail").remove();
            }

        },
        error: function(data) {
            alert('실패' + data);
        }
    });
}

function startMap() {
    var pos = new google.maps.LatLng(latitude, longitude);
    $('#map_canvas').gmap('clear', 'markers');
    $('#map_canvas').gmap('addMarker', {
        'position': pos,
        'bounds': true,
        'icon': '/images/marker/marker9.png'
    }).click(function() {
        $('#map_canvas').gmap('openInfoWindow', {
            'content': '<span class="tooltip-title">' + shopname + '</span>'
        }, this);
    });
    $('#map_canvas').gmap({
        'center': pos
    }).bind('init', function() {
        $('#map_canvas').gmap('option', 'zoom', 14);
    });
}

function load() {
    gapi.client.setApiKey('AIzaSyDAG5d5nxAaZydCf4PDdflukaCu2Lc1mKI');
    gapi.client.load('urlshortener', 'v1', function() {});
}

// 구글맵 높이 조절
function resizeMap() {
    if ($(window).width() < 500) {
        $('#map_canvas').css("height", "350px");
    } else {
        $('#map_canvas').css("height", "350px");
    }
    $('#map_canvas').gmap('refresh');
}

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