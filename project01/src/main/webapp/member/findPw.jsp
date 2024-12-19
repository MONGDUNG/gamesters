<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <h1>비밀번호 찾기</h1>

<form action="findPwPro.jsp" method="post">
	<div>
	<label for="name">ID: </label>
	<input type="text" id="id" name="id" required>
	</div>
	
	<div>
	<label for="name">이메일: </label>
	<input type="email" id="email" name="email" required>
	</div>
	
	<div>
        <button type="submit">비밀번호 찾기</button>
      </div>
</form>