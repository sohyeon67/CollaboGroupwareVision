package kr.or.ddit.account.controller;

import java.util.Base64;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.service.AccountService;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.service.OrgService;
import kr.or.ddit.org.vo.Dept;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

/**
 * 관리자 조직 관리 - 사원통합관리, 마이페이지 등 계정 관련 컨트롤러
 * 
 * @author 정소현
 */
@Slf4j
@Controller
@RequestMapping("/account")
public class AccountController {

	@Inject
	private BCryptPasswordEncoder bpe;

	@Inject
	private AccountService accountService;

	@Inject
	private OrgService orgService;

	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/empManage")
	public String accountHome(Model model) {
		model.addAttribute("adminMenu", "y");
		model.addAttribute("title", "조직관리");
		model.addAttribute("activeMain", "adminOrg");
		model.addAttribute("active", "empManage");

		return "account/empManage";
	}

	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/register")
	public String registerForm(Model model) {
		model.addAttribute("adminMenu", "y");
		model.addAttribute("title", "조직관리");
		model.addAttribute("activeMain", "adminOrg");
		model.addAttribute("active", "empManage");

		List<Dept> deptList = orgService.getDeptList();
		List<Map<String, Object>> commonCodes = accountService.getCommonCodeList();

		model.addAttribute("deptList", deptList);
		model.addAttribute("commonCodes", commonCodes);

		return "account/empForm";
	}

	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/register")
	public String register(HttpServletRequest req, Employee employee, Model model, RedirectAttributes ra) {
		log.debug("사원등록 기능");
		log.debug("등록할 사원정보 : " + employee);

		String goPage = "";

		ServiceResult result = accountService.register(req, employee);
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("successMsg", "사원 등록을 완료하였습니다.");
			goPage = "redirect:/account/empManage";
		} else {
			model.addAttribute("adminMenu", "y");
			model.addAttribute("title", "조직관리");
			model.addAttribute("activeMain", "adminOrg");
			model.addAttribute("active", "empManage");
			model.addAttribute("employee", employee);
			goPage = "account/empForm";
		}

		return goPage;
	}

	// 사원 목록
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/getEmpList")
	public List<Employee> getEmpList() {
		List<Employee> employeeList = accountService.getEmpList();

		return employeeList;
	}

	// 사원 비활성화
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@DeleteMapping("/empDisable")
	public ResponseEntity<String> empDisable(@RequestBody List<String> empNoList) {
		ResponseEntity<String> entity = null;

		ServiceResult result = accountService.empDisable(empNoList);

		if (result.equals(ServiceResult.OK)) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		} else {
			entity = new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
		}

		return entity;
	}

	// 상세 페이지 및 수정 페이지
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/details/{empNo}")
	public String getEmpDetails(@PathVariable String empNo, Model model) {
		model.addAttribute("adminMenu", "y");
		model.addAttribute("title", "조직관리");
		model.addAttribute("activeMain", "adminOrg");
		model.addAttribute("active", "empManage");
		model.addAttribute("status", "u");

		List<Dept> deptList = orgService.getDeptList();
		List<Map<String, Object>> commonCodes = accountService.getCommonCodeList();
		Employee employee = accountService.getEmpDetails(empNo);

		model.addAttribute("deptList", deptList);
		model.addAttribute("commonCodes", commonCodes);
		model.addAttribute("emp", employee);

		// 서명사진 BLOB -> base64
		if (employee.getSignImg() != null) {
			String base64signImg = Base64.getEncoder().encodeToString(employee.getSignImg());
			model.addAttribute("base64signImg", base64signImg);
		}

		return "account/empForm";
	}

	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/update")
	public String update(HttpServletRequest req, Employee employee, @RequestParam String base64signImg, Model model,
			RedirectAttributes ra) {
		log.debug("사원수정 기능");
		log.debug("수정할 사원정보 : " + employee);

		String goPage = "";

		// 기존 서명 이미지 set
		if (base64signImg != null && !base64signImg.equals("")) {
			byte[] signImg = Base64.getDecoder().decode(base64signImg);
			employee.setSignImg(signImg);
		}

		ServiceResult result = accountService.update(req, employee);
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("successMsg", "정보 수정을 완료하였습니다.");
			goPage = "redirect:/account/empManage";
		} else {
			ra.addFlashAttribute("errorMsg", "정보 수정에 실패하였습니다.");
			goPage = "redirect:/account/details/" + employee.getEmpNo();
		}

		return goPage;
	}

	// 마이페이지 들어갈 때 비밀번호 확인하기
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/checkPassword")
	public String checkPasswordForm(Model model) {
		model.addAttribute("title", "비밀번호 확인");

		return "account/checkPassword";
	}

	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/checkPassword")
	public String checkPassword(@RequestParam String password) {
		log.debug("입력한 비밀번호 확인 : " + password);
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		Employee employee = user.getEmployee();
		if(employee == null) {
			return "conn/login";
		}
		
		//log.debug("내 비밀번호 : " + user.getPassword()); // null
		log.debug("내 비밀번호 : " + employee.getEmpPw());
		
		if (bpe.matches(password, employee.getEmpPw())) {
			// 비밀번호 일치, 마이페이지로 이동
			return "redirect:/account/mypage";
		} else {
			// 비밀번호 불일치
			return "redirect:/account/checkPassword?error";
		}
	}

	// 마이페이지
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/mypage")
	public String mypage(Model model) {
		// Default로 내 정보 띄우기 위해
		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

		if (user.getEmployee() != null) {
			log.info("정보 불러오기 성공!");
			String myEmpNo = user.getEmployee().getEmpNo();
			log.info("내 사번" + myEmpNo);

			Employee employee = accountService.getEmpDetails(myEmpNo);
			List<Dept> deptList = orgService.getDeptList();
			List<Map<String, Object>> commonCodes = accountService.getCommonCodeList();

			model.addAttribute("title", "마이페이지");
			model.addAttribute("deptList", deptList);
			model.addAttribute("commonCodes", commonCodes);
			model.addAttribute("emp", employee);

			// 서명사진 BLOB -> base64
			if (employee.getSignImg() != null) {
				String base64signImg = Base64.getEncoder().encodeToString(employee.getSignImg());
				model.addAttribute("base64signImg", base64signImg);
			}
			return "account/mypage";
		} else {
			log.info("로그인 실패!");
			return "conn/login";
		}
	}

	// 내 정보 수정
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/mypage")
	public String updateMyInfo(HttpServletRequest req, Employee employee, @RequestParam String base64signImg,
			Model model, RedirectAttributes ra) {

		// 기존 서명 이미지 set
		if (base64signImg != null && !base64signImg.equals("")) {
			byte[] signImg = Base64.getDecoder().decode(base64signImg);
			employee.setSignImg(signImg);
		}

		ServiceResult result = accountService.update(req, employee);
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("successMsg", "정보 수정을 완료하였습니다.");
		} else {
			ra.addFlashAttribute("errorMsg", "정보 수정에 실패하였습니다.");
		}

		return "redirect:/account/mypage";
	}
	
	// 프로필 가져오기
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/getMyProfile")
	public ResponseEntity<Employee> getMyProfile(HttpServletRequest req) {
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if (employee != null) {
			String myEmpNo = employee.getEmpNo();
			log.info("내 사번" + myEmpNo);
			Employee myInfo = accountService.getMyProfile(myEmpNo);
			return new ResponseEntity<Employee>(myInfo, HttpStatus.OK);
		} else {
			return new ResponseEntity<Employee>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
		
}
