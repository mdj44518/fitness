<%@page import="org.fitness.dao.FitnessDAO"%>
<%@page import="org.fitness.model.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<title>회원 목록</title>
${MAX_NAV_NUM = 5; pAreaNum = Math.floor((chPage - 1) / MAX_NAV_NUM) * MAX_NAV_NUM; ''}
<%@ include file='/WEB-INF/views/common/begin.jsp' %>
<link href='<%= request.getContextPath() + "/css/table.css" %>' rel='stylesheet' type='text/css'>

<section>
	<div class='table'>
		<h1 class='mousePointer' onclick='location.href="memberList"'>회원 목록</h1>
		<table>
		<caption></caption>
			<tr>
				<th style='width: 50px;' >회원번호 </th>
				<th style='width: 190px;'>이름 </th>
				<th style='width: 115px;'>성별</th>
				<th style='width: 190px;'>연락처</th>
				<th style='width: 160px;'>시작일</th>
				<th style='width: 160px;'>종료일</th>
				<th style='width: 100px;'>회원유형</th>
				<th style='width: 190px;'>주소</th>
				<th style='width: 160px;'>생년월일</th>
				<th style='width: 85px;' >비고</th>
			</tr>
			<c:if test="${members != null}">
			<c:forEach var="member" items="${members}" varStatus="status">
			<tr id='member${status.index}'>
				<td class='m${status.index}'>${member.memberNum}</td>
				<td class='m${status.index}'>${member.mName}</td>
				<td class='m${status.index}'>${member.gender}</td>
				<td class='m${status.index}'>${member.phone}</td>
				<td class='m${status.index}'>${member.startDay}</td>
				<td class='m${status.index}'>${member.endDay}</td>
				<td class='m${status.index}'>${member.memberType}</td>
				<td class='m${status.index}'>${member.address}</td>
				<td class='m${status.index}'>${member.birthday}</td>
				<td class='mousePointer update${status.index}' onclick='update(${status.index})'>수정</td>
			</tr>
			<form action='' method='post'>
			<tr id='form${status.index}' style='display: none;'>
				<td>${member.memberNum}<input type='hidden' name='memberNum' value='${member.memberNum}'></td>
				<td><input name='mName' type='text'></td>
				<td><input name='gender' type='radio' value='male'>남자<input name='gender' type='radio' value='female'>여자</td>
				<td><input name='phone' type='tel'></td>
				<td><input name='startDay' type='date'></td>
				<td><input name='endDay' type='date'></td>
				<td>
					<select name='memberType'>
						<option value='일반'>일반</option>
						<option value='PT'>PT</option>
						<option value='프로그램'>프로그램</option>
					</select>
				</td>
				<td><input name='address' type='text'></td>
				<td><input name='birthday' type='date'></td>
				<td>
					<a class='mousePointer' onclick='rollback(${status.index})'>취소</a>
					<input type='submit' value='적용'>
				</td>
			</tr>
			</form>
			</c:forEach>
			</c:if>
		</table>
		<div class='pageNav'>
		<!-- 익명메서드 선언 = c:set 스트림. -->
			${rambda = (i)->String.valueOf(i).substring(0,String.valueOf(i).indexOf(".") == -1
							? String.valueOf(i).length() 
							: String.valueOf(i).indexOf(".")); ''}
			<a href='?page=${rambda(pAreaNum == 0 ? 1 : pAreaNum)}'> &lt;< </a>
			<c:forEach var="i" begin="1" end="${pCount}">
				<a href='?page=${rambda(i+pAreaNum)}'>${rambda(i+pAreaNum)}</a>
			</c:forEach>
			<a href='?page=${rambda(pCount == MAX_NAV_NUM ? pAreaNum + MAX_NAV_NUM + 1 : pAreaNum + pCount)}'>&gt;&gt;</a>
		</div>
	</div>
</section>



<!-- --------------------------------------------------------------------------------------------------------------------- -->

<%@ include file='/WEB-INF/views/common/end.jsp' %>

<script>
	var chPage = ${chPage};
	// '<<' 버튼에 대한 컨트롤 
	if (chPage === 1) {
		var a = document.querySelectorAll('.pageNav a[href="?page=1"]');
		a[0].removeAttribute('href');
		a[1].removeAttribute('href');
		a[1].style.fontWeight = 'bold';
		a[1].style.fontSize = '2em';
	} else {
		//현재 보고있는 페이지버튼 컨트롤
		var a = document.querySelector('.pageNav a[href="?page=' + chPage + '"]');
		a.removeAttribute('href');
		a.style.fontWeight = 'bold';
		a.style.fontSize = '2em';
	}
	
	// '>>' 버튼에 대한 컨트롤
	var endPageNum = ${pAreaNum + pCount};
	if (chPage === endPageNum) {
		var a = document.querySelector('.pageNav a[href="?page=' + chPage + '"]');
		a.removeAttribute('href');
	}
	
	
	
	
	function update(i) {
		//기존정보 감추고, 수정창 보이고
		document.querySelector('#member'+i).style.display = 'none';
		document.querySelector('#form'+i).style.display = '';
		//            input안에 값 넣기
		var info = document.querySelectorAll('.m'+i);
		var form = document.querySelectorAll('#form'+i+' input');
		form[1].value = info[1].innerText;
		document.querySelector('#form' + i + ' input[type=radio][value=' + info[2].innerText + ']').checked = true;
		form[4].value = info[3].innerText;
		form[5].value = info[4].innerText;
		form[6].value = info[5].innerText;
		document.querySelector('#form' + i + ' option[value=' + info[6].innerText + ']').selected = true;
		form[7].value = info[7].innerText;
		form[8].value = info[8].innerText;
	}
	
	function rollback(i) {
		document.querySelector('#member'+i).style.display = '';
		document.querySelector('#form'+i).style.display = 'none';
	}
</script>