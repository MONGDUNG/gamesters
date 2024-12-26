package project01.board.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import project01.site.bean.DataBaseConnection;

public class ReplyDAO extends DataBaseConnection{
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private String sql;
	
	public void replyInsert(ReplyDTO dto) {                      
	    PreparedStatement pstmt = null;
	    try {
	        String game = dto.getGame();
	        conn = getOracleConnection();

	        // 댓글 수 업데이트
	        if(dto.getIs_image()==0) {
	        	sql = "update " + game + "_board set replycount = replycount + 1 where boardnum = ?";
	        } else {
	        	sql = "update " + game + "_image_board set replycount = replycount + 1 where boardnum = ?";
	        }
	        pstmt = conn.prepareStatement(sql);                  // 새로운 PreparedStatement 생성
	        pstmt.setInt(1, dto.getBoardnum());
	        pstmt.executeUpdate();
	        pstmt.close();                                       // PreparedStatement 닫기

	        // 댓글 추가
	        sql = "insert into reply values(reply_seq.nextval, ?, ?, sysdate, ?, 0, ?, ?)";
	        pstmt = conn.prepareStatement(sql);                  // 새로운 PreparedStatement 생성
	        pstmt.setString(1, game);                            // 게임 이름
	        pstmt.setInt(2, dto.getBoardnum());                  // 게시글 번호
	        pstmt.setString(3, dto.getNickname());
	        pstmt.setString(4, dto.getRep_content());
	        pstmt.setInt(5, dto.getIs_image());
	        
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);                            // 자원 정리
	    }
	}
	public void reReplyInsert(ReplyDTO dto, int num) {                      
	    PreparedStatement pstmt = null;
	    try {
	        String game = dto.getGame();
	        conn = getOracleConnection();

	        // 댓글 수 업데이트
	        if(dto.getIs_image()==0) {
	        	sql = "update " + game + "_board set replycount = replycount + 1 where boardnum = ?";
	        } else {
	        	sql = "update " + game + "_image_board set replycount = replycount + 1 where boardnum = ?";
	        }
	        pstmt = conn.prepareStatement(sql);                  // 새로운 PreparedStatement 생성
	        pstmt.setInt(1, dto.getBoardnum());
	        pstmt.executeUpdate();
	        pstmt.close();                                       // PreparedStatement 닫기

	        // 댓글 추가
	        sql = "insert into reply values(reply_seq.nextval, ?, ?, sysdate, ?, ?, ?, ?)";
	        pstmt = conn.prepareStatement(sql);                  // 새로운 PreparedStatement 생성
	        pstmt.setString(1, game);                            // 게임 이름
	        pstmt.setInt(2, dto.getBoardnum());                  // 게시글 번호
	        pstmt.setString(3, dto.getNickname());
	        pstmt.setInt(4, num);
	        pstmt.setString(5, dto.getRep_content());
	        pstmt.setInt(6, dto.getIs_image());
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);                            // 자원 정리
	    }
	}


	
	public List<ReplyDTO> replyAll(int boardnum, String game, int is_image, int start, int end) {
	    List<ReplyDTO> list = new ArrayList<>();
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT * FROM ("
	            + "    SELECT ROWNUM rnum, r.* FROM ("
	            + "        SELECT * FROM reply WHERE boardnum = ? AND game_name = ? AND is_image = ? "
	            + "        ORDER BY CASE WHEN parent_id = 0 THEN num ELSE parent_id END, rep_reg ASC"
	            + "    ) r WHERE ROWNUM <= ?"
	            + ") WHERE rnum >= ?";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, boardnum);
	        pstmt.setString(2, game);
	        pstmt.setInt(3, is_image);
	        pstmt.setInt(4, end); // ROWNUM <= end
	        pstmt.setInt(5, start); // rnum >= start

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            ReplyDTO dto = new ReplyDTO();
	            dto.setNum(rs.getInt("num"));
	            dto.setGame(rs.getString("game_name"));
	            dto.setBoardnum(rs.getInt("boardnum"));
	            dto.setRep_content(rs.getString("rep_content"));
	            dto.setRep_reg(rs.getString("rep_reg"));
	            dto.setNickname(rs.getString("nickname"));
	            dto.setParent_id(rs.getInt("parent_id"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return list;
	}
	public int getTotalReplies(int boardnum, String game, int is_image) {
	    int totalReplies = 0;
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT COUNT(*) FROM reply WHERE boardnum = ? AND game_name = ? AND is_image = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, boardnum);
	        pstmt.setString(2, game);
	        pstmt.setInt(3, is_image);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            totalReplies = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return totalReplies;
	}
	public int getReReplyCount(int num) {
		int result = 0;
		try {
			conn = getOracleConnection();
			sql = "SELECT COUNT(*) AS reply_count FROM reply WHERE parent_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt("reply_count");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			dbClose(rs,pstmt,conn);
		}
		return result;
	}
	
	public void replyDelete(int num, String game, ReplyDTO dto) {
	    try {
	        conn = getOracleConnection();
	        int is_image = dto.getIs_image();
	        // 1. 삭제하려는 댓글의 자식 댓글 수 확인
	        String countSql = "SELECT COUNT(*) FROM reply WHERE parent_id = ?";
	        pstmt = conn.prepareStatement(countSql);
	        pstmt.setInt(1, num);
	        rs = pstmt.executeQuery();

	        int childReplyCount = 0;
	        if (rs.next()) {
	            childReplyCount = rs.getInt(1); // 자식 댓글 개수
	        }
	        rs.close();
	        pstmt.close();

	        // 2. 부모 댓글 삭제
	        String deleteParentSql = "DELETE FROM reply WHERE num = ?";
	        pstmt = conn.prepareStatement(deleteParentSql);
	        pstmt.setInt(1, num);
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 3. 자식 댓글 삭제
	        String deleteChildSql = "DELETE FROM reply WHERE parent_id = ?";
	        pstmt = conn.prepareStatement(deleteChildSql);
	        pstmt.setInt(1, num);
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 4. 게시판 replycount 업데이트: 부모 댓글 + 자식 댓글 수만큼 감소
	        int totalDeletedCount = 1 + childReplyCount; // 부모 댓글(1) + 자식 댓글 수
	        if(is_image == 0) {
	        	sql = "UPDATE " + game + "_board SET replycount = replycount - ? WHERE boardnum = ?";
	        } else {
	        	sql = "UPDATE " + game + "_image_board SET replycount = replycount - ? WHERE boardnum = ?";
	        }
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, totalDeletedCount);
	        pstmt.setInt(2, dto.getBoardnum());
	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	}

}
