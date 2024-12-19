<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>비밀번호 찾기</title>
</head>
<body>
    <h1>비밀번호 초기화</h1>
    <form action="forgot-password" method="post">
        <label for="email">이메일:</label>
        <input type="email" id="email" name="email" required>
        <button type="submit">초기화 요청</button>
    </form>
</body>
</html>