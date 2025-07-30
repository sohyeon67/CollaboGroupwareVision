package kr.or.ddit.community.vo;

import lombok.Data;

@Data
public class CmnyMem {
	private int cmnyMemNo;
	private int cmnyNo;
	private String empNo;
	private String joinDay;
	private String quitDay;
	private String cmnyEnabled;
	private String cmnyMemApproval;
	private String cmnyMemReturn;
	private String cmnyTopYn;
	private String deptName;
	private String empName;
	private String positionName;

}
