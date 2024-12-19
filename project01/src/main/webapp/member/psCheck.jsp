<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h1>비밀번호 확인</h1>

 <form action="psCheckPro.jsp" method="post">
        <input type="hidden" name="userId" value="<%= session.getAttribute("nick") %>">
        <label for="password">비밀번호:</label>
        <input type="password" id="password" name="password" required>
        <button type="submit">확인</button>
    </form>