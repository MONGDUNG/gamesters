<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.admin.bean.AdminDAO" %>

<% 
	int result = 0;
    String newBanWord = request.getParameter("newBanWord");
    if (newBanWord != null && !newBanWord.trim().isEmpty()) {
        result = new AdminDAO().addBanWord(newBanWord);
    }
    if (result == 0) {
    	%>
    	<script>
    	    alert("금칙어가 이미 존재합니다.");
    	    history.go(-1);
    	</script>
    	<%
    }else{
    response.sendRedirect("banWordAdmin.jsp");
    }
%>