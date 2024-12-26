# gamesters
Gamesters A Comprehensive Gaming Community Website.


프로젝트 개요

gamesters는 Java EE (Java Enterprise Edition) 기반의 다이나믹 웹 프로젝트로, JSP, 서블릿, 데이터베이스 통합을 활용하여 사용자가 상호작용할 수 있는 웹 애플리케이션을 제공합니다. 이 프로젝트는 MVC 아키텍처를 준수하며 관리 기능과 사용자 상호작용 기능을 포함합니다.

주요 기능

1. 사용자 관리

회원가입 및 로그인 기능

회원 정보 수정 및 삭제

비밀번호 찾기 및 아이디 찾기

관리자에 의한 사용자 제재 기능

2. 게시판 관리

게시판 생성, 수정, 삭제 (관리자 전용)

게시물 작성, 수정, 삭제

댓글 작성 및 관리

게시물 신고 및 관리

3. 메시지 시스템

사용자 간 메시지 전송

메시지 차단 및 차단 해제

메시지 삭제 및 조회

4. 레벨 시스템

사용자의 활동에 따라 레벨을 표현

레벨 아이콘을 통해 상태 표시

5. 관리자 기능

게시판, 사용자, 신고 관리

금칙어 설정 및 관리

기술 스택

백엔드

Java EE

JSP/Servlet

JDBC

프론트엔드

HTML/CSS/JavaScript

JQuery

데이터베이스

Oracle DB

추가 라이브러리

commons-fileupload
json-20210307
ojdbc17
jakarta.activation
jarkarta.mail

프로젝트 구조

project01/
├── src/main/java
│   ├── project01/admin/bean       # 관리자 관련 DAO 및 DTO
│   ├── project01/board/bean       # 게시판 관련 DAO 및 DTO
│   ├── project01/member/bean      # 회원 관련 DAO 및 DTO
│   ├── project01/msg/bean         # 메시지 관련 DAO 및 DTO
│   ├── project01/report/bean      # 신고 관리 DAO 및 DTO
│   └── project01/site/bean        # 공통 모듈 (DB 연결 등)
├── src/main/webapp
│   ├── admin/                     # 관리자 페이지 JSP
│   ├── board/                     # 게시판 관련 JSP
│   ├── member/                    # 회원 관련 JSP
│   ├── msg/                       # 메시지 관련 JSP
│   ├── resources/                 # 정적 리소스 (이미지, JS, CSS 등)
│   ├── SE2/                       # 에디터 관련 파일
│   ├── WEB-INF/
│   │   ├── lib/                   # 프로젝트 의존 라이브러리
│   │   └── web.xml                # 웹 애플리케이션 설정
│   └── sql/                       # 데이터베이스 스키마
└── build/                         # 컴파일된 클래스 파일

설치 및 실행

소스 코드 다운로드

git clone <repository-url>
cd project01

필요한 라이브러리 설치
WEB-INF/lib 디렉토리에 필요한 .jar 파일 포함되어 있습니다.

데이터베이스 설정

src/main/webapp/sql/ 경로에 있는 SQL 파일을 실행하여 데이터베이스 테이블을 생성합니다.

project01/site/bean/DataBaseConnection.java에서 DB 접속 정보를 수정합니다.

서버 실행

Eclipse, IntelliJ 등 IDE에서 Tomcat 서버를 설정하고 프로젝트를 실행합니다.

접속

브라우저에서 http://localhost:8080/project01 로 접속합니다.

기여 방법

이슈를 생성하여 버그 리포트 또는 새로운 기능 제안을 남겨주세요.

Pull Request를 통해 기여할 수 있습니다.

라이선스

이 프로젝트는 MIT 라이선스에 따라 배포됩니다.
