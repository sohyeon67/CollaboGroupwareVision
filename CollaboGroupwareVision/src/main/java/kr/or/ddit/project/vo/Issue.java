package kr.or.ddit.project.vo;

import java.util.List;

import lombok.Data;

@Data
public class Issue {
	private int issueNo;
	private String projectId;
	private String issueTitle;
	private String issueContent;
	private String issueRegDate;
	private String issueStartDay;
	private String issueEndDay;
	private String issueWriter;
	
	private String issueCharger;		// 사번
	private String issueChargerName;	// 이름
	private String issueChargerProfile;	// 프로필
	
	private int issueProgress;
	
	private String issuePriority;	// 코드
	private String priority;		// 코드명
	
	private String issueType;
	private String type;
	
	private String issueStatus;
	private String status;
	
	private List<IssueAttach> issueAttachList;	// 일감 첨부파일 리스트
	
}
