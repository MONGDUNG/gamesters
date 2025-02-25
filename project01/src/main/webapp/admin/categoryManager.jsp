<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="project01.board.bean.BoardDAO" %>
<jsp:include page="../header.jsp" />



<%
	Integer admin = (Integer) session.getAttribute("admin");
	if (admin == null || admin != 1) {
%>
<script type="text/javascript">
    alert("관리자만 접근 가능합니다.");
    window.location.href = "../member/main.jsp";
</script>
<%
    return;
}
    String game = request.getParameter("game");
%>
<h2>카테고리 목록</h2>
<%
    // 카테고리 목록
    BoardDAO dao = new BoardDAO();
    List<String> categoryList = dao.getCategory(game);
    for (String category : categoryList) {
%>
    <form action="deleteCategory.jsp" method="post" style="display:inline;">
        <%= category %>
        <input type="hidden" name="game" value="<%= game %>">
        <input type="hidden" name="category" value="<%= category %>">
        <button type="submit">삭제</button>
    </form>
    <br>
<% } %>
<a href="addCategory.jsp?game=<%= game %>">카테고리 추가</a>
<a href="../board/board.jsp?game=<%= game %>">나가기</a>