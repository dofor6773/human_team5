<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.util.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="./css/login.css">
    <script src="./js/login.js" defer></script>
</head>
<body>
    <div class="login-container">
        <img src="./images/humunlogo.png" alt="Logo" class="logo">
        <h1>휴먼 제약</h1>
        <form id="loginForm" method="post">
            <div class="input-group">
                <input type="text" id="username" name="username" placeholder="아이디를 입력하시오" aria-label="아이디 입력란" required>
            </div>
            <div class="input-group">
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하시오" aria-label="비밀번호 입력란" autocomplete="name" required>
                <button type="button" id="togglePassword" aria-label="비밀번호 표시">
                    <img src="./images/eye-slash-icon.png" alt="비밀번호 표시" id="toggle-icon">
                </button>
            </div>
            <div class="remember-me">
                <input type="checkbox" id="rememberMe">
                <label for="rememberMe">아이디 저장</label>
            </div>
            <button type="submit" class="login-btn" id="loginButton">로그인</button>
            
            <%
                // 폼이 제출되었을 때 로그인 처리
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                if (username != null && password != null) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        // DB 연결
                        conn = DBManager.getDBConnection();

                        if (conn == null) {
                            throw new SQLException("DB 연결 실패");
                        }

                        // 쿼리 작성
                        String sql = "SELECT * FROM Employees WHERE employee_id = ? AND password = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, username);
                        pstmt.setString(2, password);

                        // 실행 및 결과 처리
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            // 로그인 성공
                            // 세션에 사용자 정보 저장
                            String employeeId = rs.getString("employee_id");
                            String employeeName = rs.getString("employee_name");

                            // 로그인 성공 시 세션에 정보 저장
                            session.setAttribute("employeeId", employeeId);
                            session.setAttribute("employeeName", employeeName);

                            // 성공 시 inventory_Receipt.jsp로 리디렉션
                            response.sendRedirect("./inventory_Receipt.jsp");
                        } else {
                            // 로그인 실패
                            request.setAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("errorMessage", "로그인 처리 중 오류가 발생했습니다.");
                    } finally {
                        // 자원 해제
                        DBManager.dbClose(conn, pstmt, rs);
                    }
                }
            %>

            <%
                // 오류 메시지가 있을 경우 출력
                if (request.getAttribute("errorMessage") != null) {
            %>
            <p style="color: red; text-align: center; margin-top: 10px;">
                <%= request.getAttribute("errorMessage") %>
            </p>
            <%
                }
            %>
			</div>
        </form>
    </div>
</body>
</html>
