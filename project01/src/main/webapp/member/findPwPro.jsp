<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ page import="project01.member.bean.MemberDAO" %>
<%@ page import="project01.member.bean.MemberDTO" %>

<%
	String id = request.getParameter("id");
	String email = request.getParameter("email");
	
	MemberDAO dao = new MemberDAO();
	String pw = dao.getLostPw(id, email);
	
	if(pw == null){%>
	<h3>아이디와 이메일을 다시 한번 확인해주세요.</h3>
	<a href="loginForm.jsp">로그인 페이지로 돌아가기</a>
	<%}else{%>
	<h3><%=id%>님의 비밀번호는 <%=pw%>입니다.</h3>
	<a href="loginForm.jsp">로그인 페이지로 돌아가기</a>
	<%}%>
	