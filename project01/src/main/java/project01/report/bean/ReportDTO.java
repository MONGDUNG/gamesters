package project01.report.bean;

public class ReportDTO {
	private int report_id;
	private String game_name;
	private int post_id;
	private Integer comment_id;
	private String reporter_id;
	private String reason;
	private String reg_report;
	private int action_id;
	private String admin_id;
	private String action_taken;
	private String action_detail;
	private String reg_action;
	private String isCompleted;
	private int is_image;
	
	public int getReport_id() {
		return report_id;
	}
	public String getGame_name() {
		return game_name;
	}
	public int getPost_id() {
		return post_id;
	}
	public Integer getComment_id() {
		return comment_id;
	}
	public String getReporter_id() {
		return reporter_id;
	}
	public String getReason() {
		return reason;
	}
	public String getReg_report() {
		return reg_report;
	}
	public int getAction_id() {
		return action_id;
	}
	public String getAdmin_id() {
		return admin_id;
	}
	public String getAction_taken() {
		return action_taken;
	}
	public String getAction_detail() {
		return action_detail;
	}
	public String getReg_action() {
		return reg_action;
	}
	public String getIsCompleted() {
		return isCompleted;
	}
	public void setReport_id(int report_id) {
		this.report_id = report_id;
	}
	public void setGame_name(String game_name) {
		this.game_name = game_name;
	}
	public void setPost_id(int post_id) {
		this.post_id = post_id;
	}
	public void setComment_id(Integer comment_id) {
		this.comment_id = comment_id;
	}
	public void setReporter_id(String reporter_id) {
		this.reporter_id = reporter_id;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public void setReg_report(String reg_report) {
		this.reg_report = reg_report;
	}
	public void setAction_id(int action_id) {
		this.action_id = action_id;
	}
	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}
	public void setAction_taken(String action_taken) {
		this.action_taken = action_taken;
	}
	public void setAction_detail(String action_detail) {
		this.action_detail = action_detail;
	}
	public void setReg_action(String reg_action) {
		this.reg_action = reg_action;
	}
	public void setIsCompleted(String isCompleted) {
		this.isCompleted = isCompleted;
	}
	
	public int getIs_image() {
		return is_image;
	}

	public void setIs_image(int is_image) {
		this.is_image = is_image;
	}
}
