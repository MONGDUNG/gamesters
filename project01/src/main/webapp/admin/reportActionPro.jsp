<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.report.bean.ReportDAO"%>
<%@ page import="project01.report.bean.ReportDTO"%>
<%
	String id = (String)session.getAttribute("id");
	String handlingCode = request.getParameter("handlingCode");
	String detail = request.getParameter("details");
	int report_id = Integer.parseInt(request.getParameter("report_id"));
	ReportDAO dao = new ReportDAO();
	ReportDTO dto = new ReportDTO();
	dto.setAction_taken(handlingCode);
	dto.setAction_detail(detail);
	dto.setReport_id(report_id);
	dto.setAdmin_id(id);
	dao.addReportAction(dto);
%>
	<script>
		alert("신고처리가 완료되었습니다.");
        self.close();
	</script>