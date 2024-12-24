<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션 무효화
    if (session != null) {
        session.invalidate();
    }
    // 로그인 페이지로 리디렉트
    response.sendRedirect("login.jsp");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그아웃</title>
<meta http-equiv="refresh" content="3;url=login.jsp">
</head>
<body>
	<div class="container">
		<h1>로그아웃 되었습니다.</h1>
		<p><a href="./login.jsp">바로 이동</a></p>
	</div>
</body>
</html>