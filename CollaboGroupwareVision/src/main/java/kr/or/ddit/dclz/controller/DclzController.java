package kr.or.ddit.dclz.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.crtf.vo.CrtfEmp;
import kr.or.ddit.dclz.service.DclzService;
import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.dclz.vo.PaginationInfoVO;
import kr.or.ddit.dclz.vo.dclzCalendarVO;
import kr.or.ddit.drafting.vo.Drafting;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

/**
 * 근태관리 - 근무현황, 출장/휴가현황, 부서근무현황 컨트롤러
 * @author 김민채
 */

@Slf4j
@Controller
@RequestMapping("/dclz")
public class DclzController {

	@Inject
	private DclzService dclzService;

	// 근무현황
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/dclzhome")
	public String dclzHome(Model model) {
		log.info("dclzHome() 실행..!");
		model.addAttribute("title", "근태관리");
		model.addAttribute("activeMain", "dclz");
		model.addAttribute("active", "dclzhome");

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();

		// 근태 페이지에서 나타내야할 모든 데이터는 if문 안에다가 담아줘야 함
		if (employee != null) {
			log.info("로그인 성공!");
			Dclz dclzTime = dclzService.selectEmpTime(employee.getEmpNo());
			model.addAttribute("dclzTime", dclzTime);
		} else {
			log.info("로그인 실패!");
			return "accounts/login";
		}

		return "dclz/dclzhome";

	}

	// 근무현황 출근시각 저장(비동기)
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/dclzhomestart")
	public ResponseEntity<String> dclzStartTime(Model model) {
		log.info("dclzStartTime() 실행..!");

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();

		if (employee != null) {
			log.info("로그인 성공!");
			Dclz dclzEmp = dclzService.selectEmpTime(employee.getEmpNo());
			int cnt = dclzService.insertStartTime(employee.getEmpNo());
			log.info("제발... {}" + cnt);
			model.addAttribute("emp", dclzEmp);
		}

		return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);

	}
	
	
	// 근무현황 QR코드 일치 여부
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping(value="/dclzQR", consumes = "application/json")
	public Map<String, Object> dclzQR(@RequestBody Map<String, String> requestBody ,Model model) {
		log.info("dclzQR() 실행..!");
		
		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();
		
		Map<String, Object> response = new HashMap<>();
		
		// 클라이언트에서 전송한 scannedQRValue 가져오기
        String scannedQRValue = requestBody.get("scannedQRValue");
        
        // 서버에서 가져온 empQRValue
        String empQRValue = dclzService.checkQRCode(employee.getEmpNo());
        
        if(scannedQRValue.equals(empQRValue)) {
        	boolean isValid = true;
        	response.put("isValid", isValid);        	
        }else {
        	boolean isValid = false;
        	response.put("isValid", isValid);        	
        }
        return response;
	}
	
	
	
	
	

	// 풀캘린더 일정 저장
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping(value = "/dclzstartsave")
	public ResponseEntity<List<dclzCalendarVO>> dclzSaveStart() {
		log.info("dclzSaveStart() 실행..!");

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();
		List<dclzCalendarVO> calendarList = new ArrayList<dclzCalendarVO>();
		if (employee != null) {
			log.info("로그인 성공!");
			List<Dclz> dclzEmp = dclzService.selectEmpCal(employee.getEmpNo());

			for (int i = 0; i < dclzEmp.size(); i++) {
				Dclz dclz_ = dclzEmp.get(i);
				dclzCalendarVO calVO = new dclzCalendarVO();
				calVO.setTitle(dclz_.getCalTitle());
				if ("출근".equals(dclz_.getCalTitle()) || "지각".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
				} else if ("퇴근".equals(dclz_.getCalTitle())) {
					calVO.setTitle(dclz_.getCalTitle() + "(" + dclz_.getHoursMinutes() + ")");
					log.info("결과:" + dclz_.getHoursMinutes());
					calVO.setStart(dclz_.getLvwkDate());
					calVO.setAllDay(true); // 하루종일로 표현하기 위해 allday 사용
				} else if ("출장".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("연차".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("반차".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("병가".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("설날".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("대체휴일".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				}
				calVO.setClassName(dclz_.getCalClassName());
				calendarList.add(calVO);
			}
		}
		return new ResponseEntity<List<dclzCalendarVO>>(calendarList, HttpStatus.OK);
	}

	// 당월 근태 현황 개수 가져오기
	@ResponseBody
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@PostMapping(value = "/dclzStatusCount")
	public ResponseEntity<Map<String, Integer>> dclzStatusCount() {
		log.info("dclzStatusCount() 실행..!");
		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();

		Map<String, Integer> dclzCountMap = new HashMap<>(); // calTitle과 개수를 담을 Map

		if (employee != null) {
			log.info("로그인 성공!");

			List<String> calTitleList = new ArrayList<String>();
			calTitleList.add("출근");
			calTitleList.add("지각");
			calTitleList.add("퇴근");
			calTitleList.add("출장");
			calTitleList.add("연차");
			calTitleList.add("반차");
			calTitleList.add("병가");
			log.info("calTitleList" + calTitleList);

			for (String calTitle : calTitleList) {
				int dclzCount = dclzService.selectDclzCount(employee.getEmpNo(), calTitle);
				log.info("dclzCount" + dclzCount);
				dclzCountMap.put(calTitle, dclzCount);
				log.info("dclzCountMap" + dclzCountMap);
			}

		}

		return new ResponseEntity<>(dclzCountMap, HttpStatus.OK);
	}

	// 근무현황 퇴근시각 저장(비동기)
	// 3) 객체 타입의 JSON 요청 데이터 @RequestBody 어노테이션을 지정하여 자바빈즈 매개변수로 처리한다.
	// 비동기 처리 진행시, 객체 매개변수 -> 요청 본문안에 데이터 바인딩을 위한 @RequestBody를 필수로 붙여줘야함
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/dclzhomeleave")
	public ResponseEntity<String> dclzLeaveTime(String dclzNo, Model model) {
		log.info("dclzLeaveTime() 실행..!");

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();

		// 근태 페이지에서 나타내야할 모든 데이터는 if문 안에다가 담아줘야 함
		if (employee != null) {
			log.info("로그인 성공!");
			Dclz dclzTime = dclzService.selectEmpTime(employee.getEmpNo());
			int cnt1 = dclzService.updateLeaveTime(dclzNo);
			int cnt2 = dclzService.updateLeaveTimeStat(dclzNo);
			log.info("cnt1 {}" + cnt1);
			log.info("cnt2 {}" + cnt2);
			model.addAttribute("dclzTime", dclzTime);

		}
		log.info("dclzNo 가져오기 성공!");

		return new ResponseEntity<>(dclzNo, HttpStatus.OK);

	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	

	// 휴가/출장현황
	// 검색기능X
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/dclzrest")
	public String dclzRest(
			@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage1, 
			@RequestParam(name = "pageTrip", required = false, defaultValue = "1") int currentPage2, 
			@RequestParam(required = false, defaultValue = "drftNo") String searchType,
			@RequestParam(required = false) String searchWord, Model model) {
		log.info("dclzrest() 실행..!");
		model.addAttribute("title", "휴가현황");
		model.addAttribute("activeMain", "dclz");
		model.addAttribute("active", "dclzrest");

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();

		//좌측 시간 출력하기
		Dclz dclzTime = dclzService.selectEmpTime(employee.getEmpNo());
		model.addAttribute("dclzTime", dclzTime);
		
		
		//휴가 현황 리스트 불러오기
		PaginationInfoVO<Drafting> pagingVORest = new PaginationInfoVO<Drafting>();
		pagingVORest.setEmpNo(employee.getEmpNo());
		// 현재 페이지 전달 후, start/endRow와 start/endPage 설정
		pagingVORest.setCurrentPage(currentPage1);
		// 총 게시글 수 가져오기
		int totalRecordRest = dclzService.selectDrftToDclzRestCount(pagingVORest);
		pagingVORest.setTotalRecord(totalRecordRest);
		List<Drafting> dataListRest = dclzService.selectDrftToDclzRestList(pagingVORest);
		pagingVORest.setDataList(dataListRest);
		
		
		//출장 현황 리스트 불러오기
		PaginationInfoVO<Drafting> pagingVOTrip = new PaginationInfoVO<Drafting>();
		pagingVOTrip.setEmpNo(employee.getEmpNo());
		// 현재 페이지 전달 후, start/endRow와 start/endPage 설정
		pagingVOTrip.setCurrentPage(currentPage2);		
		// 총 게시글 수 가져오기
		int totalRecordTrip = dclzService.selectDrftToDclzTripCount(pagingVOTrip); 		
		pagingVOTrip.setTotalRecord(totalRecordTrip);
		List<Drafting> dataListTrip = dclzService.selectDrftToDclzTripList(pagingVOTrip);
		pagingVOTrip.setDataList(dataListTrip);
		
		model.addAttribute("pagingVORest", pagingVORest);
		model.addAttribute("pagingVOTrip", pagingVOTrip);

		return "dclz/dclzrest";
	}
	

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// 부서근무현황
	@GetMapping("/dclzdept")
	public String dclzDept(Model model) {
		log.info("dclzDept() 실행..!");
		model.addAttribute("title", "부서근무현황");
		model.addAttribute("activeMain", "dclz");
		model.addAttribute("active", "dclzdept");

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();

		// 근태 페이지에서 나타내야할 모든 데이터는 if문 안에다가 담아줘야 함
		if (employee != null) {
			log.info("로그인 성공!");
			Dclz dclzTime = dclzService.selectEmpTime(employee.getEmpNo());
			model.addAttribute("dclzTime", dclzTime);
		} else {
			log.info("로그인 실패!");
			return "accounts/login";
		}

		return "dclz/dclzdept";
	}
	

	// 부서근무현황(풀캘린더 출력)
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/selectDclzDept")
	public ResponseEntity<List<dclzCalendarVO>> selectDclzDept() {
		log.info("selectDclzDept() 실행..!");

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();

		List<dclzCalendarVO> dclzDeptList = new ArrayList<dclzCalendarVO>();

		if (employee != null) {
			log.info("로그인 성공!");
			List<Dclz> dclzDept = dclzService.selectDclzDept(employee.getEmpNo());
			log.info("부서현황" + dclzDept);

			for (int i = 0; i < dclzDept.size(); i++) {
				Dclz dclz_ = dclzDept.get(i);
				dclzCalendarVO calVO = new dclzCalendarVO();
				calVO.setTitle(dclz_.getCalTitle());
				if ("출근".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
					calVO.setTitle(dclz_.getEmpName() + " "+ dclz_.getCalTitle());
				} else if ("지각".equals(dclz_.getCalTitle())) {
					calVO.setStart(dclz_.getGowkDate());
					calVO.setTitle(dclz_.getEmpName() + " " + dclz_.getCalTitle() + "(" + dclz_.getHoursMinutes() + ")");
				} else if ("퇴근".equals(dclz_.getCalTitle())) {
					calVO.setTitle(dclz_.getEmpName() + " " + dclz_.getCalTitle() + "(" + dclz_.getHoursMinutes() + ")");
					log.info("결과:" + dclz_.getHoursMinutes());
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true); // 하루종일로 표현하기 위해 allday 사용
				} else if ("출장".equals(dclz_.getCalTitle())) {
					calVO.setTitle(dclz_.getEmpName() + " "+ dclz_.getCalTitle());
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("연차".equals(dclz_.getCalTitle())) {
					calVO.setTitle(dclz_.getEmpName() + " "+ dclz_.getCalTitle());
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("병가".equals(dclz_.getCalTitle())) {
					calVO.setTitle(dclz_.getEmpName() + " "+ dclz_.getCalTitle());
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("설날".equals(dclz_.getCalTitle())) {
					calVO.setTitle(dclz_.getCalTitle());
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				} else if ("대체휴일".equals(dclz_.getCalTitle())) {
					calVO.setTitle(dclz_.getCalTitle());
					calVO.setStart(dclz_.getGowkDate());
					calVO.setAllDay(true);
				}
				calVO.setColor(dclz_.getCalColor());
				log.info("★CalColor : " + dclz_.getCalColor());
				log.info("★calVo : " + calVO);
				dclzDeptList.add(calVO);

			}
		}
		
		return new ResponseEntity<List<dclzCalendarVO>>(dclzDeptList, HttpStatus.OK);

	}
	
	
	
}
