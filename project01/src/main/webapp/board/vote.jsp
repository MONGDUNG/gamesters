<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO"%>
<%@ page import="project01.board.bean.BoardDTO"%>
<%@ page import="project01.member.bean.MemberDAO"%>

<%
// JSON 응답을 설정
    response.setContentType("application/json; charset=UTF-8");

    // 세션에서 nick 값을 가져옴
    String nick = (String) session.getAttribute("nick");
    
    // 세션에서 nick 값 확인
    if (nick == null || nick.trim().isEmpty()) {
        out.print("{\"success\": false, \"message\": \"로그인이 필요한 기능입니다.\"}");
        return; // nick이 없으면 더 이상 진행하지 않음
    }

    // 파라미터 가져오기
    String game = request.getParameter("game");
    String vote = request.getParameter("vote");
    String type = request.getParameter("type");
    int num = Integer.parseInt(request.getParameter("num"));
	String content_nick = request.getParameter("content_nick");
    // DAO를 이용한 투표 처리
    BoardDAO dao = new BoardDAO();
    boolean success = dao.vote(num, nick, vote, game, type); // 투표 처리
    BoardDTO dto = dao.readNum(num, game, type); // 최신 데이터 가져오기
    
    // 추천 받은 글의 작성자에게 경험치 부여
    MemberDAO mdao = new MemberDAO();
    if (vote.equals("UP")) {
		mdao.increaseExperience(content_nick, 3);
	}
	// JSON 응답 생성
	if (success) {
		out.print("{\"success\": true, \"upvoteCount\": " + dto.getUpcnt() + ", \"downvoteCount\": " + dto.getDwncnt()
		+ "}");
	} else {
		out.print("{\"success\": false, \"message\": \"이미 추천/비추천 하셨습니다.\"}");
	}
%>