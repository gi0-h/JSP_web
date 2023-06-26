<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!--부트스트랩은 어떤device로 접속하더라도 해상도에 맞게 알아서 설정되는 탬플릿이다. -->
<meta name="viewport" content="width=device-width" , inital-scale="1">
<!--스타일시트를 참조, 주소는 css안에 부트스트랩.css-->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>세줄기</title>
</head>
<body>
<!-- 네비게이션 구현 네비게이션이라는 것은 하나의 웹사이트의 전반적인 구성을 보여주는 역할 -->
	<nav class="navbar navbar-default">
		<!-- header부분을 먼저 구현해 주는데 홈페이지의 로고같은것을 담는 영역이라고 할 수 있다. -->
		<div class="navbar-header">
			<!-- <1>웹사이트 외형 상의 제일 좌측 버튼을 생성해준다. data-target= 타겟명을 지정해주고-->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-exmaple="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!-- 여긴 웹페이지의 로고 글자를 지정해준다. 클릭 시 main2.jsp로 이동하게 해주는게 국룰 -->
			<a class="navbar-brand" href="main2.jsp">세줄기</a>
			 <img src="images/logo.png" width="30" height="30">
		</div>
		<!-- 여기서 <1>에만든 버튼 내부의 데이터 타겟과 div id가 일치해야한다. -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<!-- div 내부에 ul은 하나의 어떠한 리스트를 보여줄때 사용 -->
			<ul class="nav navbar-nav">
			<!-- 리스트 내부에 li로 원소를 구현 메인으로 이동하게만들고-->
				<li><a href="main2.jsp">메인</a></li>
			<!-- 게시판으로 이동하게 만든다. -->	
				<li><a href="board.jsp">게시판</a></li>
			</ul>
			<!-- 리스트 하나 더 생성 웹페이지 화면에서 우측 부분-->
			<ul class="nav navbar-nav navbar-right">
			<!-- 원소를 하나 구현해 준다. 네비게이션 우측 슬라이드메뉴 구현  -->
				<li class="dropdown">
					<!-- 안에 a태그를 하나 삽입한다. href="#"은 링크없음을 표시한다. -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<!--접속하기 아래에 드랍다운메뉴 생성  -->
					<ul class="dropdown-menu">
						<!-- li class="active" 현재 선택된 홈페이지를 의미 -->
						<li><a href="login.jsp">로그인</a></li>
						<li class="active"><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>	
		</div>
		<!-- 네비게이션 바 구성 끝 -->
	</nav>
	<!-- 하나의 컨테이너처럼 감싸주는 역할 -->
	<div class="container"> 
		<div class="col-lg-4"></div>
		<!-- 회원가입 폼은 위의 양식은 일치하며, 이제 내부 폼만 바꿔준다. -->
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<!-- 양식 삽입 post는 회원가입이나 로그인같이 어떠한 정보값을 숨기면서 보내는 메소드/ 로그인 Action페이지로 정보를보내겠다-->
				<form method="post" action="joinAction.jsp">
					<!-- 회원 가입에 맞게 위에 액션은 joinAction페이지로 밑에 제목은 회원가입 화면으로 변경 -->
					<h3 style="text-align: center;">회원가입 화면</h3>
					<div class="form-group">
						<!-- 회원 가입에서도 userID or userPassword는 동일하게 가져가고, 회원가입에 필요한 나머지 속성추가 -->
						<input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
					</div>
					<!-- userName 추가 -->
					<div class="form-group">
						<input type="text" class="form-control" placeholder="이름" name="userName" maxlength="20">
					</div>
						<!-- 버튼 또한 회원가입으로 value변경 -->	
						<input type="submit" class="btn btn-primary form-control" value="회원가입">
					</form>	
				</div>
			</div>	
			<div class="col-lg-4"></div>
		</div>
	<!-- 애니메이션을 담당하게 될 자바스크립트 참조 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 특정홈페이지에서 제이쿼리 호출 -->
	<script src="js/bootstrap.js"></script>
</body>
</html>