
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%
    String saveDirectory = application.getRealPath("/resources/uploads");
    File dir = new File(saveDirectory);
    if(!dir.exists()) dir.mkdirs();

    int maxPostSize = 10 * 1024 * 1024; // 10MB
    String encoding = "UTF-8";

    try {
        MultipartRequest multi = new MultipartRequest(
            request, 
            saveDirectory,
            maxPostSize,
            encoding,
            new DefaultFileRenamePolicy()
        );

        String fileUrl = "";
        String fileName = "";

        Enumeration files = multi.getFileNames();
        String file = (String)files.nextElement();
        fileName = multi.getFilesystemName(file);

        if(fileName != null) {
            String fileType = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!fileType.equals("jpg") && !fileType.equals("png")) {
                throw new Exception("Only JPG and PNG files are allowed.");
            }
            fileUrl = request.getContextPath() + "/resources/uploads/" + fileName;
        }

        // 이미지 URL 반환
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"url\":\"" + fileUrl + "\"}");

    } catch(Exception e) {
        e.printStackTrace();
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("<script>alert('이미지 업로드에 실패했습니다. " + e.getMessage() + "'); history.back();</script>");
    }
%>
