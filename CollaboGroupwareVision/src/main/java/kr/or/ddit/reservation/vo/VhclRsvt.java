package kr.or.ddit.reservation.vo;

import lombok.Data;

@Data
public class VhclRsvt {
	
	private int vRsvtNo;				//차량예약번호
	private String empNo;				//예약자(사원번호)
	private String empName;				//예약자(사원이름)
	private String vhclNo;				//차량번호
	private String rsvtDate;			//예약날짜
	private String strtRsvtDate;		//예약 시작날짜
	private String endRsvtDate;			//예약 종료날짜
	private String ppus;				//사용목적
	private String vhclCancel;			//취소사유
	private String resrceRsvtStatus;	//예약상태 : 00-취소,01-예약중,02-예약만료
	
	private Vhcl vhcl;

}
