<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<jsp:include page="../header.jsp" />
<%
    String game = request.getParameter("game");
    String currentPageParam = request.getParameter("currentPage");
    String tab = request.getParameter("tab");
    String selectedCategory = request.getParameter("category");
    String searchType = request.getParameter("searchType");
    String searchWord = request.getParameter("searchWord");
    if (selectedCategory== null){
    	selectedCategory = "전체";
    }
    int admin = (request.getSession().getAttribute("admin") != null) ? (int) request.getSession().getAttribute("admin") : 0;

    if (game == null || game.isEmpty()) {
        out.println("게임 이름이 지정되지 않았습니다.");
        return;
    }

    int recordsPerPage = 30; // 한 페이지당 게시글 수
    int currentPage = (currentPageParam == null) ? 1 : Integer.parseInt(currentPageParam); // 현재 페이지
    int start = (currentPage - 1) * recordsPerPage + 1; // 시작 게시글 번호
    int end = currentPage * recordsPerPage; // 끝 게시글 번호

    BoardDAO boardDAO = new BoardDAO();
    List<BoardDTO> boardList1 = boardDAO.getBoardList1(game, start, end);
    List<BoardDTO> boardList;
    if ("topVoted".equals(tab)) {
        boardList = boardDAO.getTopVotedBoardList(game, start, end, "normal");
    } else if (selectedCategory == null || "전체".equals(selectedCategory)) {
        boardList = boardDAO.getBoardList(game, start, end, searchType, searchWord);
    } else {
        boardList = boardDAO.getCategoryBoardList(game, start, end, selectedCategory);
    }

    // 전체 게시글 수를 가져오는 메서드 (getTotalCount 필요)
    int totalRecords = boardDAO.getTotalCount(game, searchType, searchWord);
    int noOfPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

    List<String> categoryList = boardDAO.getCategory(game);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= game %> 포럼</title>
    <style>
        /* 공통 스타일 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        a {
            text-decoration: none;
            color: #333;
        }
        a:hover {
            color: #007bff;
        }

        /* 전체 레이아웃 */
        .container {
            display: flex;
            max-width: 1600px;
            margin: 0 auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }
        .sidebar {
            width: 10%;
            background-color: #f9f9f9;
            padding: 20px;
            border-right: 1px solid #ddd;
        }
        .content {
            width: 90%;
            padding: 15px;
        }

        /* 카테고리 스타일 */
        .category-title {
            text-align: center;
            font-size: 1.2em;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
        }
        .category-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .category-list li {
            margin-bottom: 10px;
        }
        .category-list a {
            display: block;
            padding: 10px 15px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            transition: background-color 0.3s, box-shadow 0.3s;
        }
        .category-list a:hover {
            background-color: #007bff;
            color: #fff;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
        }

        /* 버튼 스타일 */
        .button-group {
            text-align: center;
            margin-bottom: 20px;
        }
        .button-group button {
            padding: 10px 20px;
            margin: 0 10px;
            border: none;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .button-group button:hover {
            background-color: #0056b3;
        }

        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        tr:nth-child(even) {
            background-color: #fafafa;
        }
        tr:hover {
            background-color: #f1f1f1;
        }

        /* 페이징 스타일 */
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination a {
            margin: 0 5px;
            padding: 8px 12px;
            text-decoration: none;
            color: #007bff;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .pagination a:hover {
            background-color: #007bff;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 사이드바 -->
        <div class="sidebar">
            <div class="category-title">카테고리</div>
            <ul class="category-list">
                <li><a href="board.jsp?game=<%= game %>&category=전체">전체</a></li>
                <% for (String category : categoryList) { %>
                    <li><a href="board.jsp?game=<%= game %>&category=<%= category %>">
                        <%= category %> 게시판</a></li>
                <% } %>
            </ul>
        </div>

        <!-- 메인 콘텐츠 -->
        <div class="content">
            <h1><a href="board.jsp?game=<%= game %>"><%= game %> 포럼</a></h1>
            
            <!-- 버튼 그룹 -->
            <div class="button-group">
                <button onclick="location.href='writeForm.jsp?game=<%= game %>&type=normal'">글쓰기</button>
                <button onclick="location.href='../member/main.jsp'">메인</button>
                <button onclick="location.href='board.jsp?game=<%= game %>&tab=topVoted'">베스트게시글</button>
                <button onclick="location.href='imageBoard.jsp?game=<%= game %>'">이미지 포럼</button>
                <% if (admin == 1) { %>
                    <button onclick="location.href='../admin/categoryManager.jsp?game=<%= game %>'">카테고리 관리</button>
                <% } %>
            </div>

            <!-- 게시판 테이블 -->
            <table>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>댓글</th>
                    <th>추천수</th>
                    <th>조회수</th>
                </tr>
                <% for (BoardDTO board : boardList1) { %>
                    <tr>
                        <td><%= board.getBoardnum() %></td>
                        <td>
                            <a href="viewBoard.jsp?game=<%=game%>&num=<%=board.getBoardnum()%>&type=normal">
                                <%= board.getTitle() %>
                            </a>
                        </td>
                        <td><%= board.getNickname() %></td>
                        <td><%= board.getReg() %></td>
                        <td><%= board.getReplycount() %></td>
                        <td><%= board.getUpcnt() %></td>
                        <td><%= board.getReadcount() %></td>
                    </tr>
                <% } %>
                <% for (BoardDTO board : boardList) { %>
                <tr>
                    <td><%= board.getBoardnum() %></td>
                    <td><a href="viewBoard.jsp?game=<%=game%>&num=<%=board.getBoardnum()%>&type=normal">
                            <% if (board.getUpcnt() >= 10) { %>
                                <img src="../resources/image/best.png" alt="Best" style="vertical-align: middle;">
                            <% } %><%= board.getTitle()%><% if (board.getFilecount() > 0) { %>
                                <img src="../resources/image/photo.png" alt="Best" style="vertical-align: middle;">
                            <% } %>
                        </a></td>
                    <td><%= board.getNickname() %></td>
                    <td><%= board.getReg() %></td>
                    <td><%= board.getReplycount() %></td>
                    <td><%= board.getUpcnt() %></td>
                    <td><%= board.getReadcount() %></td>
                </tr>
                <% } %>
            </table>
            
            <form action="board.jsp" method="get" >
            	<input type="hidden" name="game" value="<%= game %>" />
            	<select name="searchType">
            		<option value="nickname">닉네임</option>
            		<option value="title">제목</option>
            		<option value="content">내용</option>
            	</select>
            	<input type="text" name="searchWord" placeholder="검색어를 입력하세요"/>
            	<button type="submit">검색</button>
            </form>
            

            <!-- 페이징 -->
            <div class="pagination">
                <% for (int i = 1; i <= noOfPages; i++) { 
                	if(searchType != null && searchWord != null){%>
                	
                	<a href="board.jsp?game=<%= game %>&currentPage=<%= i %>&category=<%= selectedCategory %>&searchType=<%= searchType %>&searchWord=<%= searchWord %>"><%= i %></a>
                	<% } else {%>
                    <a href="board.jsp?game=<%= game %>&currentPage=<%= i %>&tab=<%= tab %>&category=<%= selectedCategory %>"><%= i %></a>
                <% }} %>
            </div>
        </div>
    </div>
</body>
</html>