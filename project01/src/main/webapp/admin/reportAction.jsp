<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
int report_id = Integer.parseInt(request.getParameter("report_id"));
%>



<form method="post" action="reportActionPro.jsp">
        <input type="hidden" name="report_id" value="<%= report_id %>">
        <div>
        <label for="handlingCode">처리코드:</label>
        <select id="handlingCode" name="handlingCode" required>
            <option value="회원제재">회원제재</option>
            <option value="게시물삭제">게시물삭제</option>
            <option value="게시물수정">게시물수정</option>
            <option value="혐의없음">혐의없음</option>
        </select>
    </div>
        <div>
            <label for="details">상세:</label>
            <textarea id="details" name="details" required></textarea>
        </div>
        <button type="submit">Submit</button>
</form>