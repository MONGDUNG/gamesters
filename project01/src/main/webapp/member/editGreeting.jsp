<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<%@ page import="project01.member.bean.MemberDTO" %>
<%@ page import="java.net.URLEncoder" %>

<%
    request.setCharacterEncoding("utf-8");
    String nick = request.getParameter("nick");
    MemberDAO dao = new MemberDAO();
    MemberDTO dto = dao.getProfile(nick);

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String newGreeting = request.getParameter("greeting");
        dao.updateGreeting(nick, newGreeting);

        // URL 인코딩 처리
        String encodedNick = URLEncoder.encode(nick, "UTF-8");
        response.sendRedirect("profile.jsp?nick=" + encodedNick);
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>인사말 수정</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>인사말 수정</h2>
        <form method="post" action="editGreeting.jsp?nick=<%= nick %>">
            <div class="mb-3">
                <label for="greeting" class="form-label">새 인사말</label>
                <textarea class="form-control" id="greeting" name="greeting" rows="3"><%= dto.getGreeting() %></textarea>
            </div>
            <button type="submit" class="btn btn-primary">수정</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='profile.jsp?nick=<%= nick %>'">취소</button>
        </form>
    </div>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>