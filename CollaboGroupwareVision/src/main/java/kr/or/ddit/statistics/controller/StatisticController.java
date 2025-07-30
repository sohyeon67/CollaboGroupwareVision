package kr.or.ddit.statistics.controller;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.org.vo.Dept;
import kr.or.ddit.statistics.service.StatisticService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stat")
public class StatisticController {

	@Inject
	private StatisticService statisticService;
	
	// 근태 통계
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/statDclz")
	public String statCrtf(Model model) {
		model.addAttribute("title","근태 통계");
		model.addAttribute("adminMenu","y");
		model.addAttribute("activeMain","stat");
		model.addAttribute("active","st_dclz");
		
		List<Integer> yearList = statisticService.selectDclzYear();
		model.addAttribute("yearList",yearList);
		return "stat/statDclz";
	}
	
	// 선택한 연도와 달의 근태현황 가져오기
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping(value = "/someDclzStatusCount")
	public ResponseEntity<Map<String, Integer>> someDclzStatusCount(@RequestBody Map<String,Object> paramMap) {
		log.info("someDclzStatusCount() 실행..!");
		log.info("someDclzStatusCount() 실행..!");

		Map<String, Integer> dclzCountMap = new HashMap<>(); // calTitle과 개수를 담을 Map
		String year = (String) paramMap.get("dclzYear");	// 연도
		
		String monthFormat = "";
		String someday = "";
		List<String> calTitleList = new ArrayList<String>();
		calTitleList.add("출근");
		calTitleList.add("지각");
		calTitleList.add("퇴근");
		calTitleList.add("출장");
		calTitleList.add("연차");
		calTitleList.add("반차");
		calTitleList.add("병가");

		for(int i=1; i<=12; i++) {
			if(i<10) {
				monthFormat = "0" + i;
			}else {
				monthFormat = i+"";
			}
			someday = year.substring(2,4) + monthFormat;
			for (String calTitle : calTitleList) {
				int dclzCount = statisticService.someDclzStatusCount(someday, calTitle);
				dclzCountMap.put(i+"_"+calTitle, dclzCount);
			}
		}
		
		return new ResponseEntity<>(dclzCountMap, HttpStatus.OK);
	}
	
	// 전직원 근태현황 확인하기
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/selectAllEmpDclz")
	public String selectAllEmpDclz(Model model) {
		model.addAttribute("title","전직원 근태현황");
		model.addAttribute("adminMenu","y");
		model.addAttribute("activeMain","stat");
		model.addAttribute("active","st_dclz");
	
		List<Dept> deptList = statisticService.selectAllDept();
		
		model.addAttribute("deptList",deptList);
		return "stat/empDclz";
	}
	
	// 전직원 근태리스트
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/empDclz")
	public ResponseEntity<List<Dclz>> empDclz(@RequestBody Map<String, Object> paramMap){
		log.info("empDclz() 실행..!");
		List<Dclz> empDclzList = new ArrayList<Dclz>();
		
		if(paramMap != null) {
			
			List<String> dayArray = (List<String>) paramMap.get("dayArray");
			for(int i=1; i<dayArray.size(); i++) {
				List<Dclz> someEmpDclzList = statisticService.selectEmpDclzListByDay(dayArray.get(i));
				if(someEmpDclzList != null) {
					for(Dclz someEmpDclz : someEmpDclzList) {
						empDclzList.add(someEmpDclz);
					}
				}
			}
		}
		
		return new ResponseEntity<List<Dclz>>(empDclzList, HttpStatus.OK);
	}
	
	// 부서별 근태 비교
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/deptCompare")
	public String deptCompare(Model model) {
		model.addAttribute("title","부서근태비교");
		model.addAttribute("adminMenu","y");
		model.addAttribute("activeMain","stat");
		model.addAttribute("active","st_dclz");
		
		List<Integer> yearList = statisticService.selectDclzYear();
		
		model.addAttribute("yearList",yearList);
		
		return "stat/deptCompare";
	}
	
	// 근태유형별 부서 통계 내기
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/statDeptCompare")
	public ResponseEntity<Map<Dept,Double>> statDeptCompare(@RequestBody Map<String, Object> paramMap){
		Map<Dept,Double> dclzCountMap = new HashMap<Dept, Double>();
		
		// 근태 통계 : 선택한 달의 근태유형의 수/전체 부서의 근태수
		// 1. 선택한 연도와 날짜 가져오기
		String calTitle = (String) paramMap.get("calTitle");	// 근태유형
		String year = (String) paramMap.get("dclzYear");	// 연도
		String month = (String) paramMap.get("dclzMonth");	// 달
		
		String monthFormat = "";
		if(Integer.parseInt(month) < 10) {
			monthFormat = "0" + month;
		}else {
			monthFormat = month;
		}
		String someday = year.substring(2,4) + monthFormat;
		
		// 2. 부서리스트 불러와 부서 코드 추출
		List<Dept> deptList = statisticService.selectAllDept();
		
		Integer allDclzCount = 0;
		Integer someDclzCount = 0;
		double someDivAll = 0;
		
		for(Dept dept : deptList) {
			// -- 여기서 선택한 연도와 날짜로 sql 연동 --> 수는 여기서 뽑아오자
			List<Dclz> deptAllDclzList = statisticService.selectAllDeptDclzList(dept.getDeptCode(), someday);
			List<Dclz> deptDclzList = statisticService.selectDeptDclzList(dept.getDeptCode(), calTitle, someday);
			
			if(deptAllDclzList == null || deptDclzList == null) {
				someDivAll = 0;
				dclzCountMap.put(dept, someDivAll);
			}else {
				// 3. 부서코드에 해당하는 해당 월의 전체 근태수 가져오기
				allDclzCount = deptAllDclzList.size();
				// 4. 부서코드에 해당하는 해당 월의 근태유형별 근태수 가져오기
				someDclzCount = deptDclzList.size();
				if(allDclzCount == 0) {
					someDivAll = 0;
					dclzCountMap.put(dept, someDivAll);
				}else {
					// 5. 백분율로 나타내어 부서이름과 함께 결과값 보내기 (Map<String,Integer>로 보내기)
					someDivAll = (double) someDclzCount / allDclzCount;
					dclzCountMap.put(dept, someDivAll);
				}
			}
		}
		
		return new ResponseEntity<Map<Dept,Double>>(dclzCountMap, HttpStatus.OK);
	}
	
	// 결재통계 페이지 이동
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/statDraft")
	public String statDraft(Model model) {
		model.addAttribute("title","전자결재통계");
		model.addAttribute("adminMenu","y");
		model.addAttribute("activeMain","stat");
		model.addAttribute("active","st_draft");

		List<Integer> yearList = statisticService.selectApprvYear();
		model.addAttribute("yearList",yearList);
		
		return "stat/statDraft";
	}
	
	// 당월 결재현황 가져오기
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/apprvStatusCount")
	public ResponseEntity<Map<String, Integer>> apprvStatusCount(@RequestBody Map<String, Object> paramMap){
		Map<String, Integer> approvalMap = new HashMap<String, Integer>();
			
		String year = (String) paramMap.get("dclzYear");	// 연도
		
		String monthFormat = "";
		String someday = "";
		List<Approval> approvalList = new ArrayList<Approval>();
		
		for(int i=1; i<=12; i++) {
			if(i<10) {
				monthFormat = "0" + i;
			}else {
				monthFormat = i+"";
			}
			someday = year + monthFormat;
			// 해당월을 리스트 불러와서 진행/승인/반려 수 map에 넣어주기
			approvalList = statisticService.selectApprovalList(someday);
			
			int progressCount = 0;
			int approvalCount = 0;
			int companionCount = 0;
			
			if(approvalList != null) {
				for(Approval appr : approvalList) {
					if(appr.getApprvStatus().equals("01")) {
						progressCount++;
					}else if(appr.getApprvStatus().equals("02")) {
						approvalCount++;
					}else if(appr.getApprvStatus().equals("03")) {
						companionCount++;
					}
				}
			}
			
			approvalMap.put(i+"_01", progressCount);
			approvalMap.put(i+"_02", approvalCount);
			approvalMap.put(i+"_03", companionCount);
		}
		
		return new ResponseEntity<Map<String, Integer>>(approvalMap, HttpStatus.OK);
	}
	
	// 전직원 결재 현황
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/selectAllEmpDraft")
	public String selectAllEmpDraft(Model model) {
		model.addAttribute("title","전직원 결재현황");
		model.addAttribute("adminMenu","y");
		model.addAttribute("activeMain","stat");
		model.addAttribute("active","st_draft");
		
		List<Dept> deptList = statisticService.selectAllDept();
		model.addAttribute("deptList",deptList);
		
		return "stat/empDraft";
	}
	
	// 날짜, 부서별 결재현황 리스트 불러오기
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping("/selectEmpDraftList")
	public ResponseEntity<List<Approval>> selectEmpDraftList(@RequestBody Map<String, Object> paramMap){
		String startDate = (String) paramMap.get("startDate");
		String endDate = (String) paramMap.get("endDate");
		String deptCode = (String) paramMap.get("deptCode");
		
		List<Approval> approvalList = new ArrayList<Approval>();
		String startDateFormat = "";
		String endDateFormat = "";
		
		if (startDate == null || startDate.trim().isEmpty()) {
	        startDateFormat = "";
	    } else {
	        startDateFormat = startDate.split("-")[0] + startDate.split("-")[1] + startDate.split("-")[2];
	    }

	    if (endDate == null || endDate.trim().isEmpty()) {
	        endDateFormat = "";
	    } else {
	        endDateFormat = endDate.split("-")[0] + endDate.split("-")[1] + endDate.split("-")[2];
	    }
	    
	    if(deptCode.trim().isEmpty()) {
	    	approvalList = statisticService.selectEmpDraftList(startDateFormat, endDateFormat, null);
	    }else {
	    	approvalList = statisticService.selectEmpDraftList(startDateFormat, endDateFormat, Integer.parseInt(deptCode));
	    }
		
		return new ResponseEntity<List<Approval>>(approvalList,HttpStatus.OK);
	}
	
	//----------------------밑에는 작업 보류-----------------------------------
	// 반려사유 페이지로 가기
//	@GetMapping("/rejectAnalyze")
//	public String rejectAnalyze(Model model) {
//		model.addAttribute("title","반려사유분석");
//		model.addAttribute("adminMenu","y");
//		model.addAttribute("activeMain","stat");
//		model.addAttribute("active","st_draft");
//		
//		SimpleDateFormat yearMonthDayFm = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
//		Calendar cal = Calendar.getInstance();
//		String todayFormat = yearMonthDayFm.format(cal.getTime());
//		String filePath = "c://statUpload/"+todayFormat+".txt";
//		
//		File f = new File(filePath);
//		
//		try(
//			FileWriter fw = new FileWriter(f);
//			BufferedWriter bw = new BufferedWriter(fw, 1024);
//			PrintWriter pw = new PrintWriter(bw);
//		){
//			List<String> rejectReasonList = statisticService.selectRejectReasonList();
//			
//			for(int i=0; i<rejectReasonList.size(); i++) {
//				pw.print(rejectReasonList.get(i));
//				pw.print("|");
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		} 
//		
//		return "stat/rejectAnalyze";
//	}
//	
//	// 크롤링
//	@GetMapping("/getURL") 
//	@ResponseBody		
//	public ResponseEntity<List<String>> getURL() {
//		File dir = new File("c://statUpload");
//		File[] dirFiles = null;
//		
//		List<String> splitedList = new ArrayList<String>();
//		
//		// 최신 파일 가져오기
//	    if (dir.isDirectory()) {
//	       dirFiles = dir.listFiles((FileFilter)FileFilterUtils.fileFileFilter());
//	       if (dirFiles != null && dirFiles.length > 0) {
//	           Arrays.sort(dirFiles, LastModifiedFileComparator.LASTMODIFIED_REVERSE);
//	       }
//	    }
//	    
//	    // 파일읽기
//    	if(dirFiles != null) {
//    		try(BufferedReader reader = new BufferedReader(new FileReader(dirFiles[0]));){
//    			String str="";
//    			String result="";
//			    while ((str = reader.readLine()) != null) {    
//			    	log.info("str:"+str);
//			    	result = str.toString();
//			    } 
//		    	for(int i=0; i<result.split("|").length; i++) {
//		    		splitedList.add(result.split("|")[i]);
//		    	}
//    		}catch (Exception e) {
//				e.printStackTrace();
//			}
//	    }
//	    
//		return new ResponseEntity<List<String>>(splitedList, HttpStatus.OK);	
//	}
	
	
	// 전체 근태현황 가져오기
//	@ResponseBody
//	@PreAuthorize("hasRole('ROLE_ADMIN')")
//	@PostMapping(value = "/dclzStatusCount")
//	public ResponseEntity<Map<String, Integer>> dclzStatusCount() {
//		log.info("dclzStatusCount() 실행..!");
//		// [스프링 시큐리티] 시큐리티 세션을 활용
//		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//		Employee employee = user.getEmployee();
//
//		Map<String, Integer> dclzCountMap = new HashMap<>(); // calTitle과 개수를 담을 Map
//
//		if (employee != null) {
//			log.info("로그인 성공!");
//
//			List<String> calTitleList = new ArrayList<String>();
//			calTitleList.add("출근");
//			calTitleList.add("지각");
//			calTitleList.add("퇴근");
//			calTitleList.add("출장");
//			calTitleList.add("연차");
//			calTitleList.add("반차");
//			calTitleList.add("병가");
//
//			for (String calTitle : calTitleList) {
//				int dclzCount = statisticService.selectAllDclzCount(calTitle);
//				dclzCountMap.put(calTitle, dclzCount);
//			}
//		}
//		return new ResponseEntity<>(dclzCountMap, HttpStatus.OK);
//	}

}
