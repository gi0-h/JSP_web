package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;


public class CommentDAO {
	private Connection conn;	//db에 접근하는 객체
	private ResultSet rs;
	
	public CommentDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String url="jdbc:oracle:thin:@localhost:1521";
			String user = "scott";
			String password = "tiger";
			conn = DriverManager.getConnection(url,user,password);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public int getNext() {
		String SQL = "SELECT commentID FROM comments ORDER BY commentID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return 1; //첫번째 댓글인 경우
	}
	public int write(String commentText, String userID, int boardID) {
		String SQL = "INSERT INTO comments VALUES(?, ?, ?, sysdate, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardID);
			pstmt.setInt(2, getNext());
			pstmt.setString(3, userID);
			//pstmt.setString(4, getDate());
			pstmt.setString(4, commentText);
			pstmt.setInt(5, 1);
			pstmt.executeUpdate();
			return getNext();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	public String getUpdateComment(int commentID) {
		String SQL = "SELECT commentText FROM comments WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //오류
	}
	public ArrayList<Comment> getList(int boardID){
		String SQL = "SELECT * FROM comments WHERE boardID = ? AND commentAvailable = 1 ORDER BY boardID DESC"; 
		ArrayList<Comment> list = new ArrayList<Comment>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Comment cmt = new Comment();
				cmt.setBoardID(rs.getInt(1));
				cmt.setCommentID(rs.getInt(2));
				cmt.setUserID(rs.getString(3));
				cmt.setCommentDate(rs.getDate(4));
				cmt.setCommentText(rs.getString(5));
				cmt.setCommentAvailable(rs.getInt(6));
				list.add(cmt);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list; //데이터베이스 오류
	}
	
	public int update(int boardID, int commentID, String commentText) {
		String SQL = "UPDATE comments SET commentText = ? WHERE boardID = ? and commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, commentText);
			pstmt.setInt(2, boardID);
			pstmt.setInt(3, commentID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	public Comment getComment(int commentID) {
		String SQL = "SELECT * FROM comments WHERE commentID = ? ORDER BY commentID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  commentID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Comment cmt = new Comment();
				cmt.setBoardID(rs.getInt(1));
				cmt.setCommentID(rs.getInt(2));
				cmt.setUserID(rs.getString(3));
				cmt.setCommentDate(rs.getDate(4));
				cmt.setCommentText(rs.getString(5));
				cmt.setCommentAvailable(rs.getInt(6));
				return cmt;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	public int delete(int commentID) {
		String SQL = "update comments set commentAvailable = 0 where commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}