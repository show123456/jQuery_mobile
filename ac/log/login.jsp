<%@page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.naming.*, javax.sql.*, java.util.*, java.text.*"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%
request.setCharacterEncoding("UTF-8");


String Email = request.getParameter("email");
String Pw = request.getParameter("pw");
String Type = "";

String[] array = { Email, Pw };
int nullCount = 0;
for (int i = 0; i < array.length; i++) {
	if (array[i] == null || array[i].equals("")) {
		nullCount++;
	}
}

if(nullCount == 0){
	Connection conn = null;
	PreparedStatement pstmt = null;		
	ResultSet rs = null;

	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource ds = (DataSource) envCtx.lookup("jdbc/jquery");

	try {
		Thread.sleep(1000);
		conn = ds.getConnection();
		String query = "SELECT Idx, Name, Email, Type, Thumbnail FROM member WHERE Email = ? AND Pw = ? AND Type != ? AND Type != ?";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, Email);
		pstmt.setString(2, Pw);
		pstmt.setString(3, "kakao");
		pstmt.setString(4, "facebook");
		rs = pstmt.executeQuery();

		if(rs.next()){
			if(rs.getString("Type").equals("admin")){
				Type = "관리자";
			}else{
				Type = rs.getString("Email");
			}
			session.setAttribute("Name", rs.getString("Name"));
			session.setAttribute("Idx", rs.getString("Idx"));
			session.setAttribute("Email", Type);
			session.setAttribute("Type", rs.getString("Type"));
			session.setAttribute("Thumbnail", rs.getString("Thumbnail"));
			out.print(true);
		}else{
			out.print(false);
		}
		
		
		
	} catch(SQLException e) {
		out.println(e.toString());
	} finally {
		if (rs != null) {
	        try {rs.close();} catch (SQLException e) { /* ignored */}
	    }
	    if (pstmt != null) {
	        try {pstmt.close();} catch (SQLException e) { /* ignored */}
	    }
	    if (conn != null) {
	        try {conn.close();} catch (SQLException e) { /* ignored */}
	    }
	}

}

%>