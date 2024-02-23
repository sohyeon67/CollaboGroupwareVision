package kr.or.ddit.project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.project.mapper.ProjectMapper;
import kr.or.ddit.project.vo.Issue;
import kr.or.ddit.project.vo.IssueAttach;
import kr.or.ddit.project.vo.Project;
import kr.or.ddit.project.vo.ProjectMember;
import kr.or.ddit.util.PaginationInfoVO;

@Service
@Transactional(rollbackFor = Exception.class)
public class ProjectServiceImpl implements ProjectService {

	@Inject
	private ProjectMapper projectMapper;
	
	@Override
	public ServiceResult create(Project project) {
		ServiceResult result = null;
		
		// 날짜 데이터 변경
		project.setProjectStartDay(StringUtils.replace(project.getProjectStartDay(), "-", ""));
		project.setProjectEndDay(StringUtils.replace(project.getProjectEndDay(), "-", ""));
		
		// 프로젝트 생성
		int status = projectMapper.create(project);
		if(status > 0) {
			// 프로젝트 아이디
			String projectId = project.getProjectId();
			
			// 프로젝트 멤버 추가
			List<ProjectMember> projectMembers = project.getProjectMemList();
			projectMembers.forEach(member -> member.setProjectId(projectId));
			projectMapper.addMember(projectMembers);
			
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public List<Project> getProjectList() {
		return projectMapper.getProjectList();
	}

	@Override
	public List<Map<String, Object>> getCommonCodeList() {
		return projectMapper.getCommonCodeList();
	}

	@Override
	public Project getProjectDetails(String projectId) {
		return projectMapper.getProjectDetails(projectId);
	}

	@Override
	public ServiceResult update(Project project) {
		ServiceResult result = null;
		
		// 날짜 데이터 변경
		project.setProjectStartDay(StringUtils.replace(project.getProjectStartDay(), "-", ""));
		project.setProjectEndDay(StringUtils.replace(project.getProjectEndDay(), "-", ""));
		
		// 프로젝트 정보 수정
		int status = projectMapper.update(project);
		if(status > 0) {
			String projectId = project.getProjectId();
			projectMapper.deleteAllMember(projectId);	// 모든 멤버 삭제
			
			// 프로젝트 멤버 추가
			List<ProjectMember> projectMembers = project.getProjectMemList();
			projectMembers.forEach(member -> member.setProjectId(projectId));
			projectMapper.addMember(projectMembers);
			
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public Map<String, Object> getMyProjectCounts(String empNo) {
		return projectMapper.getMyProjectCounts(empNo);
	}

	@Override
	public List<Project> getMyProjectList(PaginationInfoVO<Project> pagingVO) {
		return projectMapper.getMyProjectList(pagingVO);
	}

	@Override
	public int getSearchMyProjectCount(PaginationInfoVO<Project> pagingVO) {
		return projectMapper.getSearchMyProjectCount(pagingVO);
	}

	@Override
	public boolean isProjectMember(String empNo, String projectId) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("projectId", projectId);
		paramMap.put("empNo", empNo);
		
		int count = projectMapper.isProjectMember(paramMap);
		return count > 0; 
	}

	
	// 일감 --------------------------------------------------------------------
	@Override
	public ServiceResult issueRegister(Issue issue) {
		ServiceResult result = null;
		
		// 날짜 데이터 변경
		issue.setIssueStartDay(StringUtils.replace(issue.getIssueStartDay(), "-", ""));
		issue.setIssueEndDay(StringUtils.replace(issue.getIssueEndDay(), "-", ""));
		
		// 일감 등록
		int status = projectMapper.issueRegister(issue);
		if(status > 0) {
			// 일감 첨부파일
			List<IssueAttach> issueAttachList = issue.getIssueAttachList();
			if(issueAttachList != null) {
				for(IssueAttach issueAttach : issueAttachList) {
					issueAttach.setIssueNo(issue.getIssueNo());
					projectMapper.insertIssueFile(issueAttach);
				}
			}
			
			result = ServiceResult.OK;
			
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public int getSearchIssueCount(PaginationInfoVO<Issue> pagingVO) {
		return projectMapper.getSearchIssueCount(pagingVO);
	}

	@Override
	public List<Issue> getIssueList(PaginationInfoVO<Issue> pagingVO) {
		return projectMapper.getIssueList(pagingVO);
	}

	@Override
	public Issue getIssueDetails(int issueNo) {
		return projectMapper.getIssueDetails(issueNo);
	}

	@Override
	public ServiceResult issueDelete(int issueNo) {
		ServiceResult result = null;
		
		// 일감 첨부파일 먼저 전부 삭제
		projectMapper.deleteAllIssueAttach(issueNo);		// 첨부파일이 없을 수도 있음
		int status = projectMapper.issueDelete(issueNo);	// 일감 삭제
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public List<Issue> getGanttChartData(String projectId) {
		return projectMapper.getGanttChartData(projectId);
	}

	@Override
	public ServiceResult issueUpdate(Issue issue) {
		ServiceResult result = null;
		
		// 날짜 데이터 변경
		issue.setIssueStartDay(StringUtils.replace(issue.getIssueStartDay(), "-", ""));
		issue.setIssueEndDay(StringUtils.replace(issue.getIssueEndDay(), "-", ""));
		
		// 일감 내용 수정
		int status = projectMapper.issueUpdate(issue);
		if(status > 0) {
			// 모든 첨부파일 삭제
			projectMapper.deleteAllIssueAttach(issue.getIssueNo());
			
			// 첨부파일 다시 추가
			List<IssueAttach> issueAttachList = issue.getIssueAttachList();
			if(issueAttachList != null) {
				for(IssueAttach issueAttach : issueAttachList) {
					issueAttach.setIssueNo(issue.getIssueNo());
					projectMapper.insertIssueFile(issueAttach);
				}
			}
			
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> getIssueMetrics(String projectId) {
		return projectMapper.getIssueMetrics(projectId);
	}

}
