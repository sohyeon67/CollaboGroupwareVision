package kr.or.ddit.drafting.vo;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.vo.Dept;
import lombok.Data;

@Data
public class Approval {

	private int apprvOrder;
	private String drftNo;
	private String empNo;
	private String apprvSignerName;
	private String apprvSignerDeptName;
	private String apprvSignerPositionName;
	private byte[] apprvSignImg;
	private String apprvDate;
	private String apprvStatus;
	private String apprvReject;
	private String apprvFinalYn;
	
	private Employee employee;
	private Dept dept;
	
	
}
