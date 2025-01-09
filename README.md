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
