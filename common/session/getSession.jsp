<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String LName = (String) session.getAttribute("Name");
	String LId = (String) session.getAttribute("Idx");
	String LEmail = (String) session.getAttribute("Email");
	String LType = (String) session.getAttribute("Type");
	String LThumb = (String) session.getAttribute("Thumbnail");
	if(LId == null){
		LName = null;
		LId = null;
		LEmail = null;
		LType = null;
		LThumb = null;
	}
%>