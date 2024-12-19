package project01.board.bean;

public class BoardDTO {
    private int boardnum;
    private String title;
    private String nickname;
    private String content;
    private int readcount;
    private int replycount;
    private int upcnt;
    private int dwncnt;
    private String reg;
    private int filecount;
    private String gameName;
    private String gameName_kr;
    private String category;
    private int order_col;
    // Getters and Setters
    public int getOrder_col() {
        return order_col;
    }
    public void setOrder_col(int order_col) {
        this.order_col = order_col;
    }

    public int getBoardnum() {
        return boardnum;
    }
    public void setBoardnum(int boardnum) {
        this.boardnum = boardnum;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getNickname() {
        return nickname;
    }
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public int getReadcount() {
        return readcount;
    }
    public void setReadcount(int readcount) {
        this.readcount = readcount;
    }
    public int getReplycount() {
        return replycount;
    }
    public void setReplycount(int replycount) {
        this.replycount = replycount;
    }
    public int getUpcnt() {
        return upcnt;
    }
    public void setUpcnt(int upcnt) {
        this.upcnt = upcnt;
    }
    public int getDwncnt() {
        return dwncnt;
    }
    public void setDwncnt(int dwncnt) {
        this.dwncnt = dwncnt;
    }
    public String getReg() {
        return reg;
    }
    public void setReg(String reg) {
        this.reg = reg;
    }
    public int getFilecount() {
        return filecount;
    }
    public void setFilecount(int filecount) {
        this.filecount = filecount;
    }
    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

	public String getCategory() {
		return category;
	}
	
	public void setCategory(String category) {
		this.category = category;
	}

	public String getGameName_kr() {
		return gameName_kr;
	}

	public void setGameName_kr(String gameName_kr) {
		this.gameName_kr = gameName_kr;
	}
	
}
