<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    String actionType = request.getParameter("actionType");
	String actionTypeSearch = request.getParameter("actionTypeSearch");

	if ("search".equals(actionTypeSearch)) {
        // 제품명 검색 파라미터 가져오기
        String searchProductName = request.getParameter("searchProductName");

        // 데이터베이스 연결 설정
        Connection conn = DBManager.getDBConnection();
        if (conn == null) {
            System.out.println("<p>데이터베이스 연결 실패</p>");
        } else {
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            // 기본 SQL 쿼리
            String sql = "SELECT receipt_id, product_code, "
                       + "(SELECT product_name FROM Product b WHERE a.product_code = b.product_code) AS product_name, "
                       + "quantity, supplier, warehouse_location, TO_CHAR(receipt_date, 'YYYY-MM-DD') AS receipt_date, "
                       + "registered_by, TO_CHAR(registered_date, 'YYYY-MM-DD') AS registered_date "
                       + "FROM Inventory_Receipt a ";
            
            // 검색어가 있을 경우 SQL 쿼리 수정 (제품명 기준 검색)
            if (searchProductName != null && !searchProductName.trim().isEmpty()) {
                sql += " WHERE a.product_code IN (SELECT product_code FROM Product WHERE product_name LIKE ?)";
            }
            
            sql += "ORDER BY product_code";

            try {
                pstmt = conn.prepareStatement(sql);

                // 검색어가 있을 경우 파라미터 설정
                if (searchProductName != null && !searchProductName.trim().isEmpty()) {
                    pstmt.setString(1, "%" + searchProductName + "%");
                }            

                rs = pstmt.executeQuery();

                // 테이블 헤더와 tbody 시작 태그
                out.println("<thead>");
                out.println("<tr>");
                out.println("<th>입고 ID</th>");
                out.println("<th>제품 코드</th>");
                out.println("<th>제품명</th>");
                out.println("<th>입고 수량</th>");
                out.println("<th>공급업체</th>");
                out.println("<th>창고 위치</th>");
                out.println("<th>입고일자</th>");
                out.println("<th>등록자</th>");
                out.println("<th>등록일자</th>");
                out.println("</tr>");
                out.println("</thead>");
                out.println("<tbody>");
                
                while (rs.next()) {
                    String receiptId = rs.getString("receipt_id");
                    String productCode = rs.getString("product_code");
                    String productName = rs.getString("product_name");
                    String quantity = rs.getString("quantity");
                    String supplier = rs.getString("supplier");
                    String warehouseLocation = rs.getString("warehouse_location");
                    String receiptDate = rs.getString("receipt_date");
                    String registeredBy = rs.getString("registered_by");
                    String registeredDate = rs.getString("registered_date");
                    
                    out.println("<tr>");
                    out.println("<td>" + receiptId + "</td>");
                    out.println("<td>" + productCode + "</td>");
                    out.println("<td>" + productName + "</td>");
                    out.println("<td>" + quantity + "</td>");
                    out.println("<td>" + supplier + "</td>");
                    out.println("<td>" + warehouseLocation + "</td>");
                    out.println("<td>" + receiptDate + "</td>");
                    out.println("<td>" + registeredBy + "</td>");
                    out.println("<td>" + registeredDate + "</td>");
                    out.println("</tr>");
                }

                out.println("</tbody>");
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }else if ("register".equals(actionType)) {
        // Insert product into the database
        String productCode = request.getParameter("productCode");
        String quantity = request.getParameter("quantity");
        String supplier = request.getParameter("supplier");
        String warehouseLocation = request.getParameter("warehouseLocation");
        String receiveDate = request.getParameter("receiveDate");
        String receiptId = request.getParameter("receiptId"); //hidden값
        

        String insertSQL = "INSERT INTO Inventory_Receipt (product_code, quantity, supplier, warehouse_location, receipt_date, registered_by) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBManager.getDBConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(insertSQL);
            pstmt.setString(1, productCode);
            pstmt.setString(2, quantity);
            pstmt.setString(3, supplier);
            pstmt.setString(4, warehouseLocation);
            pstmt.setString(5, receiveDate);
            pstmt.setString(6, "로긴사용자");
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else if ("update".equals(actionType)) {
    	// Update product in the database
        String receiptId = request.getParameter("receiptId");
        String productCode = request.getParameter("productCode");
        String quantity = request.getParameter("quantity");
        String supplier = request.getParameter("supplier");
        String warehouseLocation = request.getParameter("warehouseLocation");
        String receiveDate = request.getParameter("receiveDate");

        String updateSQL = "UPDATE Inventory_Receipt SET product_code = ?, quantity = ?, supplier = ?, warehouse_location = ?, receipt_date = ? WHERE receipt_id = ?";
        try (Connection conn = DBManager.getDBConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(updateSQL);
            pstmt.setString(1, productCode);
            pstmt.setString(2, quantity);
            pstmt.setString(3, supplier);
            pstmt.setString(4, warehouseLocation);
            pstmt.setString(5, receiveDate);
            pstmt.setString(6, receiptId);  // Use the receiptId to identify which record to update
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else if ("delete".equals(actionType)) {
        // Delete product from the database
        String receiptId = request.getParameter("receiptId");
        String deleteSQL = "DELETE FROM Inventory_Receipt WHERE receipt_id = ?";
        try (Connection conn = DBManager.getDBConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(deleteSQL);
            pstmt.setString(1, receiptId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<%
	if ("register".equals(actionType)||"update".equals(actionType)||"update".equals(actionType)) {
		response.sendRedirect("./inventory_Receipt.jsp");
	}
%>
