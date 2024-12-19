<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>제품 검색</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
    </style>
</head>
<body>
    <h2>제품 검색</h2>
    
    <form method="POST">
        <label for="searchProduct">제품명 검색:</label>
        <input type="text" id="searchProduct" name="searchProduct">
        <button type="submit">검색</button>
    </form>
    
    <table>
        <thead>
            <tr>
                <th>제품 코드</th>
                <th>제품명</th>
            </tr>
        </thead>
        <tbody>
            <% 
                String searchProduct = request.getParameter("searchProduct");
                String sql = "SELECT product_code, product_name FROM Product";
                if (searchProduct != null && !searchProduct.trim().isEmpty()) {
                    sql += " WHERE product_name LIKE ?";
                }
                
                Connection conn = DBManager.getDBConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                if (searchProduct != null && !searchProduct.trim().isEmpty()) {
                    pstmt.setString(1, "%" + searchProduct + "%");
                }
                ResultSet rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    String productCode = rs.getString("product_code");
                    String productName = rs.getString("product_name");
            %>
                <tr onclick="selectProduct('<%= productCode %>', '<%= productName %>')">
                    <td><%= productCode %></td>
                    <td><%= productName %></td>
                </tr>
            <% 
                }
            %>
        </tbody>
    </table>

    <script>
        function selectProduct(productCode, productName) {
            window.opener.document.getElementById('productCode').value = productCode;
            window.opener.document.getElementById('productName').value = productName;
            window.close();
        }
    </script>

</body>
</html>
