# Gamesters

**Gamesters**는 Java EE (Java Enterprise Edition)를 사용하여 개발된 종합 게임 커뮤니티 웹사이트입니다. JSP, 서블릿 및 데이터베이스 통합을 활용하여 사용자와 상호작용할 수 있는 웹 애플리케이션을 제공합니다.

---

## 📖 **프로젝트 개요**

Gamesters는 Java EE 기반의 동적 웹 프로젝트로, 사용자 및 관리 기능을 포함한 다양한 상호작용 기능을 제공합니다.

---

## ✨ **주요 기능**

### 1. **사용자 관리**
- 회원가입 및 로그인 기능
- 회원 정보 수정 및 삭제
- 비밀번호 및 아이디 찾기
- 관리자의 사용자 제재 기능

### 2. **게시판 관리**
- 게시판 생성, 수정, 삭제 (관리자 전용)
- 게시물 작성, 수정, 삭제
- 댓글 작성 및 관리
- 게시물 신고 및 관리

### 3. **메시지 시스템**
- 사용자 간 메시지 전송
- 사용자 차단 및 차단 해제
- 메시지 삭제 및 조회

### 4. **레벨 시스템**
- 사용자 활동에 따라 레벨을 표현
- 레벨 아이콘을 통해 상태 표시

### 5. **관리자 기능**
- 게시판, 사용자, 신고 관리
- 금칙어 설정 및 관리

---

## ⚙️ **기술 스택**

### **백엔드**
- Java EE
- JSP/Servlet
- JDBC

### **프론트엔드**
- HTML/CSS/JavaScript
- JQuery

### **데이터베이스**
- Oracle DB

### **추가 라이브러리**
- `commons-fileupload`
- `json-20210307`
- `ojdbc17`
- `jakarta.activation`
- `jakarta.mail`

---

## 🛠️ **설치 및 실행**

### 1. **저장소 클론**
```bash
git clone <repository-url>
cd project01
```

### 2. **필요한 라이브러리 설치**
- `WEB-INF/lib` 디렉토리에 필요한 `.jar` 파일이 포함되어 있는지 확인합니다.

### 3. **데이터베이스 설정**
- `src/main/webapp/sql/` 경로에 있는 SQL 파일을 실행하여 데이터베이스 테이블을 생성합니다.
- `project01/site/bean/DataBaseConnection.java` 파일에서 데이터베이스 접속 정보를 수정합니다.

### 4. **서버 실행**
- Eclipse, IntelliJ와 같은 IDE를 사용하여 Tomcat 서버를 설정하고 프로젝트를 실행합니다.

### 5. **애플리케이션 접속**
- 브라우저에서 다음 주소로 접속합니다:
  ```
  http://localhost:8080/project01/member/main.jsp
  ```

---

## 🤝 **기여 방법**

1. 버그 리포트나 새로운 기능 제안을 위해 이슈를 생성해주세요.
2. Pull Request를 통해 기여할 수 있습니다.

---

## 📄 **라이선스**

이 프로젝트는 [MIT License](LICENSE)에 따라 배포됩니다.

---

![Gamesters Screenshot](https://github.com/user-attachments/assets/37878f6d-a12c-4446-9b2e-33b744718126)
# Gamesters

**Gamesters** is a comprehensive gaming community website developed as a dynamic web project using Java EE (Java Enterprise Edition). It leverages JSP, Servlets, and database integration to provide an interactive web application for users.

---

## 📖 **Project Overview**

Gamesters is a Java EE-based dynamic web project that offers both administrative and user interaction functionalities. It provides robust features for managing users, boards, messages, and more.

---

## ✨ **Key Features**

### 1. **User Management**
- Member registration and login functionality.
- User profile modification and deletion.
- Password and ID recovery.
- User sanctions by the administrator.

### 2. **Board Management**
- Creation, modification, and deletion of boards (Admin only).
- Post creation, editing, and deletion.
- Comment creation and management.
- Post reporting and administration.

### 3. **Messaging System**
- User-to-user message transmission.
- Message blocking and unblocking.
- Message deletion and retrieval.

### 4. **Level System**
- User levels based on activity.
- Status representation through level icons.

### 5. **Administrator Features**
- Management of boards, users, and reports.
- Configuration and management of prohibited words.

---

## ⚙️ **Tech Stack**

### **Backend**
- Java EE
- JSP/Servlet
- JDBC

### **Frontend**
- HTML/CSS/JavaScript
- JQuery

### **Database**
- Oracle DB

### **Additional Libraries**
- `commons-fileupload`
- `json-20210307`
- `ojdbc17`
- `jakarta.activation`
- `jakarta.mail`

---

## 🛠️ **Installation & Execution**

### 1. **Clone the Repository**
```bash
git clone <repository-url>
cd project01
```

### 2. **Install Required Libraries**
- Ensure the required `.jar` files are included in the `WEB-INF/lib` directory.

### 3. **Database Configuration**
- Execute the SQL files located in the `src/main/webapp/sql/` directory to set up the database tables.
- Modify database connection information in `project01/site/bean/DataBaseConnection.java`.

### 4. **Run the Server**
- Use an IDE like Eclipse or IntelliJ to configure a Tomcat server and run the project.

### 5. **Access the Application**
- Open a browser and navigate to:
  ```
  http://localhost:8080/project01/member/main.jsp
  ```

---

## 🤝 **How to Contribute**

1. Create an issue to report bugs or suggest new features.
2. Submit a pull request to contribute.

---

## 📄 **License**

This project is distributed under the [MIT License](LICENSE).

---

![Gamesters Screenshot](https://github.com/user-attachments/assets/37878f6d-a12c-4446-9b2e-33b744718126)

---

