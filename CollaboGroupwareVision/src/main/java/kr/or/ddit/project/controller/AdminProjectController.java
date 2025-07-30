package kr.or.ddit.project.controller;

import java.util.List;

import javax.inject.Inject;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.project.service.ProjectService;
import kr.or.ddit.project.vo.Project;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/adminProject")
public class AdminProjectController {
	
	@Inject
	private ProjectService projectService;
	
	// 프로젝트 관리 페이지
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping(value={"", "/home"})
	public String adminPmsHome(Model model) {
		model.addAttribute("adminMenu","y");
		model.addAttribute("title","프로젝트 관리");
		model.addAttribute("activeMain","project");
		
		return "project/adminProjectHome";
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/create")
	public String create(Project project, RedirectAttributes ra) {
		
		// 프로젝트 id는 insert key
		log.debug("프로젝트 정보" + project);
		
		ServiceResult result = projectService.create(project);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("resultMsg", "프로젝트가 정상적으로 생성되었습니다.");
		}else {
			ra.addFlashAttribute("resultMsg", "프로젝트 생성을 실패하였습니다.");
		}
		
		return "redirect:/adminProject";
	}
	
	// 모든 프로젝트 리스트
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/getProjectList")
	public List<Project> getProjectList() {
		return projectService.getProjectList();
	}
	
	
	
	
	
	
}
