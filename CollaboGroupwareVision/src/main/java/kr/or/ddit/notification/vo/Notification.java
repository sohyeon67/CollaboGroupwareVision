package kr.or.ddit.notification.vo;

import lombok.Data;

@Data
public class Notification {
	private int notiNo;
	private String empNo;
	private String notiKind;
	private String notiTitle;
	private String notiContent;
	private String notiDate;
	private String notiReadYn;
}
