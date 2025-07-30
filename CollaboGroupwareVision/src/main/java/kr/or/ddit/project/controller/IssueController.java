package kr.or.ddit.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.project.service.ProjectService;
import kr.or.ddit.project.vo.Issue;
import kr.or.ddit.project.vo.IssueAttach;
import kr.or.ddit.project.vo.Project;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.PaginationInfoVO;
import kr.or.ddit.util.UploadFileUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/project")
public class IssueController {

	@Inject
	private ProjectService projectService;
	
	// 일감 페이지. 일감 목록들을 뿌려줘야 함.
	@PreAuthorize("hasRole('ROLE_USER') and @projectSecurity.check(#projectId)")
	@RequestMapping("/{projectId}/issue")
	public String issuePage(
			@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false) String issueType,
			@RequestParam(required = false) String issueStatus,
			@RequestParam(required = false) String issuePriority,
			@RequestParam(required = false) String issueCharger,
			@RequestParam(required = false) String issueTitle,
			@PathVariable String projectId, Model model) {
		
		model.addAttribute("title", "프로젝트 일감");
		model.addAttribute("activeMain", "project");
		
		// 등록 모달을 위해
		// 프로젝트 설명, 멤버들 가져오기
		Project project = projectService.getProjectDetails(projectId);
		model.addAttribute("projectId", projectId);
		model.addAttribute("project", project);
		
		// 프로젝트 일감 목록들 가져오기
		PaginationInfoVO<Issue> pagingVO = new PaginationInfoVO<Issue>();
		pagingVO.setScreenSize(5);
		
		// 일감 검색 조건 추가
		Issue issue = new Issue();
		issue.setProjectId(projectId);
		issue.setIssueType(issueType);
		issue.setIssueStatus(issueStatus);
		issue.setIssuePriority(issuePriority);
		issue.setIssueCharger(issueCharger);
		issue.setIssueTitle(issueTitle);
		pagingVO.setSearchVO(issue);
		
		// 현재 페이지 설정 + start/endRow, start/endPage
		pagingVO.setCurrentPage(currentPage);
		
		int totalRecord = projectService.getSearchIssueCount(pagingVO);
		pagingVO.setTotalRecord(totalRecord);
		List<Issue> issueList = projectService.getIssueList(pagingVO);
		pagingVO.setDataList(issueList);
		
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("search", issue);

		return "project/issue";
	}

	
	// 비동기 파일 업로드
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/issue/uploadAjax")
	public ResponseEntity<Map<String, Object>> issueFileUploadAjax(HttpServletRequest req, String projectId, MultipartFile file) throws Exception {
		log.debug("프로젝트 아이디" + projectId);
		
		String savePath = "/resources/upload/project/"+projectId;	// 일감 첨부파일이 저장될 폴더 경로
		String issueFileName = file.getOriginalFilename();
		String resourcePath = req.getServletContext().getRealPath(savePath);	// D:\A_TeachingMaterial\07_JSP_Spring\workspace\workspace_spring2\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\CollaboGroupwareVision\resources\project\
		String savedName = UploadFileUtils.uploadFileNotMakeThumbnail(resourcePath, issueFileName, file.getBytes());	// /2024/01/29/5ee93634-db35-4b57-abed-e6a2dbc3f3bf_유재석.png
		String issueFileSavepath = savePath + savedName;
		long issueFileSize = file.getSize();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("issueFileName", issueFileName);
		map.put("issueFileSize", issueFileSize);
		map.put("issueFileFancysize", FileUtils.byteCountToDisplaySize(file.getSize()));
		map.put("issueFileMime", file.getContentType());
		map.put("issueFileSavepath", issueFileSavepath);
		
		return new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
		
	}
	
	// 일감 등록
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/issue/register")
	public String issueRegister(Issue issue, RedirectAttributes ra) {
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
		issue.setIssueWriter(employee.getEmpNo());
		
		ServiceResult result = projectService.issueRegister(issue);
		String projectId = issue.getProjectId();
		
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("successMsg", "일감 등록을 완료하였습니다.");
			return "redirect:/project/"+projectId+"/issue/"+issue.getIssueNo();
		} else {
			ra.addFlashAttribute("errorMsg", "일감 등록을 실패하였습니다.");
			return "redirect:/project/"+projectId+"/issue";
		}
		
	}
	
	// 일감 상세보기
	@PreAuthorize("hasRole('ROLE_USER') and @projectSecurity.check(#projectId)")
	@GetMapping("/{projectId}/issue/{issueNo}")
	public String issueDetails(@PathVariable String projectId, @PathVariable int issueNo, Model model) {
		
		model.addAttribute("title", "프로젝트 일감 제목");
		model.addAttribute("activeMain", "project");
		
		Issue issue = projectService.getIssueDetails(issueNo);
		
		// 수정할 때 불러올 정보들.., 네비 메뉴들 이동을 위해서
		Project project = projectService.getProjectDetails(projectId);
		
		log.debug("일감 상세정보 " + issue);
		model.addAttribute("issue", issue);
		model.addAttribute("project", project);
		
		// 수정 모달 전용 파일리스트 json 문자열
		// 파일이 없어도 issueNo 때문에 데이터가 존재
		List<IssueAttach> issueAttachList = issue.getIssueAttachList();
		if(issueAttachList != null) {
			Gson gson = new Gson();
			String jsonIssueAttachList = gson.toJson(issueAttachList);
			model.addAttribute("jsonIssueAttachList", jsonIssueAttachList);
		}
		
		
		return "project/issueDetails";
	}
	
	// 일감 삭제
	@PostMapping("/issue/delete")
	public String issueDelete(String projectId, int issueNo, RedirectAttributes ra) {
		String goPage = "";
		
		ServiceResult result = projectService.issueDelete(issueNo);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("successMsg", "일감이 정상적으로 삭제되었습니다.");
			goPage = "redirect:/project/"+projectId+"/issue";
		} else {
			ra.addFlashAttribute("errorMsg", "일감 삭제를 실패하였습니다.");
			goPage = "redirect:/project/issue/"+issueNo;
		}
		
		return goPage;
	}
	
	
	// 간트차트 뿌리기
	@PreAuthorize("hasRole('ROLE_USER') and @projectSecurity.check(#projectId)")
	@GetMapping("/{projectId}/ganttChart")
	public String ganttChart(@PathVariable String projectId, Model model) {
		
		model.addAttribute("title", "프로젝트 일감");
		model.addAttribute("activeMain", "project");
		
		
		// 간트차트 데이터들
		List<Issue> issueList = projectService.getGanttChartData(projectId);
		model.addAttribute("issueList", issueList);
		
		// 네비 메뉴들 이동, 프로젝트 시작, 종료일을 위해서
		Project project = projectService.getProjectDetails(projectId);
		model.addAttribute("project", project);
		
		return "project/ganttChart";
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/issue/update")
	public String issueUpdate(Issue issue, Model model, RedirectAttributes ra) {
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if (employee == null) {
			return "conn/login";
		}
		
		ServiceResult result = projectService.issueUpdate(issue);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("successMsg", "일감 수정을 완료하였습니다.");
		} else {
			ra.addFlashAttribute("errorMsg", "일감 수정을 실패하였습니다.");
		}
		
		return "redirect:/project/"+issue.getProjectId()+"/issue/"+issue.getIssueNo();
	}
	
	@ResponseBody
	@PostMapping("/issue/updateDate")
	public ResponseEntity<?> updateIssueDate(@RequestBody Issue issue) {
		ServiceResult result = projectService.updateIssueDate(issue);
		if(result.equals(ServiceResult.OK)) {
			return ResponseEntity.ok("success");
		} else {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("업데이트 실패");
		}
	}

	
}
