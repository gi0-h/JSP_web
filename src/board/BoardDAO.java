package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
//DAO클래스는 실제로 데이터베이스에 접근을 해서 어떤 데이터를 빼오는 역할을 하는 클래스
public class BoardDAO {
		// connection:db에접근하게 해주는 소스를 넣을 부분
		private Connection conn; 
		//private PreparedStatement pstmt; boardDAO에서는 여러개의 함수를 사용하기때문에 마찰이 없게 함수내부에서 선언을 해준다.
		private ResultSet rs;
		// mysql 연결 부분은 user 에서 사용한것과 동일하기 때문에 그대로 들고와준다.
		public BoardDAO() {
			// 생성자를 만들어준다.
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				String url="jdbc:oracle:thin:@localhost:1521";
				String user = "scott";
				String password = "tiger";
				conn = DriverManager.getConnection(url,user,password);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		//boardID 게시글 번호 가져오는 함수
			public int getNext() { 
				//들어가는 SQL문장은 boardID를 가져오는데 게시글 번호같은 경우는 1번부터 하나씩 늘어나야 하기때문에
				//마지막에 쓰인 글을 가져와서 그 글번호에다가 1을 더한 값이 그 다음번호가 되기때문에 내림차순으로 들고와서 +1해 주는 방식을 사용한다.
				String SQL = "SELECT boardID FROM BOARD ORDER BY boardID DESC";
				try {
					//나머진 그대로 가고 리턴값만 수정
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						//나온 결과물에 1을 더해서 다음 게시글~ 
						return rs.getInt(1) + 1;
					}
					//현재 쓰이는 게시글이 하나도 없는 경우에는 결과가 안나오기 때문에 1을 리턴해준다.
					return 1;
				} catch (Exception e) {
					e.printStackTrace();
				}
				//데이터베이스 오류가 발생했을때 -1이 반환하면서 프로그래머에게 오류를 알려준다.
				return -1; 
			}
			//실제로 글을 작성하는 write함수 작성 Title,ID,Content를 외부에서 받아서 함수를 실행 시킨다.
			public int write(String boardTitle, String userID, String boardContent) { 
				//board 테이블에 들어갈 인자 6개를 ?로 선언 해준다.
				String SQL = "INSERT INTO BOARD VALUES(?, ?, ?, sysdate, ?, ?)";
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					pstmt.setInt(1, getNext());
					pstmt.setString(2, boardTitle);
					pstmt.setString(3, userID);
					pstmt.setString(4, boardContent);
					pstmt.setInt(5,1);
					pstmt.executeUpdate();
					return getNext(); //수정
				} catch (Exception e) {
					e.printStackTrace();
					
				}
				//데이터베이스 오류
				return -1; 
			//이렇게 만들어 줌으로서 성공적으로 글이 들어갔는지 확인이 가능하다.
			}
			public ArrayList<Board> getList(int pageNumber) {
				//boardID가 특정한 숫자보다 작을때를 범위로 잡아주고, Available이 1인 것만 or 내림차순으로 10개까지만 가져오도록 해주는 SQL문장을 넣어준다.
				String SQL = "SELECT * FROM (SELECT * FROM BOARD where boardID < ? AND boardAvailable = 1 ORDER BY boardID DESC) where ROWNUM <= 10";
				//board라는 클래스에서 나오는 인스턴스를 보관할 수 있는 list를 하나만들어서 new ArrayList<board>();를 담아준다.
				ArrayList<Board> list = new ArrayList<Board>();
				try { 
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					pstmt.setInt(1, getNext() - (pageNumber-1)*10);
					rs = pstmt.executeQuery();
					//결과가 나올때마다,
					while(rs.next()) {
						Board board = new Board();
						board.setBoardID(rs.getInt(1));
						board.setBoardTitle(rs.getString(2));
						board.setUserID(rs.getString(3));
						board.setBoardDate(rs.getDate(4));
						board.setBoardContent(rs.getString(5));
						board.setBoardAvailable(rs.getInt(6));
						list.add(board);
					}
				}catch(Exception e) {
					e.printStackTrace();
				}
				//10개 뽑아온 게시글 리스트를 출력한다.
				return list;
			}
			
			//페이징 처리 함수. 게시글이 10단위로 끊길때 10이면 다음페이지가 없어야 할때
			//이런 고유의 상황을 처리해 주기위해 만드는 함수
			public boolean nextPage(int pageNumber) {
				String SQL ="SELECT * FROM (SELECT * FROM BOARD where boardID < ? AND boardAvailable = 1 ORDER BY boardID DESC) where ROWNUM <= 10";
				
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
					rs = pstmt.executeQuery();
					//결과가 하나라도 존재한다면,
					if (rs.next()) {
						//다음으로 넘어갈 수있다는 True를 리턴해주고,
						return true;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				//그게 아닐경우 false를 리턴 
				return false; 		
			}
			
			public Board getBoard(int boardID){
				//boardID가 특정한 숫자일때 어떠한 행위를 실행할 수 있는 쿼리를 작성
				String SQL ="SELECT * FROM BOARD WHERE boardID = ?";
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					pstmt.setInt(1, boardID);
					rs = pstmt.executeQuery();
					//결과가 나왔을때 실행되어
					if (rs.next()) {
						Board board = new Board();
						board.setBoardID(rs.getInt(1));
						board.setBoardTitle(rs.getString(2));
						board.setUserID(rs.getString(3));
						board.setBoardDate(rs.getDate(4));
						board.setBoardContent(rs.getString(5));
						board.setBoardAvailable(rs.getInt(6));

						return board;
						
						}
				} catch (Exception e) {
					e.printStackTrace();
				}

				return null;
			}
			
			public int update(int boardID, String boardTitle, String boardContent) {
				String SQL = "UPDATE BOARD SET boardTitle = ?, boardContent = ? WHERE boardID = ?";
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					pstmt.setString(1, boardTitle);
					pstmt.setString(2, boardContent);
					pstmt.setInt(3, boardID);
					return pstmt.executeUpdate();
				} catch (Exception e) {
					e.printStackTrace();
				}
				return -1; 
			}
			
			public int delete(int boardID) {
				String SQL = "UPDATE BOARD SET boardAvailable = 0 WHERE boardID = ?";
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					pstmt.setInt(1, boardID);
					return pstmt.executeUpdate();
				}catch(Exception e) {
					e.printStackTrace();
				}
				return -1;
			}	
			
 }
