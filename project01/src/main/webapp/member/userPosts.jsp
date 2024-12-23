<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<%@ page import="java.util.List" %>
<jsp:include page="../header.jsp" />
<%
	//로그인 여부 확인
	String nick = request.getParameter("profileNick");
	String currentPageParam = request.getParameter("currentPage");
	String searchType = request.getParameter("searchType");
	String searchWord = request.getParameter("searchWord");
	
	String contextPath = request.getContextPath(); //다른 폴더의 jsp로 연결 가능하게 함
	
	

	//페이지 나누기
	int recordsPerPage = 10;
	int currentPage = (currentPageParam == null) ? 1 : Integer.parseInt(currentPageParam);
	int start = (currentPage - 1) * recordsPerPage + 1;
	int end = currentPage * recordsPerPage;
	
	BoardDAO dao = new BoardDAO();
	
	List<BoardDTO> postpage = dao.searchPost(nick, start, end, searchType, searchWord);
	int totalRecords = dao.postCount(nick, searchType, searchWord);	//유저가 쓴 글 전체 갯수
	int noOfPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
	
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 게시글</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-4">
        <h2 class="mb-4"><%=nick%>님이 작성하신 글 목록</h2>
        
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>번호</th>
                        <th>게임</th>
                        <th>제목</th>
                        <th>날짜</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(BoardDTO board : postpage) { %>
                        <tr>
                            <td><%=board.getBoardnum() %></td>
                            <td><%=board.getGameName()%></td>
                            <td>
                                <a href="<%= contextPath %>/board/viewBoard.jsp?game=<%=board.getGameName()%>&num=<%=board.getBoardnum()%>&type=normal"
                                   class="text-decoration-none">
                                    <%=board.getTitle()%>
                                </a>
                            </td>
                            <td><%=board.getReg() %></td>    
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
       
        <!-- 검색 폼 -->
        <div class="card mt-4">
            <div class="card-body">
                <form action="userPosts.jsp" method="get" class="row g-3">
                    <div class="col-auto">
                    	<input type="hidden" name="profileNick" value="<%= nick %>" />
                        <select name="searchType" class="form-select">    
                            <option value="game">게임</option>
                            <option value="title">제목</option>
                        </select>
                    </div>
                    <div class="col-auto">
                        <input type="text" name="searchWord" class="form-control" placeholder="검색어를 입력하세요" />
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary">검색</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="pagination">        
        <% 
        	for(int i = 1 ; i <= noOfPages; i++){
        		if(searchType != null && searchWord != null){%>
        		<a href="userPosts.jsp?&currentPage=<%= i %>&searchType="<%= searchType %>&searchWord="<%= searchWord %>"><%= i %></a>
        		<% }else {%>
        		<a href="userPosts.jsp?&currentPage=<%= i %>"><%= i %></a>
        	<% } }%>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>























