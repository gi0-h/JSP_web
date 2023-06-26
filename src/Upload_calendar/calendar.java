package Upload_calendar;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class calendar {
    private String year;
    private String month;
    private String day;
    private String title;
    private String content;
    private String filePath;
    private String userID;

    public calendar() {
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }
    

    public void saveToDatabase() {
        String driver = "oracle.jdbc.driver.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String dbUsername = "scott";
        String dbPassword = "tiger";

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Insert the image directory into the database
            String sql = "INSERT INTO diary (year, month, day, title, content, image, userID) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, year);
            stmt.setString(2, month);
            stmt.setString(3, day);
            stmt.setString(4, title);
            stmt.setString(5, content);
            stmt.setString(6, filePath);
            stmt.setString(7, userID);
            stmt.executeUpdate();

            System.out.println("이미지 디렉토리가 저장되었습니다.");
        } catch (ClassNotFoundException e) {
            System.out.println("드라이버 로드에 실패했습니다.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("데이터베이스 연결에 실패했습니다.");
            e.printStackTrace();
        } finally {
            // Close database resources
            try {
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void saveFile() {
        if (filePath != null && !filePath.isEmpty()) {
            File storeFile = new File(filePath);
            // saves the file on disk
            // Add your file saving logic here
        }
    }
    
    public boolean isExistInDatabase(String year, String month, String day,String userID) {
        String driver = "oracle.jdbc.driver.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String dbUsername = "scott";
        String dbPassword = "tiger";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            String sql = "SELECT * FROM diary WHERE year = ? AND month = ? AND day = ? AND userID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, year);
            stmt.setString(2, month);
            stmt.setString(3, day);
            stmt.setString(4, userID);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return true;
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return false;
    }
    
    public boolean isExistUserID(String year, String month, String day, String userID) {
        String driver = "oracle.jdbc.driver.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String dbUsername = "scott";
        String dbPassword = "tiger";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            String sql = "SELECT * FROM diary WHERE year = ? AND month = ? AND day = ? AND userID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, year);
            stmt.setString(2, month);
            stmt.setString(3, day);
            stmt.setString(4, userID);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return true;
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return false;
    }
    
    public String getImagePathFromDatabase(String year, String month, String day,String userID) {
        String driver = "oracle.jdbc.driver.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String dbUsername = "scott";
        String dbPassword = "tiger";
        String imagePath = null;

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Query the database to retrieve the image path
            String sql = "SELECT image FROM diary WHERE year = ? AND month = ? AND day = ? AND userID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, year);
            stmt.setString(2, month);
            stmt.setString(3, day);
            stmt.setString(4, userID);
            rs = stmt.executeQuery();

            if (rs.next()) {
                imagePath = rs.getString("image");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("Failed to load driver.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Failed to connect to the database.");
            e.printStackTrace();
        } finally {
            // Close database resources
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return imagePath;
    }
}