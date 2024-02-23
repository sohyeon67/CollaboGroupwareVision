package kr.or.ddit.community.controller;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

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
import kr.or.ddit.community.service.CmnyService;
import kr.or.ddit.community.vo.Cmny;
import kr.or.ddit.community.vo.CmnyMem;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

/**
 * 커뮤니티 - 커뮤니티 전체 컨트롤러
 * 
 * @author 김민채
 */

@Slf4j
@Controller
@RequestMapping("/com")
public class CommunityController {
	
	@Inject
	private CmnyService cmnyService;
	
	
	//커뮤니티 홈
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/comHome")
	public String comHome(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "cmnyName") String searchType,
			@RequestParam(required = false) String searchWord, Model model) {
		log.info("comHome() 실행..!");
		
		model.addAttribute("title", "커뮤니티");
		model.addAttribute("activeMain", "com");
		model.addAttribute("active", "comHome");
		
		PaginationInfoVO<Cmny> pagingVO = new PaginationInfoVO<Cmny>();
		
		// 검색기능 추가
		// 검색했을 때의 조건은 키워드(searchWord)가 넘어왔을 때 정확하게 검색을 진행하거니까
		// 이때, 검색을 진행하기 위한 타입과 키워드를 PaginationInfoVO에 셋팅하고 목록을 조회하기 위한 조건으로
		// 쿼리를 조회할 수 있도록 보내준다.
		if (StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		// 현재 페이지 전달 후, start/endRow와 start/endPage 설정
		pagingVO.setCurrentPage(currentPage);

		int totalRecord = cmnyService.selectCmnyCount(pagingVO); // 총 게시글 수 가져오기
		pagingVO.setTotalRecord(totalRecord);
		List<Cmny> dataList = cmnyService.selectCmnyList(pagingVO);
		pagingVO.setDataList(dataList);
		log.info("cmnyDataList : " + dataList);

		model.addAttribute("pagingVO", pagingVO);

		return "com/comHome";
		
	}
	
	
	//커뮤니티 개설
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/comInsert")
	public String comInsert(HttpServletRequest req, Cmny cmny) {
		//HttpServletRequest
		//이 객체는 현재의 HTTP 요청에 대한 정보를 담고 있는 객체로, 클라이언트로부터 받은 다양한 정보를 추출하는 데 사용됩니다. 
		//주로 HTTP 요청의 헤더, 매개변수, 세션 등에 접근할 때 사용됩니다.
		
		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();		
		cmny.setCmnyTop(employee.getEmpName());	
		cmnyService.comInsert(req, cmny);
		
		return "redirect:/com/comHome";
	}
	
	
	
	//커뮤니티 상세보기
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/comDetail")
	public String comDetail(@RequestParam("cmnyNo") int cmnyNo, Model model, CmnyMem cmnyMem) {
		log.info("comDetail() CmnyNo : " + cmnyNo);
		
		model.addAttribute("title", "커뮤니티");
		model.addAttribute("activeMain", "com");
		model.addAttribute("active", "comHome");
		
		Cmny cmny= cmnyService.getCommunityDetail(cmnyNo);
	    model.addAttribute("cmny", cmny);
	    
	    List<CmnyMem> cmnyMemList = cmnyService.selectCmnyMemList(cmnyNo);
	    model.addAttribute("cmnyMemList", cmnyMemList);
	    
		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();
		
		cmnyMem.setEmpNo(employee.getEmpNo());
		cmnyMem.setEmpName(employee.getEmpName());
		cmnyMem.setCmnyNo(cmnyNo);
		
		model.addAttribute("cmnyMem",cmnyMem);
		model.addAttribute("employee",employee); //가입신청, 탈퇴버튼 검증을 위해 추가
			    		
		return "com/comDetail";
	}
	
	//커뮤니티 가입하기
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/comSubmitMem")
	public String comSubmitMem(Model model, CmnyMem cmnyMem) {
		log.info("comSubmitMem(): " + cmnyMem);
		
		model.addAttribute("title", "커뮤니티");
		model.addAttribute("activeMain", "com");
		model.addAttribute("active", "comHome");
		
		cmnyService.comSubmitMem(cmnyMem);
					    		
		return "redirect:/com/comDetail?cmnyNo="+cmnyMem.getCmnyNo();
	}
	
	//커뮤니티 탈퇴하기
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/comWithdrawMem")
	public ResponseEntity<String> comWithdrawMem(Model model, @RequestBody CmnyMem cmnyMem) {		
		model.addAttribute("title", "커뮤니티");
		model.addAttribute("activeMain", "com");
		model.addAttribute("active", "comHome");
		
		cmnyService.withdrawMem(cmnyMem);
		
		return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
	}
	
	//커뮤니티 폐쇄하기(커뮤니티 장을 제외한 멤버 리스트 호출)
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/cmnycloseMemCnt")
	public ResponseEntity<Integer> cmnycloseMemCnt(@RequestParam("cmnyNo") int cmnyNo){
		
		int cmnycloseMemCnt = cmnyService.cmnycloseMemCnt(cmnyNo);
			
		return new ResponseEntity<>(cmnycloseMemCnt, HttpStatus.OK);
	}
		
	//실제로 커뮤니티 폐쇄 메소드
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/updateCmnyStatus")
	public ResponseEntity<String> updateCmnyStatus(@RequestParam("cmnyNo") int cmnyNo){
		
		cmnyService.updateCmnyStatus(cmnyNo);
		
		return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
	}
	
	
	
	//내 커뮤니티 조회
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/comMy")
	public String comMy(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage, Model model) {
		log.info("comMy() 실행..!");
		
		model.addAttribute("title", "내 커뮤니티 조회");
		model.addAttribute("activeMain", "com");
		model.addAttribute("active", "comMy");

		PaginationInfoVO<Cmny> page = new PaginationInfoVO<Cmny>();
		
		// 현재 페이지 전달 후, start/endRow와 start/endPage 설정
		page.setCurrentPage(currentPage);

		int totalRecord = cmnyService.selectCmnyCount(page); // 총 게시글 수 가져오기
		page.setTotalRecord(totalRecord);
		List<Cmny> dataList = cmnyService.selectCmnyList(page);
		page.setDataList(dataList);
		log.info("cmnyDataList : " + dataList);

		model.addAttribute("page", page);
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();		
		
		List<Cmny> myCmnyList = cmnyService.getMyCommunityList(employee.getEmpNo());
		model.addAttribute("myCmnyList",myCmnyList);
				
		return "com/comMy";
	}
	
	
	
	
	

}
