<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.mail.internet.*" %>
<%@ page import="jakarta.mail.*" %>
<%@ page import="project01.member.bean.MemberDAO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기 처리</title>
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
            color: #555;
            margin-bottom: 15px;
        }
        form {
            margin-top: 20px;
        }
        form label {
            font-size: 1em;
            color: #555;
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
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
        a {
            display: block;
            margin: 15px 0;
            text-decoration: none;
            color: #007bff;
        }
        a:hover {
            color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <% 
            String id = request.getParameter("id");
            String email = request.getParameter("email");
            
            MemberDAO dao = new MemberDAO();
            boolean userExists = dao.checkUser(id, email);

            if (!userExists) {
        %>
            <h3>아이디와 이메일을 다시 확인해주세요.</h3>
            <a href="findPw.jsp">돌아가기</a>
        <% 
            } else {
                String authCode = UUID.randomUUID().toString().substring(0, 6).toUpperCase();
                session.setAttribute("authCode", authCode);
                session.setAttribute("userId", id);

                final String sender = "ehdrb438438@naver.com";
                final String password = "PBGGKGPJFZP1";

                Properties props = new Properties();
                props.put("mail.smtp.host", "smtp.naver.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");

                Session mailSession = Session.getInstance(props, new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(sender, password);
                    }
                });

                try {
                    MimeMessage message = new MimeMessage(mailSession);
                    message.setFrom(new InternetAddress(sender));
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
                    message.setSubject("비밀번호 찾기 인증 코드");
                    message.setText("인증 코드: " + authCode);

                    Transport.send(message);
        %>
            <h3>인증 코드가 이메일로 전송되었습니다.</h3>
            <form action="verifyCode.jsp" method="post">
                <input type="hidden" name="email" value="<%=email%>">
                <label for="authCode">인증 코드:</label>
                <input type="text" id="authCode" name="authCode" required>
                <button type="submit">확인</button>
            </form>
        <% 
                } catch (Exception e) {
                    e.printStackTrace();
        %>
            <h3>이메일 전송에 실패했습니다. 다시 시도해주세요.</h3>
            <a href="findPw.jsp">돌아가기</a>
        <% 
                }
            }
        %>
    </div>
</body>
</html>
