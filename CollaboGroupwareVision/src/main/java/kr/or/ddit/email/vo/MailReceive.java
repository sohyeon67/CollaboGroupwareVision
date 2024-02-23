package kr.or.ddit.email.vo;

import kr.or.ddit.account.vo.Employee;
import lombok.Data;

@Data
public class MailReceive {
	
	private String empNo;		// 받는사람 사번
	private int mailNo;			// 메일번호
	private String receiveDate;	// 받은날짜
	private String important;	// 중요(Y:중요/N:일반)
	private String mailStatus;	// 메일상태(01:정상/00:휴지통)
	private String mailReadYn;// 메일읽음여부
	private String mailDelYn;	// 삭제여부
	
	private Employee employee;
	
	public MailReceive() {}
	
	public MailReceive(String empNo) {
		this.empNo = empNo;
	}
}
