<%@page import="oracle.jdbc.proxy.annotation.Pre"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
	request.setCharacterEncoding("UTF-8");
	String productCode = request.getParameter("product_code");
	
	Connection conn = DBManager.getDBConnection();
	
	String sql = "DELETE FROM product WHERE product_code = ?";
	int rows =0;
	try{
		//DELETE SQL 실행
		//PreparedStatement 얻기 & 값 지정
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, productCode);
		rows = pstmt.executeUpdate();
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.dbClose(conn, null, null);
	}
%>
<%= productCode %>번호 삭제
<%
	response.sendRedirect("./product_management.jsp");
%>