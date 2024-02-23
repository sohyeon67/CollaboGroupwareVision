package kr.or.ddit.account.controller;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.service.LoginService;
import kr.or.ddit.account.vo.Employee;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/accounts")
public class LoginController {
	
	@Inject
	private LoginService loginService;

	@GetMapping("/login")
	public String loginForm(Model model) {
		model.addAttribute("title", "로그인");
		return "conn/login";
	}
	
	@GetMapping("/findPassword")
	public String findPwForm(Model model) {
		model.addAttribute("title", "비밀번호 찾기");

		return "conn/findPassword";
	}
	
	@PostMapping("/findPassword")
	public String findPw(Employee employee, RedirectAttributes ra) {
		log.debug("비밀번호 찾기 컨트롤러");
		
		ServiceResult result = null;
		result = loginService.findPassword(employee);
		if(result.equals(ServiceResult.OK)) {
			log.debug("전송완료");
			ra.addFlashAttribute("successMsg", "임시 비밀번호를 발송하였습니다.");
		} else {
			ra.addFlashAttribute("errorMsg", "입력한 정보를 다시 확인해주세요.");
			log.debug("전송실패");
		}
		
		ra.addFlashAttribute("empNo", employee.getEmpNo());
		ra.addFlashAttribute("empPsnEmail", employee.getEmpPsnEmail());
		
		
		return "redirect:/accounts/findPassword";
	}
}
