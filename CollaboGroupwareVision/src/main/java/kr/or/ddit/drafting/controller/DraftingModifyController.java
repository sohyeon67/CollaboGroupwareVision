package kr.or.ddit.drafting.controller;

import java.lang.reflect.Method;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.dclz.service.DclzService;
import kr.or.ddit.drafting.service.DraftingService;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.ApprovalBookmark;
import kr.or.ddit.drafting.vo.Drafting;
import kr.or.ddit.drafting.vo.DraftingAttach;
import kr.or.ddit.drafting.vo.DraftingForm;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/drafting")
public class DraftingModifyController {

	@Inject
	private DraftingService draftingService;
	
	//근태 insert를 위해 추가 @김민채
	@Inject
	private DclzService dclzService;
	
	// 날짜 시간제거 전역변수
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

	// 재기안
	// 결재 작성 폼
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@GetMapping(value = "/resurgenceForm")
	public String resurgenceForm(String drftNo, RedirectAttributes ra, Model model) {
		
		// 로그인 정보 세션에 저장하기
	    // [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    Employee employee = user.getEmployee();
	    String empNo = employee.getEmpNo();
	    
	    // 즐겨찾기
	    List<ApprovalBookmark> approvalBookmarkList = draftingService.selectBookmark(empNo);
	    
	    // 기안번호 자동생성
	    String drftDayCount = draftingService.selectDraftingDayCount();
	    
	    // key값 : drafting(Drafting), approvalList(List<Approval>), draftingAttachList(List<DraftingAttach>)
 		Map<String, Object> draftingMap = draftingService.detailDrafting(drftNo);
 		
 		// Drafting 객체 꺼내기
		Drafting drafting = (Drafting) draftingMap.get("drafting");

		// draftingAttach객체 꺼내기
		List<DraftingAttach> draftingAttachList = (List<DraftingAttach>) draftingMap.get("draftingAttachList");
		log.info("draftingAttachList!!!!!!!!!!!!!"+draftingAttachList);

		if(draftingAttachList != null) {
			Gson gson = new Gson();
			String jsonDraftingAttachList = gson.toJson(draftingAttachList);
			log.info("jsonString!!!!!!!!!!!!!"+jsonDraftingAttachList);
			model.addAttribute("jsonDraftingAttachList", jsonDraftingAttachList);
		}
	
		if(drafting != null && "반려".equals(drafting.getDrftStatus())) {
			String formattedDraftingDate = "";
			// 결재 신청 날짜 형식
		    if (drafting != null) {
		    	String dateString = drafting.getDrftDate();
			    	try {
			    		Date date = dateFormat.parse(dateString);
			    		String formattedDate = dateFormat.format(date);
			    		formattedDraftingDate = formattedDate;
			    		log.debug("formattedDraftingDate 값 : " + formattedDraftingDate);
			    	} catch (ParseException e) {
			    		e.printStackTrace();
			    	}
		    }
		    
		    model.addAttribute("drftDayCount", drftDayCount);
			model.addAttribute("status", "u");
			model.addAttribute("draftingMap", draftingMap);
			model.addAttribute("title","전자결재 등록");
			model.addAttribute("activeMain","drafting");
			model.addAttribute("formattedDraftingDate", formattedDraftingDate);
			model.addAttribute("employee", employee);
			model.addAttribute("approvalBookmarkList", approvalBookmarkList);
			
			log.info("draftingMap 값 : " + draftingMap);
			
			
			return "drafting/draftingForm";
		} else {
			ra.addFlashAttribute("message", "반려된 서류만 재기안이 가능합니다.");
	        return "redirect:/drafting/main";
		}
	}
	
	// 결재 재기안	
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@PostMapping(value = "/resurgence")
	public String resurgenceDrafting(HttpServletRequest req, Drafting drafting, 
				RedirectAttributes ra, Model model) {
		log.info("resurgenceDrafting() 실행!!!!!");
		log.info("drafting 값 : " + drafting);

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
			// 로그인 정보 세션에 저장하기
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
	
	
	
	// 결재승인
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@PostMapping(value = "/acceptSign")
	public String acceptSign(Approval approval, Model model, RedirectAttributes ra, Drafting drafting) {
		// 로그인 정보 세션에 저장하기
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		String empNo = employee.getEmpNo();
		byte[] signImg = employee.getSignImg();
		
		approval.setEmpNo(empNo);
		approval.setApprvSignImg(signImg);
		
		String goPage = "";
		ServiceResult result = draftingService.acceptSign(approval);
		
		if(result.equals(ServiceResult.OK)) {
			// getApprvFinalYn이 Y이면 기안상태 승인으로 변경. "Y"를 앞에 둠으로써 NullPointerException을 방지
			if("Y".equals(approval.getApprvFinalYn())) {
				
				
				draftingService.acceptDrafting(approval.getDrftNo());
				log.info("drafting.getDrftFormNo() 값 : "+drafting.getDrftFormNo());
				// 후처리 서비스 호출
				
				if(drafting.getDrftFormNo() == 4 || drafting.getDrftFormNo() == 5) {
					dclzService.insertDraftToDclz(approval);
				}
/*				
				// db에 drafting.getDrftFormNo() 정보
				// 4, kr.or.ddit.dclz.service.DclzService, insertDraftToDclz
				//
				 
				 전역변수에 Autowired 어노테이션을 사용한 spring ApplicationContext 클래스 변수 선언
				@Autowired
				ApplicationContext context;
				
				
				//drafting.getClassName();
				
				//drafting.getMethodName();
				
				Class<?> forName = Class.forName("클래스명");
				
				Object bean = context.getBean(forName);
				Method method = forName.getDeclaredMethod("함수명", Map.class);
				method.invoke(bean, approval);
				
				현재 주석처리된 것처럼 사용해야 무작위한 서비스 객체 생성을 막을 수 있다.
*/				
				
			}
			goPage = "redirect:/drafting/detail?drftNo="+approval.getDrftNo();
			ra.addFlashAttribute("successMessage", "결재 승인이 완료되었습니다.");
		}else {
			goPage = "redirect:/drafting/detail?drftNo="+approval.getDrftNo();
			ra.addFlashAttribute("failedMessage", "결재 승인이 실패했습니다.");
		}
		return goPage;
	}
	
	// 반려
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@PostMapping(value = "/rejectSign")
	public String rejectSign(Approval approval, Model model, RedirectAttributes ra) {
		// 로그인 정보 세션에 저장하기
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		String empNo = employee.getEmpNo();
		
		approval.setEmpNo(empNo);
		
		String goPage = "";
		
		ServiceResult result = draftingService.rejectSign(approval);
		if(result.equals(ServiceResult.OK)) {
			draftingService.rejectDrafting(approval.getDrftNo());
			goPage = "redirect:/drafting/detail?drftNo="+approval.getDrftNo();
			ra.addFlashAttribute("successMessage", "결재가 반려되었습니다.");
		}else {
			goPage = "redirect:/drafting/detail?drftNo="+approval.getDrftNo();
			ra.addFlashAttribute("failedMessage", "결재 반려가 실패했습니다.");
		}
		return goPage;
	}
	


}
