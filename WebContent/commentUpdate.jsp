<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %><%--데이터베이스 접근 객체 가져오기 --%>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %><%--데이터베이스 접근 객체 가져오기 --%>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name ="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>세줄기</title>
</head>
<body>
	<%
		String userID=null;
		if(session.getAttribute("userID")!=null){
			userID=(String)session.getAttribute("userID");
		}
		int boardID=0;
		if(request.getParameter("boardID")!=null)
			boardID=Integer.parseInt(request.getParameter("boardID"));
		if(boardID==0){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='board.jsp'");
			script.println("</script>");
		}
		Board board = new BoardDAO().getBoard(boardID);
		
		int commentID = 0;
		if(request.getParameter("commentID")!=null)
			commentID=Integer.parseInt(request.getParameter("commentID"));
		Comment comment = new CommentDAO().getComment(commentID);
		
	%>
	<nav class="navbar navbar-inverse">
		<div class ="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class ="icon-bar"></span>
				<span class ="icon-bar"></span>
				<span class ="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main2.jsp">세줄기</a>
			<img src="images/logo.png" width="30" height="30">
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main2.jsp">main</a></li>
				<li class="active"><a href="board.jsp">diary</a></li>
			</ul>
			<%
				if(userID==null){//로그인이 되어 있지 않다면
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else{//로그인이 되어있다면
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
						<li><a href="userUpdate.jsp">내 정보</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
			
		</div>
	</nav>
	<div class="container">
		<div class="row">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3"  text-align:center;">게시판 글 보기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width: 20%">글 제목</td>
							<td colspan="2"><%= board.getBoardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
						<tr>
							<td>작성자</td>
							<td colspan="2"><%= board.getUserID() %></td>
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan="2"><%= board.getBoardDate() %></td>
						</tr>
						<tr>
							<td>내용</td>
							<td colspan="2" style="min-height: 200px; text-align: left;"><%= board.getBoardContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
						</tr>
						
					</tbody>
				</table>
				<a href="board.jsp" class="btn btn-success">목록</a>
				
				<%
					if(userID != null && userID.equals(board.getUserID())){//해당 글이 본인이라면 수정과 삭제가 가능
				%>
						<a href="update.jsp?boardID=<%=boardID%>" class="btn btn-warning">수정</a>
						<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?boardID=<%=boardID%>" class="btn btn-danger">삭제</a>
				<%
					}
				%>
				<br><br>
	<div class="container">
         <div class="row">
            <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
               <tbody>
               <tr>
                  <td align="left">댓글</td>
               </tr>
        
     <div class="container">
		<div class="row">
			<form method="post" action="commentUpdateAction.jsp?boardID=<%=boardID%>&commentID=<%=commentID%>">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<tbody>
						<tr>
							<td><input type="text" class="form-control" placeholder="댓글 쓰기" name="commentText" maxlength="300" value=<%=comment.getCommentText() %> ></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-success pull-right" value="댓글수정">
		</form>
		</div>
	</div>
                  
               
            </table>
	</div>
	</div>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>