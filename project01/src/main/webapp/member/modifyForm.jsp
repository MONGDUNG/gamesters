<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <% request.setCharacterEncoding("UTF-8"); %>
<h1>>수정하기</h1>

<jsp:useBean id="dto" class="project01.member.bean.MemberDTO" />
<jsp:useBean id="dao" class="project01.member.bean.MemberDAO" />
<%
String nick = (String)session.getAttribute("nick");
dto = dao.memberId(nick);
%>

<form action="modifyPro.jsp" method="post">
id : <%=dto.getId()%> <br/>
nickname : <%=dto.getNickname() %><br/>
name : <input type="text" name="name" value="<%=dto.getName() %>" /> <br />
birth : <input type="date" name="birth" value="<%=dto.getBirth().split(" ")[0] %>" /> <br />
email : <input type="email" name="email" value="<%=dto.getEmail() %>"/><br/>
<input type="submit" value="수정완료"/>
</form>

