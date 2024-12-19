function updateEmailDomain(select) {
    var secondInput = document.getElementById('emailDomain');
    if (select.value === "custom") {
        secondInput.value = '';
        secondInput.removeAttribute('readonly');
    } else {
        secondInput.value = select.value;
        secondInput.setAttribute('readonly', true);
    }
}

function toggleCustomInput(select, inputId) {
    var inputField = document.getElementById(inputId);
    if (select.value === "==직접입력==") {
        inputField.style.display = 'inline-block';
    } else {
        inputField.style.display = 'none';
    }
}

function inputCheck() {
    var requiredFields = [
        { name: "name", displayName: "이름" },
        { name: "id", displayName: "아이디" },
        { name: "pw", displayName: "비밀번호" },
        { name: "email", displayName: "이메일" },
        { name: "emailDomain", displayName: "이메일 도메인" },
        { name: "nickname", displayName: "닉네임" },
        { name: "pw_quiz", displayName: "비밀번호 퀴즈" },
        { name: "pw_answer", displayName: "비밀번호 답변" }
    ];

    var missingFields = [];

    // 필수 입력 필드 체크
    for (var i = 0; i < requiredFields.length; i++) {
        var field = requiredFields[i];
        var element = document.querySelector('input[name="' + field.name + '"]');

        if (!element || !element.value) {
            missingFields.push(field.displayName);
        }
    }

    // 생년월일 체크 (년, 월, 일 통합 확인)
    var birthYear = document.querySelector('input[name="birthYear"]').value;
    var birthMonth = document.querySelector('select[name="birthMonth"]').value;
    var birthDay = document.querySelector('select[name="birthDay"]').value;

    if (!birthYear || !birthMonth || !birthDay) {
        missingFields.push("생년월일");
    } else if (isNaN(birthYear) || isNaN(birthMonth) || isNaN(birthDay)) {
        alert("생년월일을 올바르게 입력해 주세요.");
        return false;
    }

    // 누락된 필드가 있는 경우 경고 메시지 표시
    if (missingFields.length > 0) {
        alert("[" + missingFields.join(', ') + "] 을(를) 입력해 주세요.");
        return false;
    }

    // 비밀번호 확인 체크
    var pw = document.querySelector('input[name="pw"]').value;
    var pwConfirm = document.querySelector('input[name="pwConfirm"]').value;

    if (pw !== pwConfirm) {
        alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        return false;
    }

    return true;
}

function cancelSignup() {
    alert("회원가입이 취소되었습니다. 이전 페이지로 돌아갑니다.");
    history.back();
}

