package project01.member.bean;

public class MemberDTO {
	private String id;
	private String pw;
	private String name;
	private String email;
	private String emailDomain;
	private int isadmin;
	private String nickname;
	private String join_reg;
	private String birth;
	private String birthYear;
	private String birthMonth;
	private String birthDay;
	private String emailPlusDomain;
	private	String gender;
	private String pw_quiz;
	private String pw_answer;
	private int warn_stack;
	private int is_banned;
    private int level; // 현재 레벨
    private int exp; // 현재 경험치
    private int maxExp; // 최대 경험치
    private String greeting; // 인사말
    private String unban_date; // 제재 해제 날짜
    
	public String getId() {
		return id;
	}
	public String getPw() {
		return pw;
	}
	public String getName() {
		return name;
	}
	public String getEmail() {
		return email;
	}
	public String getEmailDomain() {
		return emailDomain;
	}
	public int getIsadmin() {
		return isadmin;
	}
	public String getNickname() {
		return nickname;
	}
	public String getJoin_reg() {
		return join_reg;
	}
	public String getBirth() {
		return birth;
	}
	public String getBirthYear() {
		return birthYear;
	}
	public String getBirthMonth() {
		return birthMonth;
	}
	public String getBirthDay() {
		return birthDay;
	}
	public String getEmailPlusDomain() {
		return emailPlusDomain;
	}
	public String getGender() {
		return gender;
	}
	public String getPw_quiz() {
		return pw_quiz;
	}
	public String getPw_answer() {
		return pw_answer;
	}
	public int getWarn_stack() {
		return warn_stack;
	}
	public int getIs_banned() {
		return is_banned;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public void setEmailDomain(String emailDomain) {
		this.emailDomain = emailDomain;
	}
	public void setIsadmin(int isadmin) {
		this.isadmin = isadmin;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public void setJoin_reg(String join_reg) {
		this.join_reg = join_reg;
	}
	public void setBirth(String birthYear, String birthMonth, String birthDay) {
		this.birth = birthYear + "-" + birthMonth + "-" + birthDay;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public void setBirthYear(String birthYear) {
		this.birthYear = birthYear;
	}
	public void setBirthMonth(String birthMonth) {
		this.birthMonth = birthMonth;
	}
	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}
	public void setEmailPlusDomain(String email, String emailDomain) {
		this.emailPlusDomain =  email + "@" + emailDomain;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public void setPw_quiz(String pw_quiz) {
		this.pw_quiz = pw_quiz;
	}
	public void setPw_answer(String pw_answer) {
		this.pw_answer = pw_answer;
	}
	public void setWarn_stack(int warn_stack) {
		this.warn_stack = warn_stack;
	}
	public void setIs_banned(int is_banned) {
		this.is_banned = is_banned;
	}
	public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public int getExp() {
        return exp;
    }

    public void setExp(int experience) {
        this.exp = experience;
    }

    public int getMaxExp() {
        return maxExp;
    }

    public void setMaxExp(int maxExp) {
        this.maxExp = maxExp;
    }
	
	public String getGreeting() {
		return greeting;
	}

	public void setGreeting(String greeting) {
		this.greeting = greeting;
	}

	public String getUnban_date() {
		return unban_date;
	}

	public void setUnban_date(String unban_date) {
		this.unban_date = unban_date;
	}
}
