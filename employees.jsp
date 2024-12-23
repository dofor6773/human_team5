<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사원관리</title>
    <link rel="stylesheet" href="./css/inventory_receipt.css">
    <script src="script.js"></script>
</head>
<body>
    <div class="container">
        <header>
        	<div class="top">
	            <nav>
	            	<a href="./login.jsp">l 로그인</a>
	                <a href="./product_management.jsp">l 제품관리</a>
	                <a href="./em_input.html">l 사원관리</a>
	                <!-- <a href="./inventory_Receipt.jsp">l 입고관리</a> -->
	            </nav>
	            <span>
		            <%= session.getAttribute("department") %> >
		            <%= session.getAttribute("position") %> >
		            <%= session.getAttribute("employeeName") %>
		        </span>
            </div>
            <h1>사원관리</h1>
            <p>            
        </header>

        <!-- 사원 정보 입력 폼 -->
       <form id="employessForm" method="POST">
    <div class="input-group">
        <label for="employeeId">사원번호(id)</label>
        <input type="text" id="employeeId" name="employeeId" style="background-color:  #E2E2E2;" required >
    </div>

    <div class="input-group">
        <label for="password">비밀번호</label>
        <input type="text" id="password" name="password">
    </div>
    
    <div class="input-group">
        <label for="re-password">비밀번호<br>재확인</label>
        <input type="text" id="re-password" name="re-password">
    </div>
    
    <div class="input-group">
        <label for="employeeName">사원명</label>
        <input type="text" id="employeeName" name="employeeName">
    </div>
    
    <div class="input-group">
        <label for="hireDate">입사년월일</label>
        <input type="date" id="hireDate" name="hireDate" required>
    </div>
    
    <div class="input-group">
        <label for="terminationDate">퇴사년월일</label>
        <input type="date" id="terminationDate" name="terminationDate" required>
    </div>
    
    <div class="input-group">
        <label for="department">부서</label>
        <select id="department" name="department" required style="width: 100%;">
            <option value="HR" selected>인사부 (HR)</option>
            <option value="FI">재무부 (Finance)</option>
            <option value="LE">법무부 (Legal)</option>
            <option value="PR">생산부 (Production)</option>
            <option value="LO">물류부 (Logistics)</option>
            <option value="SA">영업부 (Sales)</option>     
            <option value="RD">연구부</option>         
            <option value="QC">품질 관리부 (Quality Control) </option>
            <option value="MT">마케팅부 (Marketing)</option>
            <option value="IT">IT부 (IT)</option>
        </select>
    </div>
    
    <div class="input-group">
        <label for="position">직급</label>
        <select id="position" name="position" required style="width: 100%;">
            <option value="">직급을 선택하세요</option>
            <option value="CEO">CEO (최고경영자)</option>
            <option value="COO">COO (최고운영책임자)</option>
            <option value="CFO">CFO (최고재무책임자)</option>
            <option value="CTO">CTO (최고기술책임자)</option>
            <option value="CSO">CSO (최고전략책임자)</option>
            <option value="Head_of_Department">부서장 (Head of Department)</option>
            <option value="Director">이사 (Director)</option>
            <option value="Associate_Director">차장 (Associate Director)</option>
            <option value="Manager">과장 (Manager)</option>
            <option value="Assistant_Manager">대리 (Assistant Manager)</option>
            <option value="Senior_Staff">주임 (Senior Staff)</option>
            <option value="Staff">사원 (Staff)</option>
            <option value="Researcher">연구원 (Researcher)</option>
            <option value="Production_Staff">생산직 (Production Staff)</option>
            <option value="Quality_Control">품질관리직 (Quality Control)</option>
            <option value="Sales_Representative">영업직 (Sales Representative)</option>
            <option value="Marketing">마케팅직 (Marketing)</option>
        </select>
    </div>
    
    <div class="input-group">
        <label for="contactNumber">연락처</label>
        <input type="text" id="contactNumber" name="contactNumber">
    </div>

    <input type="hidden" id="actionType" name="actionType">
    <input type="hidden" id="receiptId" name="receiptId">
    
    <div class="buttons">
        <button type="button" onclick="registerProduct()">등록</button>
        <button type="button" onclick="updateProduct()">수정</button>
        <button type="button" onclick="deleteProduct()">삭제</button>
        <button type="button" onclick="resetSearch()">새로고침</button>
    </div>
</form>        

        <!-- 하단 조회 버튼과 검색 입력란 -->
	    <div class="search">	        
	        <form id="searchForm"  method="POST">
		        <label for="searchEmployeeName">사원명</label>
		        <input type="text" id="searchEmployeeName" name="searchEmployeeName">
		        <input type="hidden" id="actionTypeSearch" name="actionTypeSearch">
		        <button type="submit" onclick="searchProduct()">조회</button>		        
		    </form>
	    </div>

        <!-- 입고된 제품 목록 -->
        <table id="receivingTable" onclick="selectRow(event)">
            <thead>
                <tr>
                    <th>사원번호</th>
                    <th>사원명</th>
                    <th>연락처</th>
                    <th>부서</th>
                    <th>직급</th>
                    <th>입사일</th>
                    <th>퇴사일</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // 데이터베이스 연결 설정
                    Connection conn = DBManager.getDBConnection();
                    if (conn == null) {
                        System.out.println("<p>데이터베이스 연결 실패</p>");
                    } else {
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        
                        // 제품명 검색 파라미터 가져오기
                        String searchEmployeeName = request.getParameter("searchEmployeeName");
                        
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

                            while (rs.next()) {
                            	String employeeId = rs.getString("employee_id");
                                String employeeName = rs.getString("employee_name");
                                String contactNumber = rs.getString("contact_number");
                                String department = rs.getString("department");
                                String position = rs.getString("position");
                                String hireDate = rs.getString("hire_date");
                                String terminationDate = rs.getString("termination_date");
                %>
                                <tr>
                                    <td><%= employeeId %></td>
                                    <td><%= employeeName %></td>
                                    <td><%= contactNumber %></td>
                                    <td><%= department %></td>
                                    <td><%= position %></td>
                                    <td><%= hireDate %></td>
                                    <td><%= terminationDate %></td>
                                </tr>
                <% 
                            }
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
                %>
            </tbody>
        </table>        
    </div>
    
	<script>
	    // 새로고침 기능을 위한 함수
	    function resetSearch() {
	        // 입력란을 초기화
	        document.getElementById('searchEmployeeName').value = '';
	        
	        // 페이지를 새로고침
	        location.reload(); // 페이지를 완전히 새로고침
	    }
	    
	    // 조회 버튼 클릭 시
	    function searchProduct() {
	        var searchEmployeeName = document.getElementById('searchEmployeeName').value;
	        
	        // AJAX 요청 보내기
	        var xhr = new XMLHttpRequest();
	        xhr.open("GET", "employees_action.jsp?actionTypeSearch=search&searchEmployeeName=" + searchEmployeeName, true);
	        xhr.onreadystatechange = function() {
	            if (xhr.readyState == 4 && xhr.status == 200) {
	                // 테이블에 결과 반영
	                document.getElementById('receivingTable').innerHTML = xhr.responseText;
	            }
	        };
	        xhr.send();
	    }
	    
	    // 등록 버튼 클릭 시
	    function registerProduct() {
	        document.getElementById('actionType').value = 'register';
	        document.getElementById('employessForm').action = './employees_action.jsp';
	        document.getElementById('employessForm').submit();
	    }
	    
	 	// 수정 버튼 클릭 시
	    function updateProduct() {
	        document.getElementById('actionType').value = 'update';
	        document.getElementById('employessForm').action = './employees_action.jsp';
	        document.getElementById('employessForm').submit();
	    }

	    // 삭제 버튼 클릭 시
	    function deleteProduct() {
	    	if (confirm('정말 삭제하시겠습니까?')) {
		        document.getElementById('actionType').value = 'delete';
		        document.getElementById('employessForm').action = './employees_action.jsp';
		        document.getElementById('employessForm').submit();
	    	}
	    }
	    
        // 테이블 행 클릭 시 선택된 값을 폼에 채우는 함수
        function selectRow(event) {
            // 클릭한 행을 선택
            var row = event.target.closest('tr');
            if (!row) return;

            // 각 열의 값을 폼 필드에 설정
            var cells = row.getElementsByTagName('td'); 
            document.getElementById('employeeId').value = cells[0].innerText; 
            document.getElementById('employeeName').value = cells[1].innerText;
            document.getElementById('contactNumber').value = cells[2].innerText;
            document.getElementById('department').value = cells[3].innerText; 
            document.getElementById('position').value = cells[4].innerText; 
            
         	// hireDate와 terminationDate는 날짜 형식으로 변환
            document.getElementById('hireDate').value = formatDate(cells[5].innerText); 
            document.getElementById('terminationDate').value = formatDate(cells[6].innerText); 
        }
        
	</script>
    
</body>
</html>