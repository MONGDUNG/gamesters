<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDTO" %>
<%@ page import="project01.report.bean.ReportDAO" %>
<%@ page import="java.util.List" %>

<%
    int currentPage = 1;
    int limit = 10;
    if (request.getParameter("currentPage") != null) {
    	currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    int offset = (currentPage - 1) * limit;

    ReportDAO dao = new ReportDAO();
    List<MemberDTO> memberList = dao.getMemberPanaltyList(offset, limit);
    int totalMembers = dao.getTotalMemberPanaltyCount(); // Implement this method to get the total count
    int totalPages = (int) Math.ceil((double) totalMembers / limit);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 제재 목록</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row mb-4">
            <div class="col">
                <h1 class="text-center">회원 제재 목록</h1>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>닉네임</th>
                                <th>경고 스택</th>
                                <th>제재 여부</th>
                                <th>해제 날짜</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (MemberDTO member : memberList) { %>
                            <tr>
                                <td><%= member.getNickname() %></td>
                                <td>
                                    <span class="badge bg-warning text-dark">
                                        <%= member.getWarn_stack() %>
                                    </span>
                                </td>
                                <td>
                                    <% if(member.getIs_banned() == 1) { %>
                                        <span class="badge bg-danger">제재 중</span>
                                    <% } else { %>
                                        <span class="badge bg-success">제재 아님</span>
                                    <% } %>
                                </td>
                                <td><%= member.getUnban_date() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- 페이지네이션 -->
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <% if (currentPage > 1) { %>
                            <li class="page-item">
                                <a class="page-link" href="memberPanaltyList.jsp?page=<%= currentPage - 1 %>">이전</a>
                            </li>
                        <% } %>
                        
                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                                <a class="page-link" href="memberPanaltyList.jsp?page=<%= i %>"><%= i %></a>
                            </li>
                        <% } %>
                        
                        <% if (currentPage < totalPages) { %>
                            <li class="page-item">
                                <a class="page-link" href="memberPanaltyList.jsp?page=<%= currentPage + 1 %>">다음</a>
                            </li>
                        <% } %>
                    </ul>
                </nav>
            </div>
        </div>

        <div class="text-center mt-4">
            <a href="adminMain.jsp" class="btn btn-secondary">관리자 메인</a>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>