<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.admin.bean.AdminDAO" %>

<% 
    String banWord = request.getParameter("banWord");
    if (banWord != null && !banWord.trim().isEmpty()) {
        AdminDAO dao = new AdminDAO();
        dao.deleteBanWord(banWord);
    }
    response.sendRedirect("banWordAdmin.jsp");
%>