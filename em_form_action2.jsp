<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.SimpleDateFormat" %> 
<%@ page import="java.sql.Date" %>
<%
    String actionType = request.getParameter("actionType");
    String actionTypeSearch = request.getParameter("actionTypeSearch");

    if ("search".equals(actionTypeSearch)) {
        String searchEmployeeName = request.getParameter("searchEmployeeName");
        
        Connection conn = DBManager.getDBConnection();
        if (conn == null) {
            out.println("<p>데이터베이스 연결 실패</p>");
        } else { 
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String sql = "SELECT employee_id, employee_name, REGEXP_REPLACE(contact_number , '(\\d{3})(\\d{3})(\\d{4})', '\\1-\\2-\\3'), department, position, hire_date, termination_date "
                       + "FROM Employees";
            // 형식 바꿔줘야 하는 칼럼명: contact_number, hire_date, termination_date
            
            // 검색어가 있으면, sql문 수정
            if (searchEmployeeName != null && !searchEmployeeName.trim().isEmpty()) {
                sql += " WHERE employee_name LIKE ?";
            }

            try {
                pstmt = conn.prepareStatement(sql);

                if (searchEmployeeName != null && !searchEmployeeName.trim().isEmpty()) {
                    pstmt.setString(1, "%" + searchEmployeeName + "%");
                }

                rs = pstmt.executeQuery();

                out.println("<thead>");
                out.println("<tr>");
                out.println("<th>사원번호</th>");
                out.println("<th>사원명</th>");
                out.println("<th>연락처</th>");
                out.println("<th>부서</th>");
                out.println("<th>직급</th>");
                out.println("<th>입사일</th>");
                out.println("<th>퇴사일</th>");
                out.println("</tr>");
                out.println("</thead>");
                out.println("<tbody>");

                while (rs.next()) {
                    String employeeId = rs.getString("employee_id");
                    String employeeName = rs.getString("employee_name");
                    String contactNumber = rs.getString("contact_number");
                    String department = rs.getString("department");
                    String position = rs.getString("position");
                    String hireDate = rs.getString("hire_date");
                    String terminationDate = rs.getString("termination_date");

                    out.println("<tr>");
                    out.println("<td>" + employeeId + "</td>");
                    out.println("<td>" + employeeName + "</td>");
                    out.println("<td>" + contactNumber + "</td>");
                    out.println("<td>" + department + "</td>");
                    out.println("<td>" + position + "</td>");
                    out.println("<td>" + hireDate + "</td>");
                    out.println("<td>" + terminationDate + "</td>");
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
    } else if ("register".equals(actionType)) {
        String employeeId = request.getParameter("employeeId");
        String employeeName = request.getParameter("employeeName");
        String contactnumber = request.getParameter("contactnumber");
        String position = request.getParameter("position");
        String department = request.getParameter("department");
        Date hireDate = Date.valueOf(request.getParameter("Hire_date")); 
        Date terminationDate = Date.valueOf(request.getParameter("termination_date")); 
        
        String insertSQL = "INSERT INTO Employees(employee_id, employee_name, contact_number, position, department, hire_date, termination_date) VALUES(?,?,?,?,?,?,?)";
        try (Connection conn = DBManager.getDBConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(insertSQL);
            pstmt.setString(1, employeeId);
            pstmt.setString(2, employeeName);
            pstmt.setString(3, contactnumber);
            pstmt.setString(4, position);
            pstmt.setString(5, department);
            pstmt.setDate(6, hireDate);
            pstmt.setDate(7, terminationDate);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else if ("update".equals(actionType)) {
        String employeeId = request.getParameter("employeeId");
        String employeeName = request.getParameter("employeeName");
        String contactnumber = request.getParameter("contactnumber");
        String position = request.getParameter("position");
        String department = request.getParameter("department");
        Date hireDate = Date.valueOf(request.getParameter("Hire_date")); 
        Date terminationDate = Date.valueOf(request.getParameter("termination_date")); 

        String updateSQL = "UPDATE Employees SET employee_name = ?, contact_number = ?, position = ?, department = ?, hire_date = ?, termination_date = ? WHERE employee_id = ?";
        try (Connection conn = DBManager.getDBConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(updateSQL);
            pstmt.setString(1, employeeName);
            pstmt.setString(2, contactnumber);
            pstmt.setString(3, position);
            pstmt.setString(4, department);
            //pstmt.setDate(5, hireDate);
            //pstmt.setDate(6, terminationDate);
            pstmt.setString(7, employeeId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else if ("delete".equals(actionType)) {
        String employeeId = request.getParameter("employeeId");
        String deleteSQL = "DELETE FROM Employees WHERE employee_id = ?";
        try (Connection conn = DBManager.getDBConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(deleteSQL);
            pstmt.setString(1, employeeId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<%
    if ("register".equals(actionType) || "update".equals(actionType)) {
        response.sendRedirect("./em_form_action.jsp");
    }
%>
