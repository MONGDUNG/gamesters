<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h1>회원탈퇴</h1>

<form action="withdrawPro.jsp" method="post">
	비밀번호 : <input type="password" name="pw" /> <br />
	<input type="submit" value="탈퇴" />
	<button type="button" onclick="history.back();">취소</button>
</form>