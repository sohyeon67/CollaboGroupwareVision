package kr.or.ddit.drafting.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.drafting.service.DraftingService;
import kr.or.ddit.drafting.vo.ApprovalBookmark;
import kr.or.ddit.drafting.vo.ApprovalBookmarkList;
import kr.or.ddit.drafting.vo.Drafting;
import kr.or.ddit.drafting.vo.DraftingForm;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/drafting")
public class DraftingInsertController {
	
	@Inject
	private DraftingService draftingService;
	

		// 결재 작성 폼
		@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
		@GetMapping(value = "/draftingForm")
		public String draftingForm(int drftFormNo, Model model) {
			
			log.debug("넘버:"+ drftFormNo);
			
			// 로그인 정보 세션에 저장하기
		    // [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
		    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		    Employee employee = user.getEmployee();
		    String empNo = employee.getEmpNo();
		    
		    List<ApprovalBookmark> approvalBookmarkList = draftingService.selectBookmark(empNo);
		    
		    // 기안번호 자동생성
		    String drftDayCount = draftingService.selectDraftingDayCount();
		    
			// 결재 양식
			DraftingForm draftingForm = draftingService.selectDraftingForm(drftFormNo);
			
			model.addAttribute("drftDayCount", drftDayCount);
			model.addAttribute("draftingForm", draftingForm);
			model.addAttribute("drftFormNo", drftFormNo);
			model.addAttribute("title","전자결재 등록");
			model.addAttribute("activeMain","drafting");
			model.addAttribute("employee", employee);
			model.addAttribute("approvalBookmarkList", approvalBookmarkList);
			
			return "drafting/draftingForm";
		}
		
		// 결재 작성	
		@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
		@PostMapping(value = "/insert")
		public String insertDrafting(HttpServletRequest req, Drafting drafting, 
					RedirectAttributes ra, Model model) {
			log.debug("insertDrafting 값 : {}",drafting);
		
			String goPage = "";	// 이동할 페이지 정보
			
			Map<String, String> errors = new HashMap<String, String>();
			
			if(StringUtils.isBlank(drafting.getDrftTitle())) {
				errors.put("drftTitle", "제목을 입력해주세요.");
			}
			if(StringUtils.isBlank(drafting.getDrftContent())) {
				errors.put("drftContent", "내용을 입력해주세요.");
			}
			if(errors.size() > 0) { // 에러 존재
				model.addAttribute("errors", errors);
				model.addAttribute("drafting", drafting);
				goPage = "redirect:/drafting/draftingForm";
			} else { // 에러 없을 때
			    // [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
			    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			    Employee employee = user.getEmployee();
			    
			    
			    if(employee != null) { // 로그인 O
			    	drafting.setEmpNo(employee.getEmpNo());	// 사번 
			    	drafting.setDrftStatus("1");	// 기안 상태    	
			    	// 도장 사진 가져오기
			    	byte[] signImg = employee.getSignImg();
			    	if(signImg != null) { // 서명사진
			    		drafting.setDrftWriterSignImg(signImg);
			    	}
			    	
			    	ServiceResult result = draftingService.insertDrafting(req, drafting);
			    	if(result.equals(ServiceResult.OK)) {
			    		ra.addFlashAttribute("writeSuccess", "기안 등록이 완료되었습니다.");
			    		goPage = "redirect:/drafting/detail?drftNo="+drafting.getDrftNo();
			    	} else {	// 등록 실패
			    		model.addAttribute("drafting", drafting);
			    		model.addAttribute("writeFailed", "서버에러, 다시 시도해주세요!");
			    		goPage = "drafting/draftingForm";
			    	} 
			    }else {	// 로그인 X
					ra.addFlashAttribute("message", "로그인 후에 기안 작성이 가능합니다!");
					goPage = "redirect:/drafting/main";
				}
			} 
			return goPage;
		}
		
}
