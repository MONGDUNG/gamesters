<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<h1>loginPro</h1>

<jsp:useBean id="dto"  class="project01.member.bean.MemberDTO" />
<jsp:setProperty name="dto"  property="*" />
<jsp:useBean id="dao"  class="project01.member.bean.MemberDAO" />

<%
boolean result = dao.loginCheck(dto);
if(result){
	if(dto.getIs_banned() == 1){
		String unban_date = dto.getUnban_date();
		%>
			<script>
            alert("제재된 회원입니다. 해제 날짜 : <%= unban_date %>");
            history.go(-1);
            </script>
            <%
		
	}else{
    session.setAttribute("nick", dto.getNickname());
    session.setAttribute("admin", dto.getIsadmin());
    session.setAttribute("id", dto.getId());
    response.sendRedirect("main.jsp");
	}
} else { %>
    <script>
        alert("아이디 또는 비밀번호가 잘못되었습니다.");
        history.go(-1);
    </script>
<% }
%>

