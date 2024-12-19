<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>대시보드</title>
  <style>
      body {
          font-family: Arial, sans-serif;
          background-color: #f0f0f0;
          margin: 0;
          padding: 20px;
      }
      h1 {
          color: #333;
      }
      a {
          color: #007bff;
          text-decoration: none;
      }
      a:hover {
          text-decoration: underline;
      }
  </style>
</head>
<body>
    <h1>환영합니다, <%= username %>님!</h1>
    <a href="logout">로그아웃</a>
</body>
</html>