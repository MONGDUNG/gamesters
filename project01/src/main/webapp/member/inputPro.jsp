<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%-- dto에 파라미터들 저장 --%>
<jsp:useBean id="dto" class="project01.member.bean.MemberDTO" />
<jsp:setProperty name="dto" property="*" />
<jsp:useBean id="dao" class="project01.member.bean.MemberDAO" />

<%-- 가입 성공 여부 --%>
<% 
    int result = dao.memberInsert(dto);
%>

<!-- JavaScript 함수로 결과를 전달 -->
<script>
    // 서버에서 받은 result 값을 JavaScript로 전달
    var result = <%= result %>;
    handleMemberInsertResponse(result);

    // 회원가입 성공 시에만 로그인 폼으로 리다이렉트
    if (result > 0) {
        window.location.href = "loginForm.jsp";
    } else {
        history.back();
    }

    // JavaScript 함수 정의 (가능하다면 외부 스크립트 파일로 이동 가능)
    function handleMemberInsertResponse(result) {
        if (result === -1) {
            alert("이미 사용 중인 ID 또는 닉네임입니다. 다른 값을 사용해주세요.");
        } else if (result === -2) {
            alert("회원가입 중 오류가 발생했습니다. 다시 시도해주세요.");
        } else if(result === -3){
        	alert("1. id는 5~12 사이의 글자수만 허용합니다. \n2. id의 첫글자는 알파벳만 허용합니다. \n3. id는 알파벳과 숫자로 구성되어야 합니다. ");
        } else if(result === -4){
        	alert("1. pw는 7~18 사이의 글자수만 허용합니다. \n2. pw는 알파벳, 숫자, 특수기호가 모두 한 글자 이상 포함되어야 합니다. ");
        } else if(result === -5){
        	alert("1. 닉네임은 2~7 글자 사이의 한글, 영문, 숫자만 사용가능합니다. \n2. 숫자로만 이루어진 닉네임은 사용할 수 없습니다. ");
        }
        else if (result > 0) {
            alert("회원가입이 성공적으로 완료되었습니다!");
        }
    }
</script>