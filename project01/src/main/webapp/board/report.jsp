<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.SQLException"%>
<%
    String game = request.getParameter("game");
    int num = Integer.parseInt(request.getParameter("num"));
    String reportType = request.getParameter("reportType");
    String repNumParam = request.getParameter("rep_num");
    String type = request.getParameter("type");
    Integer rep_num = null;
    if (repNumParam != null) {
        try {
            rep_num = Integer.parseInt(repNumParam);
        } catch (NumberFormatException e) {
            // 예외 처리 (로그 출력 또는 기본값 설정)
            rep_num = null;
        }
    }
    String nick = (String) session.getAttribute("nick");
    if (nick == null) {
%>
    <script>
        alert("로그인이 필요한 기능입니다.");
        self.close();
    </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>신고하기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 50%;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .button-group {
            text-align: center;
        }
        .button-group button {
            padding: 10px 20px;
            margin: 0 10px;
            border: none;
            border-radius: 5px;
            color: white;
            background-color: #007bff;
            cursor: pointer;
        }
        .button-group button.cancel {
            background-color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>신고하기</h1>
        <div class="form-group">
            <label>게시판 이름: <%= game %><%if(type.equals("image"))%>이미지</label>
        </div>
        <div class="form-group">
            <label>게시물 번호: <%= num %>
                <% if (rep_num != null) { %>
                    댓글 번호: <%= rep_num %>
                <% } %>
            </label>
        </div>
        <form action="reportPro.jsp" method="post">
            <input type="hidden" name="game" value="<%= game %>">
            <input type="hidden" name="num" value="<%= num %>">
            <input type="hidden" name="reportType" value="<%= reportType %>">
            <input type="hidden" name="type" value="<%= type %>">
            <input type="hidden" name="rep_num" value="<%= rep_num %>">
            <div class="form-group">
                <label for="reason">신고 사유</label>
                <textarea id="reason" name="reason" required></textarea>
            </div>
            <div class="button-group">
                <button type="submit">등록</button>
                <button type="button" class="cancel" onclick="window.close()">취소</button>
            </div>
        </form>
    </div>
</body>
</html>
