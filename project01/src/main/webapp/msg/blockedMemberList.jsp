
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="project01.member.bean.MemberDAO" %>

<%
    String blocker_nick = (String)session.getAttribute("nick");
    if (blocker_nick == null) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "../member/loginForm.jsp";
    </script>
<%
    return;
}

    MemberDAO memberDAO = new MemberDAO();
    List<String> blockedMembers = memberDAO.getBlockedMembers(blocker_nick);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>차단 목록</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script>
    function confirmUnblock(blockedNick) {
        if (confirm(blockedNick + " 회원을 차단 해제 하시겠습니까?")) {
            document.getElementById('unblockForm-' + blockedNick).submit();
        }
    }
</script>
</head>
<body class="bg-light">
<div class="container mt-5">
    <h1 class="text-center">차단 목록</h1>
    <div class="d-flex justify-content-end mb-4">
        <a href="msgList.jsp" class="btn btn-secondary">쪽지함으로</a>
    </div>
    <div class="card shadow-sm mt-3">
        <div class="card-body">
            <h3 class="text-center">차단된 회원</h3>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>차단된 회원 닉네임</th>
                        <th>차단 해제</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (blockedMembers.isEmpty()) { %>
                        <tr>
                            <td class="text-center" colspan="2">차단된 회원이 없습니다.</td>
                        </tr>
                    <% } else { %>
                        <% for (String blockedNick : blockedMembers) { %>
                            <tr>
                                <td><%= blockedNick %></td>
                                <td>
                                    <form id="unblockForm-<%= blockedNick %>" action="unblockMember.jsp" method="post">
                                        <input type="hidden" name="blocked_nick" value="<%= blockedNick %>">
                                        <button type="button" class="btn btn-danger" onclick="confirmUnblock('<%= blockedNick %>')">차단 해제</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
