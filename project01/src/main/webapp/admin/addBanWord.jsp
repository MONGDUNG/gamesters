<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.admin.bean.AdminDAO" %>

<% 
    String newBanWord = request.getParameter("newBanWord");
    if (newBanWord != null && !newBanWord.trim().isEmpty()) {
        new AdminDAO().addBanWord(newBanWord);
    }
    response.sendRedirect("banWordAdmin.jsp");
%>