package com.team5;

import java.sql.*;

public class DBManager {
	public static Connection getDBConnection() {
		//오라클 접속 메소드
		//@return Connection -> 오라클 접속 클래스
		Connection conn = null;
		try {
			// JDBC 드라이버 등록
			Class.forName("oracle.jdbc.OracleDriver");
			// 등록된 드라이버를 실제 Connection 클래스 변수에 연결
			conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@1.220.247.78:1522/orcl",
					"MINI_2410_TEAM5",
					"1234"
			);
			System.out.println("ORACLE DB 접속 성공");
		} catch(Exception e) {
			e.printStackTrace();
			//exit();		// 에러일 경우에는 무조건 종료
			System.err.println("ORACLE DB 접속 에러");
		}
		return conn;
	}
	public static void dbClose(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		try {
			if(rs != null) {
				rs.close();
			}
			if(pstmt != null) {
				pstmt.close();
			}
			if(conn != null) {
				conn.close();
			}
		}catch(SQLException se){
			System.out.println("Oracle DB IO 오류 -> " + se.getMessage());
		}
	}
}
