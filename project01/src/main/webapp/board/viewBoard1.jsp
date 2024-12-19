<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO"%>
<%@ page import="project01.board.bean.BoardDTO"%>
<%@ page import="project01.board.bean.ReplyDTO" %>
<%@ page import="project01.board.bean.ReplyDAO" %>
<%@ page import="java.util.List"%>

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
	if (type.equals("image"))
		is_image = 1;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= game %> 포럼</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
        }
        .post-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border: 1px solid #e9ecef;
        }
        .post-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 15px;
        }
        .post-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #6c757d;
            font-size: 0.95rem;
        }
        .post-content {
            padding: 25px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 30px;
            min-height: 200px;
            line-height: 1.6;
        }
        .vote-section {
            text-align: center;
            margin: 30px 0;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        .vote-btn {
            padding: 10px 25px;
            margin: 0 10px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
            font-size: 1rem;
        }
        .upvote-btn {
            background-color: #198754;
            color: white;
        }
        .downvote-btn {
            background-color: #dc3545;
            color: white;
        }
        .vote-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
                .reply-section {
            margin-top: 40px;
        }
        .reply-form {
            background-color: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 1px solid #e9ecef;
        }
        .reply-textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            resize: vertical;
            min-height: 120px;
            margin-bottom: 15px;
            font-size: 0.95rem;
            transition: border-color 0.3s ease;
        }
        .reply-textarea:focus {
            outline: none;
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        .reply-submit {
            background-color: #0d6efd;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 25px;
            cursor: pointer;
            float: right;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .reply-submit:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
        }
        .reply-container {
            background-color: #fff;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 20px;
            transition: transform 0.2s ease;
        }
        .reply-container:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        .reply-content {
            padding: 10px 0;
            line-height: 1.6;
            color: #333;
        }
        .action-buttons {
            margin-top: 30px;
            text-align: center;
            padding: 20px 0;
            border-top: 1px solid #dee2e6;
        }
        .action-buttons a {
            display: inline-block;
            padding: 10px 20px;
            margin: 0 8px;
            text-decoration: none;
            border-radius: 25px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .action-buttons a:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .re-reply-form {
            margin-left: 40px;
            margin-top: 15px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #0d6efd;
        }
        .reply-actions {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }
        .reply-button {
            padding: 5px 15px;
            border: 1px solid #dee2e6;
            border-radius: 20px;
            background-color: #fff;
            color: #6c757d;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .reply-button:hover {
            background-color: #f8f9fa;
            color: #0d6efd;
            border-color: #0d6efd;
        }
        .image-content {
            max-width: 100%;
            margin: 20px 0;
            text-align: center;
        }
        .image-content img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="post-header">
            <h1 class="post-title"><%= dto.getTitle() %></h1>
            <div class="post-info">
                <div>
                    <i class="fas fa-user"></i> <%= dto.getNickname() %>
                    <span class="mx-2">|</span>
                    <i class="far fa-clock"></i> <%= dto.getReg() %>
                    <span class="mx-2">|</span>
                    <i class="fas fa-eye"></i> 조회 <%= dto.getReadcount() %>
                </div>
                <% if(order_col == 1) { %>
                    <span class="badge bg-primary">상단고정</span>
                <% } %>
            </div>
        </div>

        <div class="post-content">
            <% if(is_image == 1) { %>
                <div class="image-content">
                    <img src="../uploadedFiles/<%= dto.getContent() %>" alt="게시글 이미지">
                </div>
            <% } else { %>
                <%= dto.getContent() %>
            <% } %>
        </div>

        <!-- 댓글 섹션 -->
        <div class="reply-section">
            <h4 class="mb-4"><i class="far fa-comments"></i> 댓글</h4>
            
            <% if (nick != null) { %>
                <div class="reply-form">
                    <form action="replyPro.jsp" method="post">
                        <input type="hidden" name="boardnum" value="<%= num %>"/>
                        <input type="hidden" name="game" value="<%= game %>"/>
                        <input type="hidden" name="type" value="<%= type %>"/>
                        <input type="hidden" name="writer" value="<%= nick %>"/>
                        <textarea class="reply-textarea" 
                                name="content" 
                                placeholder="댓글을 입력해주세요..."
                                required></textarea>
                        <button type="submit" class="reply-submit">
                            <i class="fas fa-paper-plane"></i> 댓글 등록
                        </button>
                        <div class="clearfix"></div>
                    </form>
                </div>
            <% } else { %>
                <div class="alert alert-warning text-center">
                    <i class="fas fa-exclamation-circle"></i>
                    댓글을 작성하려면 로그인이 필요합니다.
                </div>
            <% } %>
			<%
            String currentUserNick = (String)session.getAttribute("nick");
            int boardNum = Integer.parseInt(request.getParameter("num"));
            // 댓글 리스트 가져오기
            ReplyDAO replyDAO = new ReplyDAO();
            List<ReplyDTO> replyList = replyDAO.replyAll(boardNum, game, is_image);
        %>
            <!-- 기존 댓글 표시 -->
            <div>
            <h1>댓글 리스트</h1>
            <% for (ReplyDTO reply : replyList) {
                if (reply.getParent_id() == 0) { %> <!-- 최상위 댓글만 표시 -->
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
                                <button onclick="openReportPopup('<%= num %>', '<%= reply.getNum() %>', '<%= game %>', 'reply', '<%=type%>)">신고</button>
   
                                  <%

					                if (isAdmin == 1 || (nick != null && nick.equals(reply.getNickname()))) {
					            %>
					                <button onclick="location.href='replyDelete.jsp?num=<%= reply.getNum() %>&game=<%= game %>&boardnum=<%= reply.getBoardnum()%>&nick=<%= reply.getNickname() %>'">삭제</button>
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
								        <button onclick="location.href='replyDelete.jsp?num=<%=childReply.getNum() %>&game=<%= game %>&boardnum=<%= childReply.getBoardnum()%>&nick=<%= childReply.getNickname() %>'">삭제</button>
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
        </div>
                <!-- 투표 섹션 -->
        <div class="vote-section">
            <button class="vote-btn upvote-btn" onclick="vote('UP')">
                <i class="fas fa-thumbs-up"></i> 추천 
                <span id="upvote-count" class="badge bg-light text-dark"><%= dto.getUpcnt() %></span>
            </button>
            <button class="vote-btn downvote-btn" onclick="vote('DOWN')">
                <i class="fas fa-thumbs-down"></i> 비추천 
                <span id="downvote-count" class="badge bg-light text-dark"><%= dto.getDwncnt() %></span>
            </button>
        </div>

        <!-- 작업 버튼들 -->
        <div class="action-buttons">
            <a href="<%= type.equals("normal") ? "board.jsp?game=" + game : "imageBoard.jsp?game=" + game %>" 
               class="btn btn-secondary">
                <i class="fas fa-list"></i> 목록
            </a>
            <% if (nick != null && (nick.equals(dto.getNickname()) || isAdmin == 1)) { %>
                <a href="updateForm.jsp?num=<%= num %>&game=<%= game %>&type=<%= type %>" 
                   class="btn btn-primary">
                    <i class="fas fa-edit"></i> 수정
                </a>
                <a href="#" onclick="deletePost()" class="btn btn-danger">
                    <i class="fas fa-trash-alt"></i> 삭제
                </a>
            <% } %>
            <% if (nick != null) { %>
                <a href="#" onclick="openReportPopup('<%= num %>', null, '<%= game %>', 'board', '<%= type %>')" 
                   class="btn btn-warning">
                    <i class="fas fa-flag"></i> 신고
                </a>
            <% } %>
            <% if(isAdmin == 1) { 
                if(order_col == 0) { %>
                    <a href="moveOrder.jsp?game=<%= game %>&action=up&boardnum=<%= num %>" 
                       class="btn btn-info">
                        <i class="fas fa-thumbtack"></i> 상단고정
                    </a>
                <% } else { %>
                    <a href="moveOrder.jsp?game=<%= game %>&action=down&boardnum=<%= num %>" 
                       class="btn btn-info">
                        <i class="fas fa-thumbtack fa-rotate-90"></i> 상단고정 취소
                    </a>
                <% } 
            } %>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- 기존 스크립트들 -->
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
                        
                        // 투표 성공 시 시각적 피드백
                        const btn = voteType === 'UP' ? 
                            document.querySelector('.upvote-btn') : 
                            document.querySelector('.downvote-btn');
                        btn.classList.add('voted');
                        setTimeout(() => btn.classList.remove('voted'), 1000);
                    } else {
                        alert(response.message || "추천/비추천 처리 중 오류가 발생했습니다.");
                    }
                }
            };
            xhr.send('num=' + encodeURIComponent(<%=dto.getBoardnum()%>) +
                    '&game=' + encodeURIComponent('<%=game%>') +
                    '&vote=' + encodeURIComponent(voteType) +
                    '&nick=' + encodeURIComponent(nick) +
                    '&type=' + encodeURIComponent('<%=type%>') +
                    '&content_nick=' + encodeURIComponent('<%=dto.getNickname()%>'));
        }

        function deletePost() {
            if (confirm("정말 이 게시글을 삭제하시겠습니까?")) {
                location.href = `deleteForm.jsp?num=<%=dto.getBoardnum()%>&game=<%=game%>&nick=<%=dto.getNickname()%>&type=<%=type%>`;
            }
        }

        function openReportPopup(boardNum, replyNum, game, reportType, type) {
            const url = 'report.jsp?num=' + boardNum + 
                       '&rep_num=' + replyNum + 
                       '&game=' + game + 
                       '&reportType=' + reportType + 
                       '&type=' + type;
            const options = 'width=600,height=400,scrollbars=yes,resizable=no';
            window.open(url, 'reportWindow', options);
        }

        function toggleReReplyForm(replyNum) {
            const form = document.getElementById('reReplyForm_' + replyNum);
            const allForms = document.querySelectorAll('[id^="reReplyForm_"]');
            
            // 다른 모든 답글 폼을 닫음
            allForms.forEach(f => {
                if (f.id !== 'reReplyForm_' + replyNum) {
                    f.style.display = 'none';
                }
            });
            
            // 선택된 폼을 토글
            form.style.display = form.style.display === 'none' ? 'block' : 'none';
        }
    </script>
</body>
</html>