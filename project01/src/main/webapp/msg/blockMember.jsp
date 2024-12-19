
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>

<%
    String blocker_nick = (String) session.getAttribute("nick");
    String blocked_nick = request.getParameter("blocked_nick");

    if (blocker_nick == null || blocked_nick == null) {
%>
    <script>
        alert("로그인이 필요하거나 차단할 회원 정보가 없습니다.");
        location.href = "../member/loginForm.jsp";
    </script>
<%
    return;
    }

    MemberDAO memberDAO = new MemberDAO();
    memberDAO.blockMember(blocker_nick, blocked_nick);

    response.sendRedirect("msgList.jsp");
%>
