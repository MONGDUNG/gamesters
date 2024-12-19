<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<%
    String receiver = request.getParameter("receiver"); // 쿼리 파라미터로 수신자 가져오기
%>

<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>쪽지 쓰기</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header text-center bg-primary text-white">
            <h2>쪽지 쓰기</h2>
        </div>
        <div class="card-body">
            <form action="sendMsgPro.jsp" method="post">
                <div class="mb-3">
                    <label for="receiver" class="form-label">받을 사람</label>
                    <input type="text" class="form-control" id="receiver" name="receiver" value="<%= receiver != null ? receiver : "" %>" required>
                </div>
                <div class="mb-3">
                    <label for="content" class="form-label">내용</label>
                    <textarea class="form-control" id="content" name="content" rows="5" placeholder="쪽지 내용을 입력하세요" required></textarea>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-lg">보내기</button>
                    <button type="button" class="btn btn-secondary btn-lg" onclick="history.back()">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
