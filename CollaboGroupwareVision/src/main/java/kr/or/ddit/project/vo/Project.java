package kr.or.ddit.project.vo;

import java.util.List;

import lombok.Data;

@Data
public class Project {
	private String projectId;
	private String projectName;
	private String projectDescription;
	private String projectStartDay;
	private String projectEndDay;
	private String projectStatus;
	
	private List<ProjectMember> projectMemList;
	
	private String leaderName;
	private int memCount;
}
