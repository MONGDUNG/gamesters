<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<%@ page import="project01.member.bean.MemberDAO" %>
<%@ page import="project01.member.bean.MemberDTO" %>
<%@ page import="java.util.List" %>
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
		    position: sticky; /* 화면에 고정 */
		    top: 20px; /* 상단 여백 설정 */
		    z-index: 10; /* 다른 요소 위에 표시되도록 설정 */
		    height: calc(100vh - 40px); /* 뷰포트 높이에서 상하 여백 차감 */
		    overflow-y: auto; /* 내용이 길면 스크롤 가능하게 */
		    background-color: #ffffff; /* 배경색 고정 */
		}
        img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 20px auto;
            object-fit: contain;
        }
        .progress {
            height: 20px;
        }
        .btn-sm {
            font-size: 0.9rem;
            padding: 5px 10px;
        }
        .mb-4 {
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 8px;
            background-color: #f9f9f9;
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
                    BoardDAO boardDAO = new BoardDAO();
                    List<BoardDTO> boardGames = boardDAO.getAllBoardGames();
                    for (BoardDTO dto : boardGames) {
                    %>
                        <li class="list-group-item">
                            <a href="../board/board.jsp?game=<%= dto.getGameName() %>" class="text-decoration-none">
                                <%= dto.getGameName_kr() %> 포럼
                            </a>
                        </li>
                    <% } %>
                </ul>
            </aside>

            <!-- 메인 콘텐츠 -->
            <main class="col-md-7 p-4">
                <img src="../resources/image/gamesters.png" class="img">

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
                        <%
                        List<BoardDTO> bestBoards = boardDAO.getBestBoardList(1, 30);
                        for (BoardDTO board : bestBoards) {
                        %>
                        <tr>
                            <td><%= board.getGameName() %></td>
                            <td><a href="../board/viewBoard.jsp?game=<%= board.getGameName() %>&num=<%= board.getBoardnum() %>&type=normal" class="text-decoration-none"><%= board.getTitle() %></a></td>
                            <td><%= board.getNickname() %></td>
                            <td><%= board.getReg() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <!-- 베스트 이미지 목록 -->
				<h5 class="mb-3">베스트 이미지</h5>
				<div class="d-flex overflow-auto">
				    <%
				    List<BoardDTO> bestImages = boardDAO.getBestImageAndTitleList(1, 20); // Fetch up to 20 best images
				    for (BoardDTO imageUrl : bestImages) {
				    %>
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
                <%
                String nick = (String) session.getAttribute("nick");
                Integer admin = (Integer)(session.getAttribute("admin"));
                MemberDAO memberDAO = new MemberDAO();
                MemberDTO memberDTO = null;
                if (nick != null) {
                    memberDTO = memberDAO.memberId(nick);
                }
                %>

                <!-- 로그인 상태 -->
                <% if (nick != null && memberDTO != null) { %>
                    <div class="mb-4">
                        <h5>내 정보</h5>
                        <p><strong>닉네임:</strong> <%= memberDTO.getNickname() %></p>
                        <p><strong>레벨:</strong> <%= memberDTO.getLevel() %></p>
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
                            <a href="../msg/msgList.jsp" class="btn btn-outline-secondary btn-sm">쪽지함</a>
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

                <!-- 광고 -->
                <div>
                    <h5>광고</h5>
                    <!-- Google AdSense Test Ad -->
                    <script async
                        src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"
                        crossorigin="anonymous"></script>
                    <ins class="adsbygoogle"
                         style="display:block; text-align:center;"
                         data-ad-client="ca-pub-4911679130006261"
                         data-ad-slot="1234567890"
                         data-ad-format="auto"
                         data-full-width-responsive="true"></ins>
                    <script>
                        (adsbygoogle = window.adsbygoogle || []).push({});
                    </script>
                </div>
            </aside>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
