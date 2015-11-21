<%@page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.naming.*, javax.sql.*, java.util.*, java.text.*"%>
<%
request.setCharacterEncoding("UTF-8");

String Idx = request.getParameter("idx");

String[] array = { Idx };
int nullCount = 0;
for (int i = 0; i < array.length; i++) {
	if (array[i] == null || array[i].equals("")) {
		nullCount++;
	}
}
if(nullCount == 0){
	
	Thread.sleep(1000);
	Connection conn = null;
	PreparedStatement pstmt = null;		
	ResultSet rs = null;

	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	DataSource ds = (DataSource) envCtx.lookup("jdbc/jquery");

	try {
		conn = ds.getConnection();
		String query = "DELETE FROM favorite WHERE Idx_res = ?";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, Idx);
		pstmt.execute();

		out.println(true);
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

}else{
	out.println(false);
}

%>