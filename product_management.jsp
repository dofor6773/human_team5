<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%
	//한글 처리
	request.setCharacterEncoding("UTF-8");
%>    

<%
	// DB 연결
	Connection conn = DBManager.getDBConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	// 제품 정보 가져오기 SQL 쿼리
	String selectSql = "SELECT PRODUCT_CODE, PRODUCT_NAME, CURRENT_CATEGORY, PACKAGING_UNIT, EFFICACY_GROUP, PRODUCTION_TYPE, REGISTERED_BY, REGISTERED_DATE FROM product ORDER BY REGISTERED_DATE DESC";
	
	try {
	    pstmt = conn.prepareStatement(selectSql);
	    rs = pstmt.executeQuery();
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
        <form id="productForm" method="POST" action="product_management_insert.jsp">
            <label>제품코드</label>
            <input type="text" id="productCode" style="background-color:  #E2E2E2;" name="productCode" readonly><br>
            <label>등록일</label>
            <input type="text" id="productDate" style="background-color:  #E2E2E2;" name="productDate" readonly><br>
            <label>제품명*</label>
            <input type="text" id="productName" name="productName" required><br>
            <label>카테고리</label>
            <select id="productType" name="productType" required>
                <option value="OTC" selected>일반의약품</option>
                <option value="Rx">전문의약품</option>
                <option value="NonPharmaceutical">의약외품</option>
            </select><br>
            <label>포장단위*</label>
            <input type="text" id="packaging" name="packaging" required><br>
            <label>효능군*</label>
            <input type="text" id="effect" name="effect" required><br>
            <label>생산구분</label>
            <select id="productionType" name="productionType" required>
                <option value="Normal" selected>정상</option>
                <option value="Suspended">중단</option>
            </select><br>
            <button type="submit">등록</button>
            <button type="button" id="update-button" style="display: none;" onclick="updateProduct()">수정완료</button>
            <button type="button" id="cancel-button" style="display: none;" onclick="cancelEdit()">취소</button>
            <button type="button" id="delete-button" style="display: none;" >삭제</button>
        </form>
    </div>

    <!-- 검색 조건 및 검색 창 -->
    <div class="search-container">
        <select id="searchCriteria" onchange="updateSearchPlaceholder()">
            <option value="name">제품명으로 검색</option>
            <option value="code">제품코드로 검색</option>
        </select>
        <input type="text" id="searchInput" placeholder="제품명으로 검색" onkeyup="searchProducts()">
    </div>

    <!-- 테이블 -->
    <div class="table-container">
	<table id="receivingTable" onclick="selectRow(event)">
        <thead>
            <tr>
                <th>제품코드 <button class="sort-button" data-column="0" onclick="sortTable(0)">▼</button></th>
                <th>제품명<button class="sort-button" data-column="1" onclick="sortTable(1)">▼</button></th>
                <th>카테고리<button class="sort-button" data-column="2" onclick="sortTable(2)">▼</button></th>
                <th>포장단위<button class="sort-button" data-column="3" onclick="sortTable(3)">▼</button></th>
                <th>효능군<button class="sort-button" data-column="4" onclick="sortTable(4)">▼</button></th>
                <th>생산구분<button class="sort-button" data-column="5" onclick="sortTable(5)">▼</button></th>
            </tr>
        </thead>
        <tbody class="sroll">
        <% 
			// 조회한 데이터를 테이블에 출력
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			while (rs.next()) {
			String productCode = rs.getString("PRODUCT_CODE");
			String productName = rs.getString("PRODUCT_NAME");
			String currentCategory = rs.getString("CURRENT_CATEGORY");
			String packagingUnit = rs.getString("PACKAGING_UNIT");
			String efficacyGroup = rs.getString("EFFICACY_GROUP");
			String productionType = rs.getString("PRODUCTION_TYPE");
			Timestamp registeredDateTimestamp = rs.getTimestamp("REGISTERED_DATE");
			String registeredDate = dateFormat.format(registeredDateTimestamp);
                %>
                <tr>
                    <td><%= productCode %></td>
                    <td><%= productName %></td>
                    <td><%= currentCategory %></td>
                    <td><%= packagingUnit %></td>
                    <td><%= efficacyGroup %></td>
                    <td><%= productionType %></td>
                </tr>
                <% 
                    }
                %>
            </tbody>
        
        <%
	    } catch (Exception e) {
	        e.printStackTrace();
	        out.println("오류발생: " + e.getMessage());
	    } finally {
	        DBManager.dbClose(conn, pstmt, rs);
	    }
        
        %>
        </tbody>
    </table>
    </div>
    <script type="text/javascript">
    	//수정완료 누르면 DB에 저장
    	function updateProduct(){
    		const form = document.getElementById('productForm');
    		form.action = "product_management_update.jsp";
    		form.submit();
    	}
    	//취소 눌렀을때 원래 화면으로 돌아가기
    	function cancelEdit() {
    	    // 폼 초기화
    	    document.getElementById('productForm').reset();

    	    // 수정완료, 취소 버튼 숨기기
    	    document.getElementById('update-button').style.display = 'none';
    	    document.getElementById('cancel-button').style.display = 'none';
    	    document.getElementById('delete-button').style.display = 'none';

    	    // 등록 버튼 활성화
    	    document.querySelector('button[type="submit"]').disabled = false;
    	};
    	//삭제 버튼
	    document.getElementById('delete-button').onclick = function() {
		    const productCode = document.getElementById('productCode').value;
		    if (confirm('정말 삭제하시겠습니까?')) {
		        // 서버로 삭제 요청 보내기
		        location.href = './product_management_delete.jsp?product_code=' + productCode;
		    }
		};

        // 테이블 행 클릭 시 선택된 값을 폼에 채우는 함수
        function selectRow(event) {
            // 클릭한 행을 선택
            let row = event.target.closest('tr');
            if (!row) return;
            
            let registeredDate = row.getAttribute("data-registered-date");
	       	
	        let cells = row.getElementsByTagName('td'); 
            // 각 열의 값을 폼 필드에 설정
            let productCode = cells[0].textContent.trim();
	        let productName = cells[1].textContent.trim();
	        let category = cells[2].textContent.trim();
	        let packaging = cells[3].textContent.trim();
	        let effect = cells[4].textContent.trim();
	        let production = cells[5].textContent.trim();  
	        
            document.getElementById('productCode').value = productCode;
            document.getElementById('productName').value = productName;
            document.getElementById('productType').value = category;
            document.getElementById('packaging').value = packaging;
            document.getElementById('effect').value = effect;
            document.getElementById('productionType').value = production;
            document.getElementById('productDate').value = registeredDate;
            
            document.getElementById('update-button').style.display = 'inline-block';
            //수정 누르면 수정완료 옆에 취소 버튼 생김
            document.getElementById('cancel-button').style.display = 'inline-block';
            //취소 옆에 삭제 버튼
            document.getElementById('delete-button').style.display = 'inline-block';
            //수정 눌렀을 때 등록 버튼 비활성화
            document.querySelector('button[type="submit"]').disabled = true;
        }
	    // 실시간 검색 기능
	    function searchProducts() {
	        const searchInput = document.getElementById('searchInput').value.toLowerCase();
	        const searchCriteria = document.getElementById('searchCriteria').value;
	        const table = document.querySelector('table tbody');
	        const rows = table.querySelectorAll('tr');

	        rows.forEach(row => {
	            const productCode = row.querySelector('td:nth-child(1)').textContent.toLowerCase();
	            const productName = row.querySelector('td:nth-child(2)').textContent.toLowerCase();

	            // 검색에 맞는게 없으면 가림
	            if ((searchCriteria === 'name' && productName.includes(searchInput)) ||
	                (searchCriteria === 'code' && productCode.includes(searchInput))) {
	                row.style.display = '';
	            } else {
	                row.style.display = 'none';
	            }
	        });
	    }
	    // 제품명 -> 제품명으로 검색, 제품코드-> 제품코드로 검색 나옴
	    function updateSearchPlaceholder() {
	        const searchCriteria = document.getElementById('searchCriteria').value;
	        const searchInput = document.getElementById('searchInput');
	        
	        if (searchCriteria === 'name') {
	            searchInput.placeholder = '제품명으로 검색';
	        } else {
	            searchInput.placeholder = '제품코드로 검색';
	        }
	    }
	    //정렬 버튼
	    let sortOrder = [true, true, true, true, true, true]; // 각 열의 정렬 상태 (true: 오름차순, false: 내림차순)

		function sortTable(columnIndex) {
		    const table = document.querySelector('table tbody');
		    const rows = Array.from(table.querySelectorAll('tr'));
		    const isAscending = sortOrder[columnIndex];
		
		    // 정렬 함수
		    rows.sort((rowA, rowB) => {
		        const cellA = rowA.querySelectorAll('td')[columnIndex].textContent.trim().toLowerCase();
		        const cellB = rowB.querySelectorAll('td')[columnIndex].textContent.trim().toLowerCase();
		
		        if (isAscending) {
		            // 오름차순 정렬
		            return cellA > cellB ? 1 : (cellA < cellB ? -1 : 0);
		        } else {
		            // 내림차순 정렬
		            return cellA < cellB ? 1 : (cellA > cellB ? -1 : 0);
		        }
		    });
		
		    // 테이블에 정렬된 행을 다시 추가
		    rows.forEach(row => table.appendChild(row));
		
		    // 현재 정렬 상태
		    sortOrder[columnIndex] = !isAscending;
		
		    // 화살표 모양 업데이트
		    const buttons = document.querySelectorAll('.sort-button');
		    buttons.forEach(button => {
		        const targetColumn = button.getAttribute('data-column');
		        if (targetColumn == columnIndex) {
		            // 정렬 상태에 따라 화살표 모양 변경
		            button.textContent = isAscending ? '▲' : '▼';
		        } else {
		            button.textContent = '▼';//다른 컬럼 화살표는 변경안되게
		        }
		    });
		}
    </script>
</body>
</html>
