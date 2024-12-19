<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import= "jakarta.mail.internet.*" %>
<%@ page import= "jakarta.mail.*" %>
<%@ page import="project01.member.bean.MemberDAO" %>

<%
    String id = request.getParameter("id");
    String email = request.getParameter("email");
    
    MemberDAO dao = new MemberDAO();
    boolean userExists = dao.checkUser(id, email);

    if (!userExists) {
%>
    <h3>아이디와 이메일을 다시 확인해주세요.</h3>
    <a href="findPw.jsp">돌아가기</a>
<%
    } else {
        // 인증 코드 생성
        String authCode = UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        // 인증 코드 세션 저장
        session.setAttribute("authCode", authCode);
        session.setAttribute("userId", id);

        // 이메일 전송 설정
        final String sender = "ehdrb438438@naver.com"; // 발신자 이메일
        final String password = "PBGGKGPJFZP1"; // 발신자 이메일 비밀번호

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.naver.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // TLS 활성화
 

        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(sender, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(sender));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
            message.setSubject("비밀번호 찾기 인증 코드");
            message.setText("인증 코드: " + authCode);

            Transport.send(message);
%>
    <h3>인증 코드가 이메일로 전송되었습니다.</h3>
    <form action="verifyCode.jsp" method="post">
    	<input type="hidden" name="email" value="<%=email%>">
        <label for="authCode">인증 코드: </label>
        <input type="text" id="authCode" name="authCode" required>
        <button type="submit">확인</button>
    </form>
<%
        } catch (Exception e) {
            e.printStackTrace();
%>
    <h3>이메일 전송에 실패했습니다. 다시 시도해주세요.</h3>
    <a href="findPw.jsp">돌아가기</a>
<%
        }
    }
%>