package kr.or.ddit.dclz.vo;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.vo.Dept;
import lombok.Data;

@Data
public class Dclz {
	
	private String dclzNo;
	private String empNo;
	private String gowkDate; //캘린더에서 start 값
	private String lvwkDate;
	private String dclzType;
	private String calTitle; //풀캘린더 제목 ex.근무
    private String calClassName; //풀캘린더 색상
	private String hoursMinutes; //총 근무시간
	private String empName; 
	private String calColor; //부서근태현황 event-dot color
	
	private Employee employee;
	private Dept dept;
	
}
