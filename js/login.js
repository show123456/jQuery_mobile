var mobile = (/iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase()));
var key = 'a1e3e6b58fb16d30a47947eca5a81756';
var target = 'blog';
var url = 'https://apis.daum.net/search/';


$(document).on('pageshow', '#login', function(e, d) {
    $(".menu-login").addClass("ui-btn-active");

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

    $("#login-id-text, #login-pw-text").keydown(function() {
        $(".help-word").hide();
    }).on("tap", function() {
        $("#login").animate({
            scrollTop: $(window).height()
        }, 500);
    });

    $("#login-btn").click(function() {
        var i = $("#login-id-text").val().trim();
        var p = $("#login-pw-text").val().trim();
        if (i == "") {
            $(".help-word").html("아이디를 입력해주세요.").show();
            $("#login-id-text").focus();
        } else if (p == "") {
            $(".help-word").html("비밀번호를 입력해주세요.").show();
            $("#login-pw-text").focus();
        } else {
            loadingIconStart();
            $.ajax({
                url: "/in",
                data: {
                    email: i,
                    pw: p
                },
                type: "POST",
                success: function(data) {
                    if (data.trim() == "true") {
                        location.href = document.referrer;
                    } else {
                        $(".help-word").html("아이디와 비밀번호를 확인해주세요.").show();
                    }
                    loadingIconEnd();
                },
                error: function(data) {
                    console.log(data);
                    loadingIconEnd();
                }
            });
        }
    });

    $("#login-btn-kt").click(function(){
        loginWithKakao();
    });
    $("#login-btn-fb").click(function(){
        facebooklogin();
    });

    $(".menu-logout").click(function() {
        location.replace("/out");
    });


});

$(window).resize(function() {

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

// 카카오
Kakao.init('6b7a303f87c64aea009208da73740865');
function loginWithKakao() {
    //var nowLoc = "http://" + window.location.hostname + window.location.pathname + window.location.search;
    Kakao.Auth.login({
        success: function(authObj) {
            Kakao.API.request({
                url: '/v1/user/me',
                success: function(res) {
                    var thumb = res.properties.thumbnail_image;
                    if(thumb == null){
                        thumb = "/images/thumbnail/kakao.png";
                    }
                    $.ajax({
                        type: "POST",
                        data: "username=" + res.properties.nickname + "&userid=" + res.id + "&userthumb=" + thumb,
                        url: "/ac/log/kt.jsp",
                        success: function(responsephp) {
                            if (responsephp.trim() == "true") {
                                location.href = document.referrer;
                            } else {
                                alert(responsephp.trim());
                            }
                        }
                    });
                },
                fail: function(error) {
                    alert(JSON.stringify(error))
                }
            });
        },
        fail: function(err) {
            alert(JSON.stringify(err))
        }
    });
};

//페이스북
window.fbAsyncInit = function() {
    FB.init({
        appId: '1585548195067736',
        xfbml: true,
        version: 'v2.3'
    });
};

(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {
        return;
    }
    js = d.createElement(s);
    js.id = id;
    js.src = "//connect.facebook.net/ko_KR/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));


function facebooklogin() {
    //var nowLoc = "http://" + window.location.hostname + window.location.pathname + window.location.search;
    FB.login(function(response) {
        var fbname;
        var accessToken = response.authResponse.accessToken;
        FB.api('/me', function(user) {
            fbname = user.name;
            $.ajax({
                type: "POST",
                data: "username=" + fbname + "&userid=" + user.id,
                url: "/ac/log/fb.jsp",
                success: function(responsephp) {
                    if (responsephp.trim() == "true") {
                        location.href = document.referrer;
                    } else {
                        alert(responsephp.trim());
                    }
                }
            });
        });
    }, {
        scope: "email"
    });
}
