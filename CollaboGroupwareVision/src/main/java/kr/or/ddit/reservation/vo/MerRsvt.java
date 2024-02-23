package kr.or.ddit.reservation.vo;

import lombok.Data;

@Data
public class MerRsvt {
	private int mRsvtNo;			// 회의실예약번호
	private int merNo;				// 회의실 번호
	private String empNo;			// 사원번호
	private String rsvtDate;		// 예약날짜
	private String strtRsvtDate;	// 예약 시작날짜
	private String endRsvtDate;		// 예약 종료날짜
	private String ppus;			// 사용목적
	private String merCancel;		// 취소사유
	private String resrceRsvtStatus;// 예약상태 : 00-취소,01-예약중,02-예약만료
	private String mRsvtTitle;		// 예약제목
	
	private Mer mer;
}
