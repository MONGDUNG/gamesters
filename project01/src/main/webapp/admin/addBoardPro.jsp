<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.admin.bean.AdminDAO" %>

<% 
	String boardGame = request.getParameter("boardGame");
	String boardGame_kr = request.getParameter("boardGame_kr");
	new AdminDAO().addBoard(boardGame, boardGame_kr);
%>

<script>
    alert("게시판이 추가되었습니다.");
    window.location.href = "adminMain.jsp";
</script>