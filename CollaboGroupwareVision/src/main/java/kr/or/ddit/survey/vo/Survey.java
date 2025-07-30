package kr.or.ddit.survey.vo;

import java.util.List;

import lombok.Data;

@Data
public class Survey {
	private int surveyNo; 
	private String empNo; 
	private String surveyWriter;
	private String surveyTitle;
	private String surveyContent; 
	private int surveyRegDate;
	private int surveyStartDate;
	private int surveyEndDate;
	private String surveyStatus;
	private String surveySubject;
	
	public List<SurveyQuestion> surveyQuestionList;

	public int totalEmpNo; 
}
