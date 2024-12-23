<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="/project01/resources/css/signup.css">
    <script src="/project01/resources/js/input.js"></script>
	<script>
	    function checkDuplicateId() {
	        var id = document.querySelector('input[name="id"]').value;
	        window.open('checkDuplicateId.jsp?id=' + encodeURIComponent(id), 
	        		'ID 중복 체크', 'width=400,height=200');
	    }
	    function checkDuplicateNick() {
	        var nickname = document.querySelector('input[name="nickname"]').value;
	        window.open('checkDuplicateNick.jsp?nickname=' + nickname, 
	        		'닉네임 중복 체크', 'width=400,height=200');
	    }
	    function updateEmailDomain(selectElement) {
	        var emailDomainInput = document.getElementById("emailDomain");
	        if (selectElement.value === "custom") {
	            emailDomainInput.value = "";
	            emailDomainInput.disabled = false;
	        } else {
	            emailDomainInput.value = selectElement.value;
	            emailDomainInput.disabled = true;
	        }
	    }
	    function cancelSignup() {
	        window.location.href = '/project01';
	    }
	</script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 50px 0 0 0; /* Adjust padding-top to lower the content */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .signup-container {
            width: 60%;
            max-width: 800px;
            background: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .signup-header {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
            font-weight: bold;
        }
        input[type="text"], input[type="password"], select {
            width: calc(100% - 20px);
            padding: 8px 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[name="birthYear"], select[name="birthMonth"], select[name="birthDay"] {
            width: 20%; /* Set the width to 1/5th of the original size */
        }
        input[name="email"], input[id="emailDomain"], select {
            width: 33%; /* Set equal width for email fields */
        }
        input[type="radio"] {
            margin-right: 5px;
        }
        button, input[type="submit"], input[type="button"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            margin-top: 10px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        button:hover, input[type="submit"]:hover, input[type="button"]:hover {
            background-color: #0056b3;
        }
        .cancel-button {
            background-color: #dc3545;
        }
        .cancel-button:hover {
            background-color: #c82333;
        }
        .hidden-input {
            display: none;
            margin-top: 5px;
        }
        .email-container {
            display: flex;
            align-items: center;
            gap: 5px; /* Add spacing between email fields */
        }
        .button-container {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <form action="inputPro.jsp" onsubmit="return inputCheck()" method="post">
            <div class="signup-header">회원 가입</div>
            <table>
                <tr>
                    <th>이름</th>
                    <td><input type="text" name="name" placeholder="이름을 입력하세요" required/></td>
                </tr>
                <tr>
                    <th>아이디</th>
                    <td>
                        <input type="text" name="id" placeholder="아이디를 입력하세요" required/>
                        <button type="button" onclick="checkDuplicateId()">ID 중복 체크</button>
                    </td>
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td><input type="password" name="pw" placeholder="비밀번호를 입력하세요" required/></td>
                </tr>
                <tr>
                    <th>비밀번호 확인</th>
                    <td><input type="password" name="pwConfirm" placeholder="비밀번호를 다시 입력하세요" required/></td>
                </tr>
                <tr>
                    <th>생년월일</th>
                    <td>
                        <input type="text" name="birthYear" placeholder="년" required/>년
                        <select name="birthMonth">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                            <option>6</option>
                            <option>7</option>
                            <option>8</option>
                            <option>9</option>
                            <option>10</option>
                            <option>11</option>
                            <option>12</option>
                        </select>월
                        <select name="birthDay">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                            <option>6</option>
                            <option>7</option>
                            <option>8</option>
                            <option>9</option>
                            <option>10</option>
                            <option>11</option>
                            <option>12</option>
                            <option>13</option>
                            <option>14</option>
                            <option>15</option>
                            <option>16</option>
                            <option>17</option>
                            <option>18</option>
                            <option>19</option>
                            <option>20</option>
                            <option>21</option>
                            <option>22</option>
                            <option>23</option>
                            <option>24</option>
                            <option>25</option>
                            <option>26</option>
                            <option>27</option>
                            <option>28</option>
                            <option>29</option>
                            <option>30</option>
                            <option>31</option>
                        </select>일
                    </td>
                </tr>
                <tr>
                    <th>성별</th>
                    <td>
                        <input type="radio" id="male" name="gender" value="1" required><label for="male">남</label>
                        <input type="radio" id="female" name="gender" value="2"><label for="female">여</label>
                    </td>
                </tr>
                <tr>
                    <th>E-Mail</th>
                    <td>
                        <div class="email-container">
                            <input type="text" name="email"/>@
                            <input type="text" id="emailDomain" name="emailDomain" />
                            <select onchange="updateEmailDomain(this)">
                                <option value="custom">==직접입력==</option>       
                                <option value="naver.com">naver.com</option>
                                <option value="gmail.com">gmail.com</option>
                                <option value="hanmail.net">hanmail.net</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>닉네임</th>
                    <td>
                        <input type="text" name="nickname" placeholder="닉네임을 입력하세요" required/>
                        <button type="button" onclick="checkDuplicateNick()">닉네임 중복 체크</button>
                    </td>
                </tr>
                <tr>
                    <th>비밀번호 퀴즈</th>
                    <td><input type="text" name="pw_quiz" placeholder="비밀번호 찾기 질문을 입력하세요" required/></td>
                </tr>
                <tr>
                    <th>비밀번호 답변</th>
                    <td><input type="text" name="pw_answer" placeholder="비밀번호 찾기 답변을 입력하세요" required/></td>
                </tr>
                <tr>
                    <td colspan="2" class="button-container">
                        <input type="submit" value="등록"/>
                        <input type="button" class="cancel-button" value="취소" onclick="cancelSignup()" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
