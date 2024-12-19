<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	
	<jsp:useBean id="dto"  class="project01.member.bean.MemberDTO" />
	<jsp:useBean id="dao"  class="project01.member.bean.MemberDAO" />
<%
    // 데이터베이스 연결 가져오기
   	String password = request.getParameter("password");
	String nick =(String)session.getAttribute("nick");
    boolean isPasswordCorrect = dao.checkPs(nick, password);

    if (isPasswordCorrect) {
 		response.sendRedirect("modifyForm.jsp");
} else { %>
    <script>
        alert("비밀번호가 잘못되었습니다.");
        history.go(-1);
    </script>  
<%} %>   