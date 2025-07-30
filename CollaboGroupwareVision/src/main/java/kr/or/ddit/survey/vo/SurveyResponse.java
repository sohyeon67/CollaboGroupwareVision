package kr.or.ddit.survey.vo;

import java.sql.Date;

import lombok.Data;

@Data
public class SurveyResponse {
	private int responseNo;
	private int questionNo;
	private int surveyNo;
	private int responseName;
	private String responseContent;
	private Date responseDate;
	private String responseYn;
}
