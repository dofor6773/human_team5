<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    // 폼에서 넘어온 데이터 받기
    String productName = request.getParameter("productName");
    String currentCategory = request.getParameter("productType");  // 카테고리
    String packagingUnit = request.getParameter("packagingUnit");
    String efficacyGroup = request.getParameter("efficacyGroup");
    String productionType = request.getParameter("productionType");
    String registeredBy = request.getParameter("registeredBy");
// 필수 값 입력 안했을 시
    if (productName == null || productName.trim().isEmpty()){
            out.println("<script>alert('모든 필수 항목을 입력해주세요!'); history.back();</script>");
            return;  // 폼 제출을 중단
        }
    
    //날짜 받아오기
    SimpleDateFormat sdf = new SimpleDateFormat("yyMM");
    String datePart = sdf.format(new Date());

    // 아직 안정한 규칙 맨 앞 aa랑 날짜 뒤 a
    String prefix = "AA";
    String suffix = "A";

    // DB에 연결해서 등록된 물품을 확인한다음 그 다음 물품을 다음 숫자에 저장할것임
    Connection conn = DBManager.getDBConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String productCode = null;
    // 제품 코드 번호를 생성하기 위한 SQL 쿼리
	String selectSql = "SELECT MAX(SUBSTR(PRODUCT_CODE, 8, 3)) FROM product WHERE PRODUCT_CODE LIKE ?";

    try {
        // 같은 날짜의 제품 코드에서 순차 번호를 찾기
        pstmt = conn.prepareStatement(selectSql);
        pstmt.setString(1, prefix + datePart + suffix + "%"); // 'AA2024.12.17A%' 형식으로 검색
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String maxSequence = rs.getString(1);  // 가장 큰 순차 번호 가져오기
            int sequence = 1;  // 기본 값은 1

            if (maxSequence != null) {
                sequence = Integer.parseInt(maxSequence) + 1;  // 가장 큰 순차 번호에 1을 더함
            }

            // 순차 번호가 3자리로 맞춰지도록 001 형식으로 처리
            String sequencePart = String.format("%03d", sequence);

            // 최종 productCode 생성
            productCode = prefix + datePart + suffix + sequencePart;
        }
        //System.out.println("productCode: " + productCode);
        //만들어진 productcode 확인
	//날짜가 YYmm이어서 달이 바뀌어야 숫자가 1로 초기화됨
    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류가 발생했습니다: " + e.getMessage());
    } finally {
        DBManager.dbClose(conn, pstmt, rs);
    }

    // 등록일 자동 생성
    Timestamp registeredDate = new Timestamp(System.currentTimeMillis());

    // DB 연결하여 제품 등록
    String insertSql = "INSERT INTO product (PRODUCT_CODE, PRODUCT_NAME, CURRENT_CATEGORY, PACKAGING_UNIT, EFFICACY_GROUP, PRODUCTION_TYPE, REGISTERED_BY) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
    
    try {
        conn = DBManager.getDBConnection();
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, productCode);
        pstmt.setString(2, productName);
        pstmt.setString(3, currentCategory);
        pstmt.setString(4, packagingUnit);
        pstmt.setString(5, efficacyGroup);
        pstmt.setString(6, productionType);
        pstmt.setString(7, registeredBy);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            //성공시 바로 html파일로 넘어감
            response.sendRedirect("product_management.jsp");
        } else {
            out.println("제품 등록에 실패했습니다.");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류가 발생했습니다: " + e.getMessage());
    } finally {
        DBManager.dbClose(conn, pstmt, null);
    }
%>
