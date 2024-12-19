package project01.board.bean;

public class ReplyDTO {
	private int num;
	private int Boardnum;
	private String game;
	private String rep_content;
	private String rep_reg;
	private int rep_upcnt;
	private int rep_dwncnt;
	private String nickname;
	private int parent_id;
	private int is_image;
	public int getBoardnum() {
		return Boardnum;
	}
	public void setBoardnum(int boardnum) {
		Boardnum = boardnum;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getRep_content() {
		return rep_content;
	}
	public void setRep_content(String rep_content) {
		this.rep_content = rep_content;
	}
	public String getRep_reg() {
		return rep_reg;
	}
	public void setRep_reg(String rep_reg) {
		this.rep_reg = rep_reg;
	}
	public int getRep_upcnt() {
		return rep_upcnt;
	}
	public void setRep_upcnt(int rep_upcnt) {
		this.rep_upcnt = rep_upcnt;
	}
	public int getRep_dwncnt() {
		return rep_dwncnt;
	}
	public void setRep_dwncnt(int rep_dwncnt) {
		this.rep_dwncnt = rep_dwncnt;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public int getParent_id() {
		return parent_id;
	}
	public void setParent_id(int parent_id) {
		this.parent_id = parent_id;
	}
	public String getGame() {
		return game;
	}
	public void setGame(String game) {
		this.game = game;
	}

	public int getIs_image() {
		return is_image;
	}

	public void setIs_image(int is_image) {
		this.is_image = is_image;
	}
}
