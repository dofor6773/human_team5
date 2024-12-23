<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    String actionType = request.getParameter("actionType");
	String actionTypeSearch = request.getParameter("actionTypeSearch");

	if ("search".equals(actionTypeSearch)) {
        // 사원명 검색 파라미터 가져오기
        String searchEmployeeName = request.getParameter("searchEmployeeName");

        // 데이터베이스 연결 설정
        Connection conn = DBManager.getDBConnection();
        if (conn == null) {
            System.out.println("<p>데이터베이스 연결 실패</p>");
        } else {
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            // 기본 SQL 쿼리
            String sql = "SELECT employee_id, employee_name, contact_number,department,position,hire_date, termination_date "
                       + " FROM Employees ";
            
            // 검색어가 있을 경우 SQL 쿼리 수정 (제품명 기준 검색)
            if (searchEmployeeName != null && !searchEmployeeName.trim().isEmpty()) {
                sql += " WHERE employee_name  LIKE ?";
            }
            
            sql += "ORDER BY employee_id";

            try {
                pstmt = conn.prepareStatement(sql);

                // 검색어가 있을 경우 파라미터 설정
                if (searchEmployeeName != null && !searchEmployeeName.trim().isEmpty()) {
                    pstmt.setString(1, "%" + searchEmployeeName + "%");
                }            

                rs = pstmt.executeQuery();

                // 테이블 헤더와 tbody 시작 태그
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
    }else if ("register".equals(actionType)) {
    	//날짜 받아오기
        SimpleDateFormat sdf = new SimpleDateFormat("yyMM");
        String yearCode = sdf.format(new Date());
    	
        // Insert Employees into the database
        String employeeId = request.getParameter("employeeId"); 
        String employeeName = request.getParameter("employeeName");
        String password = request.getParameter("password");
        String contactNumber = request.getParameter("contactNumber");
        String department = request.getParameter("department");
        String position = request.getParameter("position");
        String hireDate = request.getParameter("hireDate"); 
        String terminationDate = request.getParameter("terminationDate");         

        String insertSQL = "INSERT into Employees (employee_id, employee_name, password, hire_date, termination_date, department, position, contact_number, registered_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        	
        try (Connection conn = DBManager.getDBConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(insertSQL);
            pstmt.setString(1, employeeId);
            pstmt.setString(2, employeeName);
            pstmt.setString(3, password);
            pstmt.setString(4, hireDate);
            pstmt.setString(5, terminationDate);
            pstmt.setString(6, department);
            pstmt.setString(7, position);
            pstmt.setString(8, contactNumber);
            pstmt.setString(9, "로긴사용자");
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else if ("update".equals(actionType)) {
	    	// Update Employees in the database
	        String employeeId = request.getParameter("employeeId");
	        String employeeName = request.getParameter("employeeName");
	        String contactNumber = request.getParameter("contactNumber");
	        String department = request.getParameter("department");
	        String position = request.getParameter("position");
	        String hireDate = request.getParameter("hireDate"); 
	        String terminationDate = request.getParameter("terminationDate"); 

	        String updateSQL = "UPDATE Employees SET employee_name = ?, contact_number = ?, department = ?, position = ?, hire_date = ?, termination_date = ? WHERE employee_id = ?";
        
        	System.out.println("updateSQL : " + updateSQL);
        
        try (Connection conn = DBManager.getDBConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(updateSQL);
            pstmt.setString(1, employeeName);
            pstmt.setString(2, contactNumber);
            pstmt.setString(3, department);
            pstmt.setString(4, position);
            pstmt.setString(5, hireDate);
            pstmt.setString(6, terminationDate);
            pstmt.setString(7, employeeId);
            
         // 각 파라미터 값 출력
            System.out.println("SQL: " + updateSQL); // SQL 쿼리 출력
            System.out.println("employeeName: " + employeeName);
            System.out.println("contactNumber: " + contactNumber);
            System.out.println("department: " + department);
            System.out.println("position: " + position);
            System.out.println("hireDate: " + hireDate);
            System.out.println("terminationDate: " + terminationDate);
            /* System.out.println("password: " + password); */
            System.out.println("registeredBy: 로긴사용자");
            System.out.println("employeeId: " + employeeId);
            
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
	if ("register".equals(actionType)||"update".equals(actionType)||"delete".equals(actionType)) {
		response.sendRedirect("./employees.jsp");
	}
%>