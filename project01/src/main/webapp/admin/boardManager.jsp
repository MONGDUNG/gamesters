<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>포럼 관리</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row mb-4">
            <div class="col">
                <h1 class="text-center">포럼 관리</h1>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <%
                            BoardDAO boardDAO = new BoardDAO();
                            List<BoardDTO> boardGames = boardDAO.getAllBoardGames();
                        %>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>포럼 이름</th>
                                        <th class="text-end">작업</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (BoardDTO dto : boardGames) { %>
                                    <tr>
                                        <td class="align-middle"><%= dto.getGameName_kr() %></td>
                                        <td class="text-end">
                                            <form action="deleteBoardPro.jsp" method="post" class="d-inline">
                                                <input type="hidden" name="boardGame" value="<%= dto.getGameName() %>">
                                                <button type="submit" class="btn btn-danger btn-sm"
                                                        onclick="return confirm('정말로 삭제하시겠습니까?');">
                                                    삭제
                                                </button>
                                            </form>
                                            <a href="../board/board.jsp?game=<%= dto.getGameName() %>" 
                                               class="btn btn-primary btn-sm">
                                                보기
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a href="addBoardForm.jsp" class="btn btn-success me-2">포럼 추가</a>
                    <a href="adminMain.jsp" class="btn btn-secondary">관리자 메인으로</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>