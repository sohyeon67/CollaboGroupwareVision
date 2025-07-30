package kr.or.ddit.org.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.org.service.OrgService;
import kr.or.ddit.org.vo.Dept;
import kr.or.ddit.util.FormatUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/adminOrg")
public class AdminOrgController {

	@Inject
	private OrgService orgService;

	// 조직관리
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/orgDesign")
	public String getAdminOrg(Model model) {
		model.addAttribute("adminMenu","y");
		model.addAttribute("title","조직관리");
		model.addAttribute("activeMain","adminOrg");
		model.addAttribute("active","orgDesign");
		
		return "org/adminOrgChart";
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/createDept")
	public ResponseEntity<Dept> createDept(@RequestBody Dept dept) {
		
		ResponseEntity<Dept> entity = null;
		ServiceResult result = orgService.createDept(dept);
		
		if(result.equals(ServiceResult.OK)) {	// 등록 성공
			entity = new ResponseEntity<Dept>(dept, HttpStatus.OK);
		}else {		// 등록 실패
			entity = new ResponseEntity<Dept>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/softDeleteDept")
	public ResponseEntity<String> softDeleteDept(@RequestBody Dept dept) {
		ResponseEntity<String> entity = null;

		ServiceResult result = orgService.softDeleteDept(dept.getDeptCode());
		
		if(result.equals(ServiceResult.OK)) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			entity = new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/getDeptInfo")
	public Dept getDeptInfo(@RequestParam int deptCode) {
		Dept deptInfo = orgService.getDeptInfo(deptCode);
		deptInfo.setDeptRegDay(FormatUtils.formatDate(deptInfo.getDeptRegDay()));
		return deptInfo;
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/updateDeptName")
	public ResponseEntity<String> updateDeptName(@RequestBody Dept dept) {
		ResponseEntity<String> entity = null;

		ServiceResult result = orgService.updateDeptName(dept);
		
		if(result.equals(ServiceResult.OK)) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			entity = new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/transferDept")
	public ResponseEntity<String> transferDept(@RequestBody Map<String, Object> reqData) {
		ResponseEntity<String> entity = null;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("empNoList", reqData.get("empNoList"));
		params.put("targetDeptCode", reqData.get("targetDeptCode"));

		ServiceResult result = orgService.transferDept(params);
		
		if(result.equals(ServiceResult.OK)) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			entity = new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	// 부서 삭제목록
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/deptDelList")
	public String deptDelList(Model model) {
		model.addAttribute("adminMenu","y");
		model.addAttribute("title","조직관리");
		model.addAttribute("activeMain","adminOrg");
		model.addAttribute("active","orgDelList");
		model.addAttribute("flag", "dept");	// 부서 삭제목록
		
		return "org/adminOrgDelList";
	}
	
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/getDeletedDeptData")
	public List<Dept> getDeletedDeptData() {
		List<Dept> deletedDeptList = orgService.getDeletedDeptData();
		
		return deletedDeptList;
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/hardDeleteDept")
	public ResponseEntity<String> hardDeleteDept(@RequestBody List<Integer> deptCodes) {
		ResponseEntity<String> entity = null;
		
		ServiceResult result = orgService.hardDeleteDept(deptCodes);
		
		if(result.equals(ServiceResult.OK)) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		} else {
			entity = new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/recoveryDept")
	public ResponseEntity<String> recoveryDept(@RequestBody List<Integer> deptCodes) {
		ResponseEntity<String> entity = null;
		log.debug("부서 복구");
		
		ServiceResult result = orgService.recoveryDept(deptCodes);
		if(result.equals(ServiceResult.OK)) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		} else {
			entity = new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	// 사원 삭제목록
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/empDelList")
	public String empDelList(Model model) {
		model.addAttribute("adminMenu","y");
		model.addAttribute("title","조직관리");
		model.addAttribute("activeMain","adminOrg");
		model.addAttribute("active","orgDelList");
		model.addAttribute("flag", "emp");	// 사원 삭제목록
		
		return "org/adminOrgDelList";
	}
	
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/getDeletedEmpData")
	public List<Map<String, Object>> getDeletedEmpData() {
		List<Map<String, Object>> deletedEmpList = orgService.getDeletedEmpData();
		return deletedEmpList;
	}
}
