<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<%@ page import="project01.member.bean.MemberDTO" %>

<%
    request.setCharacterEncoding("utf-8");
    String profileNick = request.getParameter("nick");
    MemberDAO dao = new MemberDAO();
    MemberDTO dto = dao.getProfile(profileNick);
    String sessionNick = (String) session.getAttribute("nick");
    int admin = 0;
    if (sessionNick != null) {
    	admin = (int)session.getAttribute("admin");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로필</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .sticky-sidebar {
            position: sticky;
            top: 0;
        }
    </style>
    <script>
        function handleAction() {
            // 부모 창 이동
            if (window.opener) {
                window.opener.location.href = 'userPosts.jsp?profileNick=<%= profileNick %>'; // 이동할 페이지 설정
            }
            // 현재 창 닫기
            window.close();
        }
    </script>
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-4">
                <div class="sticky-sidebar">
                    <h2>프로필</h2>
                    <ul class="list-group">
                        <li class="list-group-item"><strong>닉네임:</strong> <%= dto.getNickname() %></li>
                        <li class="list-group-item"><strong>레벨:</strong> <%= dto.getLevel() %></li>
                        <li class="list-group-item"><strong>경험치:</strong> <%= dto.getExp() %> / <%= dto.getMaxExp() %></li>
                        <li class="list-group-item"><strong>인사말:</strong> <%= dto.getGreeting() %></li>
                    </ul>
                    <% if (sessionNick != null && sessionNick.equals(profileNick)) { %>
                        <button class="btn btn-primary mt-3" onclick="location.href='editGreeting.jsp?nick=<%= profileNick %>'">인사말 수정</button>
                    <% } %>
                    <% if (admin == 1) { %>
                        <button class="btn btn-danger mt-3" onclick="location.href='../admin/banMember.jsp?nick=<%= profileNick %>'">회원제재</button>
                    <% } %>
                    <button class="btn btn-secondary mt-3" onclick="handleAction()">작성한 게시물 확인</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>