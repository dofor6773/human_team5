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
    <title>사원관리 페이지</title>
    <link rel="stylesheet" href="./css/em.css">
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
	                <a href="./inventory_Receipt.jsp">l 입고관리</a>
	            </nav>
	            <span>
		            <%= session.getAttribute("department") %> >
		            <%= session.getAttribute("position") %> >
		            <%= session.getAttribute("employeeName") %>
		        </span>
		        <h1>사원관리</h1>
            <p>  
            </div>
        </header>

        <!-- 상단 버튼들 (등록, 수정, 삭제) -->
        <div class="buttons">
            <button onclick="registerProduct()">등록</button>
            <button onclick="updateProduct()">수정</button>
            <button onclick="deleteProduct()">삭제</button>
		    <button onclick="resetSearch()">새로고침</button>
        </div>
        <p>

        <!-- 사원정보 정보 입력 폼 -->
        <form id="EmployeesForm"  method="POST" style="width: auto;"">
            <label for="EmployeesId">사원번호</label>
            <input type="text" id="employee_id" name="employee_id">

            <label for="EmployeessName">사원명</label>
            <input type="text" id="EmployeesIdName" name="EmployeesIdName" required>

            <p>

            <label for="Password">p.w</label>
            <input type="Password" id="password" name="password" required>
            
            <label for="Re_Password">p.w 재확인</label>
            <input type="Password" id="re_password" name="re_password">
            <input type="button" value="제출" onclick="javascript: passwordCheck();"> 
            
      		<p>

            <label for="Joy firm">입사년월일</label>
            <input type="date" id="joy firm" name="joy firm" min="1990-01-01" max="2025-01-01"> 

            <label for="Naga firm">퇴사년월일</label>
            <input type="date" id="naga firm" name="naga firm min="1990-01-01" max="2025-01-01" >
            
            <p>
                  
            <label for="department">부서</label>
          	  <select id="department" style = "display: inline-block;">
          		<option value="" disabled selected>부서</option>
          		<option value="HR">인사팀</option>
          		<option value="Manufacture">생산팀</option>
        	 </select> 
            
             <label for="position">직급</label>
          	  <select id="position" style = "display: inline-block;">
          		<option value="" disabled selected>직급</option>
          		<option value="Manager">관리자</option>
          		<option value="TeamLeader">팀장</option>
          		<option value="TeamMember">사원</option>
        	 </select> 
            
            <p>
            
            <label for="receiveDate">연락처</label>
            <input type="tel" id="em_tel" name="em_tel" pattern="^010-\d{4}-\{4}$" placeholder="010-000-0000" style = "display: inline-block;">
            
            <p>
            
            <form>
          	 <label for="Home">주소</label>
          	  <div class="address-container">
			   <select id="sido" name="sido" onchange="updateGugun()">
    			<option value=""> 시도를 선택하세요 </option>
    			<option value="서울">서울특별시</option>
    			<option value="부산">부산광역시</option>
   				<option value="대구">대구광역시</option>
    			<option value="인천">인천광역시</option>
			    <option value="대전">대전광역시</option>
			    <option value="울산">울산광역시</option>
			    <option value="경기">경기도</option>
			    <option value="강원">강원도</option>
			    <option value="충남">충청남도</option>
			    <option value="충북">충청북도</option>
			    <option value="전남">전라남도</option>
			    <option value="경남">경상남도</option>
			    <option value="경북">경상북도</option>
			    <option value="제주">제주도</option>
 			  </select>
  
 			 <select id="gugun" name="gugun">
    			<option value=""> 구/군을 선택하세요</option>
      			<!-- 구/군은 JavaScript로 동적으로 변경 -->
  			</select>
  			<input type="text" placeholder="읍/면/동부터 상세주소를 입력하세요.">
  		</div>
		</form>
		
	</form>	
            
            <!-- hidden field to specify the action (등록, 수정, 삭제) -->
            <input type="hidden" id="actionType" name="actionType">
            <!-- hidden field (사원번호 hidden 처리 후 summit때 보내주기) -->
            <input type="hidden" id="employee_id" name="employee_id">
   

        <//하단 조회 버튼 및 사원명을 기준으로 조회하면 사원ID로 변경>
	    <div class="search">	        
	        <form id="searchEmployeesForm"  method="POST">
		        <label for="searchEmployees">사원명</label>
		        <input type="text" id="searchEmployeesName" name="searchEmployeesName">
		        <input type="hidden" id="actionTypeSearch" name="actionTypeSearch">
		        <button type="submit" onclick="searchEmployeesName()">조회</button>		        
		    </form>
	    </div>

        <!--사원정보 테이블 -->
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
                        
                        // 사원명 검색 파라미터 가져오기
                       String searchEmployeesName = request.getParameter("searchEmployeesName");
                        
                        // 기본 SQL 쿼리
                    String sql = "SELECT employee_id, employee_name, contact_number, department, position, hire_date, termination_date FROM Employees ";
                        
                 
                        // 검색어가 있을 경우 SQL 쿼리 수정 (제품명 기준 검색)
                        if (searchEmployeesName != null && !searchEmployeesName.trim().isEmpty()) {
                            sql += " WHERE employee_name LIKE ?";
                        }
                        
                        sql += "ORDER BY employee_id";

                        try {
                            pstmt = conn.prepareStatement(sql);

                            // 검색어가 있을 경우 파라미터 설정
                           if (searchEmployeesName != null && !searchEmployeesName.trim().isEmpty()) {
                                pstmt.setString(1, "%" + searchEmployeesName + "%");
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
  	function passwordCheck(){
  		const password = document.getElementById("password");
  		const re_password = document.getElementById("re_password");
  		
  
  		if (password.value !== re_password.value) {
  			alert("비밀번호가 일치하지 않습니다.");}
  		else
  		{alert("비밀번호가 일치합니다.");}
  	
 		 }
    </script>
    
	<script>
	    // 새로고침 기능을 위한 함수
	    function resetSearch() {
	        // 입력란을 초기화
	        document.getElementById('searchEmployeesName').value = '';
	        
	        // 페이지를 새로고침
	        location.reload(); // 페이지를 완전히 새로고침
	    }
	    
	    // 조회 버튼 클릭 시
	    function searchEmployeesName() {
	        var searchEmployeesName = document.getElementById('searchEmployeesName').value;
	        
	        // AJAX 요청 보내기
	        var xhr = new XMLHttpRequest();
	        xhr.open("GET", "employees_action.jsp?actionactionTypeSearch=search&searchEmployeeName=" + searchEmployeeName, true);
	        xhr.onreadystatechange = function() {
	            if (xhr.readyState == 4 && xhr.status == 200) {
	                // 테이블에 결과 반영
	                document.getElementById('receivingTable').innerHTML = xhr.responseText;
	            }
	        };
	        xhr.send();
	    }
	    

	    
	    // 등록 버튼 클릭 시
	    function registerEmployees(){
	        document.getElementById('actionType').value = 'register';
	        document.getElementById('EmployeesForm').action = './employees_action.jsp;
	        document.getElementById('EmployeesForm').submit();
	    }
	    
	 	// 수정 버튼 클릭 시
	    function updateEmployees() {
	        document.getElementById('actionType').value = 'update';
	        document.getElementById('EmployeesForm').action = './employees_action.jsp';
	        document.getElementById('EmployeesForm').submit();
	        
	    // 삭제 버튼 클릭 시
	    function deleteEmployees(){
	    	if (confirm('정말 삭제하시겠습니까?')) {
		        document.getElementById('actionType').value = 'delete';
		        document.getElementById('EmployeesForm').action = './employees_action.jsp';
		        document.getElementById('EmployeesForm').submit();
	    	}
	    }
	    
        // 테이블 행 클릭 시 선택된 값을 폼에 채우는 함수
        function selectRow(event) {
            // 클릭한 행을 선택
            var row = event.target.closest('tr');
            if (!row) return;

            // 각 열의 값을 폼 필드에 설정
            var cells = row.getElementsByTagName('td'); 
            document.getElementById('employeeId').value = cells[0].innerText; //  ID (hidden column 처리:수정,삭제시 입고id필요)
            document.getElementById('employeeName').value = cells[1].innerText; // 제품 코드
            document.getElementById('hireDate').value = cells[2].innerText; // 제품명
            document.getElementById('terminationDate').value = cells[3].innerText; // 입고 수량
            document.getElementById('department').value = cells[4].innerText; // 공급업체
            document.getElementById('position').value = cells[5].innerText; // 창고 위치
            document.getElementById('contactNumber').value = cells[6].innerText; // 입고일자
        }
       
        
	</script>
	
	<script>
	function updateGugun() {
	    const sido = document.getElementById("sido").value;
	    const gugun = document.getElementById("gugun");
	    
	    // 구/군 목록 초기화
	    gugun.innerHTML = '<option value=""> 구/군을 선택하세요</option>';
	    
	    let options = [];

	    // 시도에 따른 구/군 목록 설정
	    if (sido === "서울") {
	      options = ["강남구", "서초구", "종로구", "마포구", "구로구", "노원구", "송파구", "양천구", "영등포구", "용산구", "은평구", "중구"];
	    } else if (sido === "부산") {
	      options = ["해운대구", "수영구", "동래구", "남구", "북구", "사상구", "사하구", "서구", "연제구", "영도구"];
	    } else if (sido === "대구") {
	      options = ["중구", "서구", "동구", "남구", "북구", "달서구", "달성군"];
	    } else if (sido === "인천") {
	      options = ["계양구", "남동구", "동구", "미추홀구", "부평구", "서구", "연수구", "옹진군"];
	    } else if (sido === "대전") {
	      options = ["대덕구", "동구", "서구", "유성구", "중구"];
	    } else if (sido === "울산") {
	      options = ["남구", "동구", "북구", "울주군", "중구"];
	    } else if (sido === "경기") {
	      options = ["수원시", "성남시", "안양시", "고양시", "용인시", "부천시", "안산시", "화성시", "평택시", "오산시", "파주시", "의정부시", "시흥시"];
	    } else if (sido === "강원") {
	      options = ["춘천시", "원주시", "강릉시", "동해시", "태백시", "속초시", "양구군", "영월군", "고성군", "고성군", "정선군"];
	    } else if (sido === "충남") {
	      options = ["계룡시", "공주시", "논산시", "당진시", "보령시", "서산시", "아산시", "천안시", "서천군"];
	    } else if (sido === "충북") {
	      options = ["청주시", "제천시", "진천군", "음성군", "괴산군", "보은군", "단양군", "옥천군", "증평군"];
	    } else if (sido === "전남") {
	      options = ["목포시", "여수시", "순천시", "광양시", "나주시", "담양군", "순창군", "보성군", "강진군"];
	    } else if (sido === "전북") {
	      options = ["전주시", "익산시", "군산시", "김제시", "남원시", "정읍시", "완주군", "고창군"];
	    } else if (sido === "경남") {
	      options = ["창원시", "김해시", "양산시", "진주시", "사천시", "밀양시", "거제시", "통영시", "함양군"];
	    } else if (sido === "경북") {
	      options = ["포항시", "경산시", "구미시", "김천시", "안동시", "영주시", "상주시", "경주시", "울진군"];
	    } else if (sido === "제주") {
	      options = ["제주시", "서귀포시"];
	    }

	    // 구/군 목록에 동적으로 옵션 추가
	    options.forEach(function(g) {
	      let option = document.createElement("option");
	      option.value = g;
	      option.textContent = g;
	      gugun.appendChild(option);
	    });
	  }
	</script>
	
	
	
    
</body>
</html>
