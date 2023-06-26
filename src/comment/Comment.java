package comment;

public class Comment {
	private int boardID;
	private int commentID;
	private String commentText;
	private String userID;
	private int commentAvailable;
	private java.sql.Date commentDate;
	public int getBoardID() {
		return boardID;
	}
	public void setBoardID(int boardID) {
		this.boardID = boardID;
	}
	public int getCommentID() {
		return commentID;
	}
	public void setCommentID(int commentID) {
		this.commentID = commentID;
	}
	public String getCommentText() {
		return commentText;
	}
	public void setCommentText(String commentText) {
		this.commentText = commentText;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public int getCommentAvailable() {
		return commentAvailable;
	}
	public void setCommentAvailable(int commentAvailable) {
		this.commentAvailable = commentAvailable;
	}
	public java.sql.Date getCommentDate() {
		return commentDate;
	}
	public void setCommentDate(java.sql.Date commentDate) {
		this.commentDate = commentDate;
	}

}
