<%@ include file="/common/session/getSession.jsp"%>

<%
	session.invalidate();
	out.println("<script>location.replace(document.referrer);</script>");
%>
