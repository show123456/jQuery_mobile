<%@page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%
request.setCharacterEncoding("UTF-8");

String Id = request.getParameter("id");
String Pw = request.getParameter("pw");
String Gender = request.getParameter("gender");
String Name = request.getParameter("name");

String[] array = { Id, Pw };
int nullCount = 0;
for (int i = 0; i < array.length; i++) {
	if (array[i] == null || array[i].equals("")) {
		nullCount++;
	}
}
if(nullCount == 0){
	Connection conn         = null;
	PreparedStatement pstmt = null;		
	ResultSet rs            = null;

	Context initCtx = new InitialContext();
	Context envCtx  = (Context) initCtx.lookup("java:comp/env");
	DataSource ds   = (DataSource) envCtx.lookup("jdbc/jquery");

	try {
		conn = ds.getConnection();
		String query = "SELECT Email FROM member WHERE Email = ?";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, Id);
		
		rs = pstmt.executeQuery();

		if(rs.next()){
			out.print(false);
		}else{
			query = "INSERT INTO member(Email, Pw, Name, Gender, Thumbnail, JoinDate, Type) VALUES(?,?,?,?,?,now(),?)";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, Id);
			pstmt.setString(2, Pw);
			pstmt.setString(3, Name);
			pstmt.setString(4, Gender);
			pstmt.setString(5, "/images/thumbnail/1.png");
			pstmt.setString(6, "member");
			pstmt.execute();
			
			out.print(true);
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