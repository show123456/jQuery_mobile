<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%
Connection conn         = null;
PreparedStatement pstmt = null;		
ResultSet rs            = null;
ResultSet rs2            = null;

Context initCtx = new InitialContext();
Context envCtx  = (Context) initCtx.lookup("java:comp/env");
DataSource ds   = (DataSource) envCtx.lookup("jdbc/jquery");

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
	String query = "SELECT COUNT(DISTINCT Idx) FROM eval";
	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		all = rs.getInt(1);
	}else{
		all = 0;
	}
	all = 10;
	Address   = new String[all];
	Food      = new String[all];
	Shopname  = new String[all];
	Tel       = new String[all];
	Latitude  = new String[all];
	Longitude = new String[all];
	Idx       = new String[all];
	Avg       = new String[all];
	Count     = new String[all];

	query = "SELECT * FROM eval as A, res as B WHERE A.Idx = B.Idx GROUP BY A.Idx ORDER BY sum(A.Score) desc, avg(A.Score) desc, count(A.Score) desc limit 10";
	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();

	while(rs.next()){
		if(rs.getString("B.address") != null){
			Address[j] = rs.getString("B.address");
		}else{
			Address[j] = rs.getString("B.address2");
		}
		Food[j]      = rs.getString("B.food");
		Shopname[j]  = rs.getString("B.shopname");
		Tel[j]       = rs.getString("B.tel");
		Latitude[j]  = rs.getString("B.latitude");
		Longitude[j] = rs.getString("B.longitude");
		Idx[j]       = rs.getString("B.Idx");
		

		query = "SELECT Score FROM eval WHERE Idx = ?";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, rs.getString("B.Idx"));
		rs2 = pstmt.executeQuery();

		int allScore = 0;
		int count = 0;
		float avg = 0;
		if(rs2.next()){
			rs2.beforeFirst();
			while(rs2.next()){
				allScore = allScore + rs2.getInt("Score");
				count++;
			}
			avg = (float) allScore / count;
			Avg[j] = String.format("%.2f", avg);
			Count[j] = Integer.toString(count);
		}else{
			Avg[j] = "0";
			Count[j] = "0";
		}
		j++;
	}

	

} catch(SQLException e) {
	out.println(e.toString());
} finally {
	if (rs != null) {
        try {rs.close();} catch (SQLException e) { /* ignored */}
    }
    if (rs2 != null) {
        try {rs2.close();} catch (SQLException e) { /* ignored */}
    }
    if (pstmt != null) {
        try {pstmt.close();} catch (SQLException e) { /* ignored */}
    }
    if (conn != null) {
        try {conn.close();} catch (SQLException e) { /* ignored */}
    }
}
%>