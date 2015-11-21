<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%
Connection conn         = null;
PreparedStatement pstmt = null;		
ResultSet rs            = null;

Context initCtx = new InitialContext();
Context envCtx  = (Context) initCtx.lookup("java:comp/env");
DataSource ds   = (DataSource) envCtx.lookup("jdbc/jquery");

String I = request.getParameter("i");

String Address[]   = null;
String Food[]      = null;
String Shopname[]  = null;
String Tel[]       = null;
String Latitude[]  = null;
String Longitude[] = null;
String Idx[]       = null;
String Avg[]       = null;
String Count[]     = null;

int j = 0;
int all = 0;

try {
	conn = ds.getConnection();
	String query = "SELECT COUNT(*) FROM res WHERE Idx = ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, I);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		all = rs.getInt(1);
	}else{
		all = 0;
	}
	
	Address   = new String[all];
	Food      = new String[all];
	Shopname  = new String[all];
	Tel       = new String[all];
	Latitude  = new String[all];
	Longitude = new String[all];
	Idx       = new String[all];
	Avg       = new String[all];
	Count     = new String[all];

	query = "SELECT * FROM res WHERE Idx = ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, I);
	rs = pstmt.executeQuery();

	if(rs.next()){
		if(rs.getString("address") != null){
			Address[j] = rs.getString("address");
		}else{
			Address[j] = rs.getString("address2");
		}
		Food[j]      = rs.getString("food");
		Shopname[j]  = rs.getString("shopname");
		Tel[j]       = rs.getString("tel");
		Latitude[j]  = rs.getString("latitude");
		Longitude[j] = rs.getString("longitude");
		Idx[j]       = rs.getString("Idx");
		j++;
	}else{
		out.println("<script>history.back();</script>");
		return;
	}

	query = "SELECT Score FROM eval WHERE Idx = ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, I);
	rs = pstmt.executeQuery();

	int allScore = 0;
	int count = 0;
	float avg = 0;
	if(rs.next()){
		rs.beforeFirst();
		while(rs.next()){
			allScore = allScore + rs.getInt("Score");
			count++;
		}
		avg = (float) allScore / count;
		Avg[0] = String.format("%.2f", avg);
		Count[0] = Integer.toString(count);
	}else{
		Avg[0] = "0";
		Count[0] = "0";
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
%>