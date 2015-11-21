<%@page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.parser.ParseException"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.*"%>
<%@page import="org.json.*" %>
<%
request.setCharacterEncoding("UTF-8");

String Search = request.getParameter("search");
String Term   = request.getParameter("term");

String[] array = { Search , Term };
int nullCount = 0;
for (int i = 0; i < array.length; i++) {
	if (array[i] == null || array[i].equals("")) {
		nullCount++;
	}
}
if(nullCount == 0){
	
	Thread.sleep(1000);

	Connection conn         = null;
	PreparedStatement pstmt = null;		
	ResultSet rs            = null;

	Context initCtx = new InitialContext();
	Context envCtx  = (Context) initCtx.lookup("java:comp/env");
	DataSource ds   = (DataSource) envCtx.lookup("jdbc/jquery");
	String address  = "";
	String type     = "";

	JSONObject jsonObject   = new JSONObject();
	JSONObject resultObject = new JSONObject();
	JSONArray jsonArray     = new JSONArray();

	try {
		conn = ds.getConnection();
		String query = "SELECT Idx, address, address2, latitude, longitude, shopname, food, tel FROM res WHERE ";
		if(Term.equals("all")){
			query += "(address LIKE ? OR shopname LIKE ? OR food LIKE ?) GROUP BY Idx";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, "%" + Search + "%");
			pstmt.setString(2, "%" + Search + "%");
			pstmt.setString(3, "%" + Search + "%");
		}else if(Term.equals("name")){
			query += "(shopname LIKE ?) GROUP BY Idx";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, "%" + Search + "%");
		}else if(Term.equals("sort")){
			query += "(food LIKE ?) GROUP BY Idx";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, "%" + Search + "%");
		}else if(Term.equals("addr")){
			query += "(address LIKE ?) GROUP BY Idx";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, "%" + Search + "%");
		}
		rs = pstmt.executeQuery();
		

		if(rs.next()){
			rs.beforeFirst();
			while(rs.next()){
				if(rs.getString("address") != null){
					jsonObject.put("address", rs.getString("address"));
				} else {
					jsonObject.put("address", rs.getString("address2"));
				}
				jsonObject.put("latitude", rs.getString("latitude"));
				jsonObject.put("longitude", rs.getString("longitude"));
				jsonObject.put("shopname", rs.getString("shopname"));
				jsonObject.put("food", rs.getString("food"));
				jsonObject.put("tel", rs.getString("tel"));
				jsonObject.put("idx", rs.getString("Idx"));
				jsonArray.add(0, jsonObject);
				jsonObject = new JSONObject();
			}
			resultObject.put("records", jsonArray);
			out.println(resultObject);
		}else{
			resultObject.put("records", null);
			out.println(resultObject);
		}
		
		out.flush();
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