package project01.report.bean;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import project01.member.bean.MemberDTO;
import project01.site.bean.DataBaseConnection;

public class ReportDAO extends DataBaseConnection{
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private String sql = null;
	
	
	// 신고 추가
	public void addReport(ReportDTO report, String type) {
	    try {
	        conn = getOracleConnection();
	        sql = "INSERT INTO REPORT (game_name, post_id, comment_id, reporter_id, reason, reg, is_image) VALUES (?, ?, ?, ?, ?, SYSDATE, ?)";
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, report.getGame_name());
	        pstmt.setInt(2, report.getPost_id());

	        // comment_id가 NULL인지 확인
	        if (report.getComment_id() == null) {
	            pstmt.setNull(3, java.sql.Types.INTEGER); // NULL 값 설정
	        } else {
	            pstmt.setInt(3, report.getComment_id());
	        }
	        
	        pstmt.setString(4, report.getReporter_id());
	        pstmt.setString(5, report.getReason());
	        if(type.equals("image")) {
            	pstmt.setInt(6, 1);
            }else {
            	pstmt.setInt(6, 0);
            }
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	}
	
	//신고처리
	public void addReportAction(ReportDTO report) {
	    try {
	        conn = getOracleConnection();
	        sql = "INSERT INTO REPORT_ACTION (REPORT_ID, ADMIN_ID, ACTION_TAKEN, ACTION_DETAIL, reg) VALUES (?, ?, ?, ?, SYSDATE)";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, report.getReport_id());
	        pstmt.setString(2, report.getAdmin_id());
	        pstmt.setString(3, report.getAction_taken());
	        pstmt.setString(4, report.getAction_detail());
	        pstmt.executeUpdate();
	        
	        sql = "update report set iscompleted = 'Y' where report_id = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, report.getReport_id());
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	}
	//회원제재
	public void memberPanalty(String memberNick) {
		int warnStack = 0;
		try {
			conn = getOracleConnection();
			sql = "select warn_stack from member where nickname = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memberNick);
			rs = pstmt.executeQuery();
			 if (rs.next()) {
		            warnStack = rs.getInt("warn_stack");
		        }
			sql = "update member set warn_stack = warn_stack + 1";

			if(warnStack == 0) {
				
			}else if(warnStack == 1) {
				sql = sql + ",is_banned = 1, unban_date = trunc(sysdate + 1) ";
			}else if(warnStack == 2) {
				sql = sql + ",is_banned = 1, unban_date = trunc(sysdate + 3) ";
			}else if(warnStack == 3) {
				sql = sql + ",is_banned = 1, unban_date = trunc(sysdate + 7) ";
			}else if(warnStack == 4) {
				sql = sql + ",is_banned = 1, unban_date = trunc(sysdate + 30) ";
			}else if(warnStack == 5) {
				sql = sql + ",is_banned = 1, unban_date = trunc(sysdate + 365) ";
			}else {
				sql = sql + ",is_banned = 1, unban_date = trunc(sysdate + 30000) ";
			}
			sql = sql + "where nickname = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memberNick);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			dbClose(rs, pstmt, conn);
		}
	}
	//제재 내역
	public List<MemberDTO> getMemberPanaltyList(int offset, int limit) {
		List<MemberDTO> memberList = new ArrayList<>();
		try {
			conn = getOracleConnection();
			sql = "SELECT nickname, warn_stack, is_banned, unban_date FROM member WHERE warn_stack >= 1 ORDER BY warn_stack DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, limit);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				MemberDTO member = new MemberDTO();
				member.setNickname(rs.getString("nickname"));
				member.setWarn_stack(rs.getInt("warn_stack"));
				member.setIs_banned(rs.getInt("is_banned"));
				member.setUnban_date(rs.getString("unban_date"));
				memberList.add(member);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose(rs, pstmt, conn);
		}
		return memberList;
	}
	// 신고 + 처리 목록과 검색 통합
	public List<ReportDTO> getReportAndSearchList(int offset, int limit, String searchType, String searchWord) {        
	    List<ReportDTO> reportList = new ArrayList<>();
	    try {
	        conn = getOracleConnection();

	        // 기본 SQL
	        sql = "SELECT r.report_id, r.game_name, r.post_id, r.comment_id, r.reporter_id, r.reason, r.reg AS report_reg, ";
	        sql += "r.iscompleted, r.is_image, ra.action_taken, ra.action_detail, ra.reg AS action_reg, ra.admin_id ";
	        sql += "FROM report r ";
	        sql += "LEFT JOIN report_action ra ON r.report_id = ra.report_id ";

	        // 검색 조건 추가
	        if (searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {
	            if (!List.of("game_name", "reporter_id", "reason").contains(searchType)) {
	                throw new IllegalArgumentException("Invalid search type");
	            }

	            if ("reason".equals(searchType)) {
	                sql += "WHERE CONTAINS(r.reason, ?) > 0 ";
	            } else {
	                sql += "WHERE r." + searchType + " LIKE ? ";
	            }
	        }

	        // 정렬 및 페이징 추가
	        sql += "ORDER BY r.report_id DESC ";
	        sql += "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

	        pstmt = conn.prepareStatement(sql);

	        int paramIndex = 1;
	        if (searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {
	            pstmt.setString(paramIndex++, "%" + searchWord + "%");
	        }

	        pstmt.setInt(paramIndex++, offset);
	        pstmt.setInt(paramIndex, limit);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            ReportDTO report = new ReportDTO();
	            report.setReport_id(rs.getInt("report_id"));
	            report.setGame_name(rs.getString("game_name"));
	            report.setPost_id(rs.getInt("post_id"));

	            // comment_id 처리
	            Object commentIdObj = rs.getObject("comment_id");
	            if (commentIdObj instanceof BigDecimal) {
	                report.setComment_id(((BigDecimal) commentIdObj).intValue());
	            } else if (commentIdObj instanceof Integer) {
	                report.setComment_id((Integer) commentIdObj);
	            } else {
	                report.setComment_id(null);
	            }

	            report.setReporter_id(rs.getString("reporter_id"));
	            report.setReason(rs.getString("reason"));
	            report.setReg_report(rs.getString("report_reg"));
	            report.setIsCompleted(rs.getString("iscompleted"));
	            report.setIs_image(rs.getInt("is_image"));
	            report.setAction_taken(rs.getString("action_taken"));
	            report.setAction_detail(rs.getString("action_detail"));
	            report.setReg_action(rs.getString("action_reg"));
	            report.setAdmin_id(rs.getString("admin_id"));

	            reportList.add(report);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }

	    return reportList;
	}

	//신고, 처리 목록 카운트
	public int getTotalReportCount(String searchType, String searchWord) {
	    int count = 0;
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT COUNT(*) FROM report r ";
	        if (searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {
	            if ("reason".equals(searchType)) {
	                sql = sql + "WHERE CONTAINS(r.reason, ?) > 0";
	            } else {
	                sql = sql + "WHERE r." + searchType + " LIKE ?";
	            }
	        }
	        pstmt = conn.prepareStatement(sql);
	        if (searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {

	                pstmt.setString(1, "%" + searchWord + "%");

	        }
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

public int getTotalMemberPanaltyCount() {
    int count = 0;
    try {
        conn = getOracleConnection();
        sql = "SELECT COUNT(*) FROM member WHERE is_banned = 1";
        pstmt = conn.prepareStatement(sql);
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
