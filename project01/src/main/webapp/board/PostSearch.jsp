<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<%@ page import="java.util.List" %>

<%
	String contextPath = request.getContextPath();
	String nick = (String) session.getAttribute("nick");
	String st = request.getParameter("searchType");
	String sk = request.getParameter("searchKeyword");
	
	BoardDAO dao = new BoardDAO();
	
	//페이지 나누기
		int pageSize = 10;
		String pageNum = request.getParameter("pageNum");	//null은 숫자로 바꾸지 못하니 String으로 받는다.
		//밑에 a태그에서 보내는 값을 pageNum으로 받는다.
		int currentPage = (pageNum == null) ? 1 : Integer.parseInt(pageNum);
		int start = (currentPage - 1) * pageSize + 1;
		int end = currentPage * pageSize;
		List<BoardDTO> searchList = dao.searchPost(nick, st, sk, start, end);
		int count = dao.searchCount(nick, st, sk);	//검색결과 전체 갯수
		
%>
<h2><%=nick%>님이 작성하신 글 목록</h2>
<table border = "1">
	<tr>
		<th>번호</th>
		<th>게임</th>
		<th>제목</th>
		<th>날짜</th>
	</tr>
	<%for(BoardDTO board : searchList) { //BoardDTO board로 바로 선언 가능%>
		<tr>
			<td><%=board.getBoardnum() %></td>
			<td><%=board.getGameName()%></td>
			<td>
				<a href="<%= contextPath %>/board/viewBoard.jsp?game=<%=board.getGameName()%>&num=<%=board.getBoardnum()%>">
					<%=board.getTitle()%>
				</a>
			</td>
			<td><%=board.getReg() %></td>	
		</tr>
	<%}%>
	
	<%--페이지 정리 --%>
	</table>
	<%if(count > 0){
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		int startPage = (currentPage / 10) * 10 + 1;
		int pageBlock = 10;			//하단 페이지에 페이지 버튼이 나타나는 갯수 설정
		int endPage = startPage + pageBlock - 1;
		if(endPage > pageCount){
			endPage = pageCount;
		}
		
		if(startPage > 10){%>
			<a href="PostSearch.jsp?searchType=<%=st%>&searchKeyword=<%=sk%>&pageNum=<%=startPage-10%>">[이전]</a>
		<%}
		for(int i = startPage ; i <= endPage ; i++){%>
			<a href="PostSearch.jsp?searchType=<%=st%>&searchKeyword=<%=sk%>&pageNum=<%=i%>">[<%=i%>]</a>
		<%}
		if(endPage < pageCount){%>
			<a href="PostSearch.jsp?searchType=<%=st%>&searchKeyword=<%=sk%>&pageNum=<%=startPage+10%>">[다음]</a>
		<%}%>
		
	<%}%>
	
	<%--검색 --%>
	<form action="PostSearch.jsp" method="get">
		<select name="searchType">	
			<option value="game">게임</option>
			<option value="title" >제목</option>
		</select>
		<input type="text" name="searchKeyword" placeholder="검색어 입력">
		<input type="submit" value="검색" />
	</form>
