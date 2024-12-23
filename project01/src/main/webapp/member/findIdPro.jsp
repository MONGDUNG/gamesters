<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 찾기 결과</title>
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
        h3 {
            font-size: 1.2em;
            color: #555;
            margin-bottom: 15px;
        }
        a {
            display: inline-block;
            margin: 10px 0;
            text-decoration: none;
            color: #007bff;
            font-size: 1em;
        }
        a:hover {
            color: #0056b3;
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
            margin-top: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>아이디 찾기 결과</h1>
        <% 
            String name = request.getParameter("name");
            String email = request.getParameter("email");
        
            MemberDAO dao = new MemberDAO();
            String id = dao.getLostId(name, email);	
        
            if (id == null) { 
        %>
            <h3>존재하지 않는 아이디입니다.</h3>
            <a href="loginForm.jsp">로그인 페이지로 돌아가기</a>
        <% } else { %>
            <h3>아이디는 [<%=id%>]입니다.</h3>
            <a href="loginForm.jsp">로그인 페이지로 돌아가기</a>
            <a href="findPw.jsp">비밀번호 찾기</a>
        <% } %>
    </div>
</body>
</html>
