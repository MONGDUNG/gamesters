<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="project01.msg.bean.MsgDTO" %>
<%@ page import="project01.msg.bean.MsgDAO" %>
<%@ page import="project01.member.bean.MemberDAO" %>

<%
    String nick = (String)session.getAttribute("nick");
    if (nick == null) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "../member/loginForm.jsp";
    </script>
<%
        return;
    }

    // 탭 상태 관리 (기본: 받은 쪽지)
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "received";
    }

    String showUnreadParam = request.getParameter("showUnread");
    boolean showUnread = "true".equals(showUnreadParam);

    // 받은쪽지함 페이지 파라미터
    String readCurrentPageParam = request.getParameter("readCurrentPage");
    int readCurrentPage = (readCurrentPageParam == null) ? 1 : Integer.parseInt(readCurrentPageParam);

    // 보낸쪽지함 페이지 파라미터
    String sendCurrentPageParam = request.getParameter("sendCurrentPage");
    int sendCurrentPage = (sendCurrentPageParam == null) ? 1 : Integer.parseInt(sendCurrentPageParam);

    int recordsPerPage = 20; // 한 페이지당 쪽지 수

    // 받은쪽지 페이징 start, end
    int readStart = (readCurrentPage - 1) * recordsPerPage + 1;
    int readEnd = readCurrentPage * recordsPerPage;

    // 보낸쪽지 페이징 start, end
    int sendStart = (sendCurrentPage - 1) * recordsPerPage + 1;
    int sendEnd = sendCurrentPage * recordsPerPage;

    MsgDAO msgDAO = new MsgDAO();
    MemberDAO memberDAO = new MemberDAO();
    List<String> blockedMembers = memberDAO.getBlockedMembers(nick);

    List<MsgDTO> receivedMsgList = null;
    int totalReceivedRecords = 0;
    if (showUnread) {
        receivedMsgList = msgDAO.getunCheckReceivedMessages(nick, readStart, readEnd);
        totalReceivedRecords = msgDAO.getUnReadMsgCount(nick);
    } else {
        receivedMsgList = msgDAO.getReceivedMessages(nick, readStart, readEnd);
        totalReceivedRecords = msgDAO.getReceiveMsgCount(nick);
    }
    int receivedNoOfPages = (int) Math.ceil((double) totalReceivedRecords / recordsPerPage);

    List<MsgDTO> sentMsgList = msgDAO.getSentMessages(nick, sendStart, sendEnd);
    int totalSentRecords = msgDAO.getSentMsgCount(nick);
    int sentNoOfPages = (int) Math.ceil((double) totalSentRecords / recordsPerPage);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>쪽지함</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
.unread-message {
    background-color: #f8d7da;
    font-weight: bold;
}
.read-message {
    background-color: #ffffff;
}
</style>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    const messageRows = document.querySelectorAll('.message-row');

    messageRows.forEach(row => {
      row.addEventListener('click', () => {
        const sender = row.getAttribute('data-sender');
        const receiver = row.getAttribute('data-receiver');
        const time = row.getAttribute('data-time');
        const message = row.getAttribute('data-message');
        const msgNum = row.getAttribute('data-msgnum');

        fetch('checkMessageHandler.jsp?msgNum='+msgNum, {
            method: 'get',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
        .then(response => response.text())
        .then(data => {
            console.log('checkMsg 호출 결과:', data);
        })
        .catch(error => {
            console.error('checkMsg 호출 중 오류:', error);
        });

        document.getElementById('modalSender').textContent = sender;
        document.getElementById('modalTime').textContent = time;
        document.getElementById('modalMessage').textContent = message;

        const modal = new bootstrap.Modal(document.getElementById('messageModal'));
        modal.show();
      });
    });

    document.getElementById('replyButton').addEventListener('click', () => {
        const sender = document.getElementById('modalSender').textContent.trim();
        if (!sender) {
            alert("보낸 사람 정보가 없습니다.");
            return;
        }
        const encodedSender = encodeURIComponent(sender);
        location.href = 'sendMsg.jsp?receiver='+sender;
    });

    document.getElementById('blockButton').addEventListener('click', () => {
        const sender = document.getElementById('modalSender').textContent.trim();
        if (!sender) {
            alert("보낸 사람 정보가 없습니다.");
            return;
        }
        if (confirm(sender + " 회원을 차단 하시겠습니까?")) {
            const encodedSender = encodeURIComponent(sender);
            location.href = 'blockMember.jsp?blocked_nick=' + encodedSender;
        }
    });

    const deleteButtons = document.querySelectorAll('.btn-danger');
    deleteButtons.forEach(button => {
      button.addEventListener('click', (event) => {
        event.stopPropagation();
      });
    });
  });

  function openDeletePopup(msgNum, userType) {
     window.open('deleteMessage.jsp?msgNum='+msgNum+'&userType='+userType, 'deletePopup', 'width=400,height=300');
  }

</script>
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="text-center">쪽지함</h1>
        <div>
            <button class="btn btn-primary" onclick="location.href='sendMsg.jsp'">쪽지쓰기</button>
            <a href="../member/main.jsp" class="btn btn-secondary">메인으로</a>
        </div>
    </div>
    <div class="d-flex justify-content-end mb-4">
        <button class="btn btn-warning" onclick="location.href='blockedMemberList.jsp'">차단리스트</button>
    </div>
    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link <%= "received".equals(tab) ? "active" : "" %>" id="received-tab" data-bs-toggle="tab" data-bs-target="#received" type="button" role="tab" aria-controls="received" aria-selected="<%= "received".equals(tab) %>">받은 쪽지</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link <%= "sent".equals(tab) ? "active" : "" %>" id="sent-tab" data-bs-toggle="tab" data-bs-target="#sent" type="button" role="tab" aria-controls="sent" aria-selected="<%= "sent".equals(tab) %>">보낸 쪽지</button>
        </li>
    </ul>
    <div class="tab-content" id="myTabContent">
        <div class="tab-pane fade <%= "received".equals(tab) ? "show active" : "" %>" id="received" role="tabpanel" aria-labelledby="received-tab">
            <div class="card shadow-sm mt-3">
                <div class="card-body">
                    <h3 class="text-center">받은 쪽지</h3>
                    <form method="get" action="">
                        <input type="hidden" name="tab" value="received">
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="unreadOnly" name="showUnread" value="true" <%= showUnread ? "checked" : "" %> onchange="this.form.submit()">
                            <label class="form-check-label" for="unreadOnly">안읽은 쪽지만 보기</label>
                        </div>
                    </form>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>보낸 사람</th>
                                <th>내용</th>
                                <th>보낸 시각</th>
                                <th>삭제</th>
                            </tr>
                        </thead>
                       <tbody>
      <%
         for (MsgDTO msg : receivedMsgList) {
             if (blockedMembers.contains(msg.getSend_nick())) {
                 continue; 
             }
             String fullMessage = msg.getMsg();
             String shortMessage = (fullMessage != null && fullMessage.length() > 15)
                                     ? fullMessage.substring(0, 15) + "..."
                                     : fullMessage;
             int isChecked = msg.getCheckMsg();
             String rowClass = (isChecked == 0) ? "unread-message" : "read-message";
      %>
     <tr
         class="message-row <%= rowClass %>"
         data-sender="<%= msg.getSend_nick() %>"
         data-receiver="<%= nick %>"
         data-time="<%= msg.getReg() %>"
         data-message="<%= fullMessage %>"
         data-msgnum="<%= msg.getMsg_num()%>">
         <td><%= msg.getSend_nick() %></td>
         <td><%= shortMessage %></td>
         <td><%= msg.getReg() %></td>
         <td>
          <form method="get" action="deleteMessage.jsp" target="deletePopup" onsubmit="window.open('', 'deletePopup', 'width=400,height=300');">
           <input type="hidden" name="msgNum" value="<%= msg.getMsg_num() %>">
           <input type="hidden" name="userType" value="receiver">
           <button type="submit" class="btn btn-danger">삭제</button>
          </form>
         </td>
     </tr>
        <% } %>
     </tbody>
                    </table>
                    <!-- 받은쪽지 페이징 -->
                    <div class="d-flex justify-content-center mt-3">
                        <nav>
                            <ul class="pagination">
                                <% for (int i = 1; i <= receivedNoOfPages; i++) { %>
                                    <li class="page-item <%= (i == readCurrentPage) ? "active" : "" %>">
                                        <a class="page-link" href="?tab=received&readCurrentPage=<%= i %><%= showUnread ? "&showUnread=true" : "" %>"><%= i %></a>
                                    </li>
                                <% } %>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
        <div class="tab-pane fade <%= "sent".equals(tab) ? "show active" : "" %>" id="sent" role="tabpanel" aria-labelledby="sent-tab">
            <div class="card shadow-sm mt-3">
                <div class="card-body">
                    <h3 class="text-center">보낸 쪽지</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>받는 사람</th>
                                <th>내용</th>
                                <th>보낸 시각</th>
                                <th>삭제</th>
                            </tr>
                        </thead>
                        <tbody>
                          <%
                             for (MsgDTO msg : sentMsgList) {
                                 String fullMessage = msg.getMsg();
                                 String shortMessage = (fullMessage != null && fullMessage.length() > 15)
                                                         ? fullMessage.substring(0, 15) + "..."
                                                         : fullMessage;
                          %>
                             <tr
                                 class="message-row"
                                 data-sender="<%= nick %>"
                                 data-receiver="<%= msg.getReceive_nick() %>"
                                 data-time="<%= msg.getReg() %>"
                                 data-message="<%= fullMessage %>">
                                 <td><%= msg.getReceive_nick() %></td>
                                 <td><%= shortMessage %></td>
                                 <td><%= msg.getReg() %></td>
                                 <td>
                                  <form method="get" action="deleteMessage.jsp" target="deletePopup" onsubmit="window.open('', 'deletePopup', 'width=400,height=300');">
                                   <input type="hidden" name="msgNum" value="<%= msg.getMsg_num() %>">
                                   <input type="hidden" name="userType" value="sender">
                                   <button type="submit" class="btn btn-danger">삭제</button>
                                  </form>
                                 </td>
                             </tr>
                          <% } %>
                        </tbody>
                    </table>
                    <!-- 보낸쪽지 페이징 -->
                    <div class="d-flex justify-content-center mt-3">
                        <nav>
                            <ul class="pagination">
                                <% for (int i = 1; i <= sentNoOfPages; i++) { %>
                                    <li class="page-item <%= (i == sendCurrentPage) ? "active" : "" %>">
                                        <a class="page-link" href="?tab=sent&sendCurrentPage=<%= i %>"><%= i %></a>
                                    </li>
                                <% } %>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- 모달 구조 -->
<div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="messageModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="messageModalLabel">메시지 상세</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p><strong>보낸 사람:</strong> <span id="modalSender"></span></p>
        <p><strong>보낸 시간:</strong> <span id="modalTime"></span></p>
        <p><strong>내용:</strong></p>
        <p id="modalMessage"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="replyButton">답장하기</button>
        <button type="button" class="btn btn-danger" id="blockButton">차단하기</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>
