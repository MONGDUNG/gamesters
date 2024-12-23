<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ID 중복 확인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px; /* Reduced padding to move content higher */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .duplicate-check-container {
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 300px;
        }
        .duplicate-check-container p {
            font-size: 16px;
            margin-bottom: 20px;
            color: #333;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="duplicate-check-container">
        <% 
        try {
            String id = request.getParameter("id");
            MemberDAO dao = new MemberDAO();
            boolean isDuplicate = dao.isIdDuplicate(id);
            if(isDuplicate) { 
        %>
            <p>현재 사용중인 ID입니다.</p>
        <% 
            } else { 
        %>
            <p>사용할 수 있는 ID입니다.</p>
        <% 
            } 
        } catch (Exception e) { 
        %>
            <p>오류가 발생했습니다. 다시 시도해주세요.</p>
        <% 
        } 
        %>
        <button type="button" onclick="window.close()">닫기</button>
    </div>
</body>
</html>
