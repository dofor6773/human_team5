<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>

<%
    // 폼에서 넘어온 데이터 받기
    String productCode = request.getParameter("productCode");
    String productName = request.getParameter("productName");
    String currentCategory = request.getParameter("productType");  // 카테고리
    String packagingUnit = request.getParameter("packaging");
    String efficacyGroup = request.getParameter("effect");
    String productionType = request.getParameter("productionType");
    String registeredBy = "관리자";  // 관리자

    // DB 연결
    Connection conn = DBManager.getDBConnection();
    String insertSql = "INSERT INTO product (PRODUCT_CODE, PRODUCT_NAME, CURRENT_CATEGORY, PACKAGING_UNIT, EFFICACY_GROUP, PRODUCTION_TYPE, REGISTERED_BY) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    PreparedStatement pstmt = null;
    try {
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, productCode);
        pstmt.setString(2, productName);
        pstmt.setString(3, currentCategory);
        pstmt.setString(4, packagingUnit);
        pstmt.setString(5, efficacyGroup);
        pstmt.setString(6, productionType);
        pstmt.setString(7, registeredBy);  // 관리자 값

        int result = pstmt.executeUpdate();  // 데이터베이스에 데이터 삽입

        if (result > 0) {
            out.println("<p>제품이 성공적으로 등록되었습니다.</p>");
        } else {
            out.println("<p>제품 등록에 실패했습니다. 다시 시도해 주세요.</p>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
    } finally {
        // PreparedStatement 사용 후 자원 닫기
        DBManager.dbClose(conn, pstmt, null);
    }

    // 등록된 제품 목록을 가져오는 SQL 쿼리 (PreparedStatement 사용)
    String selectSql = "SELECT * FROM product";
    ResultSet rs = null;
    PreparedStatement pstmtSelect = null;

    try {
        pstmtSelect = conn.prepareStatement(selectSql);
        rs = pstmtSelect.executeQuery();

%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>제품관리</title>
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>
    <h2>제품관리</h2>
    
    <!-- 입력 폼 -->
    <div class="form-container">
        <label>제품코드</label>
        <input type="text" id="productCode" readonly><br>
        <label>등록일</label>
        <input type="text" id="productDate" readonly><br>
        <label>제품명</label>
        <input type="text" id="productName"><br>
        <label>제품구분</label>
        <select id="productType">
            <option value="OTC" selected>일반의약품</option>
            <option value="Rx">전문의약품</option>
            <option value="NonPharmaceutical">의약외품</option>
        </select><br>
        <label>포장단위</label>
        <input type="text" id="packaging"><br>
        <label>효능군</label>
        <input type="text" id="effect"><br>
        <label>생산구분</label>
        <select id="productionType">
            <option value="Normal" selected>정상</option>
            <option value="Suspended">중단</option>
        </select><br>
        <button onclick="addProduct()">등록</button>
    </div>

    <!-- 제품 목록 테이블 -->
    <h3>등록된 제품 목록</h3>
    <table>
        <thead>
            <tr>
                <th>제품코드</th>
                <th>제품명</th>
                <th>제품구분</th>
                <th>포장단위</th>
                <th>효능군</th>
                <th>생산구분</th>
                <th>등록자</th>
                <th>등록일</th>
            </tr>
        </thead>
        <tbody>
            <%
                // 결과를 테이블에 표시
                while (rs.next()) {
                    String code = rs.getString("PRODUCT_CODE");
                    String name = rs.getString("PRODUCT_NAME");
                    String category = rs.getString("CURRENT_CATEGORY");
                    String packaging = rs.getString("PACKAGING_UNIT");
                    String efficacy = rs.getString("EFFICACY_GROUP");
                    String production = rs.getString("PRODUCTION_TYPE");
                    registeredBy = rs.getString("REGISTERED_BY");
            %>
            <tr>
                <td><%= code %></td>
                <td><%= name %></td>
                <td><%= category %></td>
                <td><%= packaging %></td>
                <td><%= efficacy %></td>
                <td><%= production %></td>
                <td><%= registeredBy %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <script src="script.js"></script>
</body>
</html>

<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        DBManager.dbClose(conn, pstmtSelect, rs);  // PreparedStatement와 ResultSet을 닫음
    }
%>
