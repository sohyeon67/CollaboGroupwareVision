package kr.or.ddit.reservation.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.reservation.service.VhclService;
import kr.or.ddit.reservation.vo.MerRsvt;
import kr.or.ddit.reservation.vo.Vhcl;
import kr.or.ddit.reservation.vo.VhclRsvt;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

/**
 * 예약 - 직원 차량예약 컨트롤러
 * @author 김민채
 */

@Slf4j
@Controller
@RequestMapping("/vhcl")
public class VhclController {

	@Inject
	private VhclService vhclService;

	//차량 예약 조회
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping
	public String vchlList(Model model) {
		log.info("로그인 성공!"); //이미 @PreAuthorize에서 검증이 이루어졌기 때문에!
		log.info("vchlList() 실행..!");
		
		model.addAttribute("title","차량예약");
	    model.addAttribute("activeMain","reserve");
	    model.addAttribute("active","vhcl");
		
		// 현재 날짜 구하기   
	    LocalDate now = LocalDate.now();         
	    model.addAttribute("vhclDate",now);
	    
	    List<Vhcl> vhclList = vhclService.selectVhclList();	// 차량 조회
	    
	    log.info("now:"+now);
	    List<VhclRsvt> vhclRsvtListByDay = vhclService.selectVhclRsvtListByDay(String.valueOf(now));	// 선택한 날짜의 예약리스트 조회
	    
	    model.addAttribute("vhclList",vhclList);
	    model.addAttribute("vhclRsvtListByDay",vhclRsvtListByDay);
		
		return "vhcl/vhclList";

	}
	
	// 날짜 바꿨을 때 이벤트
	@GetMapping("/selectDay")
	public String selectDay(Model model, String vhclDate){
		model.addAttribute("title","차량예약");
	    model.addAttribute("activeMain","reserve");
	    model.addAttribute("active","vhcl");
	    
	    List<Vhcl> vhclList = vhclService.selectVhclList();	// 차량 조회
	    List<VhclRsvt> vhclRsvtListByDay =  vhclService.selectVhclRsvtListByDay(vhclDate);	// 선택한 날짜의 예약리스트 조회
	    
	    log.info("vhclDate:"+vhclDate);
	    
	    model.addAttribute("vhclList",vhclList);
	    model.addAttribute("vhclRsvtListByDay",vhclRsvtListByDay);
	    model.addAttribute("vhclDate",vhclDate);
	    
		return "vhcl/vhclList";
	}
	

	@PreAuthorize("hasRole('ROLE_USER')")
	@ResponseBody
	@PostMapping("/vhclRegister")
	public String vhclRegister(String vhcl, String vhclDate, int startTime, int endTime, String ppus) {
		log.info("vhclRegister() 실행..!!");
		log.info("vhcl:"+vhcl);
		log.info("vhclDate:"+vhclDate);
		log.info("startTime:"+startTime);
		log.info("endTime:"+endTime);
		//log.info("title:"+title);
		log.info("ppus:"+ppus);
		
		
		// [스프링 시큐리티] 시큐리티 세션을 활용
		Map<String, Object> paramMap = new HashMap<String, Object>();
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();

		paramMap.put("vhclNo", vhcl);
		paramMap.put("vhclDate", vhclDate);
		paramMap.put("startTime", startTime);
		paramMap.put("endTime", endTime);
		//paramMap.put("title", title);
		paramMap.put("ppus", ppus);
		paramMap.put("empNo", employee.getEmpNo());
				
		ServiceResult result = null;

		int status = vhclService.insertVhclRsvt(paramMap);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
	
	return result.toString();

	}
	
	// 차량 예약 예약가능한 시간대인지 체크
	@ResponseBody
	@RequestMapping(value="/checkReserve", method = RequestMethod.POST)
	public ResponseEntity<List<VhclRsvt>> checkReserve(@RequestBody VhclRsvt vhclRsvt){
		List<VhclRsvt> vhclRsvtList = vhclService.checkReserve(vhclRsvt);
		
		return new ResponseEntity<List<VhclRsvt>>(vhclRsvtList, HttpStatus.OK);
	}
	
	
	
	// 상세보기
	@GetMapping("/vhclDetail")
	public String vhclDetail(int vRsvtNo, Model model) {
		model.addAttribute("title","차량예약 상세조회");
	    model.addAttribute("activeMain","reserve");
	    model.addAttribute("active","vhcl");
	    
	    VhclRsvt vhclRsvt = vhclService.selectDetailVhclRsvt(vRsvtNo);
	
	    
	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    Employee employee = user.getEmployee();
	    
	    if(employee != null) {
	    	model.addAttribute("empNo",employee.getEmpNo());
	    }	
		model.addAttribute("vhclRsvt",vhclRsvt);
		
		return "vhcl/vhclDetail";

		}

	
	
	// 예약취소하기
	@GetMapping("/vhclCancel")
	public String vhclCancel(int vRsvtNo) {		
		vhclService.vhclCancel(vRsvtNo);
		return "redirect:/vhcl";
	}
	
	// 관리자 차량 관리 페이지
	@GetMapping("/adminVhcl")
	public String adminVhcl(Model model) {
		model.addAttribute("title","관리자 차량 관리");
	    model.addAttribute("activeMain","mng_reserve");
	    model.addAttribute("active","mng_vhcl");
	    
		return "vhcl/adminVhcl";
	}
	
}
