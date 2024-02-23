package kr.or.ddit.project.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.project.vo.Issue;
import kr.or.ddit.project.vo.Project;
import kr.or.ddit.util.PaginationInfoVO;

public interface ProjectService {

	public ServiceResult create(Project project);
	public List<Project> getProjectList();
	public List<Map<String, Object>> getCommonCodeList();
	public Project getProjectDetails(String projectId);
	public ServiceResult update(Project project);
	public Map<String, Object> getMyProjectCounts(String empNo);
	public List<Project> getMyProjectList(PaginationInfoVO<Project> pagingVO);
	public int getSearchMyProjectCount(PaginationInfoVO<Project> pagingVO);
	public boolean isProjectMember(String empNo, String projectId);
	
	public ServiceResult issueRegister(Issue issue);
	public int getSearchIssueCount(PaginationInfoVO<Issue> pagingVO);
	public List<Issue> getIssueList(PaginationInfoVO<Issue> pagingVO);
	public Issue getIssueDetails(int issueNo);
	public ServiceResult issueDelete(int issueNo);
	public List<Issue> getGanttChartData(String projectId);
	public ServiceResult issueUpdate(Issue issue);
	
	public List<Map<String, Object>> getIssueMetrics(String projectId);

}
