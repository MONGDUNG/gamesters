<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.admin.bean.AdminDAO" %>

<%
    String game = request.getParameter("game");
    String category = request.getParameter("category");
	if(category.equals("자유") || category.equals("공지")) {
		
		%>
		<script>
		    alert("기본 카테고리는 삭제할 수 없습니다.");
            history.back();
        </script>
        <%
	}
	else{AdminDAO adminDAO = new AdminDAO();
    adminDAO.deleteCategory(game, category);

    response.sendRedirect("categoryManager.jsp?game=" + game);
	}
%>>