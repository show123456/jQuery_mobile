<!--
  경민대학교 인터넷정보과,
  20151812 양욱모,
  최신 스크립트언어,
  2015.5.6 초기작성

  회원가입 페이지
-->
<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%@ include file="/common/session/getSession.jsp" %>
<% if(LId != null){
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
	<!-- Custom -->
	<link rel="stylesheet" href="/css/style.css?d=150517">
	<script type="text/javascript" charset="utf-8" src="/js/join.js"></script>
	<!-- PlaceHolder -->
	<script type="text/javascript" charset="utf-8" src="/js/placeholder/placeholders.min.js"></script>

	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->

<style type="text/css">
.center{text-align: center;}
.ui-input-text{background-color:#FFF !important;color:#333 !important;}
.input-text{width:100%; text-align: center !important;}
.join-wrap{background-color: rgba(255,255,255,0.3) !important; width:100%; max-width:952px; margin:0 auto;margin-top:20px;border-radius: 3px;}
.join-wrap-in{padding:20px;}
#user_gender div{width:50%;}
#user_gender div label{ text-align: center !important;}
.ui-input-text{margin-bottom:20px !important;}
.ui-controlgroup-controls {margin-bottom:20px !important;}

.overlap-border{box-shadow: 0 0 12px #F2643D !important;}
</style>

</head>
<body oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
	<div data-role="page" id="join">
		<div data-role="panel" id="panel-join" class="panel" data-display="overlay">
        	<%@ include file="/common/menu-02.jsp" %>
        </div>
        <div data-role="header" data-theme="a">
		    <h1>jQuery BFS</h1>
		    <a class="open-panel ui-btn ui-shadow ui-corner-all ui-icon-bars ui-btn-icon-notext">menu</a>
		    <a href="#" data-rel="back" class="ui-btn ui-shadow ui-corner-all ui-icon-back ui-btn-icon-notext">close</a>
		</div>
        <div data-role="content" class="center">
        	<div class="join-wrap">
        		<div class="join-wrap-in">
					<img class="main-logo" src="/images/logo/logo.png" alt="jquery 맛집검색"/>
					<div class="ui-field-contain">
						<label for="user_name">이름</label>
						<input type="text" id="user_name" name="user_name" class="input-text" data-clear-btn="true"/>
						<label for="user_gender">성별</label>
						<fieldset data-role="controlgroup" id="user_gender" data-type="horizontal" data-mini="true">
					         	<input type="radio" name="user_gender" id="radio-choice-21" value="man" checked="checked" />
					         	<label for="radio-choice-21">남자</label>

					         	<input type="radio" name="user_gender" id="radio-choice-22" value="woman"  />
					         	<label for="radio-choice-22">여자</label>
					    </fieldset>
					    
					    <label for="user_email">이메일</label>
						<input type="email" id="user_email" name="user_email" class="input-text" data-clear-btn="true"/>
						<label for="user_pw_01">비밀번호</label>
						<input type="password" id="user_pw_01" name="user_pw_01" class="input-text" data-clear-btn="true"/>
						<label for="user_pw_02">비밀번호 확인</label>
						<input type="password" id="user_pw_02" name="user_pw_02" class="input-text" data-clear-btn="true"/>
					</div>
					<a data-role="button" id="btn_join" data-icon="check">가 입</a>
				</div>
			</div>
        </div>
    </div> 
</body>
</html>