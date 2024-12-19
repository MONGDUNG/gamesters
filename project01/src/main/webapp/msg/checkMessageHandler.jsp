<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.msg.bean.MsgDAO" %>

<%
    String msgNum = request.getParameter("msgNum"); // 클라이언트로부터 msgNum 받기
    String nick = (String) session.getAttribute("nick"); // 세션 닉네임 가져오기

    if (msgNum != null && !msgNum.isEmpty()) {
        MsgDAO msgDAO = new MsgDAO();
        msgDAO.checkMsg(Integer.parseInt(msgNum)); // 반환값 없이 호출
        response.getWriter().write("success");
    } else {
        response.getWriter().write("fail");
    }
%>
