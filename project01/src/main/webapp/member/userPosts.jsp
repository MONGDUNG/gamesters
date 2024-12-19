<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<%@ page import="java.util.List" %>
<jsp:include page="../header.jsp" />
<%
	String contextPath = request.getContextPath();	//절대경로필요(userPosts.jsp는 member폴더에 있고, viewBoard.jsp는 board폴더에 있으니까...)
	//로그인 여부 확인
	String nick = request.getParameter("profileNick");
	
	BoardDTO dto = new BoardDTO();						//게시판에서 쓸 DB꺼내기
	BoardDAO dao = new BoardDAO();
	
	
	//List<BoardDTO> postList = dao.getUserPosts(nick);	//DB대입
	

	//페이지 나누기
	int pageSize = 20;//한 페이지에 보여줄 게시글 수
	String pageNum = request.getParameter("pageNum");	//null은 숫자로 바꾸지 못하니 String으로 받는다.
	//밑에 a태그에서 보내는 값을 pageNum으로 받는다.
	int currentPage = (pageNum == null) ? 1 : Integer.parseInt(pageNum);
	int start = (currentPage - 1) * pageSize + 1;
	int end = currentPage * pageSize;
	
	List<BoardDTO> postpage = dao.postList(nick, start, end);
	int count = dao.postCount(nick);	//유저가 쓴 글 전체 갯수
	
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

        <!-- 페이지네이션 -->
        <% if(count > 0) { 
            int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
            int startPage = (currentPage / 10) * 10 + 1;
            int pageBlock = 10;
            int endPage = startPage + pageBlock - 1;
            if(endPage > pageCount) {
                endPage = pageCount;
            }
        %>
        <nav aria-label="Page navigation" class="my-4">
            <ul class="pagination justify-content-center">
                <% if(startPage > 10) { %>
                    <li class="page-item">
                        <a class="page-link" href="userPosts.jsp?pageNum=<%=startPage - 10%>&profileNick=<%= nick%>">이전</a>
                    </li>
                <% } %>
                
                <% for(int i = startPage ; i <= endPage ; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="userPosts.jsp?pageNum=<%=i%>&profileNick=<%= nick%>"><%=i%></a>
                    </li>
                <% } %>
                
                <% if(endPage < pageCount) { %>
                    <li class="page-item">
                        <a class="page-link" href="userPosts.jsp?pageNum=<%=startPage+10%>&profileNick=<%= nick%>">다음</a>
                    </li>
                <% } %>
            </ul>
        </nav>
        <% } %>

        <!-- 검색 폼 -->
        <div class="card mt-4">
            <div class="card-body">
                <form action="<%= contextPath %>/board/PostSearch.jsp" method="post" class="row g-3">
                    <div class="col-auto">
                        <select name="searchType" class="form-select">    
                            <option value="game">게임</option>
                            <option value="title">제목</option>
                        </select>
                    </div>
                    <div class="col-auto">
                        <input type="text" name="searchKeyword" class="form-control" placeholder="검색어 입력" />
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary">검색</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>























