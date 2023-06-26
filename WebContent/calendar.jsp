<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
  <meta charset="UTF-8">
  <title>calendar.jsp</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
  <style>
    table {
      border-collapse: collapse;
      width: 100%;
    }

    th, td {
      border: 1px solid black;
      padding: 50px;
      text-align: center;
      background-position: center;
      background-size: cover;
    }


    h1{
      text-align: center;
    }

    /* Change background color on hover for date cells only */
    td.date-cell:hover {
      background-color:#B5ECD7;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>
    <a href="./calendar.jsp?targetYear=<%= targetYear %>&targetMonth=<%= targetMonth - 1 %>">이전달</a>
    <%= targetYear %>년 <%= targetMonth + 1 %>월
    <a href="./calendar.jsp?targetYear=<%= targetYear %>&targetMonth=<%= targetMonth + 1 %>">다음달</a>
  </h1>
  <table>
    <tr>
      <th>일</th>
      <th>월</th>
      <th>화</th>
      <th>수</th>
      <th>목</th>
      <th>금</th>
      <th>토</th>
    </tr>

<%
for (int i = 1; i <= totalTdCnt; i++) {
  if (i > startTdBlank && i <= (startTdBlank + endDateNum)) {
    int dateNum = i - startTdBlank;
    String dateLink = "process.jsp";
    String imageSrc = "";
    if (cal.isExistInDatabase(String.valueOf(targetYear), String.valueOf(targetMonth + 1), String.valueOf(dateNum))) {
      dateLink = "diary.jsp";
      imageSrc = cal.getImagePathFromDatabase(String.valueOf(targetYear), String.valueOf(targetMonth + 1), String.valueOf(dateNum));
      if (imageSrc == null) {
        imageSrc = "";
      } else {
        imageSrc = imageSrc.substring(imageSrc.lastIndexOf("\\") + 1);
      }
    }
%>
  <td class="date-cell" style="background-image: <% if(!imageSrc.equals("")){ %>url('images/<%= imageSrc %>')<% } %>; background-cover=cover">
    <a href="<%= dateLink %>?year=<%= targetYear %>&month=<%= targetMonth + 1 %>&day=<%= dateNum %>">
      <div class="calendar-cell">
        <%= dateNum %>
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
</div>
</body>
</html>