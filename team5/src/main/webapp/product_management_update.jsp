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
    int rows = 0;
	boolean isSuccess = false;
	String errMsg = "";
    // UPDATE
    String updateSql = "UPDATE product SET PRODUCT_NAME = ?, CURRENT_CATEGORY = ?, PACKAGING_UNIT = ?, EFFICACY_GROUP = ?, PRODUCTION_TYPE = ? WHERE PRODUCT_CODE = ?";

    try {
    	PreparedStatement pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, productName);
        pstmt.setString(2, currentCategory);
        pstmt.setString(3, packagingUnit);
        pstmt.setString(4, efficacyGroup);
        pstmt.setString(5, productionType);
        pstmt.setString(6, productCode);

		rows = pstmt.executeUpdate();
        DBManager.dbClose(conn, pstmt, null);
        isSuccess = true;
        
    } catch (Exception e) {
        e.printStackTrace();
        errMsg = e.getMessage();
    }
%>
<%
	if (isSuccess) {
%>
<script>
	alert('수정되었습니다.');
	location.href = './product_management.jsp';
</script>
<%
	} else { 
%>
<script>
	alert('수정에 실패하였습니다. 에러 사유: <%= errMsg %>');
	location.href = './product_managemnet.jsp;
</script>
<%
	}
%>
