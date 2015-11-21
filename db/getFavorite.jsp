<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%
Connection conn         = null;
PreparedStatement pstmt = null;		
ResultSet rs            = null;

Context initCtx = new InitialContext();
Context envCtx  = (Context) initCtx.lookup("java:comp/env");
DataSource ds   = (DataSource) envCtx.lookup("jdbc/jquery");

String Address[]   = null;
String Food[]      = null;
String Shopname[]  = null;
String Tel[]       = null;
String Date[]      = null;
String Latitude[]  = null;
String Longitude[] = null;
String Idx[]       = null;

int j = 0;
int all = 0;

try {
	conn = ds.getConnection();
	String query = "SELECT COUNT(*) FROM favorite";
	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		all = rs.getInt(1);
	}
	
	Address   = new String[all];
	Food      = new String[all];
	Shopname  = new String[all];
	Tel       = new String[all];
	Date      = new String[all];
	Latitude  = new String[all];
	Longitude = new String[all];
	Idx       = new String[all];

	query = "SELECT A.Date, B.address, B.address2, B.food, B.shopname, B.tel, B.latitude, B.longitude, B.Idx FROM favorite as A, res as B WHERE A.Idx_res = B.Idx ORDER BY A.Idx DESC";
	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();

	while(rs.next()){
		
		if(rs.getString("B.address") != null){
			Address[j] = rs.getString("B.address");
		} else {
			Address[j] = rs.getString("B.address2");
		}
		Food[j]      = rs.getString("B.food");
		Shopname[j]  = rs.getString("B.shopname");
		Tel[j]       = rs.getString("B.tel");
		Date[j]      = rs.getString("A.Date");
		Latitude[j]  = rs.getString("B.latitude");
		Longitude[j] = rs.getString("B.longitude");
		Idx[j]       = rs.getString("B.Idx");
		j++;
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