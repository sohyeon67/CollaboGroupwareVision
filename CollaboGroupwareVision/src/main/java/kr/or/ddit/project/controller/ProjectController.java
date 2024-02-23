package kr.or.ddit.project.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.project.service.ProjectService;
import kr.or.ddit.project.vo.Project;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/project")
public class ProjectController {

	@Inject
	private ProjectService projectService;

	// 수정버튼을 눌렀을 때 프로젝트 정보 가져오기, 수정은 사원, 관리자 가능
	@ResponseBody
	@GetMapping("/getProjectDetails/{projectId}")
	public Project getProjectDetails(@PathVariable String projectId) {
		return projectService.getProjectDetails(projectId);
	}

	// 수정기능. 사원, 관리자 어느 페이지에서 왔는지 from으로 구분
	@PostMapping("/update/{projectId}")
	public String update(@PathVariable String projectId, Project project, RedirectAttributes ra, String from) {

		project.setProjectId(projectId);

		log.debug("프로젝트 정보" + project);
		log.debug("프로젝트 멤버 " + project.getProjectMemList());

		ServiceResult result = projectService.update(project);
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("resultMsg", "프로젝트가 정상적으로 변경되었습니다.");
		} else {
			ra.addFlashAttribute("resultMsg", "프로젝트 변경을 실패하였습니다.");
		}

		// 수정 후 리더랑 관리자 리다이렉트 되는 경로 구분하기
		if (from.equals("admin")) {
			return "redirect:/adminProject";
		}
		return "redirect:/project/" + projectId;

	}

	// 프로젝트 홈
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping(value = { "", "/home" })
	public String userProjectHome(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false) String projectStatus,
			@RequestParam(required = false, defaultValue = "projectId") String searchType,
			@RequestParam(required = false) String searchWord, Model model) {
		model.addAttribute("title", "프로젝트 홈");
		model.addAttribute("activeMain", "project");

		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();

		if (employee != null) {
			PaginationInfoVO<Project> pagingVO = new PaginationInfoVO<Project>();
			String empNo = employee.getEmpNo();
			pagingVO.setEmpNo(empNo);

			// 전체, 프로젝트 상태별 수
			Map<String, Object> projectCounts = projectService.getMyProjectCounts(empNo);

			// 키워드가 있을 때 검색 => 검색 타입과 키워드 설정
			if (StringUtils.isNotBlank(searchWord)) {
				pagingVO.setSearchType(searchType);
				pagingVO.setSearchWord(searchWord);
				model.addAttribute("searchType", searchType);
				model.addAttribute("searchWord", searchWord);
			}

			// 현재 페이지 전달 후, start/endRow와 start/endPage 설정
			pagingVO.setCurrentPage(currentPage);
			Project project = new Project();
			project.setProjectStatus(projectStatus);
			pagingVO.setSearchVO(project);

			// 총 게시글 수
			int totalRecord = projectService.getSearchMyProjectCount(pagingVO);
			pagingVO.setTotalRecord(totalRecord);
			List<Project> projectList = projectService.getMyProjectList(pagingVO);
			pagingVO.setDataList(projectList);
			
			List<Map<String, Object>> commonCodes = projectService.getCommonCodeList();
			model.addAttribute("commonCodes", commonCodes);

			model.addAttribute("projectCounts", projectCounts);
			model.addAttribute("pagingVO", pagingVO);
			model.addAttribute("search", project);
		} else {
			return "conn/login";
		}

		return "project/userProjectHome";
	}
	
	// 프로젝트 담당자별 일감 통계
	@ResponseBody
	@GetMapping("/{projectId}/issueMetrics.json")
	public List<Map<String, Object>> issueMetrics(@PathVariable String projectId) {
		log.debug("일감 통계 프로젝트 " + projectId);
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		result = projectService.getIssueMetrics(projectId);
		log.debug("일감 통계 데이터 " + result);
		return result;
	}

	// 프로젝트 상세, 프로젝트 멤버(사원)만 접근 가능
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping(value = { "/{projectId}", "/{projectId}/overview" })
	public String projectOverview(@PathVariable String projectId, Model model, RedirectAttributes ra) {

		// 프로젝트 멤버만 허용하기 위해 로그인한 유저 정보 가져오기
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if (employee == null) {
			return "conn/login";
		}

		// 프로젝트 멤버인지 확인
		String empNo = employee.getEmpNo();
		boolean isProjectMember = projectService.isProjectMember(empNo, projectId);
		if (!isProjectMember) {
			ra.addFlashAttribute("accessError", "해당 프로젝트 멤버만 접근할 수 있습니다!");
			return "redirect:/project";
		}

		// 프로젝트 설명, 멤버들 가져오기
		Project project = projectService.getProjectDetails(projectId);

		model.addAttribute("title", "프로젝트 개요");
		model.addAttribute("activeMain", "project");
		model.addAttribute("project", project);

		List<Map<String, Object>> commonCodes = projectService.getCommonCodeList();
		model.addAttribute("commonCodes", commonCodes);

		return "project/overview";
	}

}
