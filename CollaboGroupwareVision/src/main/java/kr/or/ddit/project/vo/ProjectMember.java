package kr.or.ddit.project.vo;

import lombok.Data;

@Data
public class ProjectMember {
	private String empNo;
	private String projectId;
	private String leaderYn;
	
	private String empName;
	private String deptName;
	private String position;
	private String profileImgPath;
}
