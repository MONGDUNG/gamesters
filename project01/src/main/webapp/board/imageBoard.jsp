<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<%
    String game = request.getParameter("game");
    String currentPageParam = request.getParameter("currentPage");
    if (game == null || game.isEmpty()) {
        out.println("게임 이름이 지정되지 않았습니다.");
        return;
    }

    int recordsPerPage = 30; // 한 페이지당 게시글 수
    int currentPage = (currentPageParam == null) ? 1 : Integer.parseInt(currentPageParam); // 현재 페이지
    int start = (currentPage - 1) * recordsPerPage + 1; // 시작 게시글 번호
    int end = currentPage * recordsPerPage; // 끝 게시글 번호

    BoardDAO boardDAO = new BoardDAO();
    List<BoardDTO> boardList = boardDAO.getImageAndTitleList(game, start, end);

    int totalRecords = boardDAO.getTotalCount(game);
    int noOfPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= game %> 이미지 게시판</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: 
#f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            background-color: 
#fff;
            padding: 20px;
            box-shadow: 0 0 10px 
rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: 
#333;
        }
        .button-group {
            text-align: center;
            margin-bottom: 20px;
        }
        .button-group button {
            padding: 10px 20px;
            margin: 0 10px;
            border: none;
            background-color: 
#007bff;
            color: 
white;
            cursor: pointer;
            border-radius: 5px;
        }
        .button-group button:hover {
            background-color: 
#0056b3;
        }
        .album {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .album-item {
            width: 200px;
            border: 1px solid 
#ddd;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 0 10px 
rgba(0, 0, 0, 0.1);
        }
        .album-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        .album-item .title {
            padding: 10px;
            text-align: center;
            background-color: 
#f2f2f2;
        }
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination a {
            margin: 0 5px;
            padding: 10px 15px;
            text-decoration: none;
            color: 
#007bff;
            border: 1px solid 
#ddd;
            border-radius: 5px;
        }
        .pagination a:hover {
            background-color: 
#f2f2f2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1><%= game %> 이미지 게시판</h1>
        <div class="button-group">
            <button onclick="location.href='writeForm.jsp?game=<%= game %>&type=image'">포스팅하기</button>
            <button onclick="location.href='../member/main.jsp'">메인</button>
        </div>
        <div class="album">
            <% for (BoardDTO board : boardList) { %>
            	<a href="viewBoard.jsp?game=<%= game %>&num=<%= board.getBoardnum() %>&type=image">
	                <div class="album-item">
	                    <img src="<%= board.getContent() %>" alt="Image">
	                    <div class="title"><%= board.getTitle() %></div>
	                </div>
	            </a>
            <% } %>
        </div>
        <div class="pagination">
            <% for (int i = 1; i <= noOfPages; i++) { %>
                <a href="imageBoard.jsp?game=<%= game %>&currentPage=<%= i %>"><%= i %></a>
            <% } %>
        </div>
    </div>
</body>
</html>