package project01.site.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DataBaseConnection {
	
	//DB 사용 준비, 접속
	public Connection getOracleConnection() {
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String dbURL = "jdbc:oracle:thin:@192.168.219.198:1521:orcl";
			String user = "team01", pw = "1234";
			conn = DriverManager.getConnection(dbURL, user, pw);
		} catch (Exception e) {
			e.printStackTrace();// TODO: handle exception
		}
		return conn;
	}
	
	public void dbClose(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		try {if(rs != null)rs.close();} catch (Exception sq) {}
		try {if(pstmt != null)pstmt.close();} catch (Exception sq) {}
		try {if(conn != null)conn.close();} catch (Exception sq) {}
	}
	
}
