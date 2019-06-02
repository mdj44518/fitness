<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href='<%= request.getContextPath() + "/css/main.css" %>' rel='stylesheet' type='text/css'>
</head>

<%
	String Login = (String)request.getSession().getAttribute("user");
%>

<body>
<header>
	<div class='header'>
		<h1><span style='cursor: pointer;' onclick='mainCall()'>Human</span></h1>
	</div>
</header>
<nav>
	<div class='nav'>
		<a>메뉴1</a>
		<a>메뉴2</a>
		<a>메뉴3</a>
		<div class='dropManu'>
		<% if (Login != null) { %>
			<a>회원 관리</a>
			<div class='drop-con'>
				<a href='<%= request.getContextPath() + "/admin/add" %>'>등록</a>
				<a href='<%= request.getContextPath() + "/admin/memberList" %>'>관리</a>
				<a href='<%= request.getContextPath() + "/login/manager?out=" %>'>로그아웃</a>
			</div>
		<% } else { %>
			<a href='<%= request.getContextPath() + "/login/manager" %>'>로그인</a>
		<% } %>
		</div>
	</div>
</nav>

<script>
	function mainCall(){
		document.location["href"] = "http://localhost:8088/fitness";
	}
	var error = '<%= (String)request.getAttribute("error") %>'
	
	if (error !== 'null') {
		alert(error);
	}
	
</script>