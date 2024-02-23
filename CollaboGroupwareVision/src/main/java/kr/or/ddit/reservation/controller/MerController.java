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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.reservation.service.MerService;
import kr.or.ddit.reservation.vo.Mer;
import kr.or.ddit.reservation.vo.MerRsvt;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mer")
public class MerController {
	
	@Inject
	private MerService merService;

	// 회의실 예약 조회
	@GetMapping
	public String meetingRoom(Model model) {
		model.addAttribute("title","회의실예약");
	    model.addAttribute("activeMain","reserve");
	    model.addAttribute("active","meet");
	    
	    // 현재 날짜 구하기   
	    LocalDate now = LocalDate.now();         
	    model.addAttribute("merDate",now);
	    
	    List<Mer> merList = merService.selectMerList();	// 회의실 조회
	    
	    log.info("now:"+now);
	    List<MerRsvt> merRsvtListByDay =  merService.selectMerRsvtListByDay(String.valueOf(now));	// 선택한 날짜의 예약리스트 조회
	    
	    model.addAttribute("merList",merList);
	    model.addAttribute("merRsvtListByDay",merRsvtListByDay);
	    
		return "mer/merList";
	}
	
	// 날짜 바꿨을 때 이벤트
	@GetMapping("/selectDay")
	public String selectDay(Model model, String merDate){
		model.addAttribute("title","회의실예약");
	    model.addAttribute("activeMain","reserve");
	    model.addAttribute("active","meet");
	    
	    List<Mer> merList = merService.selectMerList();	// 회의실 조회
	    List<MerRsvt> merRsvtListByDay =  merService.selectMerRsvtListByDay(merDate);	// 선택한 날짜의 예약리스트 조회
	    
	    log.info("merDate:"+merDate);
	    
	    model.addAttribute("merList",merList);
	    model.addAttribute("merRsvtListByDay",merRsvtListByDay);
	    model.addAttribute("merDate",merDate);
	    
		return "mer/merList";
	}
	
	// 회의실 예약 등록
	@PreAuthorize("hasRole('ROLE_USER')")
	@ResponseBody
	@PostMapping("/merRegister")
	public ResponseEntity<ServiceResult> merRegister(int mer, String merDate, int startTime, int endTime, String title, String ppus) {
		
		ServiceResult result = null;
		Map<String, Object> paramMap = new HashMap<String, Object>();
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if(employee != null ) {
			paramMap.put("merNo", mer);
			paramMap.put("merDate", merDate);
			paramMap.put("startTime", startTime);
			paramMap.put("endTime", endTime);
			paramMap.put("title", title);
			paramMap.put("ppus", ppus);
			paramMap.put("empNo", employee.getEmpNo());
			
			int status = merService.insertMerRsvt(paramMap);
			if(status > 0) {
				result = ServiceResult.OK;
			}else {
				result = ServiceResult.FAILED;
			}
		} 
		
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}
	
	// 회의실 예약 예약가능한 시간대인지 체크
	@ResponseBody
	@RequestMapping(value="/checkReserve", method = RequestMethod.POST)
	public ResponseEntity<List<MerRsvt>> checkReserve(@RequestBody MerRsvt merRsvt){
		List<MerRsvt> merRsvtList = merService.checkReserve(merRsvt);
		
		return new ResponseEntity<List<MerRsvt>>(merRsvtList, HttpStatus.OK);
	}
	
	// 상세보기
	@GetMapping("/merDetail")
	public String merDetail(int mRsvtNo, Model model) {
		model.addAttribute("title","회의실상세");
	    model.addAttribute("activeMain","reserve");
	    model.addAttribute("active","meet");
	    
		MerRsvt merRsvt = merService.selectDetailMerRsvt(mRsvtNo);
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
		if(employee != null) {
			model.addAttribute("empNo",employee.getEmpNo());
		}
		model.addAttribute("merRsvt",merRsvt);
		return "mer/merDetail";
	}
	
	// 예약취소하기
	@GetMapping("/merCancel")
	public String merCancel(int mRsvtNo) {
		merService.merCancel(mRsvtNo);
		return "redirect:/mer";
	}
	
	// 관리자 회의실 관리 페이지
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/adminMer")
	public String adminMer(Model model) {
		model.addAttribute("adminMenu","y");
		model.addAttribute("title","관리자 회의실 관리");
	    model.addAttribute("activeMain","mng_reserve");
	    model.addAttribute("active","mng_meet");
	    
	    List<Mer> merList = merService.selectMerList();	// 회의실 조회
	    model.addAttribute("merList",merList);
	    
		return "mer/adminMer";
	}
	
	// 관리자 회의실 등록
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/adminMerInsert")
	public String adminMerInsert(@RequestParam Map<String, Object> paramMap) {
		String merName = (String) paramMap.get("merName");
		String enabled = (String) paramMap.get("enabled");
		
		Mer mer = new Mer();
		mer.setMerName(merName);
		mer.setEnabled(enabled);
		merService.adminMerInsert(mer);
		
		return "redirect:/mer/adminMer";
	}
	
	// 관리자 회의실 수정
	@PostMapping("/adminMerUpdate")
	public String adminMerUpdate(@RequestParam Map<String, Object> paramMap) {
		int merNo = Integer.parseInt((String) paramMap.get("merNo")) ;
		String merName = (String) paramMap.get("merName");
		String enabled = (String) paramMap.get("enabled");
		
		Mer mer = new Mer();
		mer.setMerNo(merNo);
		mer.setMerName(merName);
		mer.setEnabled(enabled);
		log.info("mer:"+mer);
		merService.adminMerUpdate(mer);
		
		return "redirect:/mer/adminMer";
	}
	
	@PostMapping("/adminMerDelete")
	public ResponseEntity<ServiceResult> adminMerDelete(int merNo) {
		ServiceResult result = null;
		
		int status = merService.adminMerDelete(merNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
}
