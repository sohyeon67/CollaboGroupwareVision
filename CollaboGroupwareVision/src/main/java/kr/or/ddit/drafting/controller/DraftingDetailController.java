package kr.or.ddit.drafting.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.drafting.service.DraftingService;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.Drafting;
import kr.or.ddit.drafting.vo.DraftingAttach;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/drafting")
public class DraftingDetailController {
	
	@Inject
	private DraftingService draftingService;
	
	// 날짜 시간제거 전역변수
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyy/MM/dd");
	
	// 상세조회
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@GetMapping(value = "/detail")
	public String DraftingDetail(String drftNo, Model model) {

		// 로그인 정보 세션에 저장하기
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기      
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		String empNo = employee.getEmpNo();
		
		log.debug("employee 값 : "+employee);
		
		// key값 : drafting(Drafting), approvalList(List<Approval>), draftingAttachList(List<DraftingAttach>)
		Map<String, Object> draftingMap = draftingService.detailDrafting(drftNo);
		
		// Drafting 객체 꺼내기
		Drafting drafting = (Drafting) draftingMap.get("drafting");
		
		

		// 서류 별 현재 결재해야 할 직원 조회
		List<Approval> signerNow = draftingService.signerNow();
		String signerEmpNo = "";
		String signerFinalYn = "";
		for(int i=0; i<signerNow.size(); i++) {
			String signerDrftNo = signerNow.get(i).getDrftNo();
			if(signerDrftNo.equals(drftNo)) {
				signerEmpNo = signerNow.get(i).getEmpNo();
				signerFinalYn = signerNow.get(i).getApprvFinalYn();
			}
		}
		log.debug("DraftingDetail() 실행 ---- 글번호 : "+ drftNo + "현재 결재해야 할 사번 : " + signerEmpNo);
		// model에 현재 서류의 결재자 담기
		if(empNo.equals(signerEmpNo)) {
			model.addAttribute("signerEmpNo", signerEmpNo);
			model.addAttribute("signerFinalYn", signerFinalYn);
		}
		
		
		String formattedDraftingDate = "";
		// 결재 신청 날짜 형식
	    if (drafting != null) {
	    	String dateString = drafting.getDrftDate();
		    	try {
		    		Date date = dateFormat.parse(dateString);
		    		String formattedDate = dateFormat2.format(date);
		    		formattedDraftingDate = formattedDate;
		    		log.debug("formattedDraftingDate 값 : " + formattedDraftingDate);
		    	} catch (ParseException e) {
		    		e.printStackTrace();
		    	}
	    }
	    
		// 기안자 서명사진 꺼내서 이미지 변환 (BLOB)
		if(drafting.getDrftWriterSignImg() != null) {
			String writerSignImg = Base64.getEncoder().encodeToString(drafting.getDrftWriterSignImg());
			model.addAttribute("writerSignImg", writerSignImg);
		}
		
		// 작성자와 로그인자가 같으면 -> jsp에서 재기안버튼 띄울 때 사용
		if(drafting.getEmpNo().equals(empNo)) {
			model.addAttribute("resurgence", "resurgence");
		}

	//	log.debug("drafting.getDrftStatus() 값 : " + drafting.getDrftStatus());
	
		
		// List<Approval> 객체 꺼내기
		List<Approval> approvalList = (List<Approval>) draftingMap.get("approvalList");
		
		Map<String, String> approvalMap = new HashMap<String, String>();
		// 결재 승인 blob이미지 변환 및 날짜 형식
		if(approvalList != null) {
			for(int i=0; i<approvalList.size(); i++) {
				// 서명사진 null이 아니면 model에 담아서 보내기
				if(approvalList.get(i).getApprvSignImg() != null) {
					String signerSignImg = Base64.getEncoder().encodeToString(approvalList.get(i).getApprvSignImg());
					approvalMap.put(approvalList.get(i).getEmpNo(), signerSignImg);
				}
				
				// 기안상태가 반려일 때  반려사유 찾아서 model에 보내기
				if(drafting.getDrftStatus().equals("반려")) {
					if(approvalList.get(i).getApprvReject() != null) {
						model.addAttribute("rejectReason", approvalList.get(i).getApprvReject());
					}
				}
				
				// 날짜 변환 yyyy-MM-dd hh:mm:ss -> yyyy/MM/dd
				if(approvalList.get(i).getApprvDate()!= null) {
					String dateString = approvalList.get(i).getApprvDate();
					try {
						Date date = dateFormat.parse(dateString);
						String formattedDate = dateFormat2.format(date);
						String formattedApprovalDate = formattedDate;
						// 변환한 날짜형식으로 대체
						approvalList.get(i).setApprvDate(formattedApprovalDate);
						log.debug("formattedApprovalDate 값 : " + formattedApprovalDate);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
			}
		}
		
		draftingMap.put("approvalList", approvalList);
		model.addAttribute("approvalMap", approvalMap);	// 결재자 사진 리스트
		model.addAttribute("draftingMap", draftingMap);
		model.addAttribute("title","전자결재 상세조회");
	    model.addAttribute("activeMain","drafting");
	    model.addAttribute("formattedDraftingDate", formattedDraftingDate);
		log.debug("draftingMap 값 : " + draftingMap);
		
		
		return "drafting/detail";
	}
	
	
}
