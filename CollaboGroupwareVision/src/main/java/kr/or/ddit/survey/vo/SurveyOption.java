package kr.or.ddit.survey.vo;

import lombok.Data;

@Data
public class SurveyOption {
	private int optionNo;
	private int questionNo;
	private int surveyNo;
	private String optionContent;
	private int selectEmpNo;
}
