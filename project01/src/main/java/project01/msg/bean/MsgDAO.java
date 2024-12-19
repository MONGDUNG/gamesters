package project01.msg.bean;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import project01.site.bean.DataBaseConnection;

public class MsgDAO extends DataBaseConnection{
    private Connection conn = null;
    private PreparedStatement pstmt = null;
    private ResultSet rs = null;
    private String sql = null;
   
    // 1. 쪽지 보내기
    public boolean sendMessage(MsgDTO dto) {
       boolean result = false;
       try {
          conn = getOracleConnection();
          sql = "select * from member where nickname=?";
          pstmt = conn.prepareStatement(sql);
          pstmt.setString(1, dto.getReceive_nick());
          rs = pstmt.executeQuery();
          if(rs.next()) {
             result = true;
          }
          if(result==true) {
              sql = "INSERT INTO msg (msg_num, msg, send_nick, receive_nick, reg) VALUES (msg_seq.nextval, ?, ?, ?, sysdate)";
              pstmt = conn.prepareStatement(sql);
              pstmt.setString(1, dto.getMsg());
              pstmt.setString(2, dto.getSend_nick());
              pstmt.setString(3, dto.getReceive_nick());
              pstmt.executeUpdate();
          }
       }catch(Exception e){
          e.printStackTrace();
       }finally {
          dbClose(rs,pstmt,conn);
       }
       return result;
    }

    // 2. 받은 쪽지 목록 조회 (페이징 반영)
    public List<MsgDTO> getReceivedMessages(String receive_nick, int start, int end) {
        List<MsgDTO> messages = new ArrayList<>();
        try{
           conn = getOracleConnection();
           sql = "SELECT msg_num, msg, send_nick, reg, check_msg FROM msg WHERE receive_nick = ? AND receiver_deleted = 0 ORDER BY reg DESC";
           sql = "SELECT * FROM ("
               + "SELECT ROWNUM rnum, d.* FROM ("
               + "SELECT msg_num, msg, send_nick, reg, check_msg FROM msg WHERE receive_nick = ? AND receiver_deleted = 0 ORDER BY reg DESC"
               + ") d WHERE ROWNUM <= ?"
               + ") WHERE rnum >= ?";
           
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, receive_nick);
           pstmt.setInt(2, end);   
           pstmt.setInt(3, start); 
           rs = pstmt.executeQuery();
           while (rs.next()) {
               MsgDTO message = new MsgDTO();
               message.setMsg_num(rs.getInt("msg_num"));
               message.setMsg(rs.getString("msg"));
               message.setSend_nick(rs.getString("send_nick"));
               message.setReg(rs.getString("reg"));
               message.setCheckMsg(rs.getInt("check_msg"));
               messages.add(message);
           }
        } catch (Exception e) {
           e.printStackTrace();
        } finally {
           dbClose(rs, pstmt, conn);
        }
        return messages;
    }

    // 3. 보낸 쪽지 목록 조회 (페이징 반영)
    public List<MsgDTO> getSentMessages(String send_nick, int start, int end) {
        List<MsgDTO> messages = new ArrayList<>();
        try{
           conn = getOracleConnection();
           sql = "SELECT msg_num, msg, receive_nick, reg FROM msg WHERE send_nick = ? AND sender_deleted = 0 ORDER BY reg DESC";
           sql = "SELECT * FROM ("
               + "SELECT ROWNUM rnum, d.* FROM ("
               + "SELECT msg_num, msg, receive_nick, reg FROM msg WHERE send_nick = ? AND sender_deleted = 0 ORDER BY reg DESC"
               + ") d WHERE ROWNUM <= ?"
               + ") WHERE rnum >= ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, send_nick);
           pstmt.setInt(2, end);
           pstmt.setInt(3, start);
           rs = pstmt.executeQuery();
           while (rs.next()) {
               MsgDTO message = new MsgDTO();
               message.setMsg_num(rs.getInt("msg_num"));
               message.setMsg(rs.getString("msg"));
               message.setReceive_nick(rs.getString("receive_nick"));
               message.setReg(rs.getString("reg"));
               messages.add(message);
           }
        } catch (Exception e) {
           e.printStackTrace();
        } finally {
           dbClose(rs, pstmt, conn);
        }
        return messages;
    }

    // 페이지 처리를 하지 않는 기존 보낸 쪽지 조회 (필요없다면 삭제 가능)
    public List<MsgDTO> getSentMessages(String send_nick) {
        List<MsgDTO> messages = new ArrayList<>();
        try{
           conn = getOracleConnection();
           sql = "SELECT msg_num, msg, receive_nick, reg FROM msg WHERE send_nick = ? AND sender_deleted = 0 ORDER BY reg DESC";
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, send_nick);
           rs = pstmt.executeQuery();
           while (rs.next()) {
               MsgDTO message = new MsgDTO();
               message.setMsg_num(rs.getInt("msg_num"));
               message.setMsg(rs.getString("msg"));
               message.setReceive_nick(rs.getString("receive_nick"));
               message.setReg(rs.getString("reg"));
               messages.add(message);
           }
        } catch (Exception e) {
           e.printStackTrace();
        } finally {
           dbClose(rs, pstmt, conn);
        }
        return messages;
    }
   
    // 4. 쪽지 읽기
    public MsgDTO readMessage(int msg_num) {
       MsgDTO message = new MsgDTO();
       try {
          conn = getOracleConnection();
          sql = "SELECT msg_num, msg, send_nick, receive_nick, reg FROM msg WHERE msg_num = ?";
          pstmt = conn.prepareStatement(sql);
          pstmt.setInt(1, msg_num);
          rs = pstmt.executeQuery();
          if (rs.next()) {
             message.setMsg_num(rs.getInt("msg_num"));
             message.setMsg(rs.getString("msg"));
             message.setSend_nick(rs.getString("send_nick"));
             message.setReceive_nick(rs.getString("receive_nick"));
             message.setReg(rs.getString("reg"));
          }
       } catch (Exception e) {
          e.printStackTrace();
       } finally {
          dbClose(rs, pstmt, conn);
       }
       return message;
    }
   
    // 5. 보낸 쪽지 삭제
    public void deleteMessageForSender(int msg_num) {
       try {
           conn = getOracleConnection();
           sql = "UPDATE msg SET sender_deleted = 1 WHERE msg_num = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, msg_num);
           pstmt.executeUpdate();
           checkAndDeleteMessage(msg_num);
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           dbClose(rs, pstmt, conn);
       }
    }
    
    // 6. 받은 쪽지 삭제
    public void deleteMessageForReceiver(int msg_num) {
       try {
           conn = getOracleConnection();
           sql = "UPDATE msg SET receiver_deleted = 1 WHERE msg_num = ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, msg_num);
           pstmt.executeUpdate();
           checkAndDeleteMessage(msg_num);
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           dbClose(rs, pstmt, conn);
       }
    }

    // 7. 양측 쪽지 삭제 확인
    private void checkAndDeleteMessage(int msg_num) {
       try {
           sql = "SELECT sender_deleted, receiver_deleted FROM msg WHERE msg_num = ?";
           conn = getOracleConnection();
           pstmt = conn.prepareStatement(sql);
           pstmt.setInt(1, msg_num);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               boolean senderDeleted = rs.getBoolean("sender_deleted");
               boolean receiverDeleted = rs.getBoolean("receiver_deleted");
               if (senderDeleted && receiverDeleted) {
                   sql = "DELETE FROM msg WHERE msg_num = ?";
                   pstmt = conn.prepareStatement(sql);
                   pstmt.setInt(1, msg_num);
                   pstmt.executeUpdate();
               }
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           dbClose(rs, pstmt, conn);
       }
    }

    public void checkMsg(int msg_num) {
       try {
          sql = "update msg set check_msg = 1 where msg_num = ? and check_msg = 0";
          conn = getOracleConnection();
          pstmt = conn.prepareStatement(sql);
          pstmt.setInt(1, msg_num);
          pstmt.executeUpdate();
       } catch (Exception e) {
          e.printStackTrace();
       } finally {
          dbClose(rs,pstmt,conn);
       }
    }

    // 안 읽은 쪽지만 보기 (페이징 반영)
    public List<MsgDTO> getunCheckReceivedMessages(String receive_nick, int start, int end) {
        List<MsgDTO> messages = new ArrayList<>();
        try{
           conn = getOracleConnection();
           sql = "SELECT msg_num, msg, send_nick, reg, check_msg FROM msg WHERE receive_nick = ? AND receiver_deleted = 0 AND check_msg = 0 ORDER BY reg DESC";
           sql = "SELECT * FROM ("
               + "SELECT ROWNUM rnum, d.* FROM ("
               + "SELECT msg_num, msg, send_nick, reg, check_msg FROM msg WHERE receive_nick = ? AND receiver_deleted = 0 AND check_msg = 0 ORDER BY reg DESC"
               + ") d WHERE ROWNUM <= ?"
               + ") WHERE rnum >= ?";
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, receive_nick);
           pstmt.setInt(2, end);
           pstmt.setInt(3, start);
           rs = pstmt.executeQuery();
           while (rs.next()) {
               MsgDTO message = new MsgDTO();
               message.setMsg_num(rs.getInt("msg_num"));
               message.setMsg(rs.getString("msg"));
               message.setSend_nick(rs.getString("send_nick"));
               message.setReg(rs.getString("reg"));
               message.setCheckMsg(rs.getInt("check_msg"));
               messages.add(message);
           }
        } catch (Exception e) {
           e.printStackTrace();
        } finally {
           dbClose(rs, pstmt, conn);
        }
        return messages;
    }

    public int getReceiveMsgCount(String nick) {
       int count = 0;
       try {
           conn = getOracleConnection();
           // receiver_deleted = 0 조건 추가
           sql = "SELECT COUNT(*) FROM msg where receive_nick = ? AND receiver_deleted = 0";
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, nick);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               count = rs.getInt(1);
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           dbClose(rs, pstmt, conn);
       }
       return count;
    }

    public int getSentMsgCount(String nick) {
       int count = 0;
       try {
           conn = getOracleConnection();
           // sender_deleted = 0 조건 추가
           sql = "SELECT COUNT(*) FROM msg where send_nick = ? AND sender_deleted = 0";
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, nick);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               count = rs.getInt(1);
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           dbClose(rs, pstmt, conn);
       }
       return count;
    }

    public int getUnReadMsgCount(String nick) {
       int count = 0;
       try {
           conn = getOracleConnection();
           // receiver_deleted = 0 조건 추가
           sql = "SELECT COUNT(*) FROM msg where receive_nick = ? AND check_msg = 0 AND receiver_deleted = 0";
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, nick);
           rs = pstmt.executeQuery();
           if (rs.next()) {
               count = rs.getInt(1);
           }
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           dbClose(rs, pstmt, conn);
       }
       return count;
    }
}
