package kr.or.ddit.org.controller;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.service.OrgService;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/org")
public class OrgController {
	
	@Inject
	private OrgService orgService;

	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/orgChart")
	public String getMyOrgDetails(Model model) {
		model.addAttribute("title","조직도");
		model.addAttribute("activeMain","org");
		
		// Default로 내 정보 띄우기 위해
		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
	    
	    if (employee != null) {
			log.debug("정보 불러오기 성공!");
			log.debug("내 사번"+employee.getEmpNo());
			Employee myOrgDetails = orgService.getOrgDetails(employee.getEmpNo());
			model.addAttribute("emp", myOrgDetails);
		} else {
			log.debug("로그인 실패!");
			return "conn/login";
		}
		
		return "org/orgChartDetailView";
	}
	
	@ResponseBody
	@GetMapping("/getOrgTree")
	public List<Map<String, Object>> getOrgTree() {
		List<Map<String, Object>> orgTreeData = orgService.getOrgTree();
		
		return orgTreeData;
	}
	
	@ResponseBody
	@GetMapping("/getOrgDetails")
	public Employee getOtherOrgDetails(String empNo) {
		Employee employee = orgService.getOrgDetails(empNo);
		
		return employee;
	}
	
	
	
}
