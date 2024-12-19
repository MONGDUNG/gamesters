CREATE TABLE MEMBER (
    ID VARCHAR2(12) PRIMARY KEY, -- 아이디: 최소 5자 ~ 최대 12자
    PW VARCHAR2(18) NOT NULL, -- 비밀번호: 최소 7자 ~ 최대 18자
    NAME VARCHAR2(50) NOT NULL, -- 회원 성명
    EMAIL VARCHAR2(100) NOT NULL UNIQUE, -- 이메일: 최대 100자
    ISADMIN NUMBER DEFAULT 0, -- 관리자 여부 (1이면 관리자계정)
    NICKNAME VARCHAR2(21) NOT NULL UNIQUE, -- 닉네임: 최소 2자 ~ 최대 7자 (한글 7자 고려)
    JOIN_REG DATE DEFAULT SYSDATE, -- 가입 일자
    BIRTH DATE NOT NULL, -- 생년월일: YYYY-MM-DD 형식
    GENDER VARCHAR2(10) NOT NULL,
    PW_QUIZ VARCHAR2(100) NOT NULL, -- 비밀번호 퀴즈
    PW_ANSWER VARCHAR2(100) NOT NULL, -- 비밀번호 정답
    WARN_STACK NUMBER DEFAULT 0, -- 경고 스택
    IS_BANNED NUMBER DEFAULT 0 -- 정지 여부 (1이면 정지)
);

INSERT INTO MEMBER VALUES('admin12', 'zxasqw12!@', '문동규', 'ehdrb438438@naver.com', 1, '관리자1', '2024/11/28', '1998/05/20', '남자', '내 생일의 년, 월, 일을 모두 합한 값은 ? ', '2023', 0, 0);


CREATE TABLE BOARD (
    BOARDNUM NUMBER PRIMARY KEY, -- 글번호 (Primary Key)
    TITLE VARCHAR2(200) NOT NULL, -- 제목
    NICKNAME VARCHAR2(50), -- 작성자 닉네임
    CONTENT VARCHAR2(4000) NOT NULL, -- 게시글 내용
    READCOUNT NUMBER DEFAULT 0, -- 조회수 (기본값 0)
    REPLYCOUNT NUMBER DEFAULT 0, -- 댓글 수 (기본값 0)
    UPCNT NUMBER DEFAULT 0, -- 추천 수 (기본값 0)
    DWNCNT NUMBER DEFAULT 0, -- 비추천 수 (기본값 0)
    REG DATE DEFAULT SYSDATE, -- 작성 시간
    FILECOUNT NUMBER DEFAULT 0 -- 파일 개수 (기본값 0)
);

CREATE TABLE REPLY (
    REP_NUM NUMBER PRIMARY KEY, -- 댓글 고유 번호 (Primary Key)
    REP_CONTENT VARCHAR2(4000) NOT NULL, -- 댓글 내용
    REP_REG DATE DEFAULT SYSDATE, -- 댓글 작성 시간
    REP_UPCNT NUMBER DEFAULT 0, -- 추천 수 (기본값 0)
    REP_DWNCNT NUMBER DEFAULT 0, -- 비추천 수 (기본값 0)
    NICKNAME VARCHAR2(50), -- 작성자 닉네임
    REF NUMBER, -- 댓글 그룹 (최상위 댓글 번호)
    REF_STEP NUMBER -- 대댓글 순서
);

CREATE TABLE MSG (
    MSG_NUM NUMBER PRIMARY KEY, -- 쪽지 번호
    MSG VARCHAR2(500) NOT NULL, -- 내용
    SEND_NICK VARCHAR2(50) NOT NULL, -- 보내는 사람
    RECIVE_NICK VARCHAR2(50) NOT NULL, -- 받는 사람
    REG DATE DEFAULT SYSDATE, -- 발송 시간
    CONSTRAINT FK_SEND_NICK FOREIGN KEY (SEND_NICK) REFERENCES MEMBER(NICKNAME) ON DELETE CASCADE,
    CONSTRAINT FK_RECIVE_NICK FOREIGN KEY (RECIVE_NICK) REFERENCES MEMBER(NICKNAME) ON DELETE CASCADE
);
CREATE TABLE Report (
    REPORT_ID NUMBER PRIMARY KEY, -- 신고 ID
    REPORTER_NICK VARCHAR2(50), -- 신고자 닉네임
    TARGET_ID NUMBER NOT NULL, -- 신고 대상 ID (게시글/댓글 번호)
    REASON VARCHAR2(255) NOT NULL, -- 신고 사유
    REPORT_TIME DATE DEFAULT SYSDATE, -- 신고 시간
    STATUS VARCHAR2(20) DEFAULT '대기 중' -- 처리 상태 (대기 중, 처리됨)
);
CREATE TABLE STATUS_PROFILE (
    EX NUMBER DEFAULT 0, -- 현재 경험치
    EX_MAX NUMBER , -- 현재 레벨의 최대경험치
    LV NUMBER DEFAULT 1, -- 현재 레벨
    NICKNAME VARCHAR2(21), -- 닉네임
    GREETING VARCHAR2(150) -- 인삿말
);

CREATE TABLE LOG (
    EX NUMBER DEFAULT 0, -- 현재 경험치
    EX_MAX NUMBER , -- 현재 레벨의 최대경험치
    LV NUMBER DEFAULT 1, -- 현재 레벨
    NICKNAME VARCHAR2(21), -- 닉네임
    GREETING VARCHAR2(150) -- 인삿말
);

CREATE TABLE Log (
    LOG_ID NUMBER PRIMARY KEY, -- 로그 ID
    NICKNAME VARCHAR2(50) NOT NULL, -- 작성자 닉네임
    ACTION VARCHAR2(50) NOT NULL, -- 행동 (게시글 작성, 댓글 작성, 신고 등)
    TARGET_ID NUMBER, -- 대상 글/댓글 번호
    ACTION_TIME DATE DEFAULT SYSDATE -- 행동 시간
);
