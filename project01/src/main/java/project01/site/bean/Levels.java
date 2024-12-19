package project01.site.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Levels extends DataBaseConnection{
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private String sql = null;
	
	
	public static void main(String[] args) {
		Levels a = new Levels();
		a.addEx(100, 100);
	}
	
	public void addEx(int maxLevel, int firstEx) {
		int currentEx = firstEx;
		for(int currentLevel = 1; currentLevel <= maxLevel; currentLevel++) {
			 if (currentLevel > 1) {
                 currentEx = (int) (currentEx * 1.1);
             }
			try {
				conn = getOracleConnection();
				sql = "INSERT INTO LEVELS VALUES(LEVELS_SEQ.NEXTVAL, ?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, currentEx);
				pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();// TODO: handle exception
			} finally {
				dbClose(rs, pstmt, conn);
			}
		}
		
	}
	
	
	
}
