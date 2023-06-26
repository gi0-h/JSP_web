<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.Board" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" > 
<link rel="stylesheet" href="css/bootstrap.css"> 
<link rel="stylesheet" href="css/custom.css">
<title>세줄기</title>
<style type = "text/css">
</style>
</head>
<body>
<%
    String userID = null; // 로그인이 된 사람들은 로그인정보를 담을 수 있도록한다
    if (session.getAttribute("userID") != null)
    {
        userID = (String)session.getAttribute("userID");
    }
    int pageNumber = 1; 
	 //만약에 파라미터로 pageNumber가 넘어왔다면 해당 파라미터의 값을 넣어주도록 한다.
   	if (request.getParameter("pageNumber") != null)
   	{
   	//파라미터는 항상 정수형으로 바꿔주는 parseInt를 사용해야 한다.
       pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
   	}
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
            // 접속하기는 로그인이 되어있지 않은 경우만 나오게한다
                if(userID == null)
                {
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" aria-haspopup="true"
                    aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>                    
                    </ul>
                </li>
            </ul>
            <%
            // 로그인이 되어있는 사람만 볼수 있는 화면
                } else {
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" aria-haspopup="true"
                    aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="loginAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
            <%
                }
            %>
        </div>
    </nav>
    <br><br>
    <div class="container">
        <!-- 테이블이 들어갈 수 있는 공간 구현 -->
        <div class="row">
         	<!-- striped는 게시판 글목록을 홀수와 짝수로 번갈아가며 색이 변하게 해주는 하나의 요소  -->
            <table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
                <!-- thead는 테이블의 제목부분에 해당함 -->
                <thead>
                	<!-- 테이블의 하나의 행을 말함(한 줄)-->
                    <tr>
                    	<!-- 게시판의 속성을 하나씩 명시 해준다. -->
                        <th style="background-color:#eeeeee; text-align:center;">번호</th>
                        <th style="background-color:#eeeeee; text-align:center;">제목</th>
                        <th style="background-color:#eeeeee; text-align:center;">작성자</th>
                        <th style="background-color:#eeeeee; text-align:center;">작성일</th>
                    </tr>
                </thead>
                <!-- tbody 같은 경우는 위에 지정해준 속성 아래에 하나씩 출력해주는 역할 -->
                <tbody>
               <%
                	//게시글을 담을 인스턴스
                    BoardDAO boardDAO = new BoardDAO();
                	//list 생성 그 값은 현재의 페이지에서 가져온 리스트 게시글목록
                    ArrayList<Board> list = boardDAO.getList(pageNumber);
                    //가져온 목록을 하나씩 출력하도록 선언한다..
                	for(int i = 0; i < list.size(); i++)
                    {
                %>
                    <tr>
                        <td><%=list.get(i).getBoardID() %></td>
                        <td><a href="view.jsp?boardID=<%=list.get(i).getBoardID()%>">
							<%=list.get(i).getBoardTitle() %></a></td>
                        <td><%=list.get(i).getUserID() %></td>
                        <td><%=list.get(i).getBoardDate() %></td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
            <%
            	//테이블 밑에 이전 버튼과 다음 버튼을 구현해 주는 부분
                if(pageNumber != 1) {
            %>
            	<!--페이지넘버가 1이 아니면 전부다 2페이지 이상이기 때문에 pageN에서 1을뺀값을 넣어서 게시판
            	 메인화면으로 이동하게 한다. class내부 에는 화살표모양으로 버튼이 생기게 하는 소스작성 아마 부트스트랩 기능인듯.-->
                <a href="board.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전</a>
            <%
            	//boardDAO에서 만들었던 함수를 이용해서, 다음페이지가 존재 할 경우
                } if (boardDAO.nextPage(pageNumber + 1)) {
            %>
            	<!-- a태그를 이용해서 다음페이지로 넘어 갈 수있는 버튼을 만들어 준다. -->
                <a href="board.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arrow-left">다음</a>
            <%
                }
            %>
            
            <a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>