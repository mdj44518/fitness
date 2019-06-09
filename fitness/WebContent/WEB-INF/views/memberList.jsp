<%@page import="org.fitness.model.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<title>회원 목록</title>
<%
	final int MAX_NAV_NUM = 10;

	Member[] members = (Member[])request.getAttribute("members");
	int chPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
	int pCount = (int)request.getAttribute("pCount");
	
	int pAreaNum = ((chPage - 1) / MAX_NAV_NUM) * MAX_NAV_NUM;
%>
<%@ include file='/WEB-INF/views/common/begin.jsp' %>
<link href='<%= request.getContextPath() + "/css/table.css" %>' rel='stylesheet' type='text/css'>

<section>
	<div class='table'>
		<h1 class='mousePointer' onclick='location.href="memberList"'>회원 목록</h1>
		<table>
			<tr>
				<th>회원번호 </th>
				<th>이름 </th>
				<th>성별</th>
				<th>연락처</th>
				<th>시작일</th>
				<th>종료일</th>
				<th>회원유형</th>
				<th>주소</th>
				<th>생년월일</th>
				<th>비고</th>
			</tr>
			<% if (members != null) { %>
			<% for (int i = 0; i < members.length; i++) { %>
			<tr id='<%="member"+ i%>'>
				<td class='<%="m"+i%>'><%= members[i].getMemberNum() %></td>
				<td class='<%="m"+i%>'><%= members[i].getmName() %></td>
				<td class='<%="m"+i%>'><%= members[i].getGender() %></td>
				<td class='<%="m"+i%>'><%= members[i].getPhone() %></td>
				<td class='<%="m"+i%>'><%= members[i].getStartDay() %></td>
				<td class='<%="m"+i%>'><%= members[i].getEndDay() %></td>
				<td class='<%="m"+i%>'><%= members[i].getMemberType() %></td>
				<td class='<%="m"+i%>'><%= members[i].getAddress() %></td>
				<td class='<%="m"+i%>'><%= members[i].getBirthday() %></td>
				<td class='mousePointer <%="update" + i%>' onclick='update(<%=i%>)'>수정</td>
			</tr>
			<form action='' method='post'>
			<tr id='<%="form"+ i%>' style='display: none;'>
				<td><%= members[i].getMemberNum() %><input type='hidden' name='memberNum' value='<%= members[i].getMemberNum() %>'></td>
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
					<a class='mousePointer' onclick='rollback(<%=i%>)'>취소</a>
					<input type='submit' value='적용'>
				</td>
			</tr>
			</form>
			<% }} %>
		</table>
		<div class='pageNav'>
			<a href='<%= "?page=" + (pAreaNum == 0 ? 1 : pAreaNum) %>'>&lt;&lt;</a>
			<% for (int i = 1; i <= pCount; i++) { %>
				<a href='<%= "?page=" + (i+pAreaNum) %>'><%= i+pAreaNum %></a>
			<% } %>
			<a href='<%= "?page=" + (pCount == MAX_NAV_NUM ? pAreaNum + MAX_NAV_NUM + 1 : pAreaNum + pCount) %>'>&gt;&gt;</a>
		</div>
	</div>
</section>
<%@ include file='/WEB-INF/views/common/end.jsp' %>

<script>
var chPage = <%= chPage %>;
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
var endPageNum = <%= pAreaNum + pCount %>;
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


//	function update(i){
//	var button = document.querySelector('.update' + i);
//	//각 각 인풋 타입으로 .
//	var info = document.querySelectorAll('.m'+i);
//	var pk = info[0].innerText;
//	button.innerHTML = "<a href=''>취소</a><input type='submit' value='적용'>" +
//						"<input type=\'hidden\' value=\'"+ pk +"\'>";
//	info[1].innerHTML = '<input name=\'mName\' type=\'text\' value=\'' + info[1].innerText + '\'>';
//	var gender = info[2].innerText;
//	info[2].innerHTML = '<input name=\'gender\' type=\'radio\' value=\'male\'>남자<input name=\'gender\' type=\'radio\' value=\'female\'>여자';
//	document.querySelector('.m' + i + ' input[type=radio][value=' + gender + ']').checked = true;
//	info[3].innerHTML = '<input name=\'phone\' type=\'tel\' value=\'' + info[3].innerText + '\'>';
//	info[4].innerHTML = '<input name=\'startDay\' type=\'date\' value=\'' + info[4].innerText + '\'>';
//	info[5].innerHTML = '<input name=\'endDay\' type=\'date\' value=\'' + info[5].innerText + '\'>';
//	var mType = info[6].innerText;
//	info[6].innerHTML = "<select name='memberType'>" +
//							"<option value='일반'>일반</option>" +
//							"<option value='PT'>PT</option>" +
//							"<option value='프로그램'>프로그램</option>" +
//						"</select>";
//	document.querySelector('.m'+i+' option[value='+mType+']').selected = true;
//	info[7].innerHTML = '<input name=\'address\' type=\'text\' value=\'' + info[7].innerText + '\'>';
//	info[8].innerHTML = '<input name=\'birthday\' type=\'date\' value=\'' + info[8].innerText + '\'>';
//}
</script>