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
	String selectSql = "SELECT PRODUCT_CODE, PRODUCT_NAME, CURRENT_CATEGORY, PACKAGING_UNIT, EFFICACY_GROUP, PRODUCTION_TYPE, REGISTERED_BY FROM product ORDER BY REGISTERED_DATE DESC";
	
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
    <table>
        <thead>
            <tr>
                <th>제품코드</th>
                <th>제품명</th>
                <th>카테고리</th>
                <th>포장단위</th>
                <th>효능군</th>
                <th>생산구분</th>
                <th>작업</th>
            </tr>
        </thead>
        <tbody>
        <% 
			// 조회한 데이터를 테이블에 출력
			while (rs.next()) {
			String productCode = rs.getString("PRODUCT_CODE");
			String productName = rs.getString("PRODUCT_NAME");
			String currentCategory = rs.getString("CURRENT_CATEGORY");
			String packagingUnit = rs.getString("PACKAGING_UNIT");
			String efficacyGroup = rs.getString("EFFICACY_GROUP");
			String productionType = rs.getString("PRODUCTION_TYPE");
                %>
                <tr>
                    <td><%= productCode %></td>
                    <td><%= productName %></td>
                    <td><%= currentCategory %></td>
                    <td><%= packagingUnit %></td>
                    <td><%= efficacyGroup %></td>
                    <td><%= productionType %></td>
                    <td>
                    <button class="update-button" 
                    data-id="<%= productCode %>"
                    data-name="<%= productName %>"
                    data-category="<%= currentCategory %>"
                    data-packaging="<%= packagingUnit %>"
                    data-effect="<%= efficacyGroup %>"
                    data-production="<%= productionType %>">수정</button>
                    <button class="delete-button" data-id="<%= productCode %>">삭제</button>
                    </td>
                </tr>
                <% 
                    }
                %>
            </tbody>
        <tbody>
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
    <script type="text/javascript">
    	//수정 누르면 폼에 채워짐
    	document.querySelectorAll('.update-button').forEach(button => {
            button.addEventListener('click', function(event) {
                const productCode = event.target.getAttribute('data-id');
                const productName = event.target.getAttribute('data-name');
                const category = event.target.getAttribute('data-category');
                const packaging = event.target.getAttribute('data-packaging');
                const effect = event.target.getAttribute('data-effect');
                const production = event.target.getAttribute('data-production');

                document.getElementById('productCode').value = productCode;
                document.getElementById('productName').value = productName;
                document.getElementById('productType').value = category;
                document.getElementById('packaging').value = packaging;
                document.getElementById('effect').value = effect;
                document.getElementById('productionType').value = production;
                
                //수정버튼 눌렀을때 수정 완료 버튼 나타나게
                document.getElementById('update-button').style.display = 'inline-block';
                //수정 누르면 수정완료 옆에 취소 버튼 생김
                document.getElementById('cancel-button').style.display = 'inline-block';
                //수정 눌렀을 때 등록 버튼 비활성화
                document.querySelector('button[type="submit"]').disabled = true;
            });
        });
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

    	    // 등록 버튼 활성화
    	    document.querySelector('button[type="submit"]').disabled = false;
    	}
    	//삭제 버튼
	    document.querySelectorAll('.delete-button').forEach(button => {
	        button.addEventListener('click', function(event) {
	            const productCode = event.target.getAttribute('data-id');
	            if (confirm('정말 삭제하시겠습니까?')) {
	                // 서버로 삭제 요청 보내기
	                location.href = './product_management_delete.jsp?product_code=' + productCode;
	            }
	        });
	    });
    </script>
</body>
</html>
