<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <jsp:include page="../header.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white text-center">
                        <h2>내 정보</h2>
                    </div>
                    <div class="card-body">
                        <% 
                        request.setCharacterEncoding("UTF-8");
                        String nick = (String) session.getAttribute("nick");
                        if (nick == null) { 
                        %>
                            <script>
                                alert("세션이 만료되었습니다.");
                                window.location = "loginForm.jsp";
                            </script>
                        <% }else{
                        project01.member.bean.MemberDAO dao = new project01.member.bean.MemberDAO();
                        project01.member.bean.MemberDTO dto = dao.memberId(nick);
                        
                        %>
                        <ul class="list-group list-group-flush">
                        	<li class="list-group-item"><strong>이름:</strong> <%= dto.getName() %></li>
                            <li class="list-group-item"><strong>아이디:</strong> <%= dto.getId() %></li>
                            <li class="list-group-item"><strong>닉네임:</strong> <%= dto.getNickname() %></li>
                            <li class="list-group-item"><strong>이메일:</strong> <%= dto.getEmail() %></li>
                            <li class="list-group-item"><strong>생년월일:</strong> <%= dto.getBirth() %></li>
                            <li class="list-group-item"><strong>성별:</strong> 
                                <% if (dto.getGender().equals("1")) { %>
                                    남자
                                <% } else if (dto.getGender().equals("2")) { %>
                                    여자
                                <% } }%>
                            </li>
                        </ul>
                    </div>
                    <div class="card-footer text-center">
                        <a href="psCheck.jsp" class="btn btn-primary w-50">수정하기</a>
                        <br />
                        <br />
                        <a href="withdrawForm.jsp" class="btn btn-primary w-50">회원탈퇴</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>