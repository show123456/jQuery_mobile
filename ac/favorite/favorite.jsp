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

java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String today = formatter.format(new java.util.Date());

String IdxRes = request.getParameter("idx");
int Idx = 0;

String[] array = { IdxRes };
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

	JSONObject jsonObject = new JSONObject();
	JSONObject jsonObject_sub = new JSONObject();
	JSONArray jsonArray = new JSONArray();

	try {
		conn = ds.getConnection();
		String query = "SELECT Idx FROM favorite WHERE Idx_res = ?";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, IdxRes);
		rs = pstmt.executeQuery();
		if(!rs.next()){
			query = "INSERT INTO favorite(Idx_res, date) VALUES(?, ?)";
			pstmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, IdxRes);
			pstmt.setString(2, today);
			pstmt.execute();
			rs = pstmt.getGeneratedKeys();

			if(rs.next()){
				jsonObject.put("idx", rs.getInt(1));
				jsonObject.put("idxres", IdxRes);
			}

			query = "SELECT * FROM res WHERE Idx = ?"; 
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, IdxRes);
			rs = pstmt.executeQuery();

			if(rs.next()){
				jsonObject.put("address", rs.getString("address"));
				jsonObject.put("shopname", rs.getString("shopname"));
				jsonObject.put("food", rs.getString("food"));
				jsonObject.put("tel", rs.getString("tel"));
				jsonObject.put("date", today);
			}

			out.println(jsonObject);
			out.flush();
		} else {
			jsonObject.put("shopname", null);
			out.print(jsonObject);
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