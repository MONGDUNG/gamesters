
<!-- inputForm.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project01.member.bean.MemberDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        .hidden-input {
            display: none;
            margin-top: 5px;
        }
    </style>
    <script src="/project01/resources/js/input.js"></script>
	<script>
	    function checkDuplicateId() {
	        var id = document.querySelector('input[name="id"]').value;
	        window.open('checkDuplicateId.jsp?id=' + encodeURIComponent(id), 
	        		'ID 중복 체크', 'width=400,height=200');}
	    function checkDuplicateNick() {
	        var nickname = document.querySelector('input[name="nickname"]').value;
	        window.open('checkDuplicateNick.jsp?nickname=' + nickname, 
	        		'닉네임 중복 체크', 'width=400,height=200');}
	</script>
</head>
<body>
    <form action="inputPro.jsp" onsubmit="return inputCheck()" method="post">
        <font size="5"><B><CENTER><u>회원 가입</u></CENTER></B></font>
        <br />
        <table border="1" bordercolor="black" align="center">
            <tr>
                <th colspan="2" bgcolor="#F29661"><font color="#A566FF">필수입력사항</font></th>
            </tr>
            <tr>
                <th bgcolor="#F2CB61">이름</th>
                <td align="left"><input type="text" name="name" placeholder="이름을 입력하세요" required/></td>
            </tr>
            <tr>
                <th bgcolor="#F2CB61">아이디</th>
                <td align="left"><input type="text" name="id" placeholder="아이디를 입력하세요" required/>
                <button type="button" onclick="checkDuplicateId()">ID 중복 체크</button></td>
            </tr>
            <tr>
                <th bgcolor="#F2CB61">비밀번호</th>
                <td align="left"><input type="password" name="pw" placeholder="비밀번호를 입력하세요" required/></td>
            </tr>
            <tr>
                <th bgcolor="#F2CB61">비밀번호 확인</th>
                <td align="left"><input type="password" name="pwConfirm" placeholder="비밀번호를 다시 입력하세요" required/></td>
            </tr>
            <tr>
                <th bgcolor="#F2CB61">생년월일</th>
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
                <th bgcolor="#F2CB61">성별</th>
                <td>
                    <input type="radio" id="male" name="gender" value="1" required><label for="male">남</label>
                    <input type="radio" id="female" name="gender" value="2"><label for="female">여</label>
                </td>
            </tr>
            <tr>	
				<th bgcolor="#F2CB61">E-Mail</th>
			<td>
				<input type="text"  name="email"/>@
				<input type="text" id="emailDomain" name="emailDomain" />
				<select onchange="updateEmailDomain(this)">
					<option value="custom">==직접입력==</option>       
					<option value="naver.com">naver.com</option>
					<option value="gmail.com">gmail.com</option>
					<option value="hanmail.net">hanmail.net</option>
				</select>
			</td>
			</tr>
            <tr>
                <th bgcolor="#F2CB61">닉네임</th>
                <td align="left"><input type="text" name="nickname" placeholder="닉네임을 입력하세요" required/>
                <button type="button" onclick="checkDuplicateNick()">닉네임 중복 체크</button></td>
            </tr>
            <tr>
                <th bgcolor="#F2CB61">비밀번호 퀴즈</th>
                <td align="left"><input type="text" name="pw_quiz" placeholder="비밀번호 찾기 질문을 입력하세요" required/></td>
            </tr>
            <tr>
                <th bgcolor="#F2CB61">비밀번호 답변</th>
                <td align="left"><input type="text" name="pw_answer" placeholder="비밀번호 찾기 답변을 입력하세요" required/></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="등록"/>
                    <input type="button" value="취소" onclick="cancelSignup()" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
