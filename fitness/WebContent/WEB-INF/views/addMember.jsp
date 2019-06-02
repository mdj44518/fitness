<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<title>회원 등록</title>
<%@ include file='/WEB-INF/views/common/begin.jsp' %>
<link href='<%= request.getContextPath() + "/css/form.css" %>' rel='stylesheet' type='text/css'>
<section>
	<div class='default-form'>
		<form action='' method='post'>
			<h1>회원 등록</h1>
			<fieldset>
				<legend>개인 정보</legend>
				<p>
					<label class='label1'>이름 : </label>
					<input type='text' name='mName'>
				</p>
				<p>
					<label class='label1'>연락처 : </label>
					<input type='tel' name='phone'>
				</p>
				<p>
					<label class='label1'>주소 : </label>
					<input type='text' name='address'>
				</p>
				<p>
					<label class='label1'>생년월일 : </label>
					<input type='date' name='birthday'>
				</p>
				<p>
					<input id='m' type='radio' name='gender' value='male'><label for='m'>남성</label>
					<input id='w' type='radio' name='gender' value='female'><label for='w'>여성</label>
				</p>
			</fieldset>
			<fieldset>
				<legend>회원 유형</legend>
				<p>
					<label class='label1'>시작일 : </label>
					<input type='date' name='startDay'>
				</p>
				<p>
					<label class='label1'>종료일 : </label>
					<input type='date' name='endDay'>
				</p>
				<p>
					<label class='label1'>회원 유형 : </label>
					<select name='memberType'>
						<option value='일반'>일반</option>
						<option value='PT'>PT</option>
						<option value='프로그램'>프로그램</option>
					</select>
				</p>
			</fieldset>
			<input style='width: 100px;' type='submit' value='등록'>
		</form>
	</div>
</section>
<%@ include file='/WEB-INF/views/common/end.jsp' %>