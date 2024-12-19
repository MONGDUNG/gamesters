<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="project01.board.bean.BoardDAO"%>
    <%@ page import="project01.board.bean.BoardDTO"%>
    <%@ page import="java.util.List"%>
<jsp:include page="../header.jsp" />
<%
	String ctx = request.getContextPath();	//콘텍스트명 얻어오기.
    int num = Integer.parseInt(request.getParameter("num"));
    String game = request.getParameter("game");
    String nick = (String)session.getAttribute("nick");
    String type = request.getParameter("type");
    BoardDAO dao = new BoardDAO();
    BoardDTO dto = new BoardDTO();
    dto = dao.readNum(num, game, type);
    List<String> categoryList = new BoardDAO().getCategory(game);
    if(nick == null){
    	%>
    	<script>
    	alert("로그인이 필요한 기능입니다.");
    	history.back();
    	</script>
    
    <%
    }
    else{
	int admin = (int)session.getAttribute("admin");
    
%>
    
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SmartEditor</title>
<script type="text/javascript" src="<%=ctx %>/SE2/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.0.min.js"></script>
<script type="text/javascript">
var oEditors = [];
$(function(){
      nhn.husky.EZCreator.createInIFrame({
          oAppRef: oEditors,
          elPlaceHolder: "ir1",
          //SmartEditor2Skin.html 파일이 존재하는 경로
          sSkinURI: "/project01/SE2/SmartEditor2Skin.html",  
          htParams : {
              // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
              bUseToolbar : true,             
              // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
              bUseVerticalResizer : true,     
              // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
              bUseModeChanger : true,         
              fOnBeforeUnload : function(){
                   
              }
          }, 
          fOnAppLoad : function(){
              //기존 저장된 내용의 text 내용을 에디터상에 뿌려주고자 할때 사용
              oEditors.getById["ir1"].exec("PASTE_HTML", [""]);
          },
          fCreator: "createSEditor2"
      });
      
      //저장버튼 클릭시 form 전송
      $("#save").click(function(){
          oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
          $("#frm").submit();
      });    
    //취소버튼 클릭시 board.jsp로 이동
      $("#cancel").click(function(){
          window.location.href = "board.jsp?game=<%= game %>";
      });
});



</script>

</head>
<body>
<form id="frm" action="updatePro.jsp" method="post" >
<input type="hidden" name="game" value="<%= game %>"/>
<input type="hidden" name="num" value="<%= num %>"/>
<input type="hidden" name="type" value="<%= type %>"/>
<table width="100%">
		<tr>
			<td>작성자</td>
			<td><input type="text" id="writer" name="writer" style="width:650px" value="<%=nick %>" readonly/></td>
		</tr>
		<tr>
		    <td>카테고리</td>
		    <td>
			    <select id="category" name="category" style="width:650px">
		          <% for (String category : categoryList) { %>
		            <% if (!"공지".equals(category) || admin == 1) { %>
		              <option value="<%= category %>"><%= category %></option>
		            <% } %>
		          <% } %>
		        </select>
		    </td>
		</tr>
        <tr>
            <td>제목</td>
            <td><input type="text" id="title" name="title" style="width:650px" value="<%=dto.getTitle() %>"/></td>
        </tr>
        <tr>
            <td>내용</td>
            <td>
                <textarea rows="10" cols="30" id="ir1" name="content" style="width:650px; height:350px; "><%=dto.getContent() %></textarea>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="button" id="save" value="저장"/>
                <input type="button" id="cancel" value="취소"/>
            </td>
        </tr>
</table>
</form>

</body>
</html>
<%}
%>