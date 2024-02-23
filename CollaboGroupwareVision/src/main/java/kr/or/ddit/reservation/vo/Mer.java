package kr.or.ddit.reservation.vo;

import lombok.Data;

@Data
public class Mer {
	private int merNo;		// 회의실 번호
	private String merName; // 회의실 이름
	private String enabled;	// 사용가능 여부: Y-사용가능, N-사용중
}
