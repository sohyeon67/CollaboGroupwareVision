package kr.or.ddit.notification.controller;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.notification.service.NotiService;
import kr.or.ddit.notification.vo.Notification;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
public class NotificationController {

	@Inject
	private NotiService notiService;
	
	// 알람 수 불러오기
	@GetMapping("/headerNotiCount")
	public ResponseEntity<Integer> headerNotiCount(HttpSession session, Model model) {
		String empNo = (String) session.getAttribute("loginEmpNo");
		int notiCount = 0;
		if(empNo != null ) {
			notiCount = notiService.selectNotiListCount(empNo);
		}
		return new ResponseEntity<Integer>(notiCount, HttpStatus.OK);
	}
	// 알람 리스트 불러오기
	@GetMapping("/notify/notiList")
	public ResponseEntity<List<Notification>> notiList(HttpServletRequest req,RedirectAttributes ra) {
		log.info("notiList() 실행..!");
		
		HttpSession session = req.getSession();
		String empNo = (String) session.getAttribute("loginEmpNo");
		
		List<Notification> notiList = new ArrayList<Notification>();
		//log.info("empNo:"+empNo);
		notiList = notiService.selectNotiList(empNo);	// 알람 중 읽음 여부가 'N'인거 조회 조회

		return new ResponseEntity<List<Notification>>(notiList, HttpStatus.OK);
	}
	
	// 내가 읽은 알람의 알람종류만 읽음여부 N->Y로 업데이트 하기
	@PostMapping("/notify/updateNotiRead")
	public ResponseEntity<String> updateNotiRead(HttpServletRequest req,String notiKind){
		HttpSession session = req.getSession();
		String empNo = (String) session.getAttribute("loginEmpNo");
		
		notiService.updateNotiRead(empNo,notiKind);	// 읽음여부 N->Y로 만들기
		return new ResponseEntity<String>("SUCCESS",HttpStatus.OK);
	}
}
