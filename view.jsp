<!--
  경민대학교 인터넷정보과,
  20151812 양욱모,
  최신 스크립트언어,
  2015.5.6 초기작성

  맛집 상세보기 페이지
-->
<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%@ include file="/db/getView.jsp" %>
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
	<script>
		var idx = "<%=Idx[0]%>";
		var latitude = "<%=Latitude[0]%>";
		var longitude = "<%=Longitude[0]%>";
		var shopname = "<%=Shopname[0]%>";
		var address = "<%=Address[0]%>";
	</script>
	<script type="text/javascript" charset="utf-8" src="/js/view.js"></script>
	<!-- Google Map -->
	<script src="http://maps.google.com/maps/api/js?sensor=true" type="text/javascript"></script>
	<script type="text/javascript" charset="utf-8" src="/ui/jquery.ui.map.js"></script>
	<script type="text/javascript" charset="utf-8" src="/ui/jquery.ui.map.extensions.js"></script>

	<script src="https://apis.google.com/js/client.js?onload=load"></script>

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
#map_canvas{width:100%;height:350px;background:#000;}

#image-thumbnail{background-color: rgba(68,68,68,0.5);width:100%;padding:10px 0 8px 0;}
.thumbnail-image-view{margin:5px; height:100px;}

.btn-wrap{height:80px;}
.btn-copy-url{width:80px;font-weight: normal;float:right;margin:0 5px;}
.btn-eval{width:50px;float:right;margin:0 5px;background-color: #EDB92E !important;border:0;}
.score-wrap{padding:0 10px 10px 10px;background-color: rgba(68,68,68,0.7);width:150px;margin:0 auto;border-radius: .3em;}
#score{color:#EDB92E;margin:10px auto;border-bottom:1px solid #FFF;width:150px;font-size:3em;}
#count{font-size:15px;}

</style>

</head>
<body oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
	<div data-role="page" id="view">
		<div data-role="panel" id="panel-view" class="panel" data-display="overlay">
        	<%@ include file="/common/menu-02.jsp" %>
        </div>
        <div data-role="header" data-theme="a">
		    <h1>jQuery BFS</h1>
		    <a class="open-panel ui-btn ui-shadow ui-corner-all ui-icon-bars ui-btn-icon-notext">menu</a>
		    <a href="#" data-rel="back" class="ui-btn ui-shadow ui-corner-all ui-icon-back ui-btn-icon-notext">close</a>
		</div>
        <div data-role="content" class="center">
         	<div id="map_wrap">
        		<div id="map_canvas"></div>
        		<div class="ui-resizable-handle ui-resizable-s" id="sgrip"></div>
        	</div>
        	<div class="padding-content center">        	
	        	<h1 class="shop-title"><%=Shopname[0]%></h1>
	        	<ul class="detail">
	        		<li><%=Food[0]%></li>
	        		<li><%=Tel[0]%></li>
	        		<li><%=Address[0]%></li>
	        		<li><div class="score-wrap">
	        				<h1 id="score"><%=Avg[0]%></h1>
	        				<div id="count"><%=Count[0]%>명 참여</div>
	        			</div>
	        		</li>
	        	</ul>
	        	<div class="btn-wrap">
		        	<a data-icon="action" class="ui-btn ui-shadow-icon ui-corner-all ui-icon-action ui-btn-icon-left btn-copy-url">URL 복사</a>
		        	<a href="#popupMenu" data-rel="popup" data-transition="slideup" data-icon="star" class="ui-btn ui-shadow-icon ui-corner-all ui-icon-star ui-btn-icon-left btn-eval">평 가</a>
		        	<%@ include file="/import/eval.jsp"%>
	        	</div>
	        	
	        </div>
	        <div id="image-thumbnail"></div>
	        <div class="padding-content center">	
	        	<h1 class="blog-title">블로그 검색 <small>Blog Search</small></h1>
	        	<div class="result-wrap"> 
		        	<ul data-role="listview" data-filter="true" data-filter-placeholder="검색" data-inset="true" data-icon="false" id="blog-list"></ul>
		        	<a id="more" class="ui-btn ui-shadow ui-corner-all btn-more-view a-contents">더 보기</a>
	        	</div>
        	</div>
        </div>
        <div class="go-top">
	     	<div class="go-top-btn ui-btn ui-shadow ui-corner-all ui-icon-arrow-u ui-btn-icon-notext"></div>
	    </div>
    </div> 
</body>
</html>