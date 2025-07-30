package kr.or.ddit.survey.vo;

import java.util.List;

import lombok.Data;

@Data
public class SurveyQuestion {
	private int questionNo;
	private int surveyNo;
	private String questionTitle;
	private String needYn;
	private String surveyType;
	private int attendeeCount;
	private List<SurveyOption> surveyOptionList;
}
