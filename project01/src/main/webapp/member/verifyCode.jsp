<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>

<%
    String inputCode = request.getParameter("authCode");
    String sessionCode = (String) session.getAttribute("authCode");
    String id = (String) session.getAttribute("userId");
	String email = request.getParameter("email");
    if (inputCode.equals(sessionCode)) {
        MemberDAO dao = new MemberDAO();
        String pw = dao.getLostPw(id, email);

%>
    <h3>비밀번호: <%= pw %></h3>
    <a href="loginForm.jsp">로그인 페이지로 이동</a>
<%
    } else {
%>
    <h3>인증 코드가 올바르지 않습니다.</h3>
    <a href="findPw.jsp">돌아가기</a>
<%
    }
%>