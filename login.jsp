<!--
  경민대학교 인터넷정보과,
  20151812 양욱모,
  최신 스크립트언어,
  2015.5.6 초기작성

  로그인 페이지
-->
<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%@ include file="/common/session/getSession.jsp" %>
<% if(LEmail != null){
	response.sendRedirect("/");
}%>
<!doctype html>
<html>
<head>
<title>jQuery 맛집검색 - 기말고사</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
    <meta name="theme-color" content="#edb92e">
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
    <link rel="stylesheet" href="/css/theme/2/my-theme.min.css" />
	<link rel="stylesheet" href="/css/theme/2/jquery.mobile.icons.min.css" />
    <script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
    <script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
	<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
	<!-- Kakao Login -->
	<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
	<!-- Custom -->
	<link rel="stylesheet" href="/css/style.css?d=150517">
	<script type="text/javascript" charset="utf-8" src="/js/login.js"></script>
	<!-- PlaceHolder -->
	<script type="text/javascript" charset="utf-8" src="/js/placeholder/placeholders.min.js"></script>

	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->

<style type="text/css">
.center{text-align: center;}
#staticmap{width:100%;max-width:640px;}

.shop-title{color:#EDB92E;text-shadow:1px 1px 1px #333;}
.tooltip-title{color:#333;}
.detail{list-style: none;padding:0;max-width:768px;margin:20px auto;border-top:1px solid #FFF;padding-top:10px;}
.detail li{text-align: center;padding:5px;font-size:20px;text-shadow:1px 1px 1px #333;}

.ul-list-li a{opacity:0.9 !important;}
.ui-list-li .title{color:#EDB92E;font-weight: normal;font-size:20px;margin-bottom:5px;text-overflow:ellipsis;white-space: nowrap;overflow: hidden;}
.ui-list-li .title b{color:#F88863;}
.ui-list-li .title .date{color:#FFF;font-size:15px;float: right}
.ui-list-li .contents{font-weight: normal;font-size:13px;}
.ui-list-li .contents b{color:#FFE29A;}
.ui-list-li .author{font-weight: normal;font-size:13px;color:#BBB;}
.no-result{font-size:25px;text-shadow:1px 1px 1px #333;padding-bottom:20px;}
#map_canvas{width:100%;height:500px;background:#000;}

#image-thumbnail{background-color: rgba(68,68,68,0.5);width:100%;padding:10px 0 8px 0;}
.thumbnail-image-view{margin:5px; height:100px;}

.btn-wrap{height:80px;}
.btn-copy-url{width:80px;font-weight: normal;float:right;margin:0 5px;}
.btn-eval{width:50px;float:right;margin:0 5px;background-color: #EDB92E !important;border:0;}
.score-wrap{padding:0 10px 10px 10px;background-color: rgba(68,68,68,0.7);width:150px;margin:0 auto;border-radius: .3em;}
#score{color:#EDB92E;margin:10px auto;border-bottom:1px solid #FFF;width:150px;font-size:3em;}
#count{font-size:15px;}
.ui-input-text{background-color:#FFF !important;color:#333 !important;}
#login-btn{font-weight: normal;}
#login-btn-fb{background-color:#3b5998 !important;font-weight: normal;}
#login-btn-fb:hover{background-color:#4c679e !important;}
#login-btn-kt{background-color: #ffea00 !important; color:#333;font-weight: normal;}
#login-btn-kt:hover{background-color: #fff70f !important;}
</style>

</head>
<body oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
	<div data-role="page" id="login">
		<div data-role="panel" id="panel-login" class="panel" data-display="overlay">
        	<%@ include file="/common/menu-02.jsp" %>
        </div>
        <div data-role="header" data-theme="a">
		    <h1>jQuery BFS</h1>
		    <a class="open-panel ui-btn ui-shadow ui-corner-all ui-icon-bars ui-btn-icon-notext">menu</a>
		    <a href="#" data-rel="back" class="ui-btn ui-shadow ui-corner-all ui-icon-back ui-btn-icon-notext">close</a>
		</div>
        <div data-role="content" class="center">
         	<div class="main-wrap">
				<img class="main-logo" src="/images/logo/logo.png" alt="jquery 맛집검색"/>
				<input type="email" id="login-id-text" placeholder="이메일"/>
				<input type="password" id="login-pw-text" onkeydown='if (event.keyCode==13) { $("#login-btn").trigger("click");}' placeholder="비밀번호"/>
				<div class="help-word"></div>
				<a id="login-btn" data-role="button">로그인</a>
				<a id="login-btn-fb" data-role="button">페이스북 로그인</a>
				<a id="login-btn-kt" data-role="button">카카오 로그인</a>
			</div>
        </div>
    </div> 
</body>
</html>