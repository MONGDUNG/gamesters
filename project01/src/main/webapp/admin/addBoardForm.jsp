<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <jsp:include page="../header.jsp" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>포럼 추가</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row mb-4">
            <div class="col">
                <h1 class="text-center">포럼 추가</h1>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <form action="addBoardPro.jsp" method="post">
                            <div class="mb-3">
                                <label for="boardGame" class="form-label">게임 영문명</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="boardGame"
                                       name="boardGame" 
                                       placeholder="게임의 영문명을 입력해주세요."
                                       required />
                                <div class="form-text">예시: LOL, OVERWATCH, VALORANT</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="boardGame_kr" class="form-label">게임 한글명</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="boardGame_kr"
                                       name="boardGame_kr" 
                                       placeholder="게임의 한글명을 입력해주세요."
                                       required />
                                <div class="form-text">예시: 리그오브레전드, 오버워치, 발로란트</div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">포럼 추가</button>
                                <a href="boardManager.jsp" class="btn btn-secondary">취소</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>