
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO"%>
<%@ page import="project01.board.bean.BoardDTO"%>
<%@ page import="project01.board.bean.ReplyDTO" %>
<%@ page import="project01.board.bean.ReplyDAO" %>
<%@ page import="java.util.List"%>
<jsp:include page="../header.jsp" />
<%
request.setCharacterEncoding("utf-8");
    int num = Integer.parseInt(request.getParameter("num"));
    String game = request.getParameter("game");
    String nick = (String)session.getAttribute("nick");
    String type = request.getParameter("type");
    BoardDAO dao = new BoardDAO();
    BoardDTO dto = dao.readNum(num, game, type);
    ReplyDAO rdao = new ReplyDAO();
    int isAdmin = session.getAttribute("admin") != null ? (int)session.getAttribute("admin") : 0;
    int order_col = dao.order_colSearch(num, game);
	int is_image = 0;
	if (type.equals("image")){
		is_image = 1;
	}
	
	
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><a href="board.jsp?game=<%= game %>"><%= game %> 포럼</a></title>
    <style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }
    .container {
        width: 80%;
        margin: 0 auto;
        background-color: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1 {
        text-align: center;
        color: #333;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }
    table, th, td {
        border: 1px solid #ddd;
    }
    th, td {
        padding: 10px;
    }
    th {
        background-color: #f2f2f2;
    }
    .vote-section {
        text-align: center;
        margin: 20px 0;
    }
    .vote-btn {
        display: inline-block;
        margin: 0 10px;
        padding: 10px 20px;
        text-decoration: none;
        color: white;
        border-radius: 5px;
    }
    .upvote-btn {
        background-color: green;
    }
    .downvote-btn {
        background-color: red;
    }
    .center-align {
        text-align: center;
        margin-top: 20px;
    }
    .center-align a {
        margin: 0 10px;
        padding: 10px 20px;
        text-decoration: none;
        color: white;
        background-color: #007bff;
        border-radius: 5px;
    }
    .center-align a:hover {
        background-color: #0056b3;
    }
    .reply-container {
        background: #e9ecef;
        margin: 10px 0;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .reply-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }
    .reply-main {
        display: flex;
        flex-direction: column;
    }
    .reply-author-content {
        font-size: 1.1em;
        font-weight: bold;
        margin-bottom: 5px;
    }
    .reply-date {
        font-size: 0.9em;
        color: #777;
    }
    .reply-button-container {
        margin-top: 10px;
        display: flex;
        gap: 10px;
    }
    .reply-button-container button {
        background: #007bff;
        color: white;
        border: none;
        cursor: pointer;
        padding: 5px 15px;
        border-radius: 5px;
        transition: background 0.3s;
    }
    .reply-button-container button:hover {
        background: #0056b3;
    }
    .child-reply {
        margin-top: 10px;
        padding: 10px;
        background: #f8f9fa;
        border: 1px solid #ddd;
        border-radius: 5px;
    }
    .child-reply-date {
        font-size: 0.8em;
        color: #888;
        margin-left: 10px;
    }
    .reply-form {
        margin-top: 15px;
    }
    .reply-form textarea {
        width: 100%;
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        resize: none;
    }
    .reply-form input[type="submit"] {
        background: #28a745;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
        transition: background 0.3s;
    }
    .reply-form input[type="submit"]:hover {
        background: #218838;
    }
    .reactions {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        margin-top: 5px;
        font-size: 0.9em;
        color: #555;
    }
    .reactions span {
        margin-left: 10px;
    }
    .content-cell img {
        max-width: 100%;
        height: auto;
    }
    .reply-content {
        display: none; /* 답글 초기 상태를 닫힘으로 설정 */
    }
    .content-cell {
	    height: 300px; /* 고정된 높이 */
	    min-height: 300px; /* 최소 높이 설정 */
	    padding: 20px;
	    border-radius: 10px;
	    align-items: center; /* 세로 중앙 정렬 */
	    justify-content: center; /* 가로 중앙 정렬 (선택 사항) */
	    box-sizing: border-box; /* 패딩 포함 높이 계산 */
	}
</style>
</head>
<body>
    <div class="container">
        <h1><a href="board.jsp?game=<%= game %>"><%= game %> 포럼</a></h1>
        <table>
            <tr>
                <th>번호</th>
                <td><%=dto.getBoardnum()%></td>
                <th>작성자</th>
                <td>
                    <a href="#" onclick="openProfile('<%=dto.getNickname()%>'); return false;">
                        <%=dto.getNickname()%>
                    </a>
                </td>
            </tr>
            <tr>
                <th>작성일</th>
                <td><%=dto.getReg()%></td>
                <th>조회수</th>
                <td><%=dto.getReadcount()%></td>
            </tr>
            <tr>
                <th>제목</th>
                <td colspan="3"><%=dto.getTitle()%></td>
            </tr>
            <tr>
                <th>내용</th>
                <td colspan="3" class="content-cell"><%=dto.getContent()%></td>
            </tr>
        </table>

        <%
	        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
	        int pageSize = 10; // Number of comments per page
	        int start = (currentPage - 1) * pageSize + 1;
	        int end = currentPage * pageSize;
			int boardNum = num;
	        List<ReplyDTO> replyList = rdao.replyAll(boardNum, game, is_image, start, end);
	        int totalReplies = rdao.getTotalReplies(boardNum, game, is_image); // Implement this method to get total replies count
	        int totalPages = (int) Math.ceil((double) totalReplies / pageSize);

        %>
        <div>
		    <h1>댓글 리스트</h1>
		    <% for (ReplyDTO reply : replyList) {
		        if (reply.getParent_id() == 0) { %>
		        <div class="reply-container">
		            <div class="reply-header">
		                <div class="reply-main">
		                    <div class="reply-author-content">
		                        <strong><%= reply.getNickname() %></strong>: <%= reply.getRep_content() %>
		                    </div>
		                    <div class="reply-date">
		                        <%= reply.getRep_reg() %>
		                    </div>
		                    <div class="reply-button-container">
		                        <button onclick="toggleReply('<%= reply.getNum() %>')">
		                            답글 <%=rdao.getReReplyCount(reply.getNum()) %>
		                        </button>
		                        <button onclick="openReportPopup('<%= num %>', '<%= reply.getNum() %>', '<%= game %>', 'reply', '<%=type%>')">신고</button>
		                        <% if (isAdmin == 1 || (nick != null && nick.equals(reply.getNickname()))) { %>
		                            <button onclick="location.href='replyDelete.jsp?num=<%= reply.getNum() %>&game=<%= game %>&boardnum=<%= reply.getBoardnum()%>&nick=<%= reply.getNickname() %>&type=<%=type%>'">삭제</button>
		                        <% } %>
		                    </div>
		                </div>
		            </div>
		            <div id="reply-content-<%= reply.getNum() %>" class="reply-content">
		                <% for (ReplyDTO childReply : replyList) {
		                    if (childReply.getParent_id() == reply.getNum()) { %>
		                        <div class="child-reply">
		                            <strong><%= childReply.getNickname() %></strong>: <%= childReply.getRep_content() %>
		                            <span class="child-reply-date">(작성일: <%= childReply.getRep_reg() %>)</span>
		                            <button onclick="openReportPopup('<%= num %>', '<%= childReply.getNum() %>', '<%= game %>', 'reply', '<%=type%>')">신고</button>
		                            <% if (isAdmin == 1 || (nick != null && nick.equals(childReply.getNickname()))) { %>
		                                <button onclick="location.href='replyDelete.jsp?num=<%=childReply.getNum() %>&game=<%= game %>&boardnum=<%= childReply.getBoardnum()%>&nick=<%= childReply.getNickname() %>&type=<%=type%>'">삭제</button>
		                            <% } %>
		                        </div>
		                <% }} %>
		                <form action="postReply.jsp" method="post" class="reply-form">
		                    <input type="hidden" name="boardnum" value="<%= boardNum %>">
		                    <input type="hidden" name="num" value="<%= reply.getNum() %>">
		                    <input type="hidden" name="game" value="<%= game %>">
		                    <input type="hidden" name="type" value="<%= type %>">
		                    <textarea name="content" rows="2" cols="50"></textarea>
		                    <input type="hidden" name="writer" value="<%= nick %>">
		                    <input type="submit" value="답글 등록">
		                </form>
		            </div>
		        </div>
		    <% }} %>
		</div>

<div class="pagination">
    <% for (int i = 1; i <= totalPages; i++) { %>
        <a href="viewBoard.jsp?num=<%= boardNum %>&game=<%= game %>&type=<%= type %>&page=<%= i %>"><%= i %></a>
    <% } %>
    </div>
        <script>
            // 댓글 펼치기/접기 토글 함수
            function toggleReply(replyNum) {
                const replyContent = document.getElementById('reply-content-' + replyNum);
                if (replyContent.style.display === 'none' || replyContent.style.display === '') {
                    replyContent.style.display = 'block';
                } else {
                    replyContent.style.display = 'none';
                }
            }

            function openProfile(nick) {
                const url = '../member/profile.jsp?nick=' + nick;
                const options = 'width=600,height=400,scrollbars=no,resizable=no';
                window.open(url, 'profileWindow', options);
            }

            function openReportPopup(boardNum, replyNum, game, reportType, type) {
                const url = 'report.jsp?num=' + boardNum + '&rep_num=' + replyNum + '&game=' + game + '&reportType=' + reportType + '&type=' + type;
                const options = 'width=600,height=400,scrollbars=yes,resizable=no';
                window.open(url, 'reportWindow', options);
            }
        </script>
        <% if (nick != null) { %>
		    <div class="reply-form">
		        <h5 class="mb-3">댓글 작성</h5>
		        <form action="replyPro.jsp" method="post">
		            <input type="hidden" name="boardnum" value="<%= num %>"/>
		            <input type="hidden" name="game" value="<%= game %>"/>
		            <input type="hidden" name="type" value="<%= type %>"/>
		            <input type="hidden" name="writer" value="<%= nick %>"/>
		            <div class="mb-3">
		                <textarea class="reply-textarea" 
		                          rows="3" 
		                          name="content" 
		                          placeholder="댓글을 입력해주세요..."
		                          required></textarea>
		            </div>
		            <div class="text-end">
		                <button type="submit" class="reply-submit">댓글 등록</button>
		            </div>
		        </form>
		    </div>
		<% } %>
        <!-- Voting Section -->
        <div class="vote-section">
            <button class="vote-btn upvote-btn" onclick="vote('UP')">
                추천 (<span id="upvote-count"><%=dto.getUpcnt()%></span>)
            </button>
            <button class="vote-btn downvote-btn" onclick="vote('DOWN')">
                비추천 (<span id="downvote-count"><%=dto.getDwncnt()%></span>)
            </button>
        </div>
        <script>
      function vote(voteType) {
          const nick = '<%= nick %>';
          if (nick === null || nick === '') {
              alert("로그인이 필요한 기능입니다.");
              return;
          }
          const xhr = new XMLHttpRequest();
          xhr.open("POST", "vote.jsp", true);
          xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
          xhr.onreadystatechange = function() {
              if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                  const response = JSON.parse(xhr.responseText);
                  if (response.success) {
                      document.getElementById('upvote-count').innerText = response.upvoteCount;
                      document.getElementById('downvote-count').innerText = response.downvoteCount;
                  } else {
                      alert(response.message || "추천/비추천 처리 중 오류가 발생했습니다.");
                  }
              }
          };

          // voteType이 null이 아닌지 확인 후 데이터 전송
          xhr.send('num=' + encodeURIComponent(<%=dto.getBoardnum()%>) +
                  '&game=' + encodeURIComponent('<%=game%>') +
                  '&vote=' + encodeURIComponent(voteType) +
                  '&nick=' + encodeURIComponent(nick) +
                  '&type=' + encodeURIComponent('<%=type%>') +
                  '&content_nick=' + encodeURIComponent('<%=dto.getNickname()%>'));
      }
  </script>
        <div class="center-align">
            <%
			    String href = "imageBoard.jsp?game=" + game; // 기본값 설정
			    if (type.equals("normal")) {
			        href = "board.jsp?game=" + game;
			    }
			%>
			<a href="<%= href %>">목록</a>
            <a href="updateForm.jsp?num=<%= num%>&game=<%= game %>&type=<%=type%>">게시글 수정</a>
            <a href="#" class="delete-btn" onclick="deletePost()">게시글 삭제</a>
            <a href="#" class="report-btn" onclick="openReportPopup('<%=num%>', null, '<%=game%>', 'board', '<%=type%>')">신고</a>
            <% if(isAdmin == 1) {                                   
                if(order_col == 0){%>
                   <a href="moveOrder.jsp?game=<%= game %>&action=up&boardnum=<%= num %>" >상단고정</a>
                <% } else if(order_col == 1) {%>
                   <a href="moveOrder.jsp?game=<%= game %>&action=down&boardnum=<%= num %>" >상단고정 취소</a>
                <% } %>
            <% } %>
            
        </div>
        <script>
            function deletePost(boardnum, game) {
                if (confirm("정말 이 게시글을 삭제하시겠습니까?")) {
                    location.href = `deleteForm.jsp?num=<%=dto.getBoardnum()%>&game=<%=game %>&nick=<%= dto.getNickname()%>&type=<%=type%>`;
                }
            }


        </script>
    </div>
</body>
</html>
