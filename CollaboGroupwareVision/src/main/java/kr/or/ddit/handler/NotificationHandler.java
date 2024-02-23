package kr.or.ddit.handler;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import kr.or.ddit.account.mapper.AccountMapper;
import kr.or.ddit.account.mapper.LoginMapper;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.chat.mapper.ChatMapper;
import kr.or.ddit.chat.vo.ChatMem;
import kr.or.ddit.community.mapper.CmnyMapper;
import kr.or.ddit.email.vo.Mail;
import kr.or.ddit.email.vo.MailReceive;
import kr.or.ddit.notification.mapper.NotiMapper;
import kr.or.ddit.notification.vo.Notification;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class NotificationHandler extends TextWebSocketHandler  {

private static List<WebSocketSession> list = new ArrayList<WebSocketSession>();
	
	@Inject
	private NotiMapper notiMapper;
	
	@Inject
	private AccountMapper accountMapper;
	
	@Inject
	private ChatMapper chatMapper;
	
	@Inject
	private CmnyMapper cmnyMapper;
	
    public NotificationHandler() {
    	log.info("시운 생성이 되야 하는뎅!");
    }

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		log.info("## 누군가 접속");
		
		list.add(session);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		//String uMsg = message.getPayload();
		System.out.println("받은 메세지:"+message.getPayload());
		
		String empNo = (String) session.getAttributes().get("loginEmpNo");
		
		// 알람 저장
		String content = message.getPayload();
		Notification notiVO = new Notification();
		
		if(content != null) {
			// 알림 종류과 알림 제목
			if(content.contains("공지사항")) {
				List<Employee> empList = accountMapper.getEmpList();
				for(Employee emp : empList) {
					notiVO.setNotiKind("01");
					notiVO.setNotiTitle("Notice");
					notiVO.setEmpNo(emp.getEmpNo());
					notiVO.setNotiContent(content);
					notiMapper.insertNoti(notiVO);
				}
			}else if(content.contains("메일")) {
				String[] contentSplit = content.split(",");
				if(contentSplit != null) {
					for(int i=1; i<contentSplit.length; i++) {
						String mailEmp = contentSplit[i];
						notiVO.setEmpNo(mailEmp);
						notiVO.setNotiKind("02");
						notiVO.setNotiTitle("Mail");
						notiVO.setNotiContent(contentSplit[0]);
						notiMapper.insertNoti(notiVO);
					}
				}
			}else if(content.contains("프로젝트")) {
				notiVO.setNotiKind("Project");
				notiVO.setNotiTitle("Notice");
			}else if(content.contains("커뮤니티")) {
				notiVO.setNotiKind("04");
				notiVO.setNotiTitle("Community");
				String[] contentSplit = content.split(",");
				String CmnyTopEmpNo = cmnyMapper.getCmnyTopEmpNo(Integer.parseInt(contentSplit[1].trim()));
				notiVO.setEmpNo(CmnyTopEmpNo);
				notiVO.setNotiContent(contentSplit[0]);
				notiMapper.insertNoti(notiVO);
			}else if(content.contains("결재")) {
				notiVO.setNotiKind("05");
				notiVO.setNotiTitle("Drafting");
			}else if(content.contains("채팅")) {	// 채팅방에 있는 멤버들에게 보내기
				// 메세지를 보낸 해당 채팅방에 있는 멤버들에게 보내기
				int chatroomNo = (int) session.getAttributes().get("chatroomNo");	// 방번호
				List<ChatMem> chatMemList = chatMapper.selectChatMem(chatroomNo);
				//System.out.println("chatMemList.size():"+chatMemList.size());
				for(ChatMem chatMem: chatMemList) {
					notiVO.setNotiContent(content);
					notiVO.setNotiKind("06");
					notiVO.setNotiTitle("Chatting");
					notiVO.setEmpNo(chatMem.getEmpNo());
					notiMapper.insertNoti(notiVO);
				}
			}else if(content.contains("관리자")) {
				notiVO.setNotiKind("07");
				notiVO.setNotiTitle("Admin");
			}else {
				notiVO.setNotiKind("08");
				notiVO.setNotiTitle("기타");
			}
			
			// 알림 내용
			//notiVO.setNotiContent(content);
			
			// 사원번호 - 이것도 매 경우마다 수정해야함
			//String empNo = (String) session.getAttributes().get("loginEmpNo");
			//notiVO.setEmpNo(empNo);
			
			//System.out.println("notiVO 결과:"+notiVO);
			//notiMapper.insertNoti(notiVO);
		}
		
		for (WebSocketSession webSocketSession : list) {
			webSocketSession.sendMessage(message);
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		log.info("## 누군가 떠남");
		list.remove(session);
	}
}
