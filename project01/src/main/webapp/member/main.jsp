<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<%@ page import="project01.member.bean.MemberDAO" %>
<%@ page import="project01.member.bean.MemberDTO" %>
<%@ page import="project01.msg.bean.MsgDAO" %>
<%@ page import="project01.msg.bean.MsgDTO" %>
<%@ page import="java.util.List" %>

<%--포럼 페이지네이션 --%>
<%
	String currentPageParam = request.getParameter("currentPage");	
	String searchGame = request.getParameter("game");

	int perPage = 15;
	int currentPage = (currentPageParam == null) ? 1 : Integer.parseInt(currentPageParam);
	int start = (currentPage - 1) * perPage + 1;
	int end = currentPage * perPage;
	
	BoardDAO dao = new BoardDAO();
	
	List<BoardDTO> forum = dao.getAllBoardGames(searchGame, start, end);
	int totalForum = dao.getNoOfBoardGames(searchGame);	//포럼 전체 갯수
	int noOfForum = (int) Math.ceil((double) totalForum / perPage);
%>






<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>겜스터즈</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .sticky-sidebar {
            position: sticky;
            top: 20px;
            z-index: 10;
            height: calc(100vh - 40px);
            overflow-y: auto;
            background-color: #ffffff;
        }
        .progress {
            height: 20px;
        }
        .btn-sm {
            font-size: 0.9rem;
            padding: 5px 10px;
        }
        table .d-flex {
            justify-content: flex-start;
        }
        .nickname-container, .nickname {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .nickname img {
            width: 37px;
            height: 24px;
        }
        .nickname span {
            max-width: 150px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
         .ranking-list li {
            display: flex;
            align-items: center;
            padding: 8px;
            margin-bottom: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .ranking-list li:nth-child(1) {
            background-color: gold;
            font-weight: bold;
        }
        .ranking-list li:nth-child(2) {
            background-color: silver;
            font-weight: bold;
        }
        .ranking-list li:nth-child(3) {
            background-color: #cd7f32; /* Bronze */
            font-weight: bold;
        }
        .ranking-list img {
            width: 37px;
            height: 24px;
            margin-right: 10px;
        }
        .ranking-list span {
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- 포럼 목록 -->
            <aside class="col-md-2 bg-white p-3 border-end sticky-sidebar">
                <h5 class="mb-4">포럼 목록</h5>
                <ul class="list-group">
                    <%
                    Integer admin = (Integer)(session.getAttribute("admin"));
                    BoardDAO boardDAO = new BoardDAO();
                    List<BoardDTO> boardGames = boardDAO.getAllBoardGames(searchGame, start, end);
                    for (BoardDTO dto : boardGames) { %>
                        <li class="list-group-item">
                            <a href="../board/board.jsp?game=<%= dto.getGameName() %>" class="text-decoration-none">
                                <%= dto.getGameName_kr() %> 포럼
                            </a>
                        </li>
                    <% } %>
                </ul>
              
                <!-- 검색 폼 -->
        <div class="card mt-4">
            <div class="card-body">
                <form action="main.jsp" method="get" class="row g-3">
                    <div class="col-auto">
                        <input type="text" name="game" class="form-control" placeholder="게임 이름을 입력하세요" />
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary">검색</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="pagination">        
        <% 
        	for(int i = 1 ; i <= noOfForum; i++){
        		if(searchGame != null){%>
        		<a href="main.jsp?&currentPage=<%= i %>&game="<%= searchGame %>"><%= i %></a>
        		<% }else {%>
        		<a href="main.jsp?&currentPage=<%= i %>"><%= i %></a>
        	<% } }%>
        </div>
            </aside>

            <!-- 메인 콘텐츠 -->
            <main class="col-md-7 p-4">
                <img src="../resources/image/gamesters.png" class="img-fluid mx-auto d-block" alt="Gamesters Logo">

                <!-- 베스트 게시글 목록 -->
                <h5 class="mb-3">베스트 게시글</h5>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>포럼</th>
                            <th>글 제목</th>
                            <th>작성자</th>
                            <th>게시 시간</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% MemberDAO mdao = new MemberDAO();
                        List<BoardDTO> bestBoards = boardDAO.getBestBoardList(1, 30);
                        for (BoardDTO board : bestBoards) {
                            int level = mdao.getLevel(board.getNickname()); %>
                        <tr>
                            <td><%= board.getGameName() %></td>
                            <td><a href="../board/viewBoard.jsp?game=<%= board.getGameName() %>&num=<%= board.getBoardnum() %>&type=normal" class="text-decoration-none"><%= board.getTitle() %></a></td>
                            <td class="nickname">
                             <%if(level > 100){ %>
								<img src="../resources/image/level_/sp.gif" alt="레벨 아이콘">
	                            <% } else{%>
	                            <img src="../resources/image/level_/<%= level %>.gif" alt="레벨 아이콘">
	                            <% } %>
                                <span><%= board.getNickname() %></span>
                            </td>
                            <td><%= board.getReg() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- 베스트 이미지 목록 -->
                <h5 class="mb-3">베스트 이미지</h5>
                <div class="d-flex overflow-auto">
                    <% List<BoardDTO> bestImages = boardDAO.getBestImageAndTitleList(1, 20);
                    for (BoardDTO imageUrl : bestImages) { %>
                    <div class="p-2">
                       <a href="../board/viewBoard.jsp?game=<%= imageUrl.getGameName() %>&num=<%= imageUrl.getBoardnum() %>&type=image">
                        <img src="<%= imageUrl.getContent() %>" alt="Best Image" class="img-thumbnail" style="max-width: 150px;">
                        </a>
                    </div>
                    <% } %>
                </div>
            </main>

            <!-- 사용자 정보 및 광고 -->
            <aside class="col-md-3 p-3">
                <% String nick = (String) session.getAttribute("nick");
                
                MemberDAO memberDAO = new MemberDAO();
                MemberDTO memberDTO = null;
                MsgDAO msgDAO = new MsgDAO();
                int unreadMsgCount = 0;
                if (nick != null) {
                    memberDTO = memberDAO.memberId(nick);
                    unreadMsgCount = msgDAO.getUnReadMsgCount(nick);
                } %>
                
                <!-- 로그인 상태 -->
                <% if (nick != null && memberDTO != null) { %>
                    <div class="mb-4">
                        <h5>내 정보</h5>
                        <div class="nickname">
                            <%if(memberDTO.getLevel() > 100){ %>
							<img src="../resources/image/level_/sp.gif" alt="레벨 아이콘">
                            <% } else{%>
                            <img src="../resources/image/level_/<%= mdao.getLevel(memberDTO.getNickname()) %>.gif" alt="레벨 아이콘">
                            <% } %>
                            <span><%= memberDTO.getNickname() %></span>
                        </div>
                        <p><strong>경험치:</strong></p>
                        <div class="progress">
                            <div class="progress-bar"
                                 role="progressbar"
                                 style="width: <%= (int)(((double)memberDTO.getExp() / memberDTO.getMaxExp()) * 100) %>%;"
                                 aria-valuenow="<%= memberDTO.getExp() %>"
                                 aria-valuemin="0"
                                 aria-valuemax="<%= memberDTO.getMaxExp() %>">
                                <%= memberDTO.getExp() %> / <%= memberDTO.getMaxExp() %>
                            </div>
                        </div>
                        <div class="mt-3">
                            <a href="myPage.jsp" class="btn btn-outline-primary btn-sm me-2">회원정보</a>
                            <a href="logout.jsp" class="btn btn-outline-danger btn-sm me-2">로그아웃</a>
                            <a href="userPosts.jsp?profileNick=<%= nick %>" class="btn btn-outline-secondary btn-sm me-2">내 게시물</a>
                            <a href="../msg/msgList.jsp" class="btn btn-outline-secondary btn-sm">
                            쪽지함 <span class="badge bg-danger"><%= unreadMsgCount %></span></a>
                            <% if (admin != null && admin == 1) { %>
                                <a href="../admin/adminMain.jsp" class="btn btn-warning btn-sm mt-2">관리자 페이지</a>
                            <% } %>
                        </div>
                    </div>
                <% } else { %>
                    <!-- 로그아웃 상태 -->
                    <div class="alert alert-warning text-center">
                        <p>로그인이 필요합니다.</p>
                        <a href="loginForm.jsp" class="btn btn-primary btn-sm me-2">로그인</a>
                        <a href="inputForm.jsp" class="btn btn-secondary btn-sm">회원가입</a>
                    </div>
                <% } %>

                <!-- 랭킹 10위 목록 -->
                <div>
                    <h5 class="mb-3">랭킹 TOP 10</h5>
                    <ol class="ranking-list">
                        <% int rankIndex = 1;
                        for(MemberDTO rank : mdao.getRanking()) { %>
                        <li>
                            <span class="me-2">#<%= rankIndex++ %></span>
                            <% if(rank.getLevel() > 100) { %>
                                <img src="../resources/image/level_/sp.gif" alt="레벨 아이콘">
                            <% } else { %>
                                <img src="../resources/image/level_/<%= rank.getLevel() %>.gif" alt="레벨 아이콘">
                            <% } %>
                            <span><%= rank.getNickname() %></span>
                        </li>
                        <% } %>
                    </ol>
                </div>
            </aside>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>