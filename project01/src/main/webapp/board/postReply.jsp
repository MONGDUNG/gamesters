<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<%
    String nick = (String) session.getAttribute("nick");
    if (nick == null) {
        out.println("<script>alert('세션이 만료되었습니다. 로그인해주세요.'); location.href='../member/main.jsp';</script>");
    } else {
%>
<jsp:useBean id="dao" class="project01.board.bean.ReplyDAO"/>
<jsp:useBean id="dto" class="project01.board.bean.ReplyDTO"/>
<jsp:setProperty property="*" name="dto" />
<%
request.setCharacterEncoding("UTF-8");
    String boardnum = request.getParameter("boardnum");
    String content = request.getParameter("content");
    String writer = request.getParameter("writer");
    String game = request.getParameter("game");
    String type = request.getParameter("type");
    int parentId = Integer.parseInt(request.getParameter("num"));
    dto.setBoardnum(Integer.parseInt(boardnum));
    dto.setRep_content(content);
    dto.setNickname(writer);
    dto.setGame(game);
    dto.setParent_id(parentId);
	int is_image = 0;
	if (type.equals("image"))
		is_image = 1;
	dto.setIs_image(is_image);
	dao.reReplyInsert(dto, parentId);
	MemberDAO mdao = new MemberDAO();
	mdao.increaseExperience(writer, 2);
%>
<script>
    location.href="viewBoard.jsp?num=<%=boardnum%>&game=<%=game%>&type=<%=type%>";
</script>
<%
    }
%>