package project01.msg.bean;

public class MsgDTO {
   private int msg_num;
   private String msg;
   private String send_nick;
   private String receive_nick;
   private String reg;
   private int sender_deleted;
    private int receiver_deleted;
    private int checkMsg;
    
   public int getCheckMsg() {
      return checkMsg;
   }
   public void setCheckMsg(int checkMsg) {
      this.checkMsg = checkMsg;
   }
   public int getMsg_num() {
      return msg_num;
   }
   public void setMsg_num(int msg_num) {
      this.msg_num = msg_num;
   }
   public String getMsg() {
      return msg;
   }
   public void setMsg(String msg) {
      this.msg = msg;
   }
   public String getSend_nick() {
      return send_nick;
   }
   public void setSend_nick(String send_nick) {
      this.send_nick = send_nick;
   }
   public String getReceive_nick() {
      return receive_nick;
   }
   public void setReceive_nick(String receive_nick) {
      this.receive_nick = receive_nick;
   }
   public String getReg() {
      return reg;
   }
   public void setReg(String reg) {
      this.reg = reg;
   }
   public int isSender_deleted() {
        return sender_deleted;
    }
    public void setSender_deleted(int sender_deleted) {
        this.sender_deleted = sender_deleted;
    }
    public int isReceiver_deleted() {
        return receiver_deleted;
    }
    public void setReceiver_deleted(int receiver_deleted) {
        this.receiver_deleted = receiver_deleted;
    }
}
