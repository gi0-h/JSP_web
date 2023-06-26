package user_data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;


	public UserDAO() {
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


	public int login(String userID, String userPassword) {
		//이제 입력받은 userID 와 PW가 일치하는지 확인을 하기위해서 db내에서 userID 값에 대한 PW를 조회하는 쿼리를 넣어준다. *1.해킹방지를 위해 중간에 ?를 넣어놓고
		String SQL = "SELECT userPassword FROM USER_DATA WHERE userID = ?";
		//try,catch문으로 예외처리를 해주고
		try {
			//pstmt에 어떠한 정해진 sql문장을 데이터베이스에 삽입하는 형식으로 인스턴스를 가져온다.
			pstmt = conn.prepareStatement(SQL); 
			//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다. 2말2야
			pstmt.setString(1, userID);
			//이렇게 db에 넣을 쿼리문 셋팅이 끝났다. 실행한 결과를 rs에다가 담아준다.
			rs = pstmt.executeQuery();
			//이제 결과의 존재 여부에 따른 행동을 실행시켜주는 부분을 만들어 보자, 아이디가 존재할때
			if (rs.next()) {
				//만약 rs에 들어있는 값과 db내부의 userPW가 일치하면 login성공
				if (rs.getString(1).equals(userPassword))
					//login 성공
					return 1;
			 else 
				 //아니면 비밀번호 미 일치 실행한다. 
				return 0;
			}
			// 아이디가 없을때
			return -1;
		//그 외의 예상 불가 예외는 catch로 잡아준다.
		} catch (Exception e) {
			//해당 예외 출력
			e.printStackTrace();
		}
		// 데이터베이스 오류를 의미
		return -2;
	//로그인 시도 함수 작성 끝 loginAction Page 가자;
	}
	
	
	//회원가입 정보를 넣는곳
	public int join(User user) {
		String SQL = "INSERT INTO USER_DATA VALUES (?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
}