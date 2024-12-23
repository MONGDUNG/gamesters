<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 확인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .password-check-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 350px;
        }
        .password-check-container h1 {
            font-size: 20px;
            margin-bottom: 20px;
            color: #333;
        }
        .password-check-container label {
            font-size: 14px;
            color: #555;
            display: block;
            margin-bottom: 10px;
            text-align: left;
        }
        .password-check-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .password-check-container button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            width: 100%;
        }
        .password-check-container button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="password-check-container">
        <h1>비밀번호 확인</h1>
        <form action="psCheckPro.jsp" method="post">
            <input type="hidden" name="userId" value="<%= session.getAttribute("nick") %>">
            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password" required>
            <button type="submit">확인</button>
        </form>
    </div>
</body>
</html>
