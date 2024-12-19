<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.board.bean.BoardDAO" %>
<%@ page import="project01.board.bean.BoardDTO" %>
<%@ page import="project01.member.bean.MemberDAO" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%
//제대로 utf-8환경이 아니라 한글 깨짐 그래서 임의로 추가
 request.setCharacterEncoding("utf-8");

 String title = (String)request.getParameter("title");
 String nick = (String)session.getAttribute("nick");
 String content = request.getParameter("content");
 String game = (String)request.getParameter("game");
 int fileCount = 0;
//Count the number of image tags in the content
	Pattern imgPattern = Pattern.compile("<img\\s+[^>]*src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>");
	Matcher imgMatcher = imgPattern.matcher(content);
	while (imgMatcher.find()) {
	  fileCount++;
}

 BoardDAO dao = new BoardDAO();
 BoardDTO dto = new BoardDTO();
 MemberDAO mdao = new MemberDAO();
 dto.setGameName(game);
 dto.setTitle(title);
 dto.setNickname(nick);
 dto.setContent(content);
 dto.setFilecount(fileCount);
	String noPlaster = dao.noPlaster(nick, game);	//가장 최근에 쓴 게시글의 시각 구하기
	boolean writing = true;			//  아무것도 걸리지 않고 true로 넘어가면 글쓰기 등록 가능
	if(noPlaster != null){			// 만일 이전에 아무것도 쓰지 않았다면 true로 넘어갈 것임
		String a [] = noPlaster.split(" ");		//배열을 쓰고 쪼개는 이유: 받아온 시간이 String이므로 시간계산이 불가능. 2024-12-10 11:22:33 으로 나오기 때문에 하나하나 쪼갠 후, 인트로 변환해야 함.
		String b[] = a[0].split("-");
		String c[] = a[1].split(":");
		
		int year = Integer.parseInt(b[0]) - 1900;	// java.util.Date의 Date 객체에 넣어야 하는데, year는 1900년부터 시작하기 때문에 -1900을 해주지 않으면 현재 연도가 나오지 않는다.
		int month = Integer.parseInt(b[1])-1;		// month는 0이 1월, 1이 2월,... 11이 12월이므로 -1을 해주어야 한다.
		int day = Integer.parseInt(b[2]);
		int hour = Integer.parseInt(c[0]);
		int minute = Integer.parseInt(c[1]);
		int second = Integer.parseInt(c[2]);
		
		
		Date lastPost = new Date(year, month, day, hour, minute, second);	//Date에 매개변수(최근에 쓴 글 시각)를 넣어서 객체 생성
		Calendar cal = Calendar.getInstance();		//Calender의 생성자에는 protected가 걸려있어서, getInstance()메서드를 사용해야 한다.
		cal.setTime(lastPost);		//Calendar에 Date값을 넣기
		long w = cal.getTimeInMillis();	//최근에 쓴 글 시각
		long x = System.currentTimeMillis();	//현재 시각
		
		if((x-w) < 20000){	//1000분의 1초이므로, 20초로 제한을 걸려면 20000을 기준으로 잡아야 한다.
			writing = false;	//20초 미만일 경우 false
		}
		
	}
	boolean isImage = false;
	if(fileCount > 0) {
		isImage = true;
	}
	if (writing && isImage) { //boolean writing을 받아서, true면 작성한 내용을 등록
		try {
			dao.imageBoardInsert(dto);
			mdao.increaseExperience(nick, 1);
			response.sendRedirect("imageBoard.jsp?game=" + game);
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
	}else if(writing && !isImage){
		System.out.println(fileCount);
		%>
		<script>
			alert("이미지를 첨부해주세요.");
			window.history.back();
		</script>
		<% }
	else{		//false면 안내창 뜨면서 페이지 뒤로 이동
		 %>
	     <script>
	         alert("20초 후에 가능합니다.");
	         window.history.back();
	     </script>
	<%
	}
 %>