<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Diary</title>
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
        .form-label {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .form-input {
            width: 100%;
            padding: 5px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 3px;
            box-sizing: border-box;
            margin-bottom: 10px;
        }
        .form-submit {
            padding: 10px 20px;
            background-color: #333;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            String year = request.getParameter("year");
            String month = request.getParameter("month");
            String day = request.getParameter("day");
            String title = "";
            String content = "";
            String driver = "oracle.jdbc.driver.OracleDriver";
            String url = "jdbc:oracle:thin:@localhost:1521:xe";
            String dbUsername = "scott";
            String dbPassword = "tiger";

            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                Class.forName(driver);
                conn = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "SELECT title, content FROM diary WHERE year = ? AND month = ? AND day = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, year);
                pstmt.setString(2, month);
                pstmt.setString(3, day);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    title = rs.getString("title");
                    content = rs.getString("content");
                }

                rs.close();
                pstmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        <form action="updateDiary.jsp" method="post">
            <input type="hidden" name="year" value="<%= year %>">
            <input type="hidden" name="month" value="<%= month %>">
            <input type="hidden" name="day" value="<%= day %>">
            <label class="form-label" for="title">제목:</label><br>
            <textarea id="title" class="form-input" name="title" rows="1" cols="50"><%= title %></textarea><br>
            <label class="form-label" for="content">내용:</label><br>
            <textarea id="content" class="form-input" name="content" rows="4" cols="50"><%= content %></textarea><br>
            <input type="submit" class="form-submit" value="Submit">
        </form>
    </div>
</body>
</html>
