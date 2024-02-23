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
import kr.or.ddit.org.service.OrgService;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/drafting")
public class DraftingBookmarkController {
	
	@Inject
	private DraftingService draftingService;
	
	@Inject
	private OrgService orgService;

		
		@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
		@ResponseBody
		@PostMapping(value = "/favoriteAddAjax")
		public ResponseEntity<Map<String, Object>> insertBookmark(@RequestBody ApprovalBookmark bookmark){
			
			log.info("bookmark : " + bookmark);
			log.info("getEmpNoList : " + bookmark.getEmpNoList());
			log.info("getApprvBookmarkName : " + bookmark.getApprvBookmarkName());
			
		    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		    Employee employee = user.getEmployee();
			String apprvBookmarkEmpNo = "";

			Map<String, Object> responseMap = new HashMap<>();
			
		    if(employee != null && bookmark != null) { // 로그인 o and bookmark o
	    		bookmark.setApprvBookmarkEmpNo(employee.getEmpNo());
	    		int bookmarkNo = draftingService.insertBookmark(bookmark);
	    		if(bookmarkNo > 0) {
	    			responseMap.put("bookmarkNo", bookmarkNo);
	    		}
		    }
		    
		    String bookmarkName = bookmark.getApprvBookmarkName();
		    
		    responseMap.put("bookmarkName", bookmarkName);
		    
		    
		    
			return new ResponseEntity<>(responseMap, HttpStatus.OK);
		};
		
		
		@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
		@ResponseBody
		@PostMapping(value = "/searchBookmarkList")
		public ResponseEntity<List<Employee>> searchBookmarkList(@RequestBody ApprovalBookmark apprvBookmark){
			
			List<Employee> employeeList = new ArrayList<>();
			
			log.info("apprvBookmark 값 : " + apprvBookmark);
			int apprvBookmarkNo = apprvBookmark.getApprvBookmarkNo();
			log.info("apprvBookmarkNo 값 :" + apprvBookmarkNo);
			
			if(apprvBookmark != null) {
				List<ApprovalBookmarkList> bookmarkList = draftingService.selectBookmarkList(apprvBookmarkNo);
				log.info("bookmarkList 값 : " + bookmarkList);
				if(bookmarkList != null) {
					for(ApprovalBookmarkList bookmarkEmp : bookmarkList) {
						log.info("bookmarkEmp 값 : "+bookmarkEmp);
						
						String bookmarkListEmpNo = bookmarkEmp.getEmpNo();
						log.info("bookmarkListEmpNo 값 : "+bookmarkListEmpNo);
						 
						Employee employee = orgService.getOrgDetails(bookmarkListEmpNo);
						log.info("employee"+employee);
						  
						employeeList.add(employee); log.info("employeeList"+employeeList);
						 
					}
				}
			}
			
			return new ResponseEntity<>(employeeList, HttpStatus.OK);
			
		}
		
		@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
		@ResponseBody
		@PostMapping(value = "/deleteBookmark")
		public ResponseEntity<Integer> deleteBookmark(@RequestBody Map<String, String> map){

			log.info("map 값 :"+map);
			String apprvBookmarkNoString = map.get("apprvBookmarkNo");
			int apprvBookmarkNo = Integer.parseInt(apprvBookmarkNoString);
			log.info("apprvBookmarkNo값 : " + apprvBookmarkNo);
			
			int status = draftingService.deleteBookmark(apprvBookmarkNo);
			
			if (status > 0) {
		        // status가 0보다 크면 OK 처리
		        return new ResponseEntity<>(status, HttpStatus.OK);
		    } else {
		        // status가 0이거나 음수이면 다른 처리
		        return new ResponseEntity<>(status, HttpStatus.BAD_REQUEST); // 다른 HTTP 상태 코드를 지정하세요.
		    }
		}
}
