<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO"%>

<%
	
    String game = request.getParameter("game");
    String nick = (String)session.getAttribute("nick");
    String contentNick = request.getParameter("nick");
    String type = request.getParameter("type");
    BoardDAO dao = new BoardDAO();
    int num = Integer.parseInt(request.getParameter("num"));
    if(nick == null){
    	%>
<script>
	alert("로그인이 필요한 기능입니다.");
	history.back();
</script>
<%}else{
	int admin = (int)session.getAttribute("admin");

    if(admin == 1){
    	dao.boardDelete(num, game, type);
    	%>
<script>
    	alert("삭제되었습니다.");
    	history.back();
    	</script>
    	<%
    	if(type.equals("normal")){
    		response.sendRedirect("board.jsp?game="+game);
    	}else{
    		response.sendRedirect("imageBoard.jsp?game="+game);
    	}
	}else if(admin == 0 && nick == contentNick){
	    dao.boardDelete(num, game, type);
	    %>
    	<script>
    	alert("삭제되었습니다.");
    	history.back();
    	</script>
    	<%
    	if(type.equals("normal")){
    		response.sendRedirect("board.jsp?game="+game);
    	}else{
    		response.sendRedirect("imageBoard.jsp?game="+game);
    	}
    }else{
    	%>
    <script>
    	alert("권한이 없습니다.");
    	history.back();
    </script>
    	<%
    	}}
    	%>