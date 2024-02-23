package kr.or.ddit.chat.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.chat.service.ChatService;
import kr.or.ddit.chat.vo.Chat;
import kr.or.ddit.chat.vo.ChatMem;
import kr.or.ddit.chat.vo.ChatRoom;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/chat")
public class ChatController {
	
	@Inject
	private ChatService chatService;
	
	// 채팅방 리스트
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping
	public String ChatRoom(HttpServletRequest req, Model model, RedirectAttributes ra) {
		log.info("ChatRoom() 실행..!");
		model.addAttribute("title","Chat");
		model.addAttribute("activeMain","chat");
		
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
		// 세션 정보에서 꺼낸 회원 데이터가 null이 아닐때(로그인을 진행)
		if(employee != null ) {
			// 채팅리스트 불러오기
			List<ChatRoom> chatRoomList = chatService.listChatRoom(employee.getEmpNo());
			log.info("chatRoomList : " + chatRoomList);
			model.addAttribute("chatRoomList", chatRoomList);
			
		}else {	// 로그인을 진행햐지 않았을 때
			ra.addFlashAttribute("message", "로그인 후에 사용가능합니다");
			return "account/login";
		}
		
		return "chatting/chat";
	}
	
	
	// 채팅방 생성(ajax)
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping(value = "/newChatRoom")
	public String newChatRoom(String chatroomName, String chatMember, RedirectAttributes ra) {
		String goPage = "";
		log.info("newChatRoom() 실행..!");
		
		ChatRoom chatroom = new ChatRoom();
		
		// map 안에 값 꺼내기
		// 채팅방 이름 
		log.info("chatroomName : " + chatroomName);
		
		// 멤버리스트
		List<ChatMem> chatMemList = new ArrayList<ChatMem>();
		log.info("chatMember : " + chatMember);
		
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
		// 세션 정보에서 꺼낸 회원 데이터가 null이 아닐때(로그인을 진행)
		if(employee != null ) {
			// 채팅멤버VO에 초대된 사원번호 추가하기
			chatMember += ","+employee.getEmpNo();
			for(int i=0; i<chatMember.split(",").length; i++) {
				String empNo = chatMember.split(",")[i].trim();
				// 새로운 객체 생성
				ChatMem chatmem = new ChatMem();
				chatmem.setEmpNo(empNo);
				chatMemList.add(chatmem);
			}
			log.info("chatMemList : " + chatMemList);
			
			// chatroom에 값 셋팅
			chatroom.setEmpNo(employee.getEmpNo());	// 로그인한 사원정보 설정
			chatroom.setChatroomName(chatroomName);	// 방제목 설정
			chatroom.setChatMemList(chatMemList);	// 멤버리스트 설정
			chatroom.setChatroomMemCount(chatMemList.size());	// 멤버수 설정
			
			ServiceResult result = chatService.createChatRoom(chatroom);// 채팅방 번호는 쿼리에서 자동으로 들어가 있음
			log.info("chatroom : " + chatroom);
			
			if(result.equals(ServiceResult.OK)) {	// 등록 성공
				goPage = "redirect:/chat";
				ra.addFlashAttribute("message","채팅 등록이 완료되었습니다.");
			}else {		// 등록 실패
				ra.addFlashAttribute("message","서버에러, 다시 시도해주세요!!");
				goPage = "redirect:/chat";
			}
			
		}else {	// 로그인을 진행햐지 않았을 때
			ra.addFlashAttribute("message", "로그인 후에 사용가능합니다");
			return "redirect:/account/login";
		}
		
		return goPage;
	}
	
	// 채팅방 입장
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/entryChatRoom")
	public String entryChatRoom(HttpSession session, int chatroomNo, Model model) {
		log.info("entryChatRoom() 실행..!");
		model.addAttribute("activeMain","chat");
		
		// 로그인 정보 세션에 저장하기
		// [스프링 시큐리티] 회원 ID를 스프링 시큐리티 UserDetails 정보에서 가져오기		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		session.setAttribute("loginEmpNo", employee.getEmpNo());
		model.addAttribute("loginEmpNo",employee.getEmpNo());
				
		// 리스트 다시 불러오기
		List<ChatRoom> chatRoomList = chatService.listChatRoom(employee.getEmpNo());
		log.info("chatRoomList : " + chatRoomList);
		model.addAttribute("chatRoomList", chatRoomList);
		
		// 특정 채팅방 멤버 수 가져오기
		List<ChatRoom> chatRoomMemList = chatService.selectChatRoom(chatroomNo);
		int chatroomMemCount = chatRoomMemList.get(0).getChatroomMemCount();
		model.addAttribute("chatroomMemCount",chatroomMemCount);
		
		// 채팅번호 보내기
		model.addAttribute("chatroomNo",chatroomNo);
		log.info("chatroomNo:"+chatroomNo);
		
		// 채팅 조회
		// roomId를 통해 기존 채팅방 대화내역 불러오기
		List<Chat> chatMessageList = chatService.selectChatList(chatroomNo);
		log.info("chatMessageList : " + chatMessageList);
		
		if(chatMessageList == null || chatMessageList.equals("")) {
			model.addAttribute("msg", "빈 채팅방입니다.");
		}else {
			model.addAttribute("chatMessageList", chatMessageList);
		}
		session.setAttribute("chatroomNo", chatroomNo);	// 방번호 세션에 담기
		
		model.addAttribute("chatroomNo", chatroomNo);
		model.addAttribute("activeChatroom",chatroomNo);
		//model.addAttribute("sender", sender);
		
		return "chatting/chat";
	}
	
	// 채팅방 나가기
	@PostMapping("/exitChatRoom")
	public String exitChatRoom(HttpServletRequest req, int chatroomNo, Model model) {
		log.info("exitChatRoom() 실행..!");

		// 채팅방 해당 사원정보 삭제하기
		HttpSession session = req.getSession();
		String empNo = (String) session.getAttribute("loginEmpNo");
		chatService.deleteChatMember(chatroomNo, empNo);
				
		return "redirect:/chat";
	}
	
	// 채팅삭제
	@PostMapping("/deleteChat")
	public String deleteChat(HttpServletRequest req, int chatNo, int chatroomNo) {
		log.info("deleteChat() 실행..!");
		log.info("chatNo:"+chatNo);
		log.info("chatroomNo:"+chatroomNo);
		
		// 해당 채팅 삭제하기
		chatService.deleteChat(req, chatNo);
		
		return "redirect:/chat/entryChatRoom?chatroomNo="+chatroomNo;
	}
	
	// 채팅 파일 보내기
	@PostMapping(value = "/insertChatFile", produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> insertChatFile(HttpServletRequest req, int chatroomNo, String empNo, MultipartFile[] chatFile) throws Exception{

		// 패스 경로 리스트
		List<String> chatFilePath = new ArrayList<String>();

		for(int i=0; i<chatFile.length; i++) {
			log.info("파일이름:"+chatFile[i].getOriginalFilename());
			log.info("파일사이즈:"+chatFile[i].getSize());
			
			// 저장
			chatFile[i].transferTo(new File("c:/chatupload/" + chatFile[i].getOriginalFilename()));
			//chatFile[i].transferTo(new File(req.getContextPath() + "/chatfile/" + chatFile[i].getOriginalFilename()));
			chatFilePath.add("/chatfile/"+chatFile[i].getOriginalFilename());
		}
		
		//req.getServletContext().getRealPath("/resources/chat/img")
		
		String response = String.join(",", chatFilePath);
		
		// 파일 저장을 위한 채팅 저장
		Chat chat = new Chat();
		chat.setChatroomNo(chatroomNo);
		chat.setChatFile(chatFile);
		chat.setEmpNo(empNo);
		chat.setChatContent(" ");
		chatService.createChatAttach(req, chat);
		
		return new ResponseEntity<String>(response,HttpStatus.OK);
	}

	// 채팅방 정보 가져오기
	@GetMapping(value = "/selectChatRoom")
	public ResponseEntity<List<ChatRoom>> selectChatRoom(int chatroomNo) {
		log.info("selectChatRoom() 실행..!");
		
		List<ChatRoom> chatRoomMemList = new ArrayList<ChatRoom>();
		chatRoomMemList = chatService.selectChatRoom(chatroomNo);
		log.debug("chatRoomMemList:"+chatRoomMemList);
		return new ResponseEntity<List<ChatRoom>>(chatRoomMemList, HttpStatus.OK);
	}
	
	// 채팅 멤버 초대하기
	@PostMapping(value = "/inviteMember")
	public String inviteMember(int chatroomNo, String chatMember) {
		return "redirect:/chat/entryChatRoom?chatroomNo="+chatroomNo;
	}
	
	// 실시간
	@RequestMapping(value = "/date", method = RequestMethod.GET)
	public String dateTest() {
		return "date";
	}

}