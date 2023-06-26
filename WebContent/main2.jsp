<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!--Script문장을 실행 할 수 있도록 PrintWriter 라이브러리를 불러온다. -->
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="Upload_calendar.calendar" %>
<%
  int targetYear = 0;
  int targetMonth = 0;
  calendar cal = new calendar();

  if (request.getParameter("targetYear") == null || request.getParameter("targetMonth") == null) {
    Calendar today = Calendar.getInstance();
    targetYear = today.get(Calendar.YEAR);
    targetMonth = today.get(Calendar.MONTH);
  } else {
    targetYear = Integer.parseInt(request.getParameter("targetYear"));
    targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
    if (targetMonth == -1) {
      targetMonth = 11;
      targetYear = targetYear - 1;
    } else if (targetMonth == 12) {
      targetMonth = 0;
      targetYear = targetYear + 1;
    }
  }

  int startTdBlank = 0;
  Calendar firstDate = Calendar.getInstance();
  firstDate.set(Calendar.YEAR, targetYear);
  firstDate.set(Calendar.MONTH, targetMonth);
  firstDate.set(Calendar.DATE, 1);
  startTdBlank = firstDate.get(Calendar.DAY_OF_WEEK) - 1;

  int endDateNum = firstDate.getActualMaximum(Calendar.DATE);

  int endTdBlank = 0;
  if ((startTdBlank + endDateNum) % 7 != 0) {
    endTdBlank = 7 - ((startTdBlank + endDateNum) % 7);
  }
  int totalTdCnt = startTdBlank + endDateNum + endTdBlank;
%>
<!DOCTYPE html>
<html>
<head>
<style>
 table {
 
    border-collapse: collapse;
    width: 100%;
  }

  td{
   border: 1px solid black;
   padding: 10px; /* 상하 여백을 10px로 늘림 */
    height: 80px; /* td의 높이를 80px로 지정 */
    text-align: center;
    position: relative;
  }
  th {
    border: 1px solid black;
      padding: 3px 5px; /* 상하 여백을 3px로 줄임 */
    height: 30px; /* th의 높이를 30px로 지정 */
    background-color: #f2f2f2;
    text-align: center;
    position: relative;
  }

  td.date-cell {
    cursor: pointer;
  }

  td.date-cell:hover {
    background-color: #B5ECD7;
  }

  td.date-cell .date-number {
    position: absolute;
    top: 0;
    left: 0;
    transform: translate(10px, 10px);
    font-weight: bold;
  }

  td.date-cell .event-image {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    max-width: 100%;
    max-height: 100%;
  }

  h1 {
    text-align: center;
    font-size: 20px; /* Adjust the font size as desired */
  }
</style>


<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"> -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1">
<!-- 반응형 웹에 사용하는 메타태그 -->
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
      <div class="navbar-header">
         <!-- 홈페이지의 로고 -->
         <button type="button" class="navbar-toggle collapsed"
            data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
            aria-expand="false">
            <span class="icon-bar"></span>
            <!-- 줄였을때 옆에 짝대기 -->
            <span class="icon-bar"></span> <span class="icon-bar"></span>
         </button>
         <a class="navbar-brand" href="main2.jsp">세줄기</a>
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
   <style>
   #most {
  background-size: cover;
  background-image: url('images/1.jpg'); /* 초기 배경 이미지 설정 */
}
    table {
    background-color:white;
      border-collapse: collapse;
      width: 100%;
        opacity: 0.8; /* 원하는 불투명도 값으로 설정 */
      
    }

    th, td {
      border: 1px solid black;
      text-align: center;
      background-position: center;
      background-size: cover;
    }
  th{
   padding: 10px;
   }
   td{
   padding: 60px;
   }

    h1{
      text-align: center;
      color:white;
    }
    

    /* Change background color on hover for date cells only */
    td.date-cell:hover {
      background-color:#B5ECD7;
    }
    td.date-cell .date-number {
    position: absolute;
    top: 0;
    left: 0;
    transform: translate(10px, 10px);
    font-weight: bold;    
    color: black; /* 수정: 검정색으로 설정 */
    background-color: white; /* 수정: 배경색을 흰색으로 설정 */
    padding: 5px 10px; /* 수정: 적절한 패딩 값 설정 */
  }
  </style>
</head>
<body id="most" >
<div class="container">
  <h1>
    <button class="btn btn-primary" onclick="location.href='./main2.jsp?targetYear=<%= targetYear %>&targetMonth=<%= targetMonth - 1 %>'">이전달</button>
    <%= targetYear %>년 <%= targetMonth + 1 %>월
    <button class="btn btn-primary" onclick="location.href='./main2.jsp?targetYear=<%= targetYear %>&targetMonth=<%= targetMonth + 1 %>'">다음달</button>
  </h1>
  <table>
  <br>
    <tr>
      <th style="color: red;">일</th>
      <th>월</th>
      <th>화</th>
      <th>수</th>
      <th>목</th>
      <th>금</th>
      <th style="color: blue;">토</th>
    </tr>
<%
for (int i = 1; i <= totalTdCnt; i++) {
  if (i > startTdBlank && i <= (startTdBlank + endDateNum)) {
    int dateNum = i - startTdBlank;
    String dateLink = "process.jsp";
    String imageSrc = "";
    
    // diary 테이블에서 해당 날짜의 데이터를 userID와 비교하여 이미지 경로를 가져온다
    if (userID != null && cal.isExistUserID(String.valueOf(targetYear), String.valueOf(targetMonth + 1), String.valueOf(dateNum), userID)) {
      dateLink = "diary.jsp";
      imageSrc = cal.getImagePathFromDatabase(String.valueOf(targetYear), String.valueOf(targetMonth + 1), String.valueOf(dateNum),userID );
      if (imageSrc == null) {
        imageSrc = "";
      } else {
        imageSrc = imageSrc.substring(imageSrc.lastIndexOf("\\") + 1);
      }
    }
%>
 <td class="date-cell" style="background-image: <% if(!imageSrc.equals("")){ %>url('images/<%= imageSrc %>')<% } %>; background-cover=cover;">
  <a href="<%= dateLink %>?year=<%= targetYear %>&month=<%= targetMonth + 1 %>&day=<%= dateNum %>&userID=<%= userID %>">
    <div class="calendar-cell text-left">
      <span class="date-number"><%= dateNum %></span>
    </div>
  </a>
</td>

<%
  } else {
%>
  <td></td>
<%
  }
  if (i % 7 == 0) {
%>
  </tr>
  <tr>
<%
  }
}
%>
 


  </table>
  <br>
<div style="text-align: center; margin-bottom: 20px;">
  <button class="btn btn-primary" onclick="toggleBackground()">모드 변환
   <div class="fill-one"></div>
  </button>
</div>

  <script>
  function toggleBackground() {
     var body = document.getElementById("most");
     var h1 =document.querySelector("h1");
     var currentImage = body.style.backgroundImage;

     if (currentImage.includes("images/1.jpg")) {
       body.style.backgroundImage = "url('images/2.jpg')";
       h1.style.color="white";

       
     } else if (currentImage.includes("images/2.jpg")) {
       body.style.backgroundImage = "url('images/1.jpg')";
       h1.style.color="black";
     } else {
       body.style.backgroundImage = "url('images/1.jpg')";
       h1.style.color="white";

     }
   }

</script>

  
</div>
   
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>


</body>
</html>