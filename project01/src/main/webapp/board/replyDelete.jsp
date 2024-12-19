<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.ReplyDAO"%>
<%@ page import="project01.board.bean.ReplyDTO"%>

<%
	
    String game = request.getParameter("game");
	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
    ReplyDTO dto = new ReplyDTO();
    dto.setBoardnum(boardnum);
    ReplyDAO dao = new ReplyDAO();
    String type = request.getParameter("type");
    System.out.println(type);
    int is_image = 0;
    if(type.equals("image")){
    	is_image = 1;
    }
    dto.setIs_image(is_image);
    int num = Integer.parseInt(request.getParameter("num"));
    
    dao.replyDelete(num,game,dto);
%>
    <script>
    location.href="viewBoard.jsp?num=<%=boardnum%>&game=<%=game%>&type=<%=type%>";
    </script>