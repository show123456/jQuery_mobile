<!--
  경민대학교 인터넷정보과,
  20151812 양욱모,
  최신 스크립트언어,
  2015.5.6 초기작성

  맛집 랭킹 페이지
-->
<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%@ include file="/db/getRank.jsp" %>
<%@ include file="/common/session/getSession.jsp" %>
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
	<script type="text/javascript" charset="utf-8" src="/js/rank.js"></script>
	<script src="https://apis.google.com/js/client.js?onload=load"></script>

	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->

<style type="text/css">
.title{text-align: center;text-shadow:2px 2px 3px #333;}
#ranking-list{opacity:0.9 !important;}
.rank{float:left;font-size:30px;text-align: center;}
.contents{padding-left:10px;float: left;}
.shopname{font-weight: normal !important;font-size:20px;color:#EDB92E;text-overflow:ellipsis;white-space: nowrap;overflow: hidden;}
.score{font-size:20px;}
.count{font-size:15px;font-weight: normal}
@media(max-width :768px){.contents{width:250px;}}
@media(min-width :768px) and (max-width:992px){.contents{width:450px;}}
@media(min-width :992px){.contents{width:550px;}}
</style>

</head>
<body oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
	<div data-role="page" id="rank">
		<div data-role="panel" id="panel-rank" class="panel" data-display="overlay">
        	<%@ include file="/common/menu-02.jsp" %>
        </div>
        <div data-role="header" data-theme="a">
		    <h1>jQuery BFS</h1>
		    <a class="open-panel ui-btn ui-shadow ui-corner-all ui-icon-bars ui-btn-icon-notext">menu</a>
		    <a href="#" data-rel="back" class="ui-btn ui-shadow ui-corner-all ui-icon-back ui-btn-icon-notext">close</a>
		</div>
        <div data-role="content" class="center">
        	<div class="padding-content center">
        		<h1 class="title">전국 Top 10</h1>
        		<ul data-role="listview" data-inset="true" id="ranking-list">        	
	        	<%for(int i=0; i<Address.length;i++){%>
	        		<li class="ui-list-li">
						<a href="/view/<%=Idx[i]%>" data-ajax="false">
							<div class="rank"><%=i+1%></div>
							<div class="contents">
								<div class="shopname"><%=Shopname[i]%></div>
								<div class="score"><%=Avg[i]%> <span class="count"> / <%=Count[i]%>명 평가</span></div>
							</div>
						</a>
					</li>
	        	<%}%>
	        	</ul>
	        </div>
        </div>
        <div class="go-top">
	     	<div class="go-top-btn ui-btn ui-shadow ui-corner-all ui-icon-arrow-u ui-btn-icon-notext"></div>
	    </div>
    </div> 
</body>
</html>