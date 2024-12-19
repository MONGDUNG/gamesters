<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO" %>

<%

	String game = request.getParameter("game");
	String action = request.getParameter("action");
	int boardnum = request.getParameter("boardnum") != null ? Integer.parseInt(request.getParameter("boardnum")) : 0;
	
	BoardDAO dao = new BoardDAO();
	
	if("up".equals(action)){
		dao.upOrder(boardnum, game);
	}else if("down".equals(action)){
		dao.downOrder(boardnum, game);
	}
	
	response.sendRedirect("board.jsp?game=" + game);
%>