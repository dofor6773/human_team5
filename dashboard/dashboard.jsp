<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.team5.DBManager" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>대시보드</title>
<link rel="stylesheet" href="./css/dashboard.css">
</head>
<body>
	<div class="container">
		<div class="top">
		<a href="./login.jsp">l 로그아웃</a>
		<span>
			<%= session.getAttribute("department") %> >
			<%= session.getAttribute("position") %> >
			<%= session.getAttribute("employeeName") %>
		</span>
	</div>
		<nav class="navber">
			<div class="nav-left">
				<a href="./product_management.jsp" onclick="return checkAccess1()">제품 관리</a>
				<a href="./inventory_Receipt.jsp" onclick="return checkAccess2()">입고 관리</a>
				<a href="./em_input.html" onclick="return checkAccess3()" >사원 관리</a>
			</div>
		</nav>
	</div>
<script type="text/javascript">
	function checkAccess1(){
		let department ="<%= session.getAttribute("department") %>";
		let position = "<%= session.getAttribute("position") %>";
		if(department !== "PR" && department !== "ADMIN" && position !== "HD"){
			alert("권한이 없습니다.");
			return false;
		}
		return true;
	}
	function checkAccess2(){
		let department ="<%= session.getAttribute("department") %>";
		let position = "<%= session.getAttribute("position") %>";
		if(department !== "LO" && department !== "ADMIN" && position !== "HD"){
			alert("권한이 없습니다.");
			return false;
		}
		return true;
	}
	function checkAccess3(){
		let department ="<%= session.getAttribute("department") %>";
		let position = "<%= session.getAttribute("position") %>";
		if(department !== "HR" && department !== "ADMIN" && position !== "HD"){
			alert("권한이 없습니다.");
			return false;
		}
		return true;
	}
</script>
</body>
</html>