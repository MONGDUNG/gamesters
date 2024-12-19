<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%--고윤정 2024/11/28 --%>
    <h1>아이디 찾기 결과</h1>
    
<% 
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	
	MemberDAO dao = new MemberDAO();
	String id = dao.getLostId(name, email);	
	
	if(id == null){%>
	<h3>존재하지 않는 아이디입니다.</h3>
	<a href="loginForm.jsp">로그인 페이지로 돌아가기</a>
	<%}else{%>
	<h3>아이디는 [<%=id%>]입니다.</h3>
	<a href="loginForm.jsp">로그인 페이지로 돌아가기</a>
	<br />
	<a href="findPw.jsp">비밀번호 찾기</a>
	<%}%>