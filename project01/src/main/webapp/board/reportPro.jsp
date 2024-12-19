<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.report.bean.ReportDAO"%>
<%@ page import="project01.report.bean.ReportDTO"%>


<%
	String game = request.getParameter("game");
    int post_id = Integer.parseInt(request.getParameter("num"));
	String reporter_id = (String)session.getAttribute("id");
	String reportType = request.getParameter("reportType");
	String reason = request.getParameter("reason");
	String repNumParam = request.getParameter("rep_num");
	String type = request.getParameter("type");
	Integer comment_id = null;
	if (repNumParam != null) {
        try {
        	comment_id = Integer.parseInt(repNumParam);
        } catch (NumberFormatException e) {
            // 예외 처리 (로그 출력 또는 기본값 설정)
            comment_id = null;
        }
    }
	ReportDTO dto = new ReportDTO();
	ReportDAO dao = new ReportDAO();
	dto.setGame_name(game);
	dto.setPost_id(post_id);
	dto.setReporter_id(reporter_id);
	dto.setReason(reason);
	if(reportType.equals("reply")) {
		dto.setComment_id(comment_id);
	}
	dao.addReport(dto, type);
%>
<script>
		alert("신고가 완료되었습니다.");
		close();
</script>
