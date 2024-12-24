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
    <link rel="stylesheet" href="./css/employees.css">
    <script src="script.js"></script>
</head>
<body>
    <div class="container">
        <header>
        	<div class="top">
	            <nav>
	            	<a href="./login.jsp">l 로그인</a>
	                <a href="./product_management.jsp">l 제품관리</a>
	                <a href="./inventory_Receipt.jsp">l 입고관리</a>
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
       <form id="employeesForm" method="POST">
	    <div class="input-group">
	        <label for="employeeId">사원번호(id)</label>
	        <input type="text" id="employeeId" name="employeeId" style="background-color:  #E2E2E2;" required >
	    </div>
	
	    <div class="input-group">
	        <label for="password">비밀번호</label>
	        <input type="password" id="password" name="password" required >
	    </div>
	    
	    <div class="input-group">
	        <label for="re-password">비밀번호<br>재확인</label>
	        <input type="password" id="re-password" name="re-password" required >
	    </div>
	    
	    <div class="input-group">
	        <label for="employeeName">사원명</label>
	        <input type="text" id="employeeName" name="employeeName" required >
	    </div>
	    
	    <div class="input-group">
	        <label for="hireDate">입사년월일</label>
	        <input type="date" id="hireDate" name="hireDate" required>
	    </div>
	    
	    <div class="input-group">
	        <label for="terminationDate">퇴사년월일</label>
	        <input type="date" id="terminationDate" name="terminationDate" >
	    </div>
	    
	    <div class="input-group">
	        <label for="department">부서</label>
	        <select id="department" name="department" required style="width: 100%;">
	        	<option value="">부서를 선택하세요</option>
	            <option value="HR">인사부 (HR)</option>
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
	
		    <!-- hidden field to specify the action (등록, 수정, 삭제) -->
		    <input type="hidden" id="actionType" name="actionType">
	    
	    <div class="buttons">
	        <button type="submit" onclick="registerEmployee()">등록</button>
	        <button type="submit" onclick="updateEmployee()">수정</button>
	        <button type="submit" onclick="deleteEmployee()">삭제</button>
	        <button type="submit" onclick="resetSearch()">새로고침</button>
	    </div>
	</form>        

        <!-- 하단 조회 버튼과 검색 입력란 -->
	    <div class="search">	        
	        <form id="searchForm"  method="POST">
		        <label for="searchEmployeeName">사원명</label>
		        <input type="text" id="searchEmployeeName" name="searchEmployeeName">
		        <input type="hidden" id="actionTypeSearch" name="actionTypeSearch">
		        <button type="submit" onclick="searchEmployees()">조회</button>		        
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
                       String sql = "SELECT employee_id, employee_name, nvl(contact_number,'-') as contact_number,department,position,nvl(to_char(hire_date, 'YYYY-MM-DD'),'-') as hire_date, nvl(to_char(termination_date, 'YYYY-MM-DD'),'-') as termination_date "
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
	    function searchEmployee() {
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
	    function registerEmployee() {
	    	var password = document.getElementById('password').value;
	        var rePassword = document.getElementById('re-password').value;

	        // 비밀번호와 재입력한 비밀번호 비교
	        if (password !== rePassword) {
	            alert('비밀번호가 일치하지 않습니다.');
	            
	            // 비밀번호 필드만 초기화
	            document.getElementById('password').value = '';
	            document.getElementById('re-password').value = '';
	            
	            return; // 비밀번호가 일치하지 않으면 함수 종료
	        }
	        
	        document.getElementById('actionType').value = 'register';
	        document.getElementById('employeesForm').action = './employees_action.jsp';
	        document.getElementById('employeesForm').submit();
	    }
	    
	 	// 수정 버튼 클릭 시
		function updateEmployee() {
		    document.getElementById('actionType').value = 'update';
		    document.getElementById('employeesForm').action = './employees_action.jsp';
		    document.getElementById('employeesForm').submit();
		}

	    // 삭제 버튼 클릭 시
	    function deleteEmployee() {
	    	if (confirm('정말 삭제하시겠습니까?')) {
		        document.getElementById('actionType').value = 'delete';
		        document.getElementById('employeesForm').action = './employees_action.jsp';
		        document.getElementById('employeesForm').submit();
	    	}
	    }
	    
        // 테이블 행 클릭 시 선택된 값을 폼에 채우는 함수
        function selectRow(event) {
            // 클릭한 행을 선택
            var row = event.target.closest('tr');
            if (!row) return;

            // 각 열의 값을 폼 필드에 설정
            var cells = row.getElementsByTagName('td'); 
            
            document.getElementById('employeeId').value = cells[0].innerText;  		//사원번호 채우기	
            document.getElementById('employeeName').value = cells[1].innerText;		//사원명 채우기
            document.getElementById('contactNumber').value = cells[2].innerText;	//연락처 채우기
            document.getElementById('department').value = cells[3].innerText; 		//부서 채우기
            document.getElementById('position').value = cells[4].innerText; 		//직급채우기
            
         	// hireDate와 terminationDate는 날짜 형식으로 변환
            document.getElementById('hireDate').value = formatDate(cells[5].innerText.trim()); // 입사일은 날짜 형식으로 채우기
            document.getElementById('terminationDate').value = formatDate(cells[6].innerText.trim()); // 퇴사일은 날짜 형식으로 채우기
        }
        
     	// 날짜를 yyyy-mm-dd 형식으로 변환하는 함수
        function formatDate(dateString) {
            if (dateString === '-' || dateString === '') {
                return ''; // 빈 문자열 반환 (입사일 또는 퇴사일이 없는 경우)
            }

            // 'yyyy-mm-dd' 형식으로 반환
            return dateString.split('-').join('-');
        }
        
	</script>
    
</body>
</html>
