package kr.or.ddit.calendar.vo;

import lombok.Data;
@Data
public class Calendar {
	
private int calNo;				// 일정번호
private String empNo;			// 사원번호
private String calTitle;		// 제목
private String calRegDate;		// 등록일시
private String calContent;		// 일정내용
private String calStartDate;	// 일정 시작날짜
private String calEndDate;		// 일정 끝나는날짜
private int calRepeatUnit;		// 일정 반복단위
private String calType;			// 일정 종류 개인/부서/전사
private String calRepeatYn;		// 일정반복여부 Y/N 공통코드
private String calColor;		// 일정 색깔 개인:green/부서:blue/전사:red
private String calRepeatDate; 	// 일정 반복 종료일
private String calAll;			// allDay

}              
