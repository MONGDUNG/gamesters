<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
	//제대로 utf-8환경이 아니라 한글 깨짐 그래서 임의로 추가
	request.setCharacterEncoding("utf-8");
	
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	
	//콘솔 출력
	System.out.println("제목:"+title);
	System.out.println("내용:"+content);	
%>

제목 : <%=title %><br>
내용 : <br>
<%=content %>
