package project01.member.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import java.util.List;


import project01.site.bean.DataBaseConnection;
public class MemberDAO extends DataBaseConnection{
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private String sql = null;
	
	public int memberInsert(MemberDTO dto) {	// 회원가입시 db에 추가하는 메서드
		int result = 0;;
		dto.setEmailPlusDomain(dto.getEmail(), dto.getEmailDomain());
		dto.setBirth(dto.getBirthYear(), dto.getBirthMonth(), dto.getBirthDay());	//쪼개진 이메일, 생년월일 합치는과정
		if (idCheck(dto.getId()) == false) {
			return -3; // ID 유효성 체크
		}
		if (pwCheck(dto.getPw()) == false) {
			return -4; // PW 유효성 체크
		}
		if(nickCheck(dto.getNickname()) == false) {
            return -5; // 닉네임 유효성 체크
            }
		if(!isNickDuplicate(dto.getNickname())&&!isIdDuplicate(dto.getId())) {
			try {
				conn = getOracleConnection();
				sql = "insert into member values(?, ?, ?, ?, 0, ?, sysdate, ?, ?, ?, ?, 0 ,0, null)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, dto.getId());
				pstmt.setString(2, dto.getPw());
				pstmt.setString(3, dto.getName());
				pstmt.setString(4, dto.getEmailPlusDomain());
				pstmt.setString(5, dto.getNickname());
				pstmt.setString(6, dto.getBirth());
				pstmt.setString(7, dto.getGender());
				pstmt.setString(8, dto.getPw_quiz());
				pstmt.setString(9, dto.getPw_answer());
				pstmt.executeUpdate();
				
				sql = "insert into STATUS_PROFILE values(0,100,1,?,NULL)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, dto.getNickname());
				result = pstmt.executeUpdate();
			}catch (SQLIntegrityConstraintViolationException e) {
		        // Primary Key 또는 Unique 제약 조건 위반 시 처리
		        // 예외를 사용자 친화적인 메시지로 변환
		        result = -1; // 중복 ID나 닉네임에 대한 에러 코드로 반환
		    } catch (Exception e) {
		        // 기타 예외에 대한 처리
		        e.printStackTrace(); // 실제 로그는 서버 측에서 기록, 사용자에게는 노출하지 않음
		        result = -2; // 일반적인 예외 상황에 대한 에러 코드로 반환
			}finally {
				dbClose(rs, pstmt, conn);
			}
		}
		return result;
	}
	public int memberUpdate(MemberDTO dto) {
		int result = 0;
		try {
			conn = getOracleConnection();
			sql = "update member set name=? , birth=? , email=? where nickname=? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getBirth());
			pstmt.setString(3, dto.getEmail());
			pstmt.setString(4, dto.getNickname());
			
			result = pstmt.executeUpdate();
			
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			dbClose(rs,pstmt,conn);
		}
		return result;
	}
	 public void updateMaxEx(String nickname) {		// 유저의 레벨에 따른 최대경험치를 db에서 불러와 status_profile 테이블에 넣는 메서드
	        try {
	            conn = getOracleConnection();
	            sql = "UPDATE STATUS_PROFILE SP " +
	                  "SET SP.MAX_EX = ( " +
	                  "    SELECT L.MAX_EX " +
	                  "    FROM LEVELS L " +
	                  "    WHERE L.LV = SP.LV " +
	                  ") " +
	                  "WHERE SP.NICKNAME = ?";
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, nickname);
	            pstmt.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            dbClose(null, pstmt, conn);
	        }
	    }
	 	
	 public void increaseExperience(String nickname, int actionType) {
		    int experienceToAdd;

		    if (actionType == 1) {
		        experienceToAdd = 20;  // 글쓰기 시 경험치 20 증가
		    } else if (actionType == 2) {
		        experienceToAdd = 5;   // 댓글 작성 시 경험치 5 증가
		    } else if(actionType == 3) {
		    	experienceToAdd = 5; // 내 게시글의 추천수가 오를 시 경험치 5 증가
		    } else if(actionType == 4) { 
		    	experienceToAdd = 50; // 내 게시글이 베스트 게시글로 선정됐을 시 경험치 50 증가
		    }
		    else {
		        return; // 유효하지 않은 actionType 처리
		    }

		    try {
		        conn = getOracleConnection();
		        conn.setAutoCommit(false); // 트랜잭션 시작

		        // 현재 경험치, 최대 경험치, 레벨 가져오기
		        sql = "SELECT EX, MAX_EX, LV FROM STATUS_PROFILE WHERE NICKNAME = ?";
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, nickname);
		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            int currentEx = rs.getInt("EX");
		            int newEx = currentEx + experienceToAdd;
		            int maxEx = rs.getInt("MAX_EX");
		            int currentLv = rs.getInt("LV");

		            // 리소스 해제
		            rs.close();
		            pstmt.close();

		            // 레벨 업 처리
		            while (newEx >= maxEx) {
		                newEx -= maxEx;
		                currentLv += 1;

		                // 다음 레벨의 MAX_EX 가져오기
		                sql = "SELECT MAX_EX FROM LEVELS WHERE LV = ?";
		                PreparedStatement pstmtLevel = conn.prepareStatement(sql);
		                pstmtLevel.setInt(1, currentLv);
		                ResultSet rsLevel = pstmtLevel.executeQuery();

		                if (rsLevel.next()) {
		                    maxEx = rsLevel.getInt("MAX_EX");
		                } else {
		                    // 다음 레벨이 없을 경우 현재 레벨을 유지하고 루프 종료
		                    newEx += maxEx; // 경험치 복구
		                    currentLv -= 1;
		                    break;
		                }

		                // 리소스 해제
		                rsLevel.close();
		                pstmtLevel.close();
		            }

		            // STATUS_PROFILE 업데이트
		            sql = "UPDATE STATUS_PROFILE SET EX = ?, LV = ?, MAX_EX = ? WHERE NICKNAME = ?";
		            PreparedStatement pstmtUpdate = conn.prepareStatement(sql);
		            pstmtUpdate.setInt(1, newEx);
		            pstmtUpdate.setInt(2, currentLv);
		            pstmtUpdate.setInt(3, maxEx);
		            pstmtUpdate.setString(4, nickname);
		            pstmtUpdate.executeUpdate();

		            // 리소스 해제
		            pstmtUpdate.close();

		            conn.commit(); // 트랜잭션 커밋
		        }
		    } catch (Exception e) {
		        try {
		            if (conn != null && !conn.isClosed()) {
		                conn.rollback(); // 트랜잭션 롤백
		            }
		        } catch (Exception rollbackEx) {
		            rollbackEx.printStackTrace();
		        }
		        e.printStackTrace();
		    } finally {
		        dbClose(rs, pstmt, conn);
		    }
		}
	public int memberDelete(String nick) {	// 멤버삭제 메서드
		int result = 0;
		try {
			conn = getOracleConnection();
			sql = "delete from member where nickname = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			result = pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			dbClose(rs, pstmt, conn);
		}
		return result;
	}
	public String getLostId(String name, String email) {	// 아이디 찾기 메서드
		String result = null;
		try {
			conn = getOracleConnection();
			sql = "select id from member where name=? and email=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, email);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getString("id");
			}
			
		}catch (Exception e) {
			e.printStackTrace();//
		}finally {
			dbClose(rs, pstmt, conn);
		}
		return result;
	}
	public String getLostPw(String id, String email) {		// 비밀번호 찾기 메서드
		String result = null;
		try {
			conn = getOracleConnection();
			sql = "select pw from member where id =? and email =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, email);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getString("pw");
			}
			
		}catch (Exception e) {
			e.printStackTrace();//
		}finally {
			dbClose(rs, pstmt, conn);
		}
		return result;
	}
	public boolean loginCheck(MemberDTO dto) {		// 로그인할때 입력값이 올바른지 확인하는 메서드
	    boolean result = false;
	    try {
	        conn = getOracleConnection();
	        sql = "select * from member where id=? and pw=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, dto.getId());
	        pstmt.setString(2, dto.getPw());
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	            result = true;
	            dto.setNickname(rs.getString("nickname"));
	            dto.setIsadmin(rs.getInt("isadmin")); // isadmin 속성 설정
	            dto.setIs_banned(rs.getInt("is_banned")); // is_banned 속성 설정
	            dto.setUnban_date(rs.getString("unban_date")); // unban_date 속성 설정
	        }
	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return result;
	}
	public MemberDTO memberId(String nickname) { // 로그인한 계정의 정보를 불러오는 메서드
	    MemberDTO dto = null;
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT m.*, sp.LV, sp.EX, sp.MAX_EX " +
	              "FROM member m " +
	              "JOIN STATUS_PROFILE sp ON m.nickname = sp.nickname " +
	              "WHERE m.nickname = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, nickname);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            dto = new MemberDTO();
	            dto.setId(rs.getString("id"));
	            dto.setName(rs.getString("name"));
	            dto.setEmail(rs.getString("email"));
	            dto.setNickname(rs.getString("nickname"));
	            dto.setJoin_reg(rs.getString("join_reg"));
	            dto.setBirth(rs.getString("birth"));
	            dto.setGender(rs.getString("gender"));
	            dto.setPw_quiz(rs.getString("pw_quiz"));
	            dto.setPw_answer(rs.getString("pw_answer"));
	            dto.setLevel(rs.getInt("LV")); // 현재 레벨 설정
	            dto.setExp(rs.getInt("EX")); // 현재 경험치 설정
	            dto.setMaxExp(rs.getInt("MAX_EX")); // 최대 경험치 설정
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return dto;
	}
	public boolean isIdDuplicate(String id) {		//id 중복 확인하는 메서드
	    boolean isDuplicate = false;
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT 1 FROM member WHERE id = ?";  // 단순히 존재 여부만 확인
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, id);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            isDuplicate = true;  // 레코드가 존재하면 중복된 ID임을 확인
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return isDuplicate;
	}
	public boolean isNickDuplicate(String nick) {		//닉네임 중복 확인하는 메서드
	    boolean isDuplicate = false;
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT 1 FROM member WHERE nickname = ?";  // 단순히 존재 여부만 확인
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, nick);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            isDuplicate = true;  // 레코드가 존재하면 중복된 ID임을 확인
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return isDuplicate;
	}
	public boolean checkPs(String nick, String inputPassword) {
	       boolean isCorrect = false;
	       try {
	           conn = getOracleConnection(); // DB 연결
	           sql = "SELECT * FROM member WHERE nickname = ? and pw = ?"; // 비밀번호 확인 쿼리
	           pstmt = conn.prepareStatement(sql);
	           pstmt.setString(1, nick); // 사용자 ID 바인딩
	           pstmt.setString(2, inputPassword);
	           rs = pstmt.executeQuery();
	           
	           if (rs.next()) {
	               isCorrect = true; // 입력된 비밀번호와 비교
	           }
	       } catch (Exception e) {
	           e.printStackTrace();
	       } finally {
	           dbClose(rs, pstmt, conn); // 리소스 닫기
	       }
	       return isCorrect;
	}
	
	// 프로필 확인
	public MemberDTO getProfile(String nick) {
		MemberDTO dto = null;
		
		try {
			conn = getOracleConnection(); // DB 연결
			sql = "SELECT * FROM STATUS_PROFILE WHERE NICKNAME = ?"; // 프로필 확인 쿼리
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick); // 사용자 ID 바인딩
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dto = new MemberDTO();
				dto.setNickname(rs.getString("NICKNAME"));
				dto.setLevel(rs.getInt("LV"));
				dto.setExp(rs.getInt("EX"));
				dto.setMaxExp(rs.getInt("MAX_EX"));
				dto.setGreeting(rs.getString("GREETING"));
			}		
		} catch (Exception e) {
			e.printStackTrace();// 
		}finally {
			dbClose(rs, pstmt, conn);
		}
		
		return dto;
	}
	// 인삿말 수정
	public void updateGreeting(String nick, String greeting) {
		try {
			conn = getOracleConnection(); // DB 연결
			sql = "UPDATE STATUS_PROFILE SET GREETING = ? WHERE NICKNAME = ?"; // 인삿말 수정 쿼리
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, greeting); // 사용자 ID 바인딩
			pstmt.setString(2, nick);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();// 
		} finally {
			dbClose(rs, pstmt, conn);
		}
	}
	// 회원 차단(쪽지)
	public void blockMember(String blocker_nick, String blocked_nick) {
		try {
			conn = getOracleConnection(); // DB 연결
			sql = "INSERT INTO BLOCK(blocker_nick, blocked_nick, blocked_date) VALUES(?, ?, sysdate)"; // 차단 쿼리
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, blocker_nick); // 사용자 ID 바인딩
			pstmt.setString(2, blocked_nick);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();// 
		} finally {
			dbClose(rs, pstmt, conn);
		}
	}
	// 차단 해제(쪽지)
	public void unblockMember(String blocker_nick, String blocked_nick) {
		try {
			conn = getOracleConnection(); // DB 연결
			sql = "DELETE FROM BLOCK WHERE blocker_nick = ? AND blocked_nick = ?"; // 차단 해제 쿼리
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, blocker_nick); // 사용자 ID 바인딩
			pstmt.setString(2, blocked_nick);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();// 
		} finally {
			dbClose(rs, pstmt, conn);
		}
	}
	//차단 목록(쪽지)
	public List<String> getBlockedMembers(String blocker_nick) {
		List<String> blockedMembers = new ArrayList<>();

		try {
			conn = getOracleConnection(); // DB 연결
			sql = "SELECT BLOCKED_NICK FROM BLOCK WHERE BLOCKER_NICK = ?"; // 차단 목록 쿼리
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, blocker_nick); // 사용자 ID 바인딩
			rs = pstmt.executeQuery();
			while (rs.next()) {
				blockedMembers.add(rs.getString("BLOCKED_NICK"));
			}
		} catch (Exception e) {
			e.printStackTrace();// 
		} finally {
			dbClose(rs, pstmt, conn);
		}

		return blockedMembers;
	}
	public boolean idCheck(String id) {
		// id는 5~12 사이 글자수
		// 첫글자는 알파벳만 허용
		// id는 알파벳 숫자 구성(숫자가 최소 하나이상 있어야함) charAt(반복문)
		boolean result = false;
		if(!(id.length() >=5 && id.length() <= 12)) {
			
			return false;
		}
		if(!((id.charAt(0)>=65 && id.charAt(0) <= 90)||(id.charAt(0)>=97 && id.charAt(0) <= 122))) {
			
			return false;
		}
		for(int i = 1; i<id.length(); i++) {
			if(!((id.charAt(i)>=65 && id.charAt(i) <= 90)||(id.charAt(i)>=97 && id.charAt(i) <= 122)
					||(id.charAt(i)>=48 && id.charAt(i) <= 57))) {
				return false;
			}
		}
		for(int i = 1; i<id.length(); i++) {
			if(id.charAt(i)>=48 && id.charAt(i) <= 57) {
				result = true;
			}
		}
		return result;
	}
	public boolean pwCheck(String pw) {
	    // 글자수 7~18
	    if (!(pw.length() >= 7 && pw.length() <= 18))
	        return false;

	    // 문자열의 각 유형 검사
	    String symbols = "~!@#$%^&*()_+-=";
	    boolean hasSpecial = pw.chars().anyMatch(ch -> symbols.indexOf(ch) >= 0); // 특수문자 포함 여부
	    boolean hasDigit = pw.chars().anyMatch(Character::isDigit);             // 숫자 포함 여부
	    boolean hasLetter = pw.chars().anyMatch(Character::isLetter);           // 영어 포함 여부

	    // 모든 조건 만족 확인
	    return hasSpecial && hasDigit && hasLetter;
	}

	public boolean nickCheck(String nick) {
	    // 글자수 2~7
	    if (nick.length() < 2 || nick.length() > 7) 
	        return false;
	    
	    // 한글, 영어, 숫자만 허용 (특수문자 및 공백 금지)
	    if (!nick.matches("^[a-zA-Z가-힣0-9]*$"))
	        return false;
	    
	    // 숫자만 있는 닉네임은 금지
	    if (nick.matches("^[0-9]*$"))
	        return false;

	    return true;
	}
	
	public boolean checkUser(String id, String email) {
	    boolean exists = false;
	    try {
	        // 데이터베이스 연결
	        conn = getOracleConnection(); // Oracle DB 연결 메서드

	        // SQL 쿼리 작성
	        sql = "SELECT COUNT(*) FROM member WHERE id = ? AND email = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, id);
	        pstmt.setString(2, email);

	        // 쿼리 실행 및 결과 처리
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            exists = rs.getInt(1) > 0; // COUNT(*)가 1 이상이면 true
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); // 오류 로그 출력
	    } finally {
	        // 리소스 정리
	        dbClose(rs, pstmt, conn);
	    }

	    return exists;
	}
	//회원의 레벨을 불러오는 메서드
	public int getLevel(String nick) {
		int level = 0;
		try {
			conn = getOracleConnection();
			sql = "SELECT LV FROM STATUS_PROFILE WHERE NICKNAME = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				level = rs.getInt("LV");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose(rs, pstmt, conn);
		}
		return level;
	}
	//랭킹 불러오기
	   public List<MemberDTO> getRanking(){
	      List<MemberDTO> list = new ArrayList<>();
	      try {
	         conn = getOracleConnection();
	         sql = "SELECT m.nickname, sp.lv, sp.ex FROM member m JOIN status_profile sp ON m.nickname = sp.nickname WHERE m.isadmin = 0 AND ROWNUM <= 10 ORDER BY sp.lv DESC, sp.ex DESC";
	         pstmt = conn.prepareStatement(sql);
	         rs = pstmt.executeQuery();
	         while(rs.next()) {
	            MemberDTO dto = new MemberDTO();
	            dto.setNickname(rs.getString("nickname"));
	            dto.setLevel(rs.getInt("lv"));
	            list.add(dto);
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         dbClose(rs, pstmt, conn);
	      }
	      return list;
	   }
	
	
}
	


