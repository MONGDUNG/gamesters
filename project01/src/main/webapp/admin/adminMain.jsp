<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    Integer admin = (Integer) session.getAttribute("admin");
    if (admin == null || admin != 1) {
%>
    <script type="text/javascript">
        alert("관리자만 접근 가능합니다.");
        window.location.href = "../member/main.jsp";
    </script>
<%
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <h1 class="text-center mb-5">관리자 페이지</h1>
        
        <div class="row justify-content-center g-4">
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">포럼 관리</h5>
                        <p class="card-text">게시판 및 포럼 설정을 관리합니다.</p>
                        <a href="boardManager.jsp" class="btn btn-primary">바로가기</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">금칙어 관리</h5>
                        <p class="card-text">금지된 단어를 관리합니다.</p>
                        <a href="banWordAdmin.jsp" class="btn btn-primary">바로가기</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">신고 관리</h5>
                        <p class="card-text">사용자 신고를 관리합니다.</p>
                        <a href="reportList.jsp" class="btn btn-primary">바로가기</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">회원 제재 목록</h5>
                        <p class="card-text">제재된 회원 목록을 확인합니다.</p>
                        <a href="memberPanaltyList.jsp" class="btn btn-primary">바로가기</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">메인 페이지</h5>
                        <p class="card-text">메인 페이지로 이동합니다.</p>
                        <a href="../member/main.jsp" class="btn btn-secondary">바로가기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>