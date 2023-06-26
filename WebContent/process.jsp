<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/custom.css">
    <title>Form Page</title>
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
        <form action="upload.jsp?year=<%= request.getParameter("year") %>&month=<%= request.getParameter("month") %>&day=<%= request.getParameter("day") %>&userID=<%= request.getParameter("userID") %>" method="post" enctype="multipart/form-data">
            <label class="form-label" for="title">제목:</label><br>
            <textarea id="title" class="form-input" name="title" rows="1" cols="50"></textarea><br>
            <label class="form-label" for="content">내용:</label><br>
            <textarea id="content" class="form-input" name="content" rows="4" cols="50"></textarea><br>
            <label class="form-label" for="fileField">이미지:</label><br>
            <input type="file" id="fileField" class="form-input" name="fileField"><br>
            <input type="submit" class="form-submit" value="Submit">
        </form>
    </div>
</body>
</html>