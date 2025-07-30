package kr.or.ddit.chat.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.chat.vo.Chat;
import kr.or.ddit.chat.vo.ChatRoom;

public interface ChatService {
	public List<ChatRoom> listChatRoom(String empNo);
	public ServiceResult createChatRoom(ChatRoom chatroom);
	public List<Chat> selectChatAllList();
	public List<Chat> selectChatList(int chatroomNo);
	public ServiceResult createChatMessage(Chat chat);
	public void deleteChatMember(int chatroomNo, String empNo);
	public ServiceResult deleteChat(HttpServletRequest req, int chatNo);
	public ServiceResult createChatAttach(HttpServletRequest req, Chat chat);
	public List<ChatRoom> selectChatRoom(int chatroomNo);
	
}
