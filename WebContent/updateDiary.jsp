<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Diary</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    String year = request.getParameter("year");
    String month = request.getParameter("month");
    String day = request.getParameter("day");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String driver = "oracle.jdbc.driver.OracleDriver";
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String dbUsername = "scott";
    String dbPassword = "tiger";

    Connection conn = null;

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);
        String sql = "UPDATE diary SET title = ?, content = ? WHERE year = ? AND month = ? AND day = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, year);
        pstmt.setString(4, month);
        pstmt.setString(5, day);
        int rowsUpdated = pstmt.executeUpdate();

        pstmt.close();
        conn.close();

        if (rowsUpdated > 0) {
            out.println("일기가 성공적으로 업데이트되었습니다.");
            // 업데이트 성공 시 main2.jsp로 이동
            response.sendRedirect("main2.jsp");
        } else {
            out.println("일기 업데이트에 실패했습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
</body>
</html>