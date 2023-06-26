<%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta name="viewport" content="width= device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>세줄기</title>

</head>

<body>
 <%
   //로그인이 된 사람들은 로그인정보를 담을 수 있도록한다.
   String userID = null;
   //만약에 현재 세션이 존재한다면
   if (session.getAttribute("userID") != null) {
      //그 아이디값을 받아서 userID인스턴스로 관리할 수 있도록 한다.
      userID = (String) session.getAttribute("userID");
   }
   %>
	<nav class="navbar navbar-default">

		<div class ="navbar-header"> 

			<!-- 햄버거 모양 -->

			<button type="button" class="navbar-toggle collapsed" date-toggle="collapse" 

			date-target="#bs-example-navbar-collapse-1"aria-expanded="false">

			<span class ="icon-bar"></span>

			<span class ="icon-bar"></span>

			<span class ="icon-bar"></span>

			</button>

			<a class="navbar-brand"href="main2.jsp">세줄기</a>
			 <img src="images/logo.png" width="30" height="30">

		</div>

		 <div class="collapse navbar-collapse"
         id="bs-example-navbar-collapse-1">
         <ul class="nav navbar-nav">
            <!-- 현재 페이지가 메인이기 때문에 active를 달아주고, 현재 접속한 페이지가 메인페이지인걸 사용자에게 알려준다. -->
            <li class="active"><a href="main2.jsp">메인</a></li>
            <li><a href="board.jsp">게시판</a></li>
         </ul>
         <%
            // 접속하기는 로그인이 되어있지 않은 경우만 나오게한다.
         if (userID == null) {
         %>
         <ul class="nav navbar-nav navbar-right">
            <li class="dropdown"><a href="#" class="dropdown-toggle"
               data-toggle="dropdown" role="button" aria-haspopup="true"
               aria-expanded="false">접속하기<span class="caret"></span></a>
               <ul class="dropdown-menu">
                  <li><a href="login.jsp">로그인</a></li>
                  <li><a href="join.jsp">회원가입</a></li>
               </ul></li>
         </ul>
         <%
            // 로그인이 되어있는 사람만 볼수 있는 화면
         } else {
         %>
         <ul class="nav navbar-nav navbar-right">
            <li class="dropdown"><a href="#" class="dropdown-toggle"
               data-toggle="dropdown" role="button" aria-haspopup="true"
               aria-expanded="false">회원관리<span class="caret"></span></a>
               <ul class="dropdown-menu">
               <!-- 해당 페이지로 이동 후 세션해지 후 main화면으로 링크 -->
                  <li><a href="logoutAction.jsp">로그아웃</a></li>
               </ul></li>
         </ul>
         <%
            }
         %>
      </div>

	</nav>



<div class="container"> <!-- 감싸기 -->

		<div class="col-lg-4"></div>

		<div class="col-lg-4">

		

		<div class="jumbotron" sytle="padding-top: 20px;">

			<form method="post" action="loginAction.jsp">

			<!-- 안보이게 접속 -->

				<h3 style="text-align: center;">로그인 화면</h3>

			<div class="form-group">

				<input type="text" class="form-contorl" placeholder="아이디" name="userID" maxlength="20">

			</div>

			<div class="form-group">

				<input type="password" class="form-contorl" placeholder="비밀번호" name="userPassword" maxlength="20">

			</div>

			<input type="submit" class="btn btn-primary form-control" value="로그인">

		</form>

		</div>

	</div>

	<div class="col-lg-4"></div>	

	</div>



<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

<script src="js/bootstrap.js"></script>

</body>

</html> 