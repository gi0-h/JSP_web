<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>

<%
    String year = request.getParameter("year");
    String month = request.getParameter("month");
    String day = request.getParameter("day");
    String userId = request.getParameter("userID");
    String title = "";
    String content = "";
    String image = "";
    String driver = "oracle.jdbc.driver.OracleDriver";
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String dbUsername = "scott";
    String dbPassword = "tiger";

    Connection conn = null;
    PreparedStatement stmt = null;
    
    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);
        String sql = "SELECT * FROM diary WHERE year = ? AND month = ? AND day = ? AND userId = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, year);
        pstmt.setString(2, month);
        pstmt.setString(3, day);
        pstmt.setString(4, userId);

        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
            
            image = rs.getString("image");
            image = "images/" + image.substring(image.lastIndexOf("\\") + 1);
            }

        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="css/custom.css">
  <title>세줄기</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #f2f2f2;
    }
    .container {
      max-width: 600px;
      margin: 0 auto;
      background-color: white;
      padding: 20px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }
    .header {
      text-align: center;
      margin-bottom: 20px;
    }
    .date {
      font-size: 18px;
      margin-bottom: 10px;
      border-bottom: 1px solid #ccc;
      padding-bottom: 10px;
    }
    .title {
      font-size: 24px;
      margin-bottom: 10px;
      color: #333;
      border-bottom: 1px solid #ccc;
      padding-bottom: 10px;
    }
    .content {
      font-size: 16px;
      margin-bottom: 20px;
      color: #555;
      border-bottom: 1px solid #ccc;
      padding-bottom: 20px;
    }
    .image-container {
      text-align: center;
      border-bottom: 1px solid #ccc;
      padding-bottom: 20px;
    }
    .image {
      max-width: 100%;
      max-height: 400px;
      margin-bottom: 20px;
    }
    .button-container {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin-top:20px;
      margin-bottom: 20px;
    }
    .button {
      padding: 10px 20px;
      background-color: #333;
      color: white;
      border: none;
      cursor: pointer;
      border-radius: 5px;
      font-size: 16px;
    }
    .delete-button {
      background-color: #f44336;
    }
    .back-link {
      display: block;
      margin-top: 20px;
      text-align: center;
      color: #555;
      text-decoration: none;
    }
    .back-link:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h3 class="date"><%= year %>년 <%= month %>월 <%= day %>일</h3>
    </div>
    <h2 class="title"><%= title %></h2>
    <div class="content"><%= content %></div>
    <div class="image-container">
      <img src="<%= image %>" alt="Diary Image" class="image">
    </div>
    <div class="button-container">
      <form action="editDiary.jsp" method="get">
        <input type="hidden" name="year" value="<%= year %>">
        <input type="hidden" name="month" value="<%= month %>">
        <input type="hidden" name="day" value="<%= day %>">
        <button type="submit" class="button">수정하기</button>
      </form>
      
      <form action="deleteDiary.jsp" method="post" onsubmit="return confirm('정말로 일기를 삭제하시겠습니까?');">
        <input type="hidden" name="year" value="<%= year %>">
        <input type="hidden" name="month" value="<%= month %>">
        <input type="hidden" name="day" value="<%= day %>">
        <button type="submit" class="button delete-button">삭제하기</button>
      </form>
    </div>
    <a href="main2.jsp" class="back-link">일기 목록으로 돌아가기</a>
  </div>
</body>
</html>
