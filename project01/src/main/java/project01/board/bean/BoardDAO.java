package project01.board.bean;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import project01.site.bean.DataBaseConnection;


public class BoardDAO extends DataBaseConnection{	// 게시판 DAO
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private String sql = null;
	
	public List<BoardDTO> getAllBoardGames(String searchWord, int start, int end ) {
	    List<BoardDTO> boardGames = new ArrayList<>();
	    try {
	        conn = getOracleConnection();
	        String baseSql = "SELECT game, game_kr FROM index_board_game";

	        // 검색 조건 추가
	        if (searchWord != null && !searchWord.isEmpty()) {
	            baseSql += " WHERE INSTR(game_kr, ?) > 0";
	        }

	        sql = "SELECT * FROM ("
	            + "    SELECT ROWNUM rnum, d.* FROM ("
	            + "        " + baseSql + " ORDER BY game"
	            + "    ) d WHERE ROWNUM <= ?"
	            + ") WHERE rnum >= ?";

	        pstmt = conn.prepareStatement(sql);

	        int paramIndex = 1;
	        if (searchWord != null && !searchWord.isEmpty()) {
	            pstmt.setString(paramIndex++, searchWord);
	        }
	        pstmt.setInt(paramIndex++, end);   // ROWNUM <= end
	        pstmt.setInt(paramIndex, start);   // rnum >= start

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            BoardDTO dto = new BoardDTO();
	            dto.setGameName(rs.getString("game"));
	            dto.setGameName_kr(rs.getString("game_kr"));
	            boardGames.add(dto);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return boardGames;
	}
	public int getNoOfBoardGames(String searchGame) {
		int noOfBoardGames = 0;
	    try{
	        conn = getOracleConnection();
	        sql = "SELECT COUNT(*) FROM index_board_game";
	           
	        if(searchGame != null && !searchGame.isEmpty()) {
	        sql += " WHERE INSTR(game_kr, ?) > 0";
	        }
	        pstmt = conn.prepareStatement(sql);
	           
	        if(searchGame != null && !searchGame.isEmpty()) {
	        	pstmt.setString(1, searchGame);
	        }	           
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            noOfBoardGames = rs.getInt(1);
	        }
	       } catch (SQLException e) {
	           e.printStackTrace();
	       } finally {
	           dbClose(rs, pstmt, conn);
	    }
	    return noOfBoardGames;
	}
	public String noPlaster (String nick, String game) {		// 도배방지를 위해 가장 최근에 쓴 게시글의 시각 구하는 메서드
		String result = null;
		try {
			conn = getOracleConnection();
	        sql = "SELECT REG FROM " + game + "_BOARD WHERE NICKNAME = ? order by reg desc"; //가장 최근에 쓴 글이 위로 올라오게 정렬
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, nick);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	        	result = rs.getString("reg");
	        }
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			dbClose(rs, pstmt, conn);
		}
		return result;
	}
	
	
	//////////////////////////////////////////////2024-12-18 검색기능을 추가한 메서드로 변경////////////////////////////////////////////////////////
	public List<BoardDTO> getBoardList(String game, int start, int end, String searchType, String searchWord) {   // 게시글 목록 가져오기 & 검색기능
	       List<BoardDTO> list0 = new ArrayList<>();
	       try {
	          conn = getOracleConnection();
	          // order_col = 0 인 일반게시글 가져오기
	          
	          //기본 SQL
	          String baseSql = "SELECT * FROM " +game+ "_BOARD WHERE order_col = 0"; 
	          
	          //검색조건 추가
	          if(searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {
	        	  if(searchType.equals("title")) {
	        		  baseSql += " AND INSTR(title, ?) > 0";
	        	  }else if(searchType.equals("nickname")){
	        		  baseSql += " AND INSTR(nickname, ?) > 0";
	        	  }else if(searchType.equals("content")) {
	        		  baseSql += " AND INSTR(content, ?) > 0";
	        	  }
	          }
	          
	          //페이징 및 정렬
	           sql = "SELECT * FROM ("
	                  + "    SELECT ROWNUM rnum, d.* FROM ("
	                  + "    " + baseSql + "ORDER BY boardnum DESC"
	                  + "    ) d WHERE ROWNUM <= ?"
	                  + ") WHERE rnum >= ?";
	              pstmt = conn.prepareStatement(sql);
	              
	              int paramIndex = 1; 
	              if(searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty())
	              {
	            	  pstmt.setString(paramIndex++, searchWord);	//검색어 넣고 paramInt 후증가
	            	  
	              }
	              pstmt.setInt(paramIndex++, end);
            	  pstmt.setInt(paramIndex, start);	//세번째에 start 삽입됨
	              
	              rs = pstmt.executeQuery();	             
	             
	              while (rs.next()) {
	                  BoardDTO dto = new BoardDTO();
	                  dto.setBoardnum(rs.getInt("boardnum"));
	                  dto.setTitle(rs.getString("title"));
	                  dto.setNickname(rs.getString("nickname"));
	                  dto.setContent(rs.getString("content"));
	                  dto.setReadcount(rs.getInt("readcount"));
	                  dto.setReplycount(rs.getInt("replycount"));
	                  dto.setUpcnt(rs.getInt("upcnt"));
	                  dto.setDwncnt(rs.getInt("dwncnt"));
	                  dto.setReg(rs.getString("reg"));
	                  dto.setFilecount(rs.getInt("filecount"));
	                  dto.setOrder_col(rs.getInt("order_col"));
	                  list0.add(dto);
	              }
	       } catch (Exception e) {
	           e.printStackTrace();
	       } finally {
	           dbClose(rs, pstmt, conn);
	       }
	       return list0;
	   }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public List<BoardDTO> getBoardList1(String game, int start, int end) {   // 게시글 목록 가져오기
	       List<BoardDTO> list1 = new ArrayList<>();
	       try {
	          
	          // order_col = 1 인 게시글들 먼저 가져오기
	           conn = getOracleConnection();
	           sql = "SELECT * FROM ("
	               + "    SELECT ROWNUM rnum, d.* FROM ("
	               + "        SELECT * FROM " + game + "_BOARD WHERE order_col = 1 ORDER BY order_col DESC, boardnum DESC"
	               + "    ) d WHERE ROWNUM <= ?"
	               + ") WHERE rnum >= ?";
	           pstmt = conn.prepareStatement(sql);
	           pstmt.setInt(1, end);   // ROWNUM <= end
	           pstmt.setInt(2, start); // rnum >= start
	           rs = pstmt.executeQuery();
	           while (rs.next()) {
	               BoardDTO dto = new BoardDTO();
	               dto.setBoardnum(rs.getInt("boardnum"));
	               dto.setTitle(rs.getString("title"));
	               dto.setNickname(rs.getString("nickname"));
	               dto.setContent(rs.getString("content"));
	               dto.setReadcount(rs.getInt("readcount"));
	               dto.setReplycount(rs.getInt("replycount"));
	               dto.setUpcnt(rs.getInt("upcnt"));
	               dto.setDwncnt(rs.getInt("dwncnt"));
	               dto.setReg(rs.getString("reg"));
	               dto.setFilecount(rs.getInt("filecount"));
	               dto.setOrder_col(rs.getInt("order_col"));
	               list1.add(dto);
	           }
	         
	       } catch (Exception e) {
	           e.printStackTrace();
	       } finally {
	           dbClose(rs, pstmt, conn);
	       }
	       return list1;
	   }
	
	 public void upOrder(int boardnum, String game) {		//게시글올리기
	      try {
	         conn = getOracleConnection();
	         sql = "UPDATE " + game + "_BOARD SET order_col = 1 WHERE boardnum = ?";
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, boardnum);
	         pstmt.executeUpdate();
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         dbClose(rs, pstmt, conn);
	      }
	   }
	 public void downOrder(int boardnum, String game) {		//게시글 내리기
	      try {
	         conn = getOracleConnection();
	         sql = "UPDATE " + game + "_BOARD SET order_col = 0 WHERE boardnum = ?";
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, boardnum);
	         pstmt.executeUpdate();
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         dbClose(rs, pstmt, conn);
	      }
	   }
	//order_col 찾기
	   public int order_colSearch(int boardnum, String game) {
	      int result = 0;
	      try {
	         conn = getOracleConnection();
	         sql = "SELECT order_col FROM " + game + "_BOARD WHERE boardnum = ?";
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, boardnum);
	         rs = pstmt.executeQuery();
	         if(rs.next()) {
	            result = rs.getInt(1);
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         dbClose(rs, pstmt, conn);
	      }
	      return result;
	   }

	 

	public List<BoardDTO> getCategoryBoardList(String game, int start, int end, String category) { // 해당 카테고리의 게시글 목록 가져오기
	    List<BoardDTO> list = new ArrayList<>();
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT * FROM ("
	            + "    SELECT ROWNUM rnum, d.* FROM ("
	            + "        SELECT * FROM " + game + "_BOARD WHERE category = ? ORDER BY boardnum DESC"
	            + "    ) d WHERE ROWNUM <= ?"
	            + ") WHERE rnum >= ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, category);
	        pstmt.setInt(2, end);   // ROWNUM <= end
	        pstmt.setInt(3, start); // rnum >= start
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            BoardDTO dto = new BoardDTO();
	            dto.setBoardnum(rs.getInt("boardnum"));
	            dto.setTitle(rs.getString("title"));
	            dto.setNickname(rs.getString("nickname"));
	            dto.setContent(rs.getString("content"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setReplycount(rs.getInt("replycount"));
	            dto.setUpcnt(rs.getInt("upcnt"));
	            dto.setDwncnt(rs.getInt("dwncnt"));
	            dto.setReg(rs.getString("reg"));
	            dto.setFilecount(rs.getInt("filecount"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return list;
	}
	public List<BoardDTO> getBestBoardList(int start, int end) {			// 베스트 게시글 목록 가져오기
	    List<BoardDTO> list = new ArrayList<>();	
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT * FROM ("  
	            + "    SELECT ROWNUM rnum, d.* FROM ("
	            + "        SELECT * FROM BEST_BOARD WHERE is_image = 0 ORDER BY BEST_NUM DESC"
	            + "    ) d WHERE ROWNUM <= ?"
	            + ") WHERE rnum >= ?";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, end);   // ROWNUM <= end
	        pstmt.setInt(2, start); // rnum >= start
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            BoardDTO dto = new BoardDTO();
	            dto.setBoardnum(rs.getInt("BOARD_NUM"));
	            dto.setTitle(rs.getString("TITLE"));
	            dto.setNickname(rs.getString("NICKNAME"));
	            dto.setContent(rs.getString("CONTENT"));
	            dto.setReadcount(rs.getInt("READ_COUNT"));
	            dto.setReplycount(rs.getInt("REPLY_COUNT"));
	            dto.setUpcnt(rs.getInt("UPCNT"));
	            dto.setDwncnt(rs.getInt("DWNCNT"));
	            dto.setReg(rs.getString("REG_DATE"));
	            dto.setFilecount(rs.getInt("FILE_COUNT"));
	            dto.setGameName(rs.getString("GAME_NAME"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return list;
	}
	
	//////////////////////////////////////2024-12-19 수정/////////////////////////////////
	public int getTotalCount(String game, String searchType, String searchWord) {
	    int count = 0;
	    try {
	        conn = getOracleConnection();
	        String baseSql = "SELECT COUNT(*) FROM " + game + "_BOARD";
	        
	        if(searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {
	        	 baseSql += " WHERE INSTR(" +searchType+ ", ?) > 0";
	          }
	        	        
	        pstmt = conn.prepareStatement(baseSql);
	        
	        if(searchType != null && searchWord != null && !searchWord.isEmpty()) {
	        	pstmt.setString(1, searchWord);
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
	//////////////////////////////////////////////////////////////////////////////////////////
	public void boardInsert(BoardDTO dto, String game, String category) {  // 게시글 작성
	    try {
	        conn = getOracleConnection();

	        // 금지어 목록 가져오기
	        List<String> bannedWords = new ArrayList<>();
	        sql = "SELECT word FROM ban_word";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            bannedWords.add(rs.getString("word"));
	        }
	        
	        // 금지어 체크
	        for (String word : bannedWords) {
	            if (dto.getTitle().contains(word) || dto.getContent().contains(word)) {
	                throw new RuntimeException("금지어가 포함되어 있습니다.");
	            }
	        }
	        // 게시글 삽입
	        sql = "INSERT INTO " + game + "_BOARD (boardnum, title, nickname, content, readcount, replycount, upcnt, dwncnt, reg, category, filecount) "
	            + "VALUES (" + game + "_BOARD_SEQ.NEXTVAL, ?, ?, ?, 0, 0, 0, 0, SYSDATE, ?, ?)";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, dto.getTitle());
	        pstmt.setString(2, dto.getNickname());
	        pstmt.setString(3, dto.getContent());
	        pstmt.setString(4, dto.getCategory());
	        pstmt.setInt(5, dto.getFilecount());
	        pstmt.executeUpdate();
	        

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	}
	public void imageBoardInsert(BoardDTO dto) {
		String game = dto.getGameName();
		try {
	        conn = getOracleConnection();

	        // 금지어 목록 가져오기
	        List<String> bannedWords = new ArrayList<>();
	        sql = "SELECT word FROM ban_word";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            bannedWords.add(rs.getString("word"));
	        }
	        
	        // 금지어 체크
	        for (String word : bannedWords) {
	            if (dto.getTitle().contains(word) || dto.getContent().contains(word)) {
	                throw new RuntimeException("금지어가 포함되어 있습니다.");
	            }
	        }
	        // 게시글 삽입
	        sql = "INSERT INTO " + game + "_IMAGE_BOARD (boardnum, title, nickname, content, readcount, replycount, upcnt, dwncnt, reg, filecount) "
	            + "VALUES (" + game + "_IMAGE_BOARD_SEQ.NEXTVAL, ?, ?, ?, 0, 0, 0, 0, SYSDATE, ?)";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, dto.getTitle());
	        pstmt.setString(2, dto.getNickname());
	        pstmt.setString(3, dto.getContent());
	        pstmt.setInt(4, dto.getFilecount());
	        pstmt.executeUpdate();
	        

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	}
	/////////////////////////////////2024-12-19 검색기능 추가//////////////////////////////////////////////////////////
	//썸네일 이미지목록 + 제목 가져오기 + 검색기능 추가
	public List<BoardDTO> getImageAndTitleList(String game, int start, int end, String searchType, String searchWord) {
	    List<BoardDTO> list = new ArrayList<>();
	    try {
	        conn = getOracleConnection();
	        String insertSql = "";
	        
	       
	         //검색처리
	        if(searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {
	        	  if(searchType.equals("title")) {
	        		  insertSql += " WHERE INSTR(title, ?) > 0";
	        	  }else if(searchType.equals("nickname")){
	        		  insertSql += " WHERE INSTR(nickname, ?) > 0";
	        	  }else if(searchType.equals("content")) {
	        		  insertSql += " WHERE INSTR(content, ?) > 0";
	        	  }
	          }
	        
	        String baseSql = "SELECT content, title, boardnum FROM " + game + "_image_board "+insertSql+" ORDER BY boardnum DESC";
	        
	        //페이징 처리
	        sql = "SELECT * FROM ("
	            + "    SELECT ROWNUM rnum, d.* FROM ("
	            + "       " + baseSql + " "
	            + "    ) d WHERE ROWNUM <= ?"
	            + ") WHERE rnum >= ?";
	
	        pstmt = conn.prepareStatement(sql);
	        
	        int paramIndex = 1;
	        if(searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {
	        	pstmt.setString(paramIndex++, searchWord);	        	
	        }
	        pstmt.setInt(paramIndex++, end);   // ROWNUM <= end
	        pstmt.setInt(paramIndex, start); // rnum >= start
	        rs = pstmt.executeQuery();
	        Pattern imgPattern = Pattern.compile("<img\\s+[^>]*src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>");
	        while (rs.next()) {
	            String content = rs.getString("content");
	            String title = rs.getString("title");
	            Matcher imgMatcher = imgPattern.matcher(content);
	            if (imgMatcher.find()) {
	                BoardDTO dto = new BoardDTO();
	                dto.setContent(imgMatcher.group(1)); // 이미지 URL 설정
	                dto.setTitle(title);
	                dto.setBoardnum(rs.getInt("boardnum"));
	                list.add(dto);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return list;
	}
	
	//이미지 게시판 totalCount
	
	public int getImgTotalCount(String game, String searchType, String searchWord) {
	    int count = 0;
	    try {
	        conn = getOracleConnection();
	        String baseSql = "SELECT COUNT(*) FROM " + game + "_IMAGE_BOARD";
	        
	        if(searchType != null && searchWord != null && !searchType.isEmpty() && !searchWord.isEmpty()) {
	        	 baseSql += " WHERE INSTR(" +searchType+ ", ?) > 0";
	          }
	        	        
	        pstmt = conn.prepareStatement(baseSql);
	        
	        if(searchType != null && searchWord != null && !searchWord.isEmpty()) {
	        	pstmt.setString(1, searchWord);
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
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 썸네일 이미지목록 + 제목 가져오기 (BEST_BOARD에서 is_image = 1인 데이터)
	public List<BoardDTO> getBestImageAndTitleList(int start, int end) {
	    List<BoardDTO> list = new ArrayList<>();
	    try {
	        conn = getOracleConnection();
	        sql = "SELECT * FROM ("
	            + "    SELECT ROWNUM rnum, d.* FROM ("
	            + "        SELECT game_name, content, title, board_num FROM BEST_BOARD WHERE is_image = 1 ORDER BY BEST_NUM DESC"
	            + "    ) d WHERE ROWNUM <= ?"
	            + ") WHERE rnum >= ?";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, end);   // ROWNUM <= end
	        pstmt.setInt(2, start); // rnum >= start
	        rs = pstmt.executeQuery();

	        Pattern imgPattern = Pattern.compile("<img\\s+[^>]*src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>");
	        while (rs.next()) {
	            String content = rs.getString("content");
	            String title = rs.getString("title");
	            Matcher imgMatcher = imgPattern.matcher(content);

	            if (imgMatcher.find()) { // 이미지 태그 찾기
	                BoardDTO dto = new BoardDTO();
	                dto.setContent(imgMatcher.group(1)); // 이미지 URL 설정
	                dto.setTitle(title);
	                dto.setGameName(rs.getString("game_name"));
	                dto.setBoardnum(rs.getInt("board_num")); // 게시글 번호
	                list.add(dto);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return list;
	}
	//POST_RECORD에 삽입
		public void postRecord(BoardDTO dto, String game, String nick) { 
			try {
				int boardNum = callBoardNum(game); //보드넘 가져오는 메서드
		        
		        //오류 확인
		        if(boardNum == 0) {
		        	System.out.println("게시글 내역 기록 오류. BoardDAO의 postRecord 메서드, post_Records DB 확인 바람.");
		        }
				conn = getOracleConnection();
				sql = "INSERT INTO post_record (game, nickname, title, boardnum) VALUES (?, ?, ?, ?)";
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, game);
		        pstmt.setString(2, nick);
		        pstmt.setString(3, dto.getTitle());
		        pstmt.setInt(4, boardNum);
		        pstmt.executeUpdate();
		      	 
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				dbClose(rs, pstmt, conn);
			}
		}
		
		public int callBoardNum(String game) {
			int bNumber = 0;
			try {
				conn = getOracleConnection();
				
		        //보드넘 가져오기
		        sql = "SELECT NVL(MAX(boardnum), 0) FROM " + game + "_BOARD";
		        pstmt = conn.prepareStatement(sql);
		        rs = pstmt.executeQuery();
		        if(rs.next()) {
		        	bNumber = rs.getInt(1);
		        }
		        
		        
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				dbClose(rs, pstmt, conn);
			}
			return bNumber;
		}
	public BoardDTO readNum(int num, String game, String type) {
		BoardDTO dto = new BoardDTO();
		try {
			conn = getOracleConnection();
			if(type.equals("image")) {
                sql="update "+game+"_image_board set readcount = readcount+1 where boardnum = ?";
			}else {
				sql="update "+game+"_board set readcount = readcount+1 where boardnum = ?";
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			if(type.equals("image")) {
                sql = "select * from "+ game +"_image_board where boardnum=?";
			} else {
				sql = "select * from " + game + "_board where boardnum=?";
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setTitle(rs.getString("title"));
				dto.setNickname(rs.getString("nickname"));
				dto.setContent(rs.getString("content"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setReplycount(rs.getInt("replycount"));
				dto.setUpcnt(rs.getInt("upcnt"));
				dto.setDwncnt(rs.getInt("dwncnt"));
				dto.setReg(rs.getString("reg"));
				dto.setFilecount(rs.getInt("filecount"));
			}
		} catch (Exception e) {
			e.printStackTrace();// 
		}finally {
			dbClose(rs, pstmt, conn);
		}
		return dto;
	}
	public boolean vote(int boardnum, String nickname, String voteType, String game, String type) {
	    boolean success = false;
	    try {
	        conn = getOracleConnection();

	        // 1. 추천 테이블에 삽입
	        sql = "INSERT INTO " + game + "_BOARD_VOTE VALUES (?, ?, ?, SYSDATE, ?)";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, boardnum);
	        pstmt.setString(2, nickname);
	        pstmt.setString(3, voteType);
	        pstmt.setInt(4, type.equals("image") ? 1 : 0); // 이미지 타입: 1, 일반 타입: 0
	        pstmt.executeUpdate();

	        // 2. 게시글 추천/비추천 수 업데이트
	        if (type.equals("normal")) {
	            if ("UP".equals(voteType)) {
	                sql = "UPDATE " + game + "_BOARD SET upcnt = upcnt + 1 WHERE boardnum = ?";
	            } else if ("DOWN".equals(voteType)) {
	                sql = "UPDATE " + game + "_BOARD SET dwncnt = dwncnt + 1 WHERE boardnum = ?";
	            }
	        } else if (type.equals("image")) {
	            if ("UP".equals(voteType)) {
	                sql = "UPDATE " + game + "_IMAGE_BOARD SET upcnt = upcnt + 1 WHERE boardnum = ?";
	            } else if ("DOWN".equals(voteType)) {
	                sql = "UPDATE " + game + "_IMAGE_BOARD SET dwncnt = dwncnt + 1 WHERE boardnum = ?";
	            }
	        }
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, boardnum);
	        pstmt.executeUpdate();

	     // 3. 추천 수 확인 및 BEST_BOARD 삽입
	        if ("UP".equals(voteType)) {
	            sql = type.equals("normal")
	                    ? "SELECT upcnt FROM " + game + "_BOARD WHERE boardnum = ?"
	                    : "SELECT upcnt FROM " + game + "_IMAGE_BOARD WHERE boardnum = ?";
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, boardnum);
	            rs = pstmt.executeQuery();

	            if (rs.next() && rs.getInt("upcnt") >= 10) {
	                // 게시글 정보 가져오기
	                sql = type.equals("normal")
	                        ? "SELECT * FROM " + game + "_BOARD WHERE boardnum = ?"
	                        : "SELECT * FROM " + game + "_IMAGE_BOARD WHERE boardnum = ?";
	                pstmt = conn.prepareStatement(sql);
	                pstmt.setInt(1, boardnum);
	                rs = pstmt.executeQuery();

	                if (rs.next()) {
	                    // BEST_BOARD에 삽입
	                    sql = "INSERT INTO BEST_BOARD (BEST_NUM, GAME_NAME, BOARD_NUM, TITLE, NICKNAME, CONTENT, READ_COUNT, REPLY_COUNT, UPCNT, DWNCNT, REG_DATE, FILE_COUNT, IS_IMAGE) "
	                        + "VALUES (BEST_BOARD_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	                    pstmt = conn.prepareStatement(sql);
	                    pstmt.setString(1, game);
	                    pstmt.setInt(2, rs.getInt("boardnum"));
	                    pstmt.setString(3, rs.getString("title"));
	                    pstmt.setString(4, rs.getString("nickname"));
	                    pstmt.setString(5, rs.getString("content"));
	                    pstmt.setInt(6, rs.getInt("readcount"));
	                    pstmt.setInt(7, rs.getInt("replycount"));
	                    pstmt.setInt(8, rs.getInt("upcnt"));
	                    pstmt.setInt(9, rs.getInt("dwncnt"));
	                    pstmt.setDate(10, rs.getDate("reg"));
	                    pstmt.setInt(11, rs.getInt("filecount"));
	                    pstmt.setInt(12, type.equals("image") ? 1 : 0); // IS_IMAGE 값 설정
	                    pstmt.executeUpdate();

	                    // 경험치 추가
	                    new project01.member.bean.MemberDAO().increaseExperience(rs.getString("nickname"), 4);
	                }
	            }
	        }
	        success = true;
	    } catch (SQLException e) {
	        if (e.getErrorCode() == 1) { // ORA-00001: unique constraint violated
	            System.out.println("You have already voted.");
	        } else {
	            e.printStackTrace();
	        }
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return success;
	}
	public List<BoardDTO> getTopVotedBoardList(String game, int start, int end, String type) {
	    List<BoardDTO> list = new ArrayList<>();
	    try {
	        conn = getOracleConnection();
	        if(type.equals("normal")) {
		        sql = "SELECT * FROM ("
		            + "    SELECT ROWNUM rnum, d.* FROM ("
		            + "        SELECT * FROM " + game + "_BOARD WHERE upcnt >= 10 ORDER BY boardnum DESC"
		            + "    ) d WHERE ROWNUM <= ?"
		            + ") WHERE rnum >= ?";
	        }else {
				sql = "SELECT * FROM (" + "    SELECT ROWNUM rnum, d.* FROM ( SELECT * FROM " + game
					+ "_image_BOARD WHERE upcnt >= 10 ORDER BY boardnum DESC) d WHERE ROWNUM <= ?"
					+ ") WHERE rnum >= ?";
	        }
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, end);   // ROWNUM <= end
	        pstmt.setInt(2, start); // rnum >= start
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            BoardDTO dto = new BoardDTO();
	            dto.setBoardnum(rs.getInt("boardnum"));
	            dto.setTitle(rs.getString("title"));
	            dto.setNickname(rs.getString("nickname"));
	            dto.setContent(rs.getString("content"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setReplycount(rs.getInt("replycount"));
	            dto.setUpcnt(rs.getInt("upcnt"));
	            dto.setDwncnt(rs.getInt("dwncnt"));
	            dto.setReg(rs.getString("reg"));
	            dto.setFilecount(rs.getInt("filecount"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        dbClose(rs, pstmt, conn);
	    }
	    return list;
	}

	public void boardUpdate(BoardDTO dto, String type) {		// 게시글 수정
		String game = dto.getGameName();
		String category = dto.getCategory();
        try {
            conn = getOracleConnection();
         // 금지어 목록 가져오기
	        List<String> bannedWords = new ArrayList<>();
	        sql = "SELECT word FROM ban_word";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            bannedWords.add(rs.getString("word"));
	        }

	        // 금지어 체크
	        for (String word : bannedWords) {
	            if (dto.getTitle().contains(word) || dto.getContent().contains(word)) {
	                throw new RuntimeException("금지어가 포함되어 있습니다.");
	            }
	        }
	        if(type.equals("normal")) {
            sql = "UPDATE " + game + "_board SET title=?, content=?, category=? WHERE boardnum=?";
	        } else {
	        	sql = "UPDATE " + game + "_image_board SET title=?, content=? WHERE boardnum=?";
            }
	        
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
			if (type.equals("normal")) {
				pstmt.setString(3, category);
				pstmt.setInt(4, dto.getBoardnum());
			}else {
				pstmt.setInt(3, dto.getBoardnum());
			}
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();//
        } finally {
            dbClose(rs, pstmt, conn);
        }
	}

	
	
	public void boardDelete(int boardnum, String game, String type) {		// 게시글 삭제
		try {
			conn = getOracleConnection();
			if(type.equals("normal")) {
				sql = "DELETE FROM " + game + "_board WHERE boardnum=?";
			} else {
				sql = "DELETE FROM " + game + "_image_board WHERE boardnum=?";
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			pstmt.executeUpdate();
			sql = "delete from best_board where board_num = ? and game_name = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			pstmt.setString(2, game);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose(rs, pstmt, conn);
		}
	}
	//현재 게시판의 카테고리 가져오기
	public List<String> getCategory(String game) {
		List<String> category = new ArrayList<>();
		try {
			conn = getOracleConnection();
			sql = "SELECT CATEGORY_NAME FROM CATEGORIES WHERE GAME_NAME = ? OR GAME_NAME = 'EVERYGAME' ORDER BY created_at";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, game);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				category.add(rs.getString("CATEGORY_NAME"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose(rs, pstmt, conn);
		}
		return category;
	}
	
	////////////////////////////////////////2024-12-19 수정///////////////////////////////////////////
	//내 게시글 검색 & 페이징
		public List<BoardDTO> searchPost(String nick, int start, int end, String searchType, String searchWord){
			List<BoardDTO> searchList = new ArrayList<>();
			try {
				conn = getOracleConnection();
				
				String insertSql = "";
				String baseSql = "SELECT * FROM post_record WHERE nickname=? ";
				
				//검색 조건
				if(searchType != null && searchWord != null && !searchWord.isEmpty()) {
					insertSql = "AND INSTR(" + searchType + ", ?) > 0 ";
				}
				
				baseSql += insertSql + "ORDER BY reg DESC";
				
				//페이징 처리
				sql = "SELECT * FROM ("
						+ " SELECT F.*, ROWNUM R FROM ("
						+ " " +baseSql+ " "
						+ ") F WHERE ROWNUM >= ?) WHERE R <= ?";
								
				pstmt = conn.prepareStatement(sql);
				int paramIndex = 1;
				
				pstmt.setString(paramIndex++, nick);
				if(searchType != null && searchType != null && !searchWord.isEmpty()) {
					pstmt.setString(paramIndex++, searchWord);
				}
				
				pstmt.setInt(paramIndex++, start);
				pstmt.setInt(paramIndex, end);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					BoardDTO dto = new BoardDTO();
					dto.setGameName(rs.getString("game"));
					dto.setTitle(rs.getString("title"));
					dto.setBoardnum(rs.getInt("boardnum"));
					dto.setReg(rs.getString("reg"));
					searchList.add(dto);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				dbClose(rs, pstmt, conn);
			}
			return searchList;
		}
		
		//내 게시글 세기
			public int postCount(String nick, String searchType, String searchWord) {
				int result = 0;
				try {			
					conn = getOracleConnection();
					
					String insertSql = " ";
					String baseSql = "SELECT COUNT(*) FROM post_record WHERE nickname=? ";
					
					if(searchWord != null && !searchWord.isEmpty()) {
						insertSql = " AND INSTR(" +searchType+ ", ?) > 0 ";
					}
					baseSql += insertSql;
										
					pstmt = conn.prepareStatement(baseSql);
					
					int paramIndex = 1;
						pstmt.setString(paramIndex++, nick);
					if(searchWord != null && !searchWord.isEmpty()) {
						pstmt.setString(paramIndex, searchWord);
					}
					rs = pstmt.executeQuery();
					if(rs.next()) {
						result = rs.getInt(1);
					}
				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					dbClose(rs, pstmt, conn);
				}
				return result;
			}

}