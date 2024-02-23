package kr.or.ddit.project.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.project.vo.Issue;
import kr.or.ddit.project.vo.IssueAttach;
import kr.or.ddit.project.vo.Project;
import kr.or.ddit.project.vo.ProjectMember;
import kr.or.ddit.util.PaginationInfoVO;

public interface ProjectMapper {

	public int create(Project project);
	public void addMember(List<ProjectMember> projectMemList);
	public List<Project> getProjectList();
	public List<Map<String, Object>> getCommonCodeList();
	public Project getProjectDetails(String projectId);
	public int update(Project project);
	public void deleteAllMember(String projectId);
	public Map<String, Object> getMyProjectCounts(String empNo);
	public List<Project> getMyProjectList(PaginationInfoVO<Project> pagingVO);
	public int getSearchMyProjectCount(PaginationInfoVO<Project> pagingVO);
	public int isProjectMember(Map<String, Object> paramMap);
	
	public int issueRegister(Issue issue);
	public void insertIssueFile(IssueAttach issuAttach);
	public int getSearchIssueCount(PaginationInfoVO<Issue> pagingVO);
	public List<Issue> getIssueList(PaginationInfoVO<Issue> pagingVO);
	public Issue getIssueDetails(int issueNo);
	public int issueDelete(int issueNo);
	public int deleteAllIssueAttach(int issueNo);
	public List<Issue> getGanttChartData(String projectId);
	public int issueUpdate(Issue issue);
	
	public List<Map<String, Object>> getIssueMetrics(String projectId);

	
}
