<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
function confirmDelete() {
    return confirm("게시판을 삭제하면 게시판의 모든 정보가 삭제됩니다. 정말 삭제하시겠습니까?");
}
</script>

<form action="deleteBoardPro.jsp" method="post" onsubmit="return confirmDelete();">
    <input type="text" name="boardGame" placeholder="게임의 영문명을 입력해주세요." />
    <input type="submit" value="삭제" />
</form>