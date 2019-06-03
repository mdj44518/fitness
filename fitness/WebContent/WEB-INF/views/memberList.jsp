<%@page import="org.fitness.model.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<title>회원 목록</title>
<%
	final int VIEW_PAGE = 10;
	Member[] members = (Member[])request.getAttribute("members");
	int pageNum = (int)request.getAttribute("pageNum");
	String chPage = (String)request.getAttribute("chPage");
	int chPageInt = 1;
	if (chPage != null) {
		chPageInt = Integer.parseInt(chPage);
	}
	int pageView = ((chPageInt - 1) / VIEW_PAGE) * VIEW_PAGE;
%>
<%@ include file='/WEB-INF/views/common/begin.jsp' %>
<link href='<%= request.getContextPath() + "/css/table.css" %>' rel='stylesheet' type='text/css'>

<section>
	<div class='table'>
		<h1>회원 목록</h1>
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
			<form>
			<tr>
				<td class='<%="m"+i%>'><%= members[i].getMemberNum() %></td>
				<td class='<%="m"+i%>'><%= members[i].getmName() %></td>
				<td class='<%="m"+i%>'><%= members[i].getGender() %></td>
				<td class='<%="m"+i%>'><%= members[i].getPhone() %></td>
				<td class='<%="m"+i%>'><%= members[i].getStartDay() %></td>
				<td class='<%="m"+i%>'><%= members[i].getEndDay() %></td>
				<td class='<%="m"+i%>'><%= members[i].getMemberType() %></td>
				<td class='<%="m"+i%>'><%= members[i].getAddress() %></td>
				<td class='<%="m"+i%>'><%= members[i].getBirthday() %></td>
				<td class='update <%="update" + i%>'><span onclick='update(<%=i%>)'>수정</span></td>
			</tr>
			</form>
			<% }} %>
		</table>
		<div class='page'>
			<a href='<%= "?page=" + (pageView == 0 ? 1 : pageView) %>'>&lt;&lt;</a>
			<% for (int i = 1; i <= pageNum && i <= VIEW_PAGE; i++) { %>
				<a href='<%= "?page=" + (i + pageView) %>'><%= i + pageView %></a>
			<% } %>
			<a href='<%= "?page=" + (pageNum >= VIEW_PAGE ? pageView + VIEW_PAGE + 1 : pageView + pageNum) %>'>&gt;&gt;</a>
		</div>
	</div>
</section>
<%@ include file='/WEB-INF/views/common/end.jsp' %>

<script>
	var chPage = '<%= chPage %>';
	if (chPage !== 'null' && chPage !== '1') {
		var a = document.querySelector('.page a[href="?page=' + chPage + '"]');
		a.removeAttribute('href');
		a.style.fontWeight = 'bold';
		a.style.fontSize = '2em';
	} else {
		var a = document.querySelectorAll('.page a[href="?page=1"]');
		a[0].removeAttribute('href');
		a[1].removeAttribute('href');
		a[1].style.fontWeight = 'bold';
		a[1].style.fontSize = '2em';
	}
	
	var endPageNum = '<%= pageView + pageNum %>';
	if (chPage === endPageNum) {
		var a = document.querySelector('.page a[href="?page=' + chPage + '"]');
		a.removeAttribute('href');
	}
	
	function update(i){
		var button = document.querySelector('.update' + i);
		button.innerHTML = "<a href=''>취소</a><input type='submit' value='적용'>";
		//각 각 인풋 타입으로 .
		var info = document.querySelectorAll('.m'+i);
		var pk = info[0].innerText;
		info[1].innerHTML = '<input name=\'mName\' type=\'text\' value=\'' + info[1].innerText + '\'>';
		var gender = info[2].innerText;
		info[2].innerHTML = '<input name=\'gender\' type=\'radio\' value=\'male\'>남자<input name=\'gender\' type=\'radio\' value=\'female\'>여자';
		document.querySelector('.m' + i + ' input[type=radio][value=' + gender + ']').checked = true;
	}
	
</script>