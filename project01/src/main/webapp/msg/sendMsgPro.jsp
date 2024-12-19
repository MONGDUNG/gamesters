<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="dto"  class="project01.msg.bean.MsgDTO" />
<jsp:setProperty name="dto"  property="*" />
<jsp:useBean id="dao"  class="project01.msg.bean.MsgDAO" />



<h1>쪽지 쓰기 프로이올시다</h1>

<%
    String sender = (String) session.getAttribute("nick");
    String message = request.getParameter("content");
    String receiver = request.getParameter("receiver");
	dto.setMsg(message);
	dto.setSend_nick(sender);
	dto.setReceive_nick(receiver);
	
    if (sender.equals(receiver)) {
%>
        <script>
            alert("자신에게 쪽지를 보낼 수 없습니다.");
            history.go(-1); // 이전 페이지로 돌아가기
        </script>
<%
        return; // 추가 작업 중단
    }
%>
    
            
<%	
    try {
        if (dao.sendMessage(dto)) {
%>
            <script>
                alert("쪽지가 성공적으로 전송되었습니다.");
                window.location.href = "msgList.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("쪽지 전송에 실패했습니다.");
                history.go(-1);
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.go(-1);</script>");
    }
%>

