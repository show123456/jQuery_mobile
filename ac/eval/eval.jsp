<%@page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.naming.*, javax.sql.*, java.util.*, java.text.*"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.parser.ParseException"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.*"%>
<%@ page import="org.json.*" %>
<%
request.setCharacterEncoding("UTF-8");


String IdxRes = request.getParameter("i");
String Score = request.getParameter("s");

int allScore = 0;
int count = 0;
float avg = 0f;

String[] array = { IdxRes, Score };
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
		String query = "INSERT INTO eval(Idx, Score, Date) VALUES(?, ?, now());";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, IdxRes);
		pstmt.setString(2, Score);
		pstmt.execute();

		query = "SELECT Score FROM eval WHERE Idx = ?";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, IdxRes);
		rs = pstmt.executeQuery();
		
		while(rs.next()){
			allScore = allScore + rs.getInt("Score");
			count++;
		}
		avg = (float) allScore / count;
		String result = String.format("%.2f", avg);

		out.println(result + "," + count);		
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