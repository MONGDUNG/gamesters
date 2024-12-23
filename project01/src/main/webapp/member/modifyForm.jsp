<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDTO" %>
<%@ page import="project01.member.bean.MemberDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>수정하기</title>
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
        .modify-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 400px;
        }
        .modify-container h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }
        .modify-container label {
            font-size: 14px;
            color: #555;
            display: block;
            margin-bottom: 5px;
            text-align: left;
        }
        .modify-container input[type="text"], 
        .modify-container input[type="date"], 
        .modify-container input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .modify-container input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            width: 100%;
        }
        .modify-container input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="modify-container">
        <h1>수정하기</h1>
        <form action="modifyPro.jsp" method="post">
            <% 
                String nick = (String) session.getAttribute("nick");
                MemberDAO dao = new MemberDAO();
                MemberDTO dto = dao.memberId(nick);
            %>
            <p>ID: <%=dto.getId()%></p>
            <p>닉네임: <%=dto.getNickname() %></p>
            <label for="name">이름</label>
            <input type="text" id="name" name="name" value="<%=dto.getName() %>" />
            <label for="birth">생일</label>
            <input type="date" id="birth" name="birth" value="<%=dto.getBirth().split(" ")[0] %>" />
            <label for="email">이메일</label>
            <input type="email" id="email" name="email" value="<%=dto.getEmail() %>"/>
            <input type="submit" value="수정완료"/>
        </form>
    </div>
</body>
</html>
