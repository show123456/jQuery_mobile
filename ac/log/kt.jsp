<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, javax.sql.*, java.util.*"%>
<%
	String IP = request.getHeader("X-Forwarded-For");
	if (IP == null) {
		IP = request.getRemoteAddr();
	}
	String id = "";
	String name = "";
	String thumb = "";
	
	if(request.getParameter("userid") != null){
		id = request.getParameter("userid");
	}
	if(request.getParameter("username") != null){
		name = request.getParameter("username");
	}
	if(request.getParameter("userthumb") != null){
		thumb = request.getParameter("userthumb");
	}
	String sns = "kakao";
	if(id != ""){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
	
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/jquery");
		
		try {
			conn = ds.getConnection();
			String query = "SELECT * FROM member WHERE Email = ?";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if (rs.next()){
				session.setAttribute("Name", rs.getString("Name"));
				session.setAttribute("Idx", rs.getString("Idx"));
				session.setAttribute("Email", "카카오 접속 중");
				session.setAttribute("Type", rs.getString("Type"));
				session.setAttribute("Thumbnail", rs.getString("Thumbnail"));
			}	

			rs.beforeFirst();

			if (!rs.next()) {
				query = "INSERT INTO member(Email, Name, Thumbnail, JoinDate, Type) VALUES(?, ?, ?, now(), ?)";
				pstmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, id);
				pstmt.setString(2, name);
				pstmt.setString(3, thumb);
				pstmt.setString(4, sns);
				pstmt.execute();

				rs2 = pstmt.getGeneratedKeys();

				if(rs2.next()){
					String Idx = rs2.getInt(1) + "";
					session.setAttribute("Name", name);
					session.setAttribute("Idx", Idx);
					session.setAttribute("Email", "카카오 접속 중");
					session.setAttribute("Type", sns);
					session.setAttribute("Thumbnail", thumb);
				}
			}
			
			
			out.print(true);
			
		} catch (SQLException e) {
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
	}
%>