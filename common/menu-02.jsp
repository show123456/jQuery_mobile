<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<h1 class="menu-title">MENU</h1>
            <div class="ui-panel-inner">
                <ul data-role="listview" class="ui-listview">
                    <%if(LId == null){%>
                    <li data-icon="user"><a href="/login" data-ajax="false" class="ui-btn ui-btn-icon-right ui-icon-user menu-login">로그인</a></li>
                    <li data-icon="user"><a href="/join" data-ajax="false" class="ui-btn ui-btn-icon-right ui-icon-action menu-join">회원가입</a></li>
                    <%}else{%>
                    <li data-role="collapsible" data-inset="false" data-iconpos="right">
                        <h4 class="my-info"><img src="<%=LThumb%>" class="my-thumbnail-image" alt="thumbnail"/><div class="my-name"><%=LName%></div><div class="my-email"><%=LEmail%></div></h4>
                        <ul data-role="listview" class="my-info-menu">   
                            <li><a href="#" class="ui-btn ui-btn-icon-right ui-icon-edit">&nbsp;&nbsp;- 개인정보 수정</a></li>
                            <li><a href="/out" data-ajax="false" class="ui-btn ui-btn-icon-right ui-icon-power">&nbsp;&nbsp;- 로그아웃</a></li>
                        </ul>    
                    </li>
                    <%}%>
                    <li data-icon="home"><a href="/#main" data-ajax="false" class="ui-btn ui-btn-icon-right ui-icon-home menu-main">홈</a></li>
                    <li data-icon="search"><a href="/#search" data-ajax="false" class="ui-btn ui-btn-icon-right ui-icon-search menu-search">검색</a></li>
                    <li data-icon="star"><a href="#" data-ajax="false" class="ui-btn ui-btn-icon-right ui-icon-star menu-favorite">즐겨찾기</a></li>
                    <li data-icon="tag"><a data-ajax="false" href="/rank" class="ui-btn ui-btn-icon-right ui-icon-tag menu-ranking">전국 Top 10</a></li>
                    <li data-icon="navigation"><a href="/#navigation" data-ajax="false" class="ui-btn ui-btn-icon-right ui-icon-navigation menu-navigation">위치정보</a></li>  
                </ul>
            </div>
            <div class="panel-in-footer">
                <table>
                    <tr>
                        <td><img src="/images/logo/logo.png" alt="jQuery Best Food Search" class="panel-logo"/></td>
                        <td class="td-left panel-my-info">
                            <ul>
                                <li>경민대학교</li>
                                <li>인터넷정보과</li>
                                <li>20151812 양욱모</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </div>