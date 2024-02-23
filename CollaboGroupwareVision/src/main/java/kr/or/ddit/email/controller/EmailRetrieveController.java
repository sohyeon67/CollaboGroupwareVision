package kr.or.ddit.email.controller;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
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

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.email.service.EmailService;
import kr.or.ddit.email.vo.Mail;
import kr.or.ddit.email.vo.MailAttach;
import kr.or.ddit.email.vo.MailPaginationInfo;
import kr.or.ddit.email.vo.MailReceive;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.MediaUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/email")
public class EmailRetrieveController {
	
	@Inject
	private EmailService emailService;

	// 처음 메일 들어왔을 때(받은메일함)
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/inbox")
	public String inbox(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,HttpServletRequest req, Model model) {
		model.addAttribute("title", "이메일");
		model.addAttribute("activeMain","email");
		model.addAttribute("active","inbox");
		model.addAttribute("subTitle", "받은메일함");
		
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
				
		// 페이징 처리
		MailPaginationInfo<Mail> pagingVO = new MailPaginationInfo<Mail>();
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setEmpNo(employee.getEmpNo());
		
		// 검색
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		int totalRecord = emailService.selectMailReceiveCount(pagingVO);	
		pagingVO.setTotalRecord(totalRecord);
		List<Mail> dataList = emailService.selectMailReceiveList(pagingVO);
		pagingVO.setDataList(dataList);
		
		// 받은메일함 리스트 출력
		//List<Mail> mailList = emailService.selectMailReceiveList(employee.getEmpNo());
		
		// 파일출력
		List<Mail> mailAttachList = new ArrayList<Mail>();
		Mail mail = new Mail();
		for(Mail mails : dataList) {
			mail = emailService.selectDetailMail(mails.getMailNo());
			mailAttachList.add(mail);
		}
		
		// 안읽은 메일 카운트
		int noRead = emailService.selectNoReadCount(employee.getEmpNo());
		
		model.addAttribute("loginEmpNo",employee.getEmpNo());
		model.addAttribute("pagingVO",pagingVO);
		model.addAttribute("mailAttachList",mailAttachList);
		model.addAttribute("noRead",noRead);
		return "email/inbox";
	}
	
	// 보낸메일함 눌렀을 때
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/sentMailBox")
	public String sentMailBox(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,Model model) {
		model.addAttribute("title", "이메일");
		model.addAttribute("activeMain","email");
		model.addAttribute("active","sentBox");
		model.addAttribute("subTitle", "보낸메일함");
		
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
				
		// 페이징 처리
		MailPaginationInfo<Mail> pagingVO = new MailPaginationInfo<Mail>();
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setEmpNo(employee.getEmpNo());
		
		// 검색
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		int totalRecord = emailService.selectMailSentCount(pagingVO);	
		pagingVO.setTotalRecord(totalRecord);
		List<Mail> dataList = emailService.selectMailSentList(pagingVO);

		pagingVO.setDataList(dataList);
		
		// 보낸메일함 리스트 출력
		//List<Mail> mailList = emailService.selectMailSentList(employee.getEmpNo());
		
		// 파일출력
		List<Mail> mailAttachList = new ArrayList<Mail>();
		Mail mail = new Mail();
		for(Mail mails : dataList) {
			mail = emailService.selectDetailMail(mails.getMailNo());
			mailAttachList.add(mail);
		}
		
		// 안읽은 메일 카운트
		int noRead = emailService.selectNoReadCount(employee.getEmpNo());
		
		model.addAttribute("loginEmpNo",employee.getEmpNo());
		model.addAttribute("pagingVO",pagingVO);
		model.addAttribute("mailAttachList",mailAttachList);
		model.addAttribute("noRead",noRead);
				
		return "email/inbox";
	}
	
	// 메일작성 눌렀을 때
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/compose")
	public String sendMailForm(Model model) {
		model.addAttribute("title", "이메일");
		model.addAttribute("activeMain","email");
		
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
				
		// 안읽은 메일 카운트
		int noRead = emailService.selectNoReadCount(employee.getEmpNo());
		model.addAttribute("noRead",noRead);
		return "email/compose";
	}
	
	// 메일작성 후 보내기 버튼 눌렀을 때
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/mailSend")
	public String mailSend(HttpServletRequest req, Mail mail) {
		log.info("mail:"+mail);
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		mail.setEmpNo(employee.getEmpNo());
		
		HttpSession session = req.getSession();
		session.setAttribute("mailEmpToArr", mail.getEmpToArr());
		
		emailService.insertMail(req,mail);
		return "redirect:/email/inbox";
	}
	
	// 상세보기
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/mailDetail")
	public String mailDetail(Model model,int mailNo, String active) {
		model.addAttribute("title", "이메일");
		model.addAttribute("activeMain","email");
		model.addAttribute("active",active);
		
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
				
		// 안읽은 메일 카운트
		int noRead = emailService.selectNoReadCount(employee.getEmpNo());
		model.addAttribute("noRead",noRead);
		
		// 상세보기
		Mail mail = emailService.selectDetailMail(mailNo);
		model.addAttribute("mail",mail);
		log.info("상세보기 mail:"+mail);
		// 읽음여부 바꾸기
		emailService.updateReadYes(mailNo,employee.getEmpNo());
		model.addAttribute("empNo",employee.getEmpNo());
		
		return "email/mailDetail";
	}
	
	// 파일다운로드
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/download")
	public ResponseEntity<byte[]> download(int fileNo) throws Exception{
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		String fileName = null;
		MailAttach fileVO = emailService.selectFileInfo(fileNo);
		if(fileVO != null) {
			fileName = fileVO.getFileName();
			
			String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
			MediaType mType = MediaUtils.getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(fileVO.getFileSavepath());
			
			// if안에 내용이 있으면 이미지 파일은 썸네일을 보여주고 다운로드 진행할 수 있게 해줌
			// 만약 if가 없으면 바로 다운로드 됨 -> 주석처리 : 바로 다운로드
//			if(mType != null) {
//				headers.setContentType(mType);
//			}else {
				fileName = fileName.substring(fileName.indexOf("_") + 1);
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				headers.add("Content-Disposition","attachment; filename=\"" +
						new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
				
//			}
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		}else {
			entity= new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}
		return entity;
	}
	
	// 답장보내기
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/sendReply")
	public ResponseEntity<ServiceResult> sendReply(HttpServletRequest req,@RequestBody Map<String,Object> paramMap){
		ServiceResult result = null;
		ResponseEntity<ServiceResult> entity = null;
		
		Mail mail = new Mail();
		String mailTitle = (String) paramMap.get("mailTitle");
		String mailContent = (String) paramMap.get("replyContent");
		String senderEmpNo = (String) paramMap.get("senderEmpNo");
		List<String> empToArr = new ArrayList<String>();
		empToArr.add(senderEmpNo);
		
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
		mail.setEmpNo(employee.getEmpNo());
		mail.setMailTitle("↳Reply: ["+mailTitle+"]");
		mail.setMailContent(mailContent);
		mail.setEmpToArr(empToArr);
		emailService.insertMail(req,mail);
		return entity;
	}
	
	// 휴지통
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/trashCan")
	public String trashCan(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord, Model model) {
		model.addAttribute("title", "이메일");
		model.addAttribute("activeMain","email");
		model.addAttribute("active","trash");
		model.addAttribute("subTitle", "휴지통");
		
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
				
		// 페이징 처리
		MailPaginationInfo<Mail> pagingVO = new MailPaginationInfo<Mail>();
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setEmpNo(employee.getEmpNo());
		
		// 검색
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		int totalRecord = emailService.selectMailTrashCount(pagingVO);	
		pagingVO.setTotalRecord(totalRecord);
		List<Mail> dataList = emailService.selectMailTrashList(pagingVO);
		pagingVO.setDataList(dataList);
		
		// 받은메일함 리스트 출력
		//List<Mail> mailList = emailService.selectMailTrashList(employee.getEmpNo());
		
		// 파일출력
		List<Mail> mailAttachList = new ArrayList<Mail>();
		Mail mail = new Mail();
		for(Mail mails : dataList) {
			mail = emailService.selectDetailMail(mails.getMailNo());
			mailAttachList.add(mail);
		}
				
		// 안읽은 메일 카운트
		int noRead = emailService.selectNoReadCount(employee.getEmpNo());
		
		model.addAttribute("loginEmpNo",employee.getEmpNo());
		model.addAttribute("pagingVO",pagingVO);
		model.addAttribute("mailAttachList",mailAttachList);
		model.addAttribute("noRead",noRead);
		
		return "email/inbox";
	}
	
	// 받은메일함 임시삭제
	@ResponseBody
	@PostMapping("/inboxTempDelMail")
	public ResponseEntity<ServiceResult> inboxTempDelMail(@RequestBody Map<String, Object> paramMap){
		ServiceResult result = null;
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
				
		List<Integer> mailNoList = (List<Integer>) paramMap.get("chkYesArr");
		for(int mailNo : mailNoList) {
			result = emailService.inboxTempDelMail(mailNo, employee.getEmpNo());
		}
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}
	
	// 보낸메일함 임시삭제
	@ResponseBody
	@PostMapping("/sentBoxTempDelMail")
	public ResponseEntity<ServiceResult> sentBoxTempDelMail(@RequestBody Map<String, Object> paramMap){
		ServiceResult result = null;
		
		List<Integer> mailNoList = (List<Integer>) paramMap.get("chkYesArr");
		for(int mailNo : mailNoList) {
			result = emailService.sentBoxTempDelMail(mailNo);
		}
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}
	
	// 복구
	@ResponseBody
	@PostMapping("/restoreMail")
	public ResponseEntity<ServiceResult> restoreMail(@RequestBody Map<String, Object> paramMap){
		ServiceResult result = null;
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
		List<Integer> mailNoList = (List<Integer>) paramMap.get("chkYesArr");
		for(int mailNo : mailNoList) {
			Mail mail = emailService.selectDetailMail(mailNo);
			List<MailReceive> mailReceiveList = emailService.selectDetailMailReceive(mailNo);
			for(int i=0; i<mailReceiveList.size(); i++) {
				if(employee.getEmpNo().equals(mailReceiveList.get(i).getEmpNo())) {	// 받은메일함으로 인식
					result = emailService.restoreIndexMail(mailNo, employee.getEmpNo());
				}
			}
			if(employee.getEmpNo().equals(mail.getEmpNo())) {	// 보낸메일함으로 인식
				result = emailService.restoreSentMail(mailNo);
			}
			
		}
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}
	
	// 영구삭제
	@ResponseBody
	@PostMapping("/deleteMail")
	public ResponseEntity<ServiceResult> deleteMail(@RequestBody Map<String, Object> paramMap){
		ServiceResult result = null;
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
		List<Integer> mailNoList = (List<Integer>) paramMap.get("chkYesArr");
		for(int mailNo : mailNoList) {
			Mail mail = emailService.selectDetailMail(mailNo);
			List<MailReceive> mailReceiveList = emailService.selectDetailMailReceive(mailNo);
			for(int i=0; i<mailReceiveList.size(); i++) {
				if(employee.getEmpNo().equals(mailReceiveList.get(i).getEmpNo())) {	// 받은메일함으로 인식
					result = emailService.deleteIndexMail(mailNo, employee.getEmpNo());
				}
			}
			if(employee.getEmpNo().equals(mail.getEmpNo())) {	// 보낸메일함으로 인식
				result = emailService.deleteSentMail(mailNo);
			}
		}
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}
	
	// 중요메일함 눌렀을 때
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/importantBox")
	public String importantBox(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord, Model model) {
		model.addAttribute("title", "이메일");
		model.addAttribute("activeMain","email");
		model.addAttribute("active","importantBox");
		model.addAttribute("subTitle", "중요메일함");
		
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
				
		// 페이징 처리
		MailPaginationInfo<Mail> pagingVO = new MailPaginationInfo<Mail>();
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setEmpNo(employee.getEmpNo());
		
		// 검색
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		
		int totalRecord = emailService.selectImportantCount(pagingVO);	
		pagingVO.setTotalRecord(totalRecord);
		List<Mail> dataList = emailService.selectImportantList(pagingVO);

		pagingVO.setDataList(dataList);
		
		// 파일출력
		List<Mail> mailAttachList = new ArrayList<Mail>();
		Mail mail = new Mail();
		for(Mail mails : dataList) {
			mail = emailService.selectDetailMail(mails.getMailNo());
			mailAttachList.add(mail);
		}
		
		// 안읽은 메일 카운트
		int noRead = emailService.selectNoReadCount(employee.getEmpNo());
		
		model.addAttribute("loginEmpNo",employee.getEmpNo());
		model.addAttribute("pagingVO",pagingVO);
		model.addAttribute("mailAttachList",mailAttachList);
		model.addAttribute("noRead",noRead);
				
		return "email/inbox";
	}
	
	// 중요메일함 업데이트
	@ResponseBody
	@PostMapping("/updateImportant")
	public ResponseEntity<ServiceResult> updateImportant(@RequestBody Map<String, Object> paramMap){
		ServiceResult result = null;
		
		String importantYN = (String) paramMap.get("afterImportantYN");
		Integer mailNo = (Integer) paramMap.get("mailNo");
		
		// 로그인한 사원번호
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
		Mail mail = emailService.selectDetailMail(mailNo);
		List<MailReceive> mailReceiveList = emailService.selectDetailMailReceive(mailNo);
		for(int i=0; i<mailReceiveList.size(); i++) {
			if(employee.getEmpNo().equals(mailReceiveList.get(i).getEmpNo())) {	// 받은메일함으로 인식
				result = emailService.updateInboxImportantMail(mailNo, employee.getEmpNo(),importantYN );
			}
		}
		if(employee.getEmpNo().equals(mail.getEmpNo())) {	// 보낸메일함으로 인식
			result = emailService.updateSentMailImportantMail(mailNo,importantYN);
		}
		
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}
}
