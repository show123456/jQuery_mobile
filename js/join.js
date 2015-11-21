var mobile = (/iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase()));
var key = 'a1e3e6b58fb16d30a47947eca5a81756';
var target = 'blog';
var url = 'https://apis.daum.net/search/';


$(document).on('pageshow', '#join', function(e, d) {
    $(".menu-join").addClass("ui-btn-active");

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

    $(".menu-logout").click(function() {
        location.replace("/out");
    });

    var typingTimer;                //timer identifier
    var doneTypingInterval = 500;  //time in ms, 5 second for example

    //on keyup, start the countdown
    $('#user_email').keyup(function(){
        clearTimeout(typingTimer);
        typingTimer = setTimeout(doneTyping, doneTypingInterval);
    });
    //on keydown, clear the countdown 
    $('#user_email').keydown(function(){
        clearTimeout(typingTimer);
    });

    $('#user_pw_02').keyup(function(){
        clearTimeout(typingTimer);
        typingTimer = setTimeout(pwCheck, doneTypingInterval);
    });
    //on keydown, clear the countdown 
    $('#user_pw_02').keydown(function(){
        clearTimeout(typingTimer);
    });

    
    $("#btn_join").click(function(){
        var name = $("#user_name").val();
        var email = $("#user_email").val();
        var pw01 = $("#user_pw_01").val();
        var pw02 = $("#user_pw_02").val();

        if($(".ui-input-text").hasClass("overlap-border")){
            alert("붉은 부분을 확인해주세요.");
        }else if(name=="" || email=="" || pw01=="" || pw02==""){
            alert("빈 칸을 확인해주세요.");
        }else{
            var gender = $(':radio[name="user_gender"]:checked').val();
            var param = "id=" + $("#user_email").val() + "&pw=" + $("#user_pw_02").val() + "&gender=" + gender + "&name=" + $("#user_name").val();
            $.ajax({
                url:"/ac/join/insert.jsp",
                data:param,
                type:"POST",
                success:function(data){
                        alert("가입완료");
                        location.replace("/");
                },
                error:function(data){
                    alert("실패");
                }
            });
        }
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

 //user is "finished typing," do something
    function doneTyping () {
        var param = "email=" + $("#user_email").val();
        $.ajax({
            url:"/ac/join/overlap.jsp",
            type:"POST",
            data:param,
            success:function(data){
                if(data=="false"){
                    $("#user_email").parent().removeClass("overlap-border");
                }else{
                    $("#user_email").parent().addClass("overlap-border");
                }
            },
            error:function(data){

            }
        });
    }

    function pwCheck(){
        var pw01 = $("#user_pw_01").val();
        var pw02 = $("#user_pw_02").val();

        if(pw01 != pw02){
            $("#user_pw_02").parent().addClass("overlap-border");
        }else{
            $("#user_pw_02").parent().removeClass("overlap-border");
        }
    }