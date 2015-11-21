<!--
  경민대학교 인터넷정보과,
  20151812 양욱모,
  최신 스크립트언어,
  2015.5.6 초기작성

  메인, 검색, 위치정보 페이지
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/db/getFavorite.jsp" %>
<%@ include file="/common/session/getSession.jsp" %>
<!doctype html>
<html>
<head>
<title>jQuery 맛집검색 - 기말고사</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
	<meta name="theme-color" content="#edb92e">
    <!-- jQuery Mobile -->
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
    <link rel="stylesheet" href="/css/theme/2/my-theme.min.css" />
	<link rel="stylesheet" href="/css/theme/2/jquery.mobile.icons.min.css" />
    <script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
    <script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>  
	<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
	<!-- Kakao Login -->
	<script>
		var LType = "<%=LType%>";
	</script>
	<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
	<!-- Custom -->
	<link rel="stylesheet" href="/css/style.css?d=150517">
    <script type="text/javascript" charset="utf-8" src="/js/common.js"></script>
    <script type="text/javascript" charset="utf-8" src="/js/main.js"></script>
    <script type="text/javascript" charset="utf-8" src="/js/search.js"></script>
    <script type="text/javascript" charset="utf-8" src="/js/favorite.js"></script>
    <script type="text/javascript" charset="utf-8" src="/js/navigation.js"></script>
    <!-- Google Map -->
   	<script src="http://maps.google.com/maps/api/js?sensor=true" type="text/javascript"></script>
	<script type="text/javascript" charset="utf-8" src="/ui/jquery.ui.map.js"></script>
	<script type="text/javascript" charset="utf-8" src="/ui/jquery.ui.map.extensions.js"></script>
	<!-- Long Press -->
	<script type="text/javascript" charset="utf-8" src="/js/longpress/jquery.longpress.js"></script>
	<!-- TagCloud -->
	<script type="text/javascript" charset="utf-8" src="/js/tagcloud/jquery.tagcloud.js"></script>
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->

		
</head>
<body oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
	<div data-role="page" id="main">
		<div data-role="panel" id="panel-main" class="panel" data-display="overlay">
        	<%@ include file="/common/menu.jsp" %>
        </div>
        <div data-role="header" data-theme="a">
		    <a class="open-panel ui-btn ui-shadow ui-corner-all ui-icon-bars ui-btn-icon-notext">menu</a>
		</div>
		<div data-role="content">
			<div class="main-wrap">
				<img class="main-logo" src="/images/logo/logo.png" alt="jquery 맛집검색"/>
				<input type="search" id="main-search-text" onkeydown='if (event.keyCode==13) { $("#main-search-btn").trigger("click");}'/>
				<div class="help-word">검색어를 입력해주세요!</div>
				<input type="submit" id="main-search-btn" value="검 색" />
			</div>

			<div id="tagcloud">
	        <%
	        ArrayList<Integer> ranNumber = new ArrayList<Integer>();
			for(int i=0; i < Idx.length;i++){
				ranNumber.add(i);
				if(i > 30){
					break;
				}
			}
			Collections.shuffle(ranNumber);
	        for(int z=0;z< Idx.length;z++){
	        	int ran = ranNumber.get(z);
	        %>
	        	<a href="#" onclick="javascript:location.href='/view/<%=Idx[ran]%>';" rel="<%=(int) (Math.random() * 15)%>"><%=Shopname[ran]%></a>
	        <%
		        	if(z > 30){
						break;
					}
				}
			%>
	        </div>
		</div>
	</div>

	<div data-role="page" id="search">
		<div data-role="panel" id="panel-search" class="panel" data-display="overlay">
        	<%@ include file="/common/menu.jsp" %>
        </div>
        <%@ include file="/common/header.jsp" %>
        <div data-role="content">
        	<div class="padding-content">
	        	<h1 class="search-title">검색 <small>Search</small></h1>
	        	<div class="search-wrap">
	        		<table style="width:100%;">
	        			<tr>
		        			<td colspan="2">
		        				<div id="search-condition" data-role="fieldcontain">
								    <fieldset data-role="controlgroup" data-type="horizontal" data-mini="true" id="search-term">
								         	<input type="radio" name="radio-choice-2" id="radio-choice-21" value="all" checked="checked" />
								         	<label for="radio-choice-21">전체</label>

								         	<input type="radio" name="radio-choice-2" id="radio-choice-22" value="name" />
								         	<label for="radio-choice-22">이름</label>

								         	<input type="radio" name="radio-choice-2" id="radio-choice-23" value="sort" />
								         	<label for="radio-choice-23">종류</label>

								         	<input type="radio" name="radio-choice-2" id="radio-choice-24" value="addr" />
								         	<label for="radio-choice-24">주소</label>
								    </fieldset>
								</div>
		        			</td>
	        			</tr>
	        			<tr>
		        			<td><input type="search" id="search-text" onkeydown='if (event.keyCode==13) { $("#search-btn").trigger("click");}'/></td>
		        			<td style="width:60px;"><input data-icon="search" type="submit" id="search-btn" value="검색" data-mini="true"/></td>
	        			</tr>
	        		</table>
	        	</div>
	        </div>
	        <div id="map_wrap">
	        	<div id="map_canvas" class="ui-widget-content"></div>	
	        	<div class="map-init">
	        		<a id="refresh-map" data-role="button" data-icon="refresh" class="ui-btn ui-shadow ui-corner-all ui-icon-refresh ui-btn-icon-notext ui-btn-right">초기화</a>
	        	</div>
        	<div class="ui-resizable-handle ui-resizable-s" id="sgrip"></div>
        	</div>
        	<div class="padding-content" id="favorite-start">
	        	<div class="favorite-warp">
		        	<h1 class="favorite-title">즐겨찾기 <small>Favorite</small><span class="favorite-del-tip">길게 눌러 삭제</span></h1>
		        	<ul data-role="listview" data-filter="true" data-filter-placeholder="즐겨찾기 검색" data-inset="true" id="favorite-list">
		        		<% for(int z=0;z<Address.length;z++){ %>
					    <li class="ui-list-li" id="favorite-<%=Idx[z]%>">
					    	<a class="a-contents" value="<%=Idx[z]%>" onclick="marker(<%=Idx[z]%>);">
					    		<div class="list-1"><span class="list-title"><%=Shopname[z]%></span></div>
					    		<div class="list-2"><span class="list-addr"><%=Address[z]%></span><br/><span class="list-tel"><%=Tel[z]%></span></div>
					    	</a>
					        <a href="tel:<%=Tel[z]%>" class="ui-btn ui-icon-phone">Call</a>		    	
					    </li>
					    <% } %>
					</ul>
	        	</div>
	        	
	        </div>
	        <div class="go-top">
	        	<div class="go-top-btn ui-btn ui-shadow ui-corner-all ui-icon-arrow-u ui-btn-icon-notext"></div>
	        </div>
        </div>
    </div>

    <div data-role="page" id="navigation">
    	<div data-role="panel" id="panel-navigation" class="panel" data-display="overlay">
        	<%@ include file="/common/menu.jsp" %>
        </div>
        <%@ include file="/common/header.jsp" %>
        <div data-role="content">
        	<div id="map_canvas_nav" class="ui-widget-content"></div>
        	<div class="padding-content">
        		
        	</div>
        </div>
        <div class="go-top">
	        <div class="nav-map-refresh ui-btn ui-shadow ui-corner-all ui-icon-refresh ui-btn-icon-notext"></div>
	    </div>
    </div>

</body>
</html>