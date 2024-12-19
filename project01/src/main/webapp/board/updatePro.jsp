<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<%@ page import="project01.member.bean.MemberDAO" %>

<%
//제대로 utf-8환경이 아니라 한글 깨짐 그래서 임의로 추가
 request.setCharacterEncoding("utf-8");

 String title = (String)request.getParameter("title");
 String nick = (String)session.getAttribute("nick");
 String content = request.getParameter("content");
 String game = (String)request.getParameter("game");
 String type = request.getParameter("type");
 int num = Integer.parseInt(request.getParameter("num"));
 String category = (String)request.getParameter("category");
 BoardDAO dao = new BoardDAO();
 BoardDTO dto = new BoardDTO();
 if(type.equals("normal")){
 title = title.replaceFirst("\\[.*?\\]", "");
 title = "["+category+"]"+title; 
 }
 dto.setTitle(title);
 dto.setNickname(nick);
 dto.setContent(content);
 dto.setBoardnum(num);
 dto.setGameName(game);
 dto.setCategory(category);
 try {
	 
     dao.boardUpdate(dto, type);
     if(type.equals("normal")){
		response.sendRedirect("board.jsp?game=" + game);
     }else{
    	response.sendRedirect("imageBoard.jsp?game=" + game);
     }
	
	} catch (RuntimeException e) {
		// 실제 예외 메시지 출력
		String errorMessage = e.getMessage() != null ? e.getMessage() : "금지어가 포함되어 작성할 수 없습니다.";
%>
     <script>
         alert('<%= errorMessage %>');
         window.history.back();
     </script>
<%
 }
 %>