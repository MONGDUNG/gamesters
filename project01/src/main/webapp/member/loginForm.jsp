<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-header text-center bg-primary text-white">
                        <h2>로그인</h2>
                    </div>
                    <div class="card-body">
                        <form action="loginPro.jsp" method="post">
                            <div class="mb-3">
                                <label for="id" class="form-label">아이디</label>
                                <input type="text" id="id" name="id" class="form-control" placeholder="아이디를 입력하세요" required>
                            </div>
                            <div class="mb-3">
                                <label for="pw" class="form-label">비밀번호</label>
                                <input type="password" id="pw" name="pw" class="form-control" placeholder="비밀번호를 입력하세요" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">로그인</button>
                        </form>
                    </div>
                    <div class="card-footer text-center">
                        <a href="inputForm.jsp" class="btn btn-link">회원 가입</a>
                        <a href="findId.jsp" class="btn btn-link">아이디 찾기</a>
                        <a href="findPw.jsp" class="btn btn-link">비밀번호 찾기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
