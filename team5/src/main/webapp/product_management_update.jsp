<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%
    // 한글 처리
    request.setCharacterEncoding("UTF-8");

    // 수정값
    String productCode = request.getParameter("productCode");
    String productName = request.getParameter("productName");
    String currentCategory = request.getParameter("productType");
    String packagingUnit = request.getParameter("packagingUnit");
    String efficacyGroup = request.getParameter("efficacyGroup");
    String productionType = request.getParameter("productionType");

    // DB 연결
    Connection conn = DBManager.getDBConnection();

    // UPDATE
    String updateSql = "UPDATE product SET PRODUCT_NAME = ?, CURRENT_CATEGORY = ?, PACKAGING_UNIT = ?, EFFICACY_GROUP = ?, PRODUCTION_TYPE = ? WHERE PRODUCT_CODE = ?";

    try {
        PreparedStatement pstmt = pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, productName);
        pstmt.setString(2, currentCategory);
        pstmt.setString(3, packagingUnit);
        pstmt.setString(4, efficacyGroup);
        pstmt.setString(5, productionType);
        pstmt.setString(6, productCode);

        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            //성공시 바로 html파일로 넘어감
            response.sendRedirect("product_management.jsp");
        } else {
            out.println("제품 등록에 실패했습니다.");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBManager.dbClose(conn, pstmt, null);
    }
%>
