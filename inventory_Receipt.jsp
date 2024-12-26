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
    <title>제약 입고관리</title>
    <link rel="stylesheet" href="./css/inventory_receipt.css">
<!--     <script src="script.js"></script> -->
    <script>
        // 페이지 로드 시 입고일자 필드에 오늘 날짜를 기본값으로 설정
        window.onload = function() {
            var today = new Date();
            var yyyy = today.getFullYear();
            var mm = today.getMonth() + 1;  // 월은 0부터 시작하므로 1을 더함
            var dd = today.getDate();
            
            // 월과 일이 두 자리가 되도록 보정
            if (mm < 10) mm = '0' + mm;
            if (dd < 10) dd = '0' + dd;
            
            // 오늘 날짜 (YYYY-MM-DD) 형식으로 변환
            var todayDate = yyyy + '-' + mm + '-' + dd;
            
            // 입고일자 input에 오늘 날짜를 설정
            document.getElementById('receiveDate').value = todayDate;
        }
    </script>
</head>
<body>
    <div class="container">
        <header>
        	<div class="top">
	            <nav>
	            	<a href="./login.jsp">l 로그아웃</a>
	    			<a href="./dashboard.jsp">l 메인</a>
	                <a href="./product_management.jsp">l 제품관리</a>
	                <a href="./employees.jsp">l 사원관리</a>
	            </nav>
	            <span>
		            <%= session.getAttribute("department") %> >
		            <%= session.getAttribute("position") %> >
		            <%= session.getAttribute("employeeName") %>		            
		        </span>
            </div>
            <h1>입고관리</h1>
            <p>            
        </header>

        <!-- 입고 정보 입력 폼 -->
        <form id="productForm" method="POST">
	    <div class="input-group" style="display:flex; align-items:center;">
	        <label for="productCode" style="display:block;">제품코드</label>
	        <input type="text" id="productCode" name="productCode" style="display:block;" required>
	        <button type="button" onclick="openProductSearch()" style="width:100px; display:block; margin-bottom:16px; ">찾기</button>
	    </div>
	    <div class="input-group">
	        <label for="productName">제품명</label>
	        <input type="text" id="productName" name="productName">
	    </div>
	
	    <div class="input-group">
	        <label for="quantity">입고 수량</label>
	        <input type="number" id="quantity" name="quantity" required min="0" style="text-align: right;">
	    </div>
	    
	   <div class="input-group">
	        <label for="supplier">공급업체</label>
	        <select id="supplier" name="supplier" required style="width: 130%;">
	            <option value="">공급업체를 선택하세요</option>
	            <option value="PharmaCorp">PharmaCorp</option>
	            <option value="MediSupplies">MediSupplies(Legal)</option>
	            <option value="BioHealth">BioHealth</option>
	            <option value="GlobalPharma">GlobalPharma</option>
	            <option value="MediLab">MediLab</option>   
	        </select>
	    </div>
	    
	   	<div class="input-group">
	        <label for="warehouseLocation">창고위치</label>
	        <select id="warehouseLocation" name="warehouseLocation" required style="width: 100%;">
	            <option value="">창고위치를 선택하세요</option>
	            <option value="Seoul">Seoul</option>
	            <option value="Busan">Busan</option>
	            <option value="Incheon">Incheon</option>
	            <option value="Daegu">Daegu</option>
	            <option value="Daejeon">Daejeon</option>   
	        </select>
	    </div>
	
	    <div class="input-group">
	        <label for="receiveDate">입고일자</label>
	        <input type="date" id="receiveDate" name="receiveDate" required >
	    </div>
	
	    <!-- hidden field to specify the action (등록, 수정, 삭제) -->
	    <input type="hidden" id="actionType" name="actionType">
	    <input type="hidden" id="receiptId" name="receiptId">
	    <input type="hidden" id="registeredBy" name="registeredBy" value="<%= session.getAttribute("employeeId") %>">  <!-- 세션 정보를 등록자 필드에 삽입 -->>
	
	    <div class="buttons">
	        <button onclick="registerProduct()">등록</button>
	        <button onclick="updateProduct()">수정</button>
	        <button onclick="deleteProduct()">삭제</button>
	        <button onclick="resetSearch()">새로고침</button>
	    </div>
	</form>    
        

        <!-- 하단 조회 버튼과 검색 입력란 -->
	    <div class="search">	        
	        <form id="searchForm"  method="POST">
		        <label for="searchProductName">제품명</label>
		        <input type="text" id="searchProductName" name="searchProductName">
		        <input type="hidden" id="actionTypeSearch" name="actionTypeSearch">
		        <button type="submit" onclick="searchProduct()">조회</button>		        
		    </form>
	    </div>

        <!-- 입고된 제품 목록 -->
        <table id="receivingTable" onclick="selectRow(event)">
            <thead>
                <tr>
                    <th onclick="sortTable(0)">입고 ID<span class="sort-arrow">▼</span></th>
                    <th onclick="sortTable(1)">제품 코드<span class="sort-arrow">▼</span></th>
                    <th onclick="sortTable(2)">제품명<span class="sort-arrow">▼</span></th>
                    <th onclick="sortTable(3)">입고 수량<span class="sort-arrow">▼</span></th>
                    <th onclick="sortTable(4)">공급업체<span class="sort-arrow">▼</span></th>
                    <th onclick="sortTable(5)">창고 위치<span class="sort-arrow">▼</span></th>
                    <th onclick="sortTable(6)">입고일자<span class="sort-arrow">▼</span></th>
                    <th onclick="sortTable(7)">등록자<span class="sort-arrow">▼</span></th>
                    <th onclick="sortTable(8)">등록일자<span class="sort-arrow">▼</span></th>
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
                        String searchProductName = request.getParameter("searchProductName");
                        
                        // 기본 SQL 쿼리
                        String sql = "SELECT receipt_id, product_code, "
                                   + "(SELECT product_name FROM Product b WHERE a.product_code = b.product_code) AS product_name, "
                                   + "quantity, supplier, warehouse_location, TO_CHAR(receipt_date, 'YYYY-MM-DD') AS receipt_date, "
                                   + "(SELECT c.employee_name FROM Employees c WHERE a.REGISTERED_BY = c.EMPLOYEE_ID) AS registered_by, TO_CHAR(registered_date, 'YYYY-MM-DD') AS registered_date "
                                   + "FROM Inventory_Receipt a ";
                        
                        // 검색어가 있을 경우 SQL 쿼리 수정 (제품명 기준 검색)
                        if (searchProductName != null && !searchProductName.trim().isEmpty()) {
                            sql += " WHERE a.product_code IN (SELECT d.product_code FROM Product d WHERE d.product_name LIKE ?) ";
                        }
                        
                        sql += "ORDER BY a.product_code ";
                        
                        System.out.println("sql" + sql);

                        try {
                            pstmt = conn.prepareStatement(sql);

                            // 검색어가 있을 경우 파라미터 설정
                            if (searchProductName != null && !searchProductName.trim().isEmpty()) {
                                pstmt.setString(1, "%" + searchProductName + "%");
                            }

                            rs = pstmt.executeQuery();

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
                %>
                                <tr>
                                    <td><%= receiptId %></td>
                                    <td><%= productCode %></td>
                                    <td><%= productName %></td>
                                    <td><%= quantity %></td>
                                    <td><%= supplier %></td>
                                    <td><%= warehouseLocation %></td>
                                    <td><%= receiptDate %></td>
                                    <td><%= registeredBy %></td>
                                    <td><%= registeredDate %></td>
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
	        document.getElementById('searchProductName').value = '';
	        
	        // 페이지를 새로고침
	        location.reload(); // 페이지를 완전히 새로고침
	    }
	    
	    // 조회 버튼 클릭 시
	    function searchProduct() {
	        var searchProductName = document.getElementById('searchProductName').value;
	        
	        // AJAX 요청 보내기
	        var xhr = new XMLHttpRequest();
	        xhr.open("GET", "inventory_Receipt_action.jsp?actionTypeSearch=search&searchProductName=" + searchProductName, true);
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
	        document.getElementById('productForm').action = './inventory_Receipt_action.jsp';
	        document.getElementById('productForm').submit();
	    }
	    
	 	// 수정 버튼 클릭 시
	    function updateProduct() {
	    	if (confirm('정말 수정하시겠습니까?')) {
		        document.getElementById('actionType').value = 'update';
		        document.getElementById('productForm').action = './inventory_Receipt_action.jsp';
		        document.getElementById('productForm').submit();
	    	}
	    }

	    // 삭제 버튼 클릭 시
	    function deleteProduct() {
	    	if (confirm('정말 삭제하시겠습니까?')) {
		        document.getElementById('actionType').value = 'delete';
		        document.getElementById('productForm').action = './inventory_Receipt_action.jsp';
		        document.getElementById('productForm').submit();
	    	}
	    }
	    
        // 테이블 행 클릭 시 선택된 값을 폼에 채우는 함수
        function selectRow(event) {
            // 클릭한 행을 선택
            var row = event.target.closest('tr');
            if (!row) return;

            // 각 열의 값을 폼 필드에 설정
            var cells = row.getElementsByTagName('td'); 
            document.getElementById('receiptId').value = cells[0].innerText; // 입고 ID (hidden column 처리:수정,삭제시 입고id필요)
            document.getElementById('productCode').value = cells[1].innerText; // 제품 코드
            document.getElementById('productName').value = cells[2].innerText; // 제품명
            document.getElementById('quantity').value = cells[3].innerText; // 입고 수량
            document.getElementById('supplier').value = cells[4].innerText; // 공급업체
            document.getElementById('warehouseLocation').value = cells[5].innerText; // 창고 위치
            document.getElementById('receiveDate').value = cells[6].innerText; // 입고일자
        }
        
     	// "제품 찾기" 버튼 클릭 시 팝업창을 여는 함수
        function openProductSearch() {
     		//alert('찾기팝업함수호출');
            // 팝업 창을 새 창으로 여는 코드 (productSearch.jsp 페이지 호출)
            window.open('./productSearch.jsp', 'productSearch', 'width=600,height=400');
        }
     	
	    // 목록에서 정렬 할때 사용하는 함수
	    let sortOrder = [true, true, true, true, true, true]; // 각 열의 정렬 상태 (true: 오름차순, false: 내림차순)

		function sortTable(columnIndex) {
		    const table = document.querySelector('table tbody');
		    const rows = Array.from(table.querySelectorAll('tr'));
		    const isAscending = sortOrder[columnIndex];
		
		    const headers = document.querySelectorAll('th');
	        headers.forEach((header, index) => {
	            const arrow = header.querySelector('.sort-arrow');
	            if (arrow && index !== columnIndex) {
	                arrow.textContent = '▼';
	            }
	        });
		    
		    // 정렬 함수
		    rows.sort((rowA, rowB) => {
		        const cellA = rowA.querySelectorAll('td')[columnIndex].textContent.trim().toLowerCase();
		        const cellB = rowB.querySelectorAll('td')[columnIndex].textContent.trim().toLowerCase();
		        
		     	// 숫자 비교 (입고 수량 열일 경우)
		        if (columnIndex === 3) { // 입고 수량 열의 인덱스 (0부터 시작)
		            return isAscending
		                ? parseInt(cellA) - parseInt(cellB) // 오름차순
		                : parseInt(cellB) - parseInt(cellA); // 내림차순
		        } else {
		            // 기본 문자열 비교 (기타 열들)
		            if (isAscending) {
		                return cellA > cellB ? 1 : (cellA < cellB ? -1 : 0);
		            } else {
		                return cellA < cellB ? 1 : (cellA > cellB ? -1 : 0);
		            }
		        }
		    });
		
		    // 테이블에 정렬된 행을 다시 추가
		    rows.forEach(row => table.appendChild(row));
		
		    const currentHeader = headers[columnIndex];
	        const arrow = currentHeader.querySelector('.sort-arrow');
	        if (arrow) {
	            if (isAscending) {
	                arrow.textContent = '▲';
	            } else {
	                arrow.textContent = '▼';
	            }
	        }

	        // 현재 정렬 상태 반전
	        sortOrder[columnIndex] = !isAscending;
	    }
	</script>
    
</body>
</html>
