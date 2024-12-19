<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "project01.report.bean.ReportDAO" %>

<%
	String nick = request.getParameter("nick");
	ReportDAO dao = new ReportDAO();
	
	dao.memberPanalty(nick);
%>

<script>
	alert("회원이 제재되었습니다.");
	self.close();
</script>