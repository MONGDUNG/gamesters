<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.msg.bean.MsgDAO" %>

<%
    // 전달받은 파라미터 처리
    String msgNum = request.getParameter("msgNum");
    String userType = request.getParameter("userType");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>삭제 확인</title>
</head>
<body>
    <h3>정말 삭제하시겠습니까?</h3>
    <form method="post" action="deleteMessage.jsp">
        <input type="hidden" name="msgNum" value="<%= msgNum %>">
        <input type="hidden" name="userType" value="<%= userType %>">
        <button type="submit" name="confirm" value="yes">예</button>
        <button type="button" onclick="window.close();">아니오</button>
    </form>
</body>
</html>

<%
    // 삭제 요청 확인 후 처리
    if ("POST".equalsIgnoreCase(request.getMethod()) && "yes".equals(request.getParameter("confirm"))) {
        MsgDAO msgDAO = new MsgDAO();
        if ("sender".equals(userType)) {
            msgDAO.deleteMessageForSender(Integer.parseInt(msgNum));
        } else if ("receiver".equals(userType)) {
            msgDAO.deleteMessageForReceiver(Integer.parseInt(msgNum));
        }
		System.out.println(msgNum + "번 쪽지가 삭제되었습니다.");
		System.out.println("userType: " + userType);
        out.print("<script>alert('쪽지가 삭제되었습니다.'); window.close();</script>");
    }
%>