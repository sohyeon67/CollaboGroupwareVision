package kr.or.ddit.drafting.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.drafting.service.DraftingService;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.Drafting;
import kr.or.ddit.drafting.vo.DraftingAttach;
import kr.or.ddit.drafting.vo.DraftingForm;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/drafting")
public class DraftingPageController {

	@Inject
	private DraftingService draftingService;
	
	// 날짜 시간제거 전역변수
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	// 전자결재 홈
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@GetMapping(value = "/main")
	public String draftingMainPage(Model model) {		
		
		// 로그인 정보 세션에 저장하기
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		String empNo = user.getEmployee().getEmpNo();
	    
	    // 결재해야할 문서 5개
	    List<Drafting> toSignList =  draftingService.selectMainToSign(empNo);
	    // 날짜 시간 제거
	    if (toSignList != null) {
		    for(int i=0; i<toSignList.size(); i++) {
		    	String dateString = toSignList.get(i).getDrftDate();
		    	
		    	try {
		    		Date date = dateFormat.parse(dateString);
		    		String formattedDate = dateFormat.format(date);
		    		toSignList.get(i).setDrftDate(formattedDate);
		    	} catch (ParseException e) {
		    		e.printStackTrace();
		    	}
		    }
	    }
	    
	    // 내가 작성한 결재 5개
	    List<Drafting> writeDraftingList = draftingService.selectMainDrafting(empNo);
	    // 날짜 시간제거
	    if (writeDraftingList != null) {
		    for(int i=0; i<writeDraftingList.size(); i++) {
		    	String dateString = writeDraftingList.get(i).getDrftDate();
		    	
		    	try {
		    		Date date = dateFormat.parse(dateString);
		    		String formattedDate = dateFormat.format(date);
		    		writeDraftingList.get(i).setDrftDate(formattedDate);
		    	} catch (ParseException e) {
		    		e.printStackTrace();
		    	}
		    }
	    }
	    
	    // 결재 양식
	    List<DraftingForm> draftingFormList = draftingService.selectDraftingFormList();
	    
	    model.addAttribute("toSignList", toSignList);
	    model.addAttribute("writeDraftingList", writeDraftingList);
	    model.addAttribute("draftingFormList", draftingFormList);
	    model.addAttribute("title","전자결재 홈");
	    model.addAttribute("activeMain","drafting");
	    model.addAttribute("employee", employee);
		
		return "drafting/mainDrafting";
	}
	
	// 결재 대기 문서함
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@RequestMapping(value = "/waitingApprovalList")
	public String waitingApprovalListPage(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model) {
		// 로그인 정보 세션에 저장하기
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		String empNo = user.getEmployee().getEmpNo();
		
		// 페이징 변수
		PaginationInfoVO<Drafting> pagingVO = new PaginationInfoVO<Drafting>();
		
		// 검색기능
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setEmpNo(empNo);
		int totalRecord = draftingService.toSignCount(pagingVO);
		pagingVO.setTotalRecord(totalRecord);
		
		// 결재할 문서
		List<Drafting> signList = draftingService.selectToSign(pagingVO);
		
	    // 날짜 시간 제거
	    if (signList != null) {
		    for(int i=0; i<signList.size(); i++) {
		    	String dateString = signList.get(i).getDrftDate();
		    	
		    	try {
		    		Date date = dateFormat.parse(dateString);
		    		String formattedDate = dateFormat.format(date);
		    		signList.get(i).setDrftDate(formattedDate);
		    	} catch (ParseException e) {
		    		e.printStackTrace();
		    	}
		    }
	    }
	    
	    // pagingVO에 담기
	    pagingVO.setDataList(signList);
		
		// 결재 양식
		List<DraftingForm> draftingFormList = draftingService.selectDraftingFormList();
		model.addAttribute("draftingFormList", draftingFormList);	

		model.addAttribute("pagingVO", pagingVO);	
		model.addAttribute("title","결재 대기 문서함");
		model.addAttribute("activeMain","drafting");
		model.addAttribute("employee", employee);
		
		return "drafting/waitingApprovalList";
	}
	
	// 기안 문서함
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@RequestMapping(value = "/draftingList")
	public String draftingListPage(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model) {
		
		// 로그인 정보 세션에 저장하기
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		String empNo = user.getEmployee().getEmpNo();
		
		// 페이징 변수
		PaginationInfoVO<Drafting> pagingVO = new PaginationInfoVO<Drafting>();
		
		// 검색기능
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setEmpNo(empNo);
		int totalRecord = draftingService.writingCount(pagingVO);
		pagingVO.setTotalRecord(totalRecord);
		
		// 작성한 문서
		List<Drafting> writingList = draftingService.selectWriting(pagingVO);	
		
		// 날짜 시간 제거
	    if (writingList != null) {
		    for(int i=0; i<writingList.size(); i++) {
		    	String dateString = writingList.get(i).getDrftDate();
		    	
		    	try {
		    		Date date = dateFormat.parse(dateString);
		    		String formattedDate = dateFormat.format(date);
		    		writingList.get(i).setDrftDate(formattedDate);
		    	} catch (ParseException e) {
		    		e.printStackTrace();
		    	}
		    }
	    }
	    
	    // pagingVO에 담기
	    pagingVO.setDataList(writingList);
		
		// 결재 양식
		List<DraftingForm> draftingFormList = draftingService.selectDraftingFormList();
		model.addAttribute("draftingFormList", draftingFormList);	
		
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("title","기안 문서함");
		model.addAttribute("activeMain","drafting");
		model.addAttribute("employee", employee);
		
		return "drafting/draftingList";
	}
	
	// 결재문서함
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@RequestMapping(value = "/approvalList")
	public String approvalListPage(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model) {
		
		// 로그인 정보 세션에 저장하기
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		String empNo = user.getEmployee().getEmpNo();
		
		
		// 페이징 변수
		PaginationInfoVO<Drafting> pagingVO = new PaginationInfoVO<Drafting>();
		
		// 검색기능
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setEmpNo(empNo);
		int totalRecord = draftingService.toApprvCount(pagingVO);
		pagingVO.setTotalRecord(totalRecord);
		
		
		// 결재자로 등록된 문서 가져오기
		List<Drafting> toApprvList =  draftingService.selectToApproval(pagingVO);
		// 날짜 시간 제거
	    if (toApprvList != null) {
		    for(int i=0; i<toApprvList.size(); i++) {
		    	String dateString = toApprvList.get(i).getDrftDate();
		    	
		    	try {
		    		Date date = dateFormat.parse(dateString);
		    		String formattedDate = dateFormat.format(date);
		    		toApprvList.get(i).setDrftDate(formattedDate);
		    	} catch (ParseException e) {
		    		e.printStackTrace();
		    	}
		    }
	    }
		pagingVO.setDataList(toApprvList);
		
		// 결재 양식
		List<DraftingForm> draftingFormList = draftingService.selectDraftingFormList();
		model.addAttribute("draftingFormList", draftingFormList);
		
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("title","결재 문서함");
		model.addAttribute("activeMain","drafting");
		model.addAttribute("employee", employee);
		
		return "drafting/approvalList";
	}
	

	
	

	

}
