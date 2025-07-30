package kr.or.ddit.reservation.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.reservation.service.VhclService;
import kr.or.ddit.reservation.vo.Mer;
import kr.or.ddit.reservation.vo.Vhcl;
import kr.or.ddit.reservation.vo.VhclRsvt;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

/**
 * 예약 - 관리자 차량예약 컨트롤러
 * @author 김민채
 */

@Slf4j
@Controller
@RequestMapping("/adminVhcl")
public class AdminVhclController {

	@Inject
	private VhclService vhclService;
	
	// 관리자 차량 관리 페이지
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/adminVhcl")
	public String adminVhcl(Model model) {
		model.addAttribute("adminMenu","y");
		model.addAttribute("title","관리자 차량 관리");
	    model.addAttribute("activeMain","mng_reserve");
	    model.addAttribute("active","mng_vhcl");
	    
	    List<Vhcl> vhclList = vhclService.selectVhclList();	//차량 조회
	    model.addAttribute("vhclList",vhclList);
	    
	    return "vhcl/adminVhcl";
	}
	
	// 관리자 차량 등록
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/adminVhclInsert")
	public String adminVhclInsert(HttpServletRequest req, Vhcl vhcl) {
		//HttpServletRequest
		//이 객체는 현재의 HTTP 요청에 대한 정보를 담고 있는 객체로, 클라이언트로부터 받은 다양한 정보를 추출하는 데 사용됩니다. 
		//주로 HTTP 요청의 헤더, 매개변수, 세션 등에 접근할 때 사용됩니다.
	
		vhclService.adminVhclInsert(req, vhcl);
		
		return "redirect:/adminVhcl/adminVhcl";
	}
	
	// 관리자 차량 수정
	@PostMapping("/adminVhclUpdate")
	public String adminVhclUpdate(HttpServletRequest req, Vhcl vhcl) {
		log.info("vhcl:"+vhcl);
		log.debug("파일체크:{}",vhcl.getImgFile());
		log.debug("파일체크:{}",vhcl.getImgFile().getSize());
		
		// 파일이 있으면, 요 파일을 저장하공 생긴 경로
		if(vhcl.getImgFile().getSize() !=0) {
			vhclService.adminVhclUpdate(req, vhcl);
		}else {
			vhclService.adminVhclUpdate2(req, vhcl);
		}
		
		return "redirect:/adminVhcl/adminVhcl";
	}
	
	
	// 관리자 차량 삭제
	@PostMapping("/adminVhclDelete")
	public ResponseEntity<ServiceResult> adminVhclDelete(String vhclNo) {
		log.info("Deleting vhclNo: {}", vhclNo);
		
		ServiceResult result = null;
		
		int status = vhclService.adminVhclDelete(vhclNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}

	
}
