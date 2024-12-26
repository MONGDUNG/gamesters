<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.admin.bean.AdminDAO" %>
<%@ page import="java.util.List" %>
<jsp:include page="../header.jsp" />
<%
    AdminDAO dao = new AdminDAO();
    int currentPage = 1;
    int limit = 30;
    String search = request.getParameter("search");
    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }
    int offset = (currentPage - 1) * limit;
    List<String> banWords = dao.getBanWords(offset, limit, search);
    int totalBanWords = dao.getBanWordCount(search);
    int totalPages = (int) Math.ceil((double) totalBanWords / limit);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>금칙어 관리</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript">
        function deleteBanWord(word) {
            if (confirm("정말로 삭제하시겠습니까?")) {
                document.deleteForm.banWord.value = word;
                document.deleteForm.submit();
            }
        }
    </script>
</head>
<body class="bg-light">
    <div class="container py-4">
        <h2 class="mb-4">금칙어 관리</h2>

        <!-- 검색 기능 -->
        <form method="get" action="banWordAdmin.jsp" class="row g-3 mb-4">
            <div class="col-auto">
                <input type="text" name="search" class="form-control" placeholder="검색어 입력" value="<%= search != null ? search : "" %>">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">검색</button>
            </div>
        </form>

        <!-- 금칙어 목록 -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>금칙어</th>
                        <th>작업</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for (String word : banWords) {
                    %>
                    <tr>
                        <td><%= word %></td>
                        <td>
                            <button type="button" class="btn btn-danger btn-sm"
                                    onclick="deleteBanWord('<%= word %>')">삭제</button>
                        </td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        </div>

        <!-- 페이지네이션 -->
        <nav aria-label="Page navigation" class="my-4">
            <ul class="pagination justify-content-center">
                <% if (currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="banWordAdmin.jsp?page=<%= currentPage - 1 %>&search=<%= search != null ? search : "" %>">이전</a>
                    </li>
                <% } %>

                <% for (int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="banWordAdmin.jsp?page=<%= i %>&search=<%= search != null ? search : "" %>"><%= i %></a>
                    </li>
                <% } %>

                <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="banWordAdmin.jsp?page=<%= currentPage + 1 %>&search=<%= search != null ? search : "" %>">다음</a>
                    </li>
                <% } %>
            </ul>
        </nav>

        <!-- 금칙어 추가 폼 -->
        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title">새 금칙어 추가</h5>
                <form method="post" action="addBanWord.jsp" class="row g-3">
                    <div class="col-auto">
                        <input type="text" name="newBanWord" class="form-control" placeholder="금칙어 입력">
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-success">추가</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 삭제 폼 -->
        <form name="deleteForm" method="post" action="deleteBanWord.jsp" style="display:none;">
            <input type="hidden" name="banWord">
        </form>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>