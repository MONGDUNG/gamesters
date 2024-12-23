package project01.admin.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import project01.site.bean.DataBaseConnection;

/**
 * AdminDAO 클래스는 관리자 기능과 관련된 데이터베이스 작업을 담당합니다.
 * 기능: 게시판 추가/삭제, 금지어 관리, 카테고리 관리 등
 */
public class AdminDAO extends DataBaseConnection {
    private Connection conn = null;
    private PreparedStatement pstmt = null;
    private ResultSet rs = null;
    private String sql = null;

    /**
     * 새로운 게시판을 생성합니다.
     * @param boardGame 영문 게시판 이름
     * @param boardGame_kr 한글 게시판 이름
     */
    public void addBoard(String boardGame, String boardGame_kr) {
        try {
            conn = getOracleConnection();
            // 일반 게시판 테이블 생성
            sql = "CREATE TABLE " + boardGame + "_BOARD (\r\n"
                    + "    BOARDNUM NUMBER PRIMARY KEY, -- 글번호 (Primary Key)\r\n"
                    + "    TITLE VARCHAR2(200) NOT NULL, -- 제목\r\n"
                    + "    NICKNAME VARCHAR2(50) NOT NULL, -- 작성자 닉네임\r\n"
                    + "    CONTENT clob NOT NULL, -- 게시글 내용\r\n"
                    + "    READCOUNT NUMBER DEFAULT 0, -- 조회수 (기본값 0)\r\n"
                    + "    REPLYCOUNT NUMBER DEFAULT 0, -- 댓글 수 (기본값 0)\r\n"
                    + "    UPCNT NUMBER DEFAULT 0, -- 추천 수 (기본값 0)\r\n"
                    + "    DWNCNT NUMBER DEFAULT 0, -- 비추천 수 (기본값 0)\r\n"
                    + "    REG DATE DEFAULT SYSDATE, -- 작성 시간\r\n"
                    + "    CATEGORY VARCHAR2(50), -- 카테고리\r\n"
                    + "    FILECOUNT NUMBER DEFAULT 0, -- 파일 개수 (기본값 0)\r\n"
                    + "    ORDER_COL NUMBER DEFAULT 0 -- 게시글 올리고 내리기 (기본값 0)\r\n"
                    + ")";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // 이미지 게시판 테이블 생성
            sql = "CREATE TABLE " + boardGame + "_IMAGE_BOARD (\r\n"
                    + "    BOARDNUM NUMBER PRIMARY KEY, -- 글번호 (Primary Key)\r\n"
                    + "    TITLE VARCHAR2(200) NOT NULL, -- 제목\r\n"
                    + "    NICKNAME VARCHAR2(50) NOT NULL, -- 작성자 닉네임\r\n"
                    + "    CONTENT clob NOT NULL, -- 게시글 내용\r\n"
                    + "    READCOUNT NUMBER DEFAULT 0, -- 조회수 (기본값 0)\r\n"
                    + "    REPLYCOUNT NUMBER DEFAULT 0, -- 댓글 수 (기본값 0)\r\n"
                    + "    UPCNT NUMBER DEFAULT 0, -- 추천 수 (기본값 0)\r\n"
                    + "    DWNCNT NUMBER DEFAULT 0, -- 비추천 수 (기본값 0)\r\n"
                    + "    REG DATE DEFAULT SYSDATE, -- 작성 시간\r\n"
                    + "    FILECOUNT NUMBER DEFAULT 0, -- 파일 개수 (기본값 0)\r\n"
                    + "    ORDER_COL NUMBER DEFAULT 0 -- 게시글 올리고 내리기 (기본값 0)\r\n"
                    + ")";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // 일반 게시판용 시퀀스 생성
            sql = "create sequence " + boardGame + "_BOARD_SEQ start with 1 increment by 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // 이미지 게시판용 시퀀스 생성
            sql = "create sequence " + boardGame + "_image_BOARD_SEQ start with 1 increment by 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // 게시판 투표 테이블 생성
            sql = "CREATE TABLE " + boardGame + "_BOARD_VOTE (\r\n"
                    + "    boardnum NUMBER,\r\n"
                    + "    nickname VARCHAR2(50) NOT NULL,\r\n"
                    + "    vote_type VARCHAR2(10), -- 'UP' 또는 'DOWN'\r\n"
                    + "    vote_date DATE DEFAULT SYSDATE,\r\n"
                    + "    is_image NUMBER, -- 이미지 게시판 여부 (1: 이미지 게시판, 0: 일반 게시판)\r\n"
                    + "    PRIMARY KEY (boardnum, nickname, vote_type, is_image)\r\n"
                    + ")";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // INDEX_BOARD_GAME 테이블에 정보 추가
            sql = "INSERT INTO INDEX_BOARD_GAME VALUES(INDEX_BOARD_seq.NEXTVAL, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, boardGame);
            pstmt.setString(2, boardGame_kr);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == 955) { // ORA-00955: 이미 존재하는 객체
                System.out.println("테이블이 이미 존재합니다: " + boardGame + "_BOARD");
            } else {
                e.printStackTrace();
            }
        } finally {
            dbClose(rs, pstmt, conn);
        }
    }

    /**
     * 게시판을 삭제합니다.
     * @param boardGame 삭제할 게시판 이름
     * @return 성공 시 1, 실패 시 -1 또는 -2
     */
    public int deleteBoard(String boardGame) {
        int result = 0;
        try {
            conn = getOracleConnection();
            // BEST_BOARD 테이블에서 삭제
            sql = "DELETE FROM BEST_BOARD WHERE GAME_NAME = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, boardGame);
            pstmt.executeUpdate();

            // CATEGORIES 테이블에서 삭제
            sql = "DELETE FROM categories WHERE game_name = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, boardGame);
            pstmt.executeUpdate();

            // 게시판 테이블 삭제
            sql = "DROP TABLE " + boardGame + "_BOARD";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // 이미지 게시판 테이블 삭제
            sql = "DROP TABLE " + boardGame + "_IMAGE_BOARD";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // 투표 테이블 삭제
            sql = "DROP TABLE " + boardGame + "_BOARD_VOTE";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // 시퀀스 삭제
            sql = "DROP SEQUENCE " + boardGame + "_BOARD_SEQ";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            sql = "DROP SEQUENCE " + boardGame + "_image_BOARD_SEQ";
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();

            // INDEX_BOARD_GAME 테이블에서 삭제
            sql = "DELETE FROM INDEX_BOARD_GAME WHERE game = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, boardGame);
            pstmt.executeUpdate();

            result = 1;
        } catch (SQLException e) {
            if (e.getErrorCode() == 942) { // ORA-00942: 테이블 또는 뷰가 존재하지 않음
                System.out.println("테이블이 존재하지 않습니다: " + boardGame + "_BOARD");
                result = -1;
            } else {
                e.printStackTrace();
                result = -2;
            }
        } finally {
            dbClose(rs, pstmt, conn);
        }
        return result;
    }

    /**
     * 금지어를 추가합니다.
     * @param banWord 추가할 금지어
     */
    public void addBanWord(String banWord) {
        try {
            conn = getOracleConnection();
            sql = "INSERT INTO ban_word VALUES (?, ban_word_seq.NEXTVAL)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, banWord);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            dbClose(rs, pstmt, conn);
        }
    }
    /**
     * 금지어를 삭제합니다.
     * @param banWord 삭제할 금지어
     */
	public int deleteBanWord(String banWord) {
	    int result = 0;
	    try {
	        conn = getOracleConnection();
	        sql = "DELETE FROM ban_word WHERE word = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, banWord);
	        result = pstmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	        result = -1;
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return result;
	}
	/**
	 * 금지어 목록을 페이지네이션 방식으로 조회합니다.
	 * @param offset 시작 위치
	 * @param limit 조회할 최대 개수
	 * @return 금지어 목록
	 */
	public List<String> getBanWords(int offset, int limit) {
	    List<String> banWords = new ArrayList<>();
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT word FROM ban_word ORDER BY word OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, limit);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            banWords.add(rs.getString("word"));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return banWords;
	}
	/**
	 * 금지어 총 개수를 반환합니다.
	 * @return 금지어 개수
	 */
	public int getBanWordCount() {
	    int count = 0;
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT COUNT(*) FROM ban_word";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return count;
	}
	/**
	 * 새로운 카테고리를 추가합니다.
	 * @param game 게임 이름
	 * @param categoryName 추가할 카테고리 이름
	 */
	public void addCategory(String game, String categoryName) {
	    try {
	        conn = getOracleConnection();
	        sql = "INSERT INTO categories (game_name, category_name, created_at) VALUES (?, ?, SYSDATE)";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, game);
	        pstmt.setString(2, categoryName);
	        pstmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	}
	/**
	 * 특정 카테고리를 삭제합니다.
	 * @param game 게임 이름
	 * @param categoryName 삭제할 카테고리 이름
	 */
	public void deleteCategory(String game, String categoryName) {
		try {
			conn = getOracleConnection();
			sql = "DELETE FROM categories WHERE game_name = ? AND category_name = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, game);
			pstmt.setString(2, categoryName);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dbClose(rs, pstmt, conn);
		}
	}
}

