<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <h1>아이디 찾기</h1>

<form action="findIdPro.jsp" method="post">
	<div>
	<label for="name">이름: </label>
	<input type="text" id="name" name="name" required>
	</div>
	
	<div>
	<label for="name">이메일: </label>
	<input type="email" id="email" name="email" required>
	</div>
	
	<div>
        <button type="submit">검색</button>
      </div>
</form>