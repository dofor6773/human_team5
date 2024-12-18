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
    <script src="script.js"></script>
</head>
<body>
    <div class="container">
        <header>
            <h1>입고관리</h1>
            <nav>
                <a href="#">제품관리</a>
                <a href="#">사원관리</a>
                <a href="#">입고관리</a>
            </nav>
            <p>
            <span>생산팀>관리자>박휴먼</span>
        </header>

        <!-- 상단 버튼들 (등록, 수정, 삭제) -->
        <div class="buttons">
            <button onclick="registerProduct()">등록</button>
            <button onclick="updateProduct()">수정</button>
            <button onclick="deleteProduct()">삭제</button>
        </div>
        <p>

        <!-- 입고 정보 입력 폼 -->
        <form id="productForm"  method="POST">
            <label for="productCode">제품 코드</label>
            <input type="text" id="productCode" name="productCode" required>

            <label for="productName">제품명</label>
            <input type="text" id="productName" name="productName">

            <p>

            <label for="quantity">입고 수량</label>
            <input type="number" id="quantity" name="quantity" required>

            <label for="supplier">공급업체</label>
            <input type="text" id="supplier" name="supplier" required>
            
            <p>

            <label for="warehouseLocation">창고 위치</label>
            <input type="text" id="warehouseLocation" name="warehouseLocation" required>

            <label for="receiveDate">입고일자</label>
            <input type="date" id="receiveDate" name="receiveDate" required>
            
            <!-- hidden field to specify the action (등록, 수정, 삭제) -->
            <input type="hidden" id="actionType" name="actionType">
            <!-- hidden field (입고id hidden 처리 후 summit때 보내주기) -->
            <input type="hidden" id="receiptId" name="receiptId">
        </form>

        <!-- 하단 조회 버튼과 검색 입력란 -->
        <div class="search">
            <label for="searchProductName">제품명</label>
            <input type="text" id="searchProductName" name="searchProductName">
            <button onclick="searchProduct()">조회</button>
             <button onclick="resetSearch()">새로고침</button>
        </div>

        <!-- 입고된 제품 목록 -->
        <table id="receivingTable" onclick="selectRow(event)">
            <thead>
                <tr>
                    <th>입고 ID</th>
                    <th>제품 코드</th>
                    <th>제품명</th>
                    <th>입고 수량</th>
                    <th>공급업체</th>
                    <th>창고 위치</th>
                    <th>입고일자</th>
                    <th>등록자</th>
                    <th>등록일자</th>
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
	    
	    // 등록 버튼 클릭 시
	    function registerProduct() {
	        document.getElementById('actionType').value = 'register';
	        document.getElementById('productForm').action = './inventory_Receipt_action.jsp';
	        document.getElementById('productForm').submit();
	    }
	    
	 	// 수정 버튼 클릭 시
	    function updateProduct() {
	        document.getElementById('actionType').value = 'update';
	        document.getElementById('productForm').action = './inventory_Receipt_action.jsp';
	        document.getElementById('productForm').submit();
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
        
	</script>
    
</body>
</html>
