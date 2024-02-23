package kr.or.ddit.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.chat.service.ChatService;
import kr.or.ddit.chat.vo.Chat;

// 채팅 핸들러 클래스
public class EchoHandler extends TextWebSocketHandler {
	
	private final List<WebSocketSession> sessionList = new ArrayList<WebSocketSession>();
	
	private Map<String, List<Chat>> chatMap = new HashMap<String, List<Chat>>();
	
	@Inject
	private ChatService chatService;
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		//String userName = (String) session.getAttributes().get("loginName");
		//System.out.println("입장한 사람 : " + userName);	// 사용자 id
		
		int chatroomNo = (int) session.getAttributes().get("chatroomNo");	// 방번호
		System.out.println("방번호 : " + chatroomNo);
		
		chatMap.putIfAbsent(String.valueOf(chatroomNo) , new ArrayList<>());
		
		sessionList.add(session);
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.println("handleTextMessage() 실행!!!");
		//String sender = (String) session.getAttributes().get("loginName");
		int chatroomNo = (int) session.getAttributes().get("chatroomNo");	// 방번호
		System.out.println("방번호 : " + chatroomNo);
		System.out.println("내용이다!:"+message.getPayload());
		List<Chat> chatList = chatMap.get(String.valueOf(chatroomNo));
        if (chatList == null) {
            chatList = new ArrayList<>();
            chatMap.put(String.valueOf(chatroomNo), chatList);
        }
        
        // 받아온 메세지 json 객체로 변환
        Gson gson = new Gson();							//json으로부터 객체를 만듦		
        //이 message클래스를 기반으로 json이만들어진다.		
        Chat msg = gson.fromJson(message.getPayload(), Chat.class); 		
        // ↑ json을 java의 객체로 바꿔주는 것.		// user, to, articleId, articleOwnver(방장?), message;
        
        String empNo = (String) session.getAttributes().get("loginEmpNo");
        
        // 채팅 설정
        Chat chat = new Chat();
        if(msg.getChatContent() != null) {
	    	chat.setChatroomNo(chatroomNo);
	        chat.setEmpNo(empNo);
	        chat.setChatContent(msg.getChatContent());
	        
	        // 채팅저장
	        chatService.createChatMessage(chat);
	        chatList.add(chat);
	        System.out.println("chat:"+chat);	// 확인
        }
        
        // json 메세지 설정
        System.out.println("msg:"+msg);		 		// 전달 메시지	
        msg.setChatNo(chat.getChatNo());
        msg.setChatroomNo(chat.getChatroomNo());
        msg.setEmpNo(empNo);
        
        Chat chatMessage2 = chatService.selectChatList(chatroomNo).get(chatService.selectChatList(chatroomNo).size() -1);
        Employee emp = chatMessage2.getEmployee();
        msg.setEmployee(emp);
        
        TextMessage sendMsg = new TextMessage(gson.toJson(msg));
        System.out.println("후 msg:"+msg);		 		// 전달 메시지	
        
        // 웹소켓으로 보내기
        for (WebSocketSession webSocketSession : sessionList) {
        	// 채팅방 분리(방번호 같을 때만 메세지 보내기)
        	System.out.println("chatRoomNo : "+webSocketSession.getAttributes().get("chatroomNo"));
            if (webSocketSession.getAttributes().get("chatroomNo").toString().equals(String.valueOf(chatroomNo))) {
            	webSocketSession.sendMessage(sendMsg);
            }
        }
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		sessionList.remove(session);
	}
}
