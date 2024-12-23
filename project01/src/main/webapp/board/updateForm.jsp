
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO"%>
<%@ page import="project01.board.bean.BoardDTO"%>
<%@ page import="java.util.List"%>
<jsp:include page="../header.jsp" />
<%
 String ctx = request.getContextPath(); // 콘텍스트명 얻어오기
 int num = Integer.parseInt(request.getParameter("num"));
 String game = request.getParameter("game");
 String nick = (String) session.getAttribute("nick");
 String type = request.getParameter("type");
 BoardDAO dao = new BoardDAO();
 BoardDTO dto = dao.readNum(num, game, type);
 List<String> categoryList = new BoardDAO().getCategory(game);
 if (nick == null) {
%>
<script>
 alert("로그인이 필요한 기능입니다.");
 history.back();
</script>
<%
 } else {
 int admin = (int) session.getAttribute("admin");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="<%= ctx %>/SE2/js/HuskyEZCreator.js" charset="utf-8"></script>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }

        .container {
            margin-top: 50px;
            max-width: 800px;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 30px;
            border-radius: 8px;
        }

        .form-control {
            border-radius: 6px;
        }

        .form-group label {
            font-weight: bold;
        }

        #save {
            background-color: #007bff;
            color: white;
            border: none;
        }

        #cancel {
            background-color: #6c757d;
            color: white;
            border: none;
        }

        #save:hover {
            background-color: #0056b3;
        }

        #cancel:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center mb-4">게시글 수정</h2>
        <form id="frm" action="updatePro.jsp" method="post">
            <input type="hidden" name="game" value="<%= game %>" />
            <input type="hidden" name="num" value="<%= num %>" />
            <input type="hidden" name="type" value="<%= type %>" />
            <div class="form-group">
                <label for="writer">작성자</label>
                <input type="text" id="writer" name="writer" class="form-control" value="<%= nick %>" readonly />
            </div>
            <div class="form-group">
                <label for="category">카테고리</label>
                <select id="category" name="category" class="form-control">
                    <% for (String category : categoryList) { 
                        if (!"공지".equals(category) || admin == 1) { %>
                    <option value="<%= category %>"><%= category %></option>
                    <% }
                    } %>
                </select>
            </div>
            <div class="form-group">
                <label for="title">제목</label>
                <input type="text" id="title" name="title" class="form-control" value="<%= dto.getTitle() %>" />
            </div>
            <div class="form-group">
                <label for="content">내용</label>
                <textarea rows="10" cols="30" id="ir1" name="content" class="form-control" style="height: 350px;"><%= dto.getContent() %></textarea>
            </div>
            <div class="text-center">
                <button type="button" id="save" class="btn btn-primary btn-lg mr-3">저장</button>
                <button type="button" id="cancel" class="btn btn-secondary btn-lg">취소</button>
            </div>
        </form>
    </div>

    <script>
        var oEditors = [];
        $(function () {
            nhn.husky.EZCreator.createInIFrame({
                oAppRef: oEditors,
                elPlaceHolder: "ir1",
                sSkinURI: "/project01/SE2/SmartEditor2Skin.html",
                htParams: {
                    bUseToolbar: true,
                    bUseVerticalResizer: true,
                    bUseModeChanger: true,
                },
                fOnAppLoad: function () {
                    oEditors.getById["ir1"].exec("PASTE_HTML", [""]);
                },
                fCreator: "createSEditor2"
            });

            $("#save").click(function () {
                oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);

                var title = $("#title").val().trim();
                var content = $("#ir1").val().trim();

                if (title.length < 2) {
                    alert("제목은 최소 2글자 이상이어야 합니다.");
                    return;
                }

                if (content.length < 5 || content === "<p>&nbsp;</p>" || content === "") {
                    alert("내용은 최소 5글자 이상이어야 합니다.");
                    return;
                }

                $("#frm").submit();
            });

            $("#cancel").click(function () {
                window.location.href = "board.jsp?game=<%= game %>";
            });
        });
    </script>
</body>
</html>
<% } %>
