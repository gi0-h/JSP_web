<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!--javaBeans 들고오기-->
<%@ page import="board.Board"%>
<!-- db접근객체 가져오기 -->
<%@ page import="board.BoardDAO"%>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>세줄기</title>
</head>
<body>
	<%
		//로긴한사람이라면	 userID라는 변수에 해당 아이디가 담기고 그렇지 않으면 null값
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		//매개변수및 기본셋팅 처리 하는 부분
		int boardID = 0;
		//만약에 매개변수로 넘어온 boardID라는 매개변수가 존재 할 시 
		//(이 매개변수는 board.jsp에서 view로 이동하는 a태그에서 넘겨준 값이다.)
		if (request.getParameter("boardID") != null) {
			//파라미터는 항상 정수형으로 바꿔주는 parseInt를 사용해야 한다. 다음과 같이 정수형으로 변환시켜준다.
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
		//받아온 boardID가 0이면 유효하지 않은 글이라고 넣어준다.
		if (boardID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글 입니다.')");
			//다시 board.jsp로 돌려보내주자.
			script.println("location.href = 'board.jsp'");
			script.println("</script>");
			//boardID가 존재해야지, 특정한 글을 볼 수있도록 하는 거고,
		}
		//해당글의 구체적인 내용을 boardDAO 내부 만들었던 getboard함수를 실행시켜주는 부분 
		Board board = new BoardDAO().getBoard(boardID);
	%>
	<!-- 웹사이트 공통메뉴 -->
    <nav class ="navbar navbar-default">
        <div class="navbar-header"> <!-- 홈페이지의 로고 -->
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expand="false">
                <span class ="icon-bar"></span><!-- 줄였을때 옆에 짝대기 -->
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
            </button>
            <a class ="navbar-brand" href="main2.jsp">세줄기</a>
             <img src="images/logo.png" width="30" height="30">
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main2.jsp">메인</a></li>
                <!-- 현재의 게시판 화면이라는 것을 사용자에게 보여주는 부분 -->
                <li class="active"><a href="board.jsp">게시판</a></li>
            </ul>
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
		<!-- 화면 공통메뉴 끝 -->
	</nav>
	<!-- 게시판 틀 -->
	<div class="container">
		<div class="row">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<!--테이블 제목 부분 구현 -->
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width: 20%;"> 글 제목 </td>
							<td colspan="2"><%= board.getBoardTitle() %></td>
						</tr>
						<tr>
							<td>작성자</td>	
							<td colspan="2"><%= board.getUserID() %></td>
						</tr>
						<tr>
							<td>작성일</td>
							<td colspan="2"><%= board.getBoardDate()%></td>
						</tr>
						<!--<tr>-->
						<% 	
						String real = "C:\\jsp-work\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\JSPStudy\\boardUpload";
						File viewFile = new File(real+"\\"+boardID+"사진.jpg");
						if(viewFile.exists()){
				%>
					<tr>
						<td colspan="6"><br><img src = "boardUpload/<%=boardID %>사진.jpg" ><br><br>
					<% }
					else {%><td colspan="6" ><br><br><%} %>
						<%= board.getBoardContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%><br><br></td>
					</tr>
					</tbody>
				</table>
				<!-- 목록으로 돌아갈 수 있는 버튼을 테이블 외부에서 작성해준다. -->	
				<a href = "board.jsp" class="btn btn-primary">목록</a>
				
				<%
					//만약 글작성자가 본인일시 현재 페이지의 userID와 board Db내부의 UserID를 들고와서 비교 후
					if(userID != null && userID.equals(board.getUserID())){
				%>
						<!-- 본인이라면 update.jsp에 boardID를 가져갈 수 있게 해주고, 넘겨준다.-->
						<a href="update.jsp?boardID=<%= boardID %>" class="btn btn-primary">수정</a>
						<!-- 삭제는 페이지를 거치지않고 바로 실행될꺼기때문에 Action페이지로 바로 보내준다. -->
						<a onclick="return confirm('정말 삭제하시겠습니까?')" href="deleteAction.jsp?boardID=<%= boardID %>" class="btn btn-primary">삭제</a>
				<%					
					}
				%>
		</div>
	</div>
	<div class="container">
				<div class="row">
					<table class="table table-striped"
						style="text-align: center; border: 1px solid #dddddd">
						<tbody>
						<br>
							<tr>
								<td align="left">댓글</td>
							</tr>
							<tr>
								<%
									CommentDAO commentDAO = new CommentDAO();
									ArrayList<Comment> list = commentDAO.getList(boardID);
									for (int i = 0; i < list.size(); i++) {
								%>
								<div class="container">
									<div class="row">
										<table class="table table-striped"
											style="text-align: center; border: 1px solid #dddddd">
											<tbody>
												<tr>
													<td align="left"><%=list.get(i).getUserID()%></td>

													<td align="right"><%=list.get(i).getCommentDate() %></td>
												</tr>

												<tr>
													<td align="left"><%=list.get(i).getCommentText()%></td>
													<td align="right"><a
														href="commentUpdate.jsp?boardID=<%=boardID%>&commentID=<%=list.get(i).getCommentID()%>"
														class="btn btn-warning">수정</a> <a
														onclick="return confirm('정말로 삭제하시겠습니까?')"
														href="commentDeleteAction.jsp?boardID=<%=boardID%>&commentID=<%=list.get(i).getCommentID()%>"
														class="btn btn-danger">삭제</a></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<%
									}
								%>
							</tr>
					</table>
				</div>
			</div>
			<br>
			<div class="container">
				<div class="row">
					<form method="post" action="submitAction.jsp?boardID=<%=boardID%>">
						<table class="table table-bordered"
							style="text-align: center; border: 1px solid #dddddd">
							<tbody>
								<tr>
									<td align="left"><%=userID%></td>
								</tr>
								<tr>
									<td><input type="text" class="form-control"
										placeholder="댓글 쓰기" name="commentText" maxlength="300"></td>
								</tr>
							</tbody>
						</table>
						<input type="submit" class="btn btn-success pull-right"
							value="댓글 쓰기">
					</form>
				</div>
			</div>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>