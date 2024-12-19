<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="dao" class="project01.member.bean.MemberDAO" />
<jsp:useBean id="dto" class="project01.member.bean.MemberDTO" />

<%
	String pw = request.getParameter("pw");				
	dto.setPw(pw);

	//아이디 비밀번호 파라미터 받아서 저장
	String nick = (String)session.getAttribute("nick");
	
	boolean result = dao.checkPs(nick, pw);	// 아이디와 비밀번호 확인
	
	System.out.println(result);
	
	if(result){		// 아이디와 비밀번호가 일치할 경우
		int success = dao.memberDelete(nick);
		if(success > 0){%>		<%--계정 탈퇴시 오류 확인--%>
			<script>
				alert("정상적으로 탈퇴되었습니다.");
				<% session.invalidate(); %>		<%--세션 삭제--%>
				window.location = "main.jsp";	<%--회원탈퇴 후, 메인으로 이동--%>
			</script>
		<%}else{%>
			<script>
				alert("비정상적인 작동이 감지되었습니다. 관리자에게 문의하세요."); <%--오류가 있을 경우 작동--%>
				window.location = "main.jsp";
			</script>			
		<%}
	}else{%>	<%-- 아이디와 비밀번호가 일치하지 않을 경우 --%>
		<script>
			alert("아이디와 비밀번호가 일치하지 않습니다. 다시 한번 확인해주세요.");
			window.location = "withdrawForm.jsp";
		</script>
	<%}%>