<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="dao" class="project01.member.bean.MemberDAO" />
<!DOCTYPE html>



<% String id = request.getParameter("id");
	boolean isDuplicate = dao.isIdDuplicate(id);
	if(isDuplicate){
		%>현재 사용중인 id 입니다.<%
	}else{
		%>
		사용할 수 있는 id 입니다.
		<%
	}
%>

<button type="button" onclick="window.close()">닫기</button>