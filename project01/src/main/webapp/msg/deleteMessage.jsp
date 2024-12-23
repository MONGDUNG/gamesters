<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.msg.bean.MsgDAO" %>
<%
    // 전달받은 파라미터 처리
    String msgNum = request.getParameter("msgNum");
    String userType = request.getParameter("userType");

    if ("POST".equalsIgnoreCase(request.getMethod()) && "yes".equals(request.getParameter("confirm"))) {
        MsgDAO msgDAO = new MsgDAO();
        if ("sender".equals(userType)) {
            msgDAO.deleteMessageForSender(Integer.parseInt(msgNum));
        } else if ("receiver".equals(userType)) {
            msgDAO.deleteMessageForReceiver(Integer.parseInt(msgNum));
        }
        out.print("<script>alert('쪽지가 삭제되었습니다.'); window.close();</script>");
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>삭제 확인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px 30px;
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        h3 {
            font-size: 1.2em;
            color: #333;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        button {
            padding: 10px;
            font-size: 1em;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        button[type="button"] {
            background-color: #6c757d;
        }
        button[type="button"]:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <h3>정말 삭제하시겠습니까?</h3>
        <form method="post" action="">
            <input type="hidden" name="msgNum" value="<%= msgNum %>">
            <input type="hidden" name="userType" value="<%= userType %>">
            <button type="submit" name="confirm" value="yes">예</button>
            <button type="button" onclick="window.close();">아니오</button>
        </form>
    </div>
</body>
</html>
