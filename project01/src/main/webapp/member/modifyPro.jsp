<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <% request.setCharacterEncoding("UTF-8"); %>
<h1>수정PRO</h1>
<jsp:useBean id="dto" class="project01.member.bean.MemberDTO" />
<jsp:useBean id="dao" class="project01.member.bean.MemberDAO" />
<jsp:setProperty name="dto" property="*" />
<%
	String nick = (String)session.getAttribute("nick");
	dto.setNickname(nick);
	
	int result = dao.memberUpdate(dto);
	if(result == 1){
%>		<script>
			alert("회원정보가 수정되었습니다.");
			window.location="myPage.jsp"
		</script>
<%} %>