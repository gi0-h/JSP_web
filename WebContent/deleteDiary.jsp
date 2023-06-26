<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String year = request.getParameter("year");
    String month = request.getParameter("month");
    String day = request.getParameter("day");
    String driver = "oracle.jdbc.driver.OracleDriver";
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String dbUsername = "scott";
    String dbPassword = "tiger";

    Connection conn = null;

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);
        String sql = "DELETE FROM diary WHERE year = ? AND month = ? AND day = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, year);
        pstmt.setString(2, month);
        pstmt.setString(3, day);
        int rowsDeleted = pstmt.executeUpdate();

        pstmt.close();
        conn.close();

        if (rowsDeleted > 0) {
            response.sendRedirect("main2.jsp");
        } else {
            out.println("일기 삭제에 실패했습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>