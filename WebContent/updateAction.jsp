<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.Board"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	//response.setContentType("text/html; charset=UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {//유저아이디이름으로 세션이 존재하는 회원들은 
			userID = (String) session.getAttribute("userID");//유저아이디에 해당 세션값을 넣어준다.
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} 
		int boardID = 0;
		if (request.getParameter("boardID") != null) {
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
		//boardID가 제대로 들어오지 않았다면,
		if (boardID == 0) {
			//다시 게시판 메인 페이지로 돌려보낸다.
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글 입니다.')");
			script.println("location.href = 'board.jsp'");
			script.println("</script>");
		}
		
		Board board = new BoardDAO().getBoard(boardID);
		String realFolder="";
		String saveFolder = "boardUpload";
		String encType = "utf-8";
		int maxSize=5*1024*1024;
		
		ServletContext context = this.getServletContext();
		realFolder = context.getRealPath(saveFolder);
		
		MultipartRequest multi = null;
		
		multi = new MultipartRequest(request,realFolder,maxSize,encType,new DefaultFileRenamePolicy());		
		
		String fileName = multi.getFilesystemName("fileName");
		String boardTitle = multi.getParameter("boardTitle");
		String boardContent = multi.getParameter("boardContent");
		
		board.setBoardTitle(boardTitle);
		board.setBoardContent(boardContent);
		
		
		//현재 작성한 글이 작성자가 일치하는지 확인해주는 소스코드 작성
		//만약 userID와 뷰페이지에서 넘겨받은 boardID값을 가지고 해당 글을 가져온 후
		//Board board = new BoardDAO().getBoard(boardID);
		//실제로 이 글의 작성자가 일치하는지 비교해준다. userID는 세션에 있는 값이고, board.getUserID는 이글을 작성한 사람의 값이다.
		if (!userID.equals(board.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			//동일하지 않다면 오류를 출력해 돌려보내준다.
			script.println("location.href = 'board.jsp'");
			script.println("</script>");				
		//성공적으로 권한이 있는사람이라면 넘어간다.
		}else {
			// 이건 내일 자세히 한번더 봐야할듯
			//update페이지에서 글제목과 글내용이 넘어오는 부분인데 넘어온 값이 null이거나 빈칸인지 분석을 해서
			//한번더 거치고 갈 수 있게 해준다.
			if (board.getBoardTitle().equals("") || board.getBoardContent().equals("")){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				//정상적으로 글이 입력되었을때 성공적으로 수정하게 해 주는 소스코드를 작성하자.
				BoardDAO boardDAO = new BoardDAO();
				//인스턴스에 update로 접근을 해서 안에 글번호,제목,내용이 들어갈 수있게 만들어주면 정상적으로 작동이 되게된다.
				int result = boardDAO.update(boardID, board.getBoardTitle(),board.getBoardContent());
				//오류가 발생했을때 띄워줄 메세지
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				} else {
					//성공한경우 다시 게시판 메인화면으로 돌아갈 수 있게 해준다.
					PrintWriter script = response.getWriter();
					if(fileName != null){
						String real = "C:\\jsp-work\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\JSPStudy\\boardUpload";
						File delFile = new File(real+"\\"+boardID+"사진.jpg");
						if(delFile.exists()){
							delFile.delete();
						}
						File oldFile = new File(realFolder+"\\"+fileName);
						File newFile = new File(realFolder+"\\"+boardID+"사진.jpg");
						oldFile.renameTo(newFile);
					}
					script.println("<script>");
					script.println("location.href='board.jsp'");
					//script.println("history.back()");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>