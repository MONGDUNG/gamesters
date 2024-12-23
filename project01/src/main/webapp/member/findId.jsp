<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 찾기</title>
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
        h1 {
            font-size: 1.8em;
            color: #333;
            margin-bottom: 20px;
        }
        form div {
            margin-bottom: 15px;
            text-align: left;
        }
        label {
            font-size: 1em;
            color: #555;
        }
        input {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            font-size: 1em;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
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
    </style>
</head>
<body>
    <div class="container">
        <h1>아이디 찾기</h1>
        <form action="findIdPro.jsp" method="post">
            <div>
                <label for="name">이름:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div>
                <label for="email">이메일:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div>
                <button type="submit">검색</button>
            </div>
        </form>
    </div>
</body>
</html>
