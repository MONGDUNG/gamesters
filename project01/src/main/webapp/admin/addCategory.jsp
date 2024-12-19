<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.admin.bean.AdminDAO" %>
<jsp:include page="../header.jsp" />
<%
    String game = request.getParameter("game");
    String categoryName = request.getParameter("categoryName");
    String message = "";

    if (categoryName != null && !categoryName.isEmpty()) {
        AdminDAO adminDAO = new AdminDAO();
        adminDAO.addCategory(game, categoryName);
        message = "카테고리가 추가되었습니다.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카테고리 추가</title>
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
        form {
            display: flex;
            flex-direction: column;
        }
        label, input {
            margin-bottom: 10px;
        }
        input[type="text"] {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        input[type="submit"] {
            padding: 10px;
            border: none;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            border-radius: 5px;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .message {
            text-align: center;
            color: green;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>카테고리 추가</h1>
        <form action="addCategory.jsp" method="post">
            <input type="hidden" name="game" value="<%= game %>">
            <label for="categoryName">카테고리 이름:</label>
            <input type="text" id="categoryName" name="categoryName" required>
            <input type="submit" value="추가">
        </form>
        <div class="message"><%= message %></div>
    </div>
</body>
</html>