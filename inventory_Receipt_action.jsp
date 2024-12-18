<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    String actionType = request.getParameter("actionType");

    if ("register".equals(actionType)) {
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
	response.sendRedirect("./inventory_Receipt.jsp");
%>
