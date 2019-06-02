<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<title>로그인 페이지</title>
<link href='<%= request.getContextPath() + "/css/form.css" %>' rel='stylesheet' type='text/css'>
<%@ include file='/WEB-INF/views/common/begin.jsp' %>

	<section>
		<div class='default-form'>
			<form action='<%= request.getContextPath() + "/login/manager" %>' method='post'>
				<h1>관리자 로그인</h1>
				<fieldset>
					<p><label class='label1'>아이디 : &nbsp;</label><input type='text' name='id' required></p>
					<p><label class='label1'>비밀번호 : &nbsp;</label><input type='password' name='pw' required></p>
					<input type='submit' value='로그인'>
				</fieldset>
			</form>
		</div>
	</section>

<%@ include file='/WEB-INF/views/common/end.jsp' %>