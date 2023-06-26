<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="Upload_calendar.*" %>

<%
    calendar calendar = new calendar();
    calendar.setYear(request.getParameter("year"));
    calendar.setMonth(request.getParameter("month"));
    calendar.setDay(request.getParameter("day"));
    calendar.setUserID(request.getParameter("userID"));

    // Create a factory for disk-based file items
    DiskFileItemFactory factory = new DiskFileItemFactory();

    // Create a new file upload handler
    ServletFileUpload upload = new ServletFileUpload(factory);

    // Parse the request
    List<FileItem> items = upload.parseRequest(request);

    for (FileItem item : items) {
        if (item.isFormField()) {
            // Process regular form fields
            String fieldName = item.getFieldName();
            String fieldValue = item.getString("UTF-8");
            if (fieldName.equals("title")) {
                calendar.setTitle(fieldValue);  // Assign the value to title variable
            } else if (fieldName.equals("content")) {
                calendar.setContent(fieldValue);  // Assign the value to content variable
            }
        } else {
            if (item.getSize() > 0) {  // Check if file is uploaded
                // processes only fields that are not form fields
                String fileName = new File(item.getName()).getName();
                String filePath = getServletContext().getRealPath("/images/") + fileName;
                calendar.setFilePath(filePath);

                // saves the file on disk
                item.write(new File(filePath));
            }
        }
    }

    calendar.saveToDatabase();

    // Redirect to calendar.jsp
    response.sendRedirect("main2.jsp");
%>