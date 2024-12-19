<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
  <link rel="stylesheet" href="../css/style.css">
  <script src="../js/script.js" defer></script>
</head>
<body>
  <div class="login-container">
    <img src="../images/humunlogo.png" alt="Logo" class="logo">
    <h1>휴먼 제약</h1>
    <form id="loginForm" action="pages/dashboard.jsp" method="post">
      <div class="input-group">
        <input type="text" id="username" name="username" placeholder="아이디를 입력하시오" aria-label="아이디 입력란" required>
      </div>
      <div class="input-group">
        <input type="password" id="password" name="password" placeholder="비밀번호를 입력하시오" aria-label="비밀번호 입력란" autocomplete="name" required>
        <button type="button" id="togglePassword" aria-label="비밀번호 표시">
          <img src="../images/eye-slash-icon.png" alt="비밀번호 표시" id="toggle-icon">
        </button>
      </div>
      <div class="remember-me">
        <input type="checkbox" id="rememberMe">
        <label for="rememberMe">아이디 저장</label>
      </div>
      <button type="submit" class="login-btn" id="loginButton">로그인</button>
      <% if (request.getAttribute("errorMessage") != null) { %>
        <p style="color: red; text-align: center; margin-top: 10px;">
          <%= request.getAttribute("errorMessage") %>
        </p>
      <% } %>
      <div class="link-container">
        <a href="pages/forgot-password.jsp" class="forgot-password">비밀번호 찾기</a>
      </div>
    </form>
  </div>
</body>
</html>