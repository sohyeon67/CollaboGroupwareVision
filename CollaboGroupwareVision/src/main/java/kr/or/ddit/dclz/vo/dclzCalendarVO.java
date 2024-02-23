package kr.or.ddit.dclz.vo;

import lombok.Data;

@Data
public class dclzCalendarVO {
	private String id;
	private String title;
	private String start;
	private String end;
	private String backgroundColor;
	private String textColor;
	private String className;
	private boolean allDay;
	private String color;
}
