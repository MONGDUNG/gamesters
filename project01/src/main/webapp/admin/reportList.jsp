<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.report.bean.ReportDAO"%>
<%@ page import="project01.report.bean.ReportDTO"%>
<%@ page import="java.util.List"%>

<%
    request.setCharacterEncoding("UTF-8");
    String searchType = request.getParameter("searchType");
    String searchWord = request.getParameter("searchKeyword");
    int currentPage = 1; // 기본 페이지 번호
    int recordsPerPage = 30; // 한 페이지당 표시할 데이터 수

    // 페이지 번호 파라미터 처리
    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }
    int start = (currentPage - 1) * recordsPerPage;
    int end = recordsPerPage;

    ReportDAO dao = new ReportDAO();
    List<ReportDTO> dtoList;

    if (searchType != null && searchWord != null && !searchWord.trim().isEmpty()) {
        dtoList = dao.getReportAndSearchList(start, end, searchType, searchWord);
    } else {
        dtoList = dao.getReportAndSearchList(start, end, null, null);
    }

    // 총 데이터 수 가져오기
    int totalRecords = dao.getTotalReportCount(searchType, searchWord);
    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신고 관리</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript">
        function openPopup(reportId) {
            window.open('reportAction.jsp?report_id=' + reportId, 'ReportAction', 'width=600,height=400');
        }
    </script>
</head>
<body class="bg-light">
    <div class="container-fluid p-4">
        <h1 class="mb-4">신고 관리</h1>
        
        <form method="get" action="reportList.jsp" class="mb-4">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <select name="searchType" class="form-select">
                        <option value="game_name" <% if ("game_name".equals(searchType)) { %>selected<% } %>>게시판</option>
                        <option value="reporter_id" <% if ("reporter_id".equals(searchType)) { %>selected<% } %>>신고자ID</option>
                        <option value="reason" <% if ("reason".equals(searchType)) { %>selected<% } %>>신고사유</option>
                    </select>
                </div>
                <div class="col-auto">
                    <input type="text" name="searchKeyword" class="form-control" placeholder="검색어 입력" 
                           value="<%= searchWord != null ? searchWord : "" %>">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary">검색</button>
                </div>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-striped table-hover">
    <tr>
        <th>신고번호</th>
        <th>게시판</th>
        <th>이미지게시판</th>
        <th>게시글번호</th>
        <th>댓글번호</th>
        <th>신고자ID</th>
        <th>신고사유</th>
        <th>신고시각</th>
        <th>처리여부</th>
        <th>처리코드</th>
        <th>상세내용</th>
        <th>처리일시</th>
        <th>처리자ID</th>
        <th>열람</th>
        <th>처리</th>
    </tr>
    <%
    for (ReportDTO dto : dtoList) { 
    	String type = null;
        	if(dto.getIs_image() == 1) {
    			type = "image";
    		} else {
    			type = "normal";
    		}
    %>
    <tr>
        <td><%= dto.getReport_id() %></td>
        <td><%= dto.getGame_name() %></td>
        <td><%if(dto.getIs_image()==1) %>Y<%else%>N</td>
        <td><%= dto.getPost_id() %></td>
        <td><%= dto.getComment_id() %></td>
        <td><%= dto.getReporter_id() %></td>
        <td><%= dto.getReason() %></td>
        <td><%= dto.getReg_report() %></td>
        <td><%= dto.getIsCompleted() %></td>
        <td><%= dto.getAction_taken() != null ? dto.getAction_taken() : "-" %></td>
        <td><%= dto.getAction_detail() != null ? dto.getAction_detail() : "-" %></td>
        <td><%= dto.getReg_action() != null ? dto.getReg_action() : "-" %></td>
        <td><%= dto.getAdmin_id() != null ? dto.getAdmin_id() : "-" %></td>
        <td><a href="../board/viewBoard.jsp?game=<%=dto.getGame_name()%>&num=<%=dto.getPost_id()%>&type=<%=type%>">열람</a></td>
        <td><button type="button" onclick="openPopup(<%=dto.getReport_id()%>)">처리</button></td>
    </tr>
    <% } %>
 </table>
        </div>

        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <% if (currentPage > 1) { %>
                    <li class="page-item">
                     <%if(searchType != null && searchWord != null){ %>
                        <a class="page-link" href="reportList.jsp?page=<%= currentPage - 1 %>&searchType=<%= searchType %>&searchKeyword=<%= searchWord %>">이전</a>
                     <%}else{ %><a class="page-link" href="reportList.jsp?page=<%= currentPage - 1 %>">이전</a>
                        <%} %>
                    </li>
                <% } %>
                
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                    <%if(searchType != null && searchWord != null){ %>
                        <a class="page-link" href="reportList.jsp?page=<%= i %>&searchType=<%= searchType %>&searchKeyword=<%= searchWord %>"><%= i %></a>
                    <%}else{ %><a class="page-link" href="reportList.jsp?page=<%= i %>"><%= i %></a>
                        <%} %>
                    </li>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                    <%if(searchType != null && searchWord != null){ %>
                        <a class="page-link" href="reportList.jsp?page=<%= currentPage + 1 %>&searchType=<%= searchType %>&searchKeyword=<%= searchWord %>">다음</a>
                        <%}else{ %><a class="page-link" href="reportList.jsp?page=<%= currentPage + 1 %>">다음</a>
                        <%} %>
                    </li>
                <% } %>
            </ul>
        </nav>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
