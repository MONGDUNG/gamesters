<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<%@ page import="project01.member.bean.MemberDTO" %>
<%
    String nick = (String) session.getAttribute("nick");
    MemberDAO memberDAO = new MemberDAO();
    MemberDTO memberDTO = null;

    if (nick != null) {
        memberDTO = memberDAO.memberId(nick);
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <style>
        .header {
            background-color: #333; /* 어두운 회색 배경 */
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* 부드러운 그림자 */
        }
        .header a {
            text-decoration: none;
            font-weight: bold;
            padding: 8px 15px;
            border-radius: 5px;
            margin-left: 10px;
            font-size: 14px;
        }
        .btn-main {
            background-color: #007bff; /* 파란색 */
            color: #fff;
            border: 1px solid #007bff;
        }
        .btn-login {
            background-color: #ffc107; /* 노란색 */
            color: #333;
            border: 1px solid #ffc107;
        }
        .btn-logout {
            background-color: #dc3545; /* 빨간색 */
            color: #fff;
            border: 1px solid #dc3545;
        }
        .btn-signup {
            background-color: #ffc107; /* 노란색 */
            color: #333;
            border: 1px solid #ffc107;
        }
        .header a:hover {
            opacity: 0.9;
        }
        .header .left a {
            margin-right: 15px;
        }
        .header .right span {
            font-size: 14px;
            margin-right: 10px;
            color: #fff;
        }
    </style>

</head>
<body>
    <div class="header">
        <!-- 왼쪽: 메인 버튼 -->
        <div class="left">
            <a href="../member/main.jsp" class="btn-main">메인으로</a>
        </div>
        <!-- 오른쪽: 로그인/회원가입 또는 닉네임/로그아웃 -->
        <div class="right">
            <% if (memberDTO != null) { %>
                <span>안녕하세요, <%= memberDTO.getNickname() %>님!</span>
                <a href="../member/logout.jsp" class="btn-logout">로그아웃</a>
            <% } else { %>
                <a href="../member/loginForm.jsp" class="btn-login">로그인</a>
                <a href="../member/inputForm.jsp" class="btn-signup">회원가입</a>
            <% } %>
        </div>
    </div>
</body>
</html>