package org.fitness.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.fitness.model.Member;

public class FitnessDAO {
	private static final int TEST_NUM = -1;
	private static final String url = "jdbc:oracle:thin:@localhost:1521:xe";
	private static final String user = "fitness";
	private static final String password = "1234";
	
	private Connection getConnection() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(url, user, password);
			return conn;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public int addMember(Member member) {
		Connection conn = getConnection();
		if (conn == null) return -1;
		//있는 회원인지 판독
		if (existMember(member)) return -2;
		
		String sql = "insert into member (membernum, mname, gender, startday, endday, phone, address, membertype, birthday) "
				+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		PreparedStatement stmt = null;
		ResultSet result = null;
		
		try {
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, TEST_NUM);
			stmt.setString(2, member.getmName());
			stmt.setString(3, member.getGender());
			stmt.setDate(4, member.getStartDay());
			stmt.setDate(5, member.getEndDay());
			stmt.setString(6, member.getPhone());
			stmt.setString(7, member.getAddress());
			stmt.setString(8, member.getMemberType());
			stmt.setDate(9, member.getBirthday());
			int resultInt = stmt.executeUpdate();
			if (resultInt > 0) {
				//트렌젝션 찾아보질 못해서..
				int memberNum = getMemberNum();
				if (memberNum > 0) {
					stmt = conn.prepareStatement("update member set membernum = " + memberNum + " where mname = '" + member.getmName() + "' and phone = '" + member.getPhone() + "'");
					stmt.executeUpdate();
					return memberNum;
				} else {
					stmt = conn.prepareStatement("delete from member where membernum = " + TEST_NUM);
					stmt.executeUpdate();
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			endDAO(conn, stmt, result);
		}
		return -1;
	}
	
	public static void main(String[] args) {
		FitnessDAO dao = new FitnessDAO();
		Member m = new Member();
		m.setAddress("경기도");
		m.setBirthday("2012-02-23");
		m.setEndDay("2019-08-02");
		m.setGender("male");
		m.setMemberType("일반");
		m.setmName("홍길동");
		m.setPhone("010-1234-1234");
		m.setStartDay("2019-06-01");
		dao.addMember(m);
		for (int i = 1; i <= 20; i++) {
			m.setmName("홍군" + i);
			dao.addMember(m);
		}
	}

	private int getMemberNum() {
		Connection conn = getConnection();
		if (conn == null) return -1;
		String sql = "select membernum.nextval from dual";
		Statement stmt = null;
		ResultSet result = null;
		
		try {
			stmt = conn.createStatement();
			result = stmt.executeQuery(sql);
			result.next();
			return result.getInt(1);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			endDAO(conn, stmt, result);
		}
		
		return -1;
	}

	private boolean existMember(Member member) {
		Connection conn = getConnection();
		if (conn == null) return true;
		
		String sql = "select 1 from member where mname = ? and phone = ?";
		
		PreparedStatement stmt = null;
		ResultSet result = null;
		
		try {
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, member.getmName());
			stmt.setString(2, member.getPhone());
			result = stmt.executeQuery();
			return result.next();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			endDAO(conn, stmt, result);
		}
		
		return true;
	}

	private void endDAO(Connection conn, Statement stmt, ResultSet result) {
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (result != null) {
			try {
				result.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public Member[] getMemberList(int page) {
		Connection conn = getConnection();
		if (conn == null) return null;
		
		Statement stmt = null;
		ResultSet result = null;
		
//		String sql = "select t2.membernum, mname, gender, startday, endday, phone, address, membertype, birthday " + 
//				"from (select membernum, rownum r from member) t1, member t2 " + 
//				"where t1.membernum = t2.membernum and r between " + (page - 1) + "1 and " + page + "0";
		
		String sql = "select membernum, mname, gender, startday, endday, phone, address, membertype, birthday " + 
				"from (select membernum, mname, gender, startday, endday, phone, address, membertype, birthday, rownum r from member) " + 
				"where r between " + (page - 1) + "1 and " + page + "0";
		
		
		try {
			stmt = conn.createStatement();
			result = stmt.executeQuery(sql);
			List<Member> mList = new ArrayList<>();
			while (result.next()) {
				Member m = new Member();
				m.setMemberNum(result.getInt(1));
				m.setmName(result.getString(2));
				m.setGender(result.getString(3));
				m.setStartDay(result.getDate(4));
				m.setEndDay(result.getDate(5));
				m.setPhone(result.getString(6));
				m.setAddress(result.getString(7));
				m.setMemberType(result.getString(8));
				m.setBirthday(result.getDate(9));
				mList.add(m);
			}
			return mList.toArray(new Member[0]);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			endDAO(conn, stmt, result);
		}	
		return null;
	}

	public int getPageCount(int pageNum) {
		final int MAX_NAV_NUM = 10;
		Connection conn = getConnection();
		if (conn == null) return 0;
		
		Statement stmt = null;
		ResultSet result = null;
		
		//String sql = "select trunc((count(membernum) - 1 -" + ((10* MAX_NAV_NUM) * ((pageNum - 1) / MAX_NAV_NUM)) + ") / 10 + 1) from member";
		String sql = "select trunc((count(membernum) - 1 -" + (100 * ((pageNum - 1) / 10)) + ") / 10 + 1) from member";
		
		try {
			stmt = conn.createStatement();
			result = stmt.executeQuery(sql);
			result.next();
			int rt = result.getInt(1);
			if (rt >= MAX_NAV_NUM) {
				return MAX_NAV_NUM;
			} else {
				return rt;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			endDAO(conn, stmt, result);
		}
		return 0;
	}

	public int updateMember(Member member) {
		Connection conn = getConnection();
		if (conn == null) return -1;
		
		String sql = "update member set mname = ?, gender = ?, startday = ?, endday = ?, phone = ?, address = ?, membertype = ?, birthday = ? "
				+ "where membernum = ?";
		
		PreparedStatement stmt = null;
		ResultSet result = null;
		
		try {
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, member.getmName());
			stmt.setString(2, member.getGender());
			stmt.setDate(3, member.getStartDay());
			stmt.setDate(4, member.getEndDay());
			stmt.setString(5, member.getPhone());
			stmt.setString(6, member.getAddress());
			stmt.setString(7, member.getMemberType());
			stmt.setDate(8, member.getBirthday());
			stmt.setInt(9, member.getMemberNum());
			int resultInt = stmt.executeUpdate();
			if (resultInt > 0) {
				return member.getMemberNum();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			endDAO(conn, stmt, result);
		}
		return -1;
	}
}
