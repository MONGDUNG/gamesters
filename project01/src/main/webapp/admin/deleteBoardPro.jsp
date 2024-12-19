<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.admin.bean.AdminDAO" %>


<% 
	System.out.println(request.getParameter("boardGame"));
int result = new AdminDAO().deleteBoard(request.getParameter("boardGame")); %>

<script>
    <% if (result == 1) { %>
        alert("게시판이 삭제되었습니다.");
    <% } else if (result == -1) { %>
        alert("입력하신 게시판이 존재하지 않습니다.");
    <% } %>
    window.location.href = "adminMain.jsp";
</script>