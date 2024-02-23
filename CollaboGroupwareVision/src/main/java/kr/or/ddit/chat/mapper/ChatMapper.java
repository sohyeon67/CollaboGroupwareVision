package kr.or.ddit.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.chat.vo.Chat;
import kr.or.ddit.chat.vo.ChatAttach;
import kr.or.ddit.chat.vo.ChatMem;
import kr.or.ddit.chat.vo.ChatRoom;

public interface ChatMapper {
	public List<ChatRoom> listChatRoom(String empNo);
	public int createChatRoom(ChatRoom chatroom);
	public ChatAttach selectChatFileInfo(int chatFileNo);
	public void createChatMember(ChatMem chatmem);
	public List<Chat> selectChatList(int chatroomNo);
	public int createChatMessage(Chat chat);
	public int deleteChatMember(@Param("chatroomNo") int chatroomNo,@Param("empNo") String empNo);
	public int deleteChat(int chatNo);
	public List<Chat> selectChatAllList();
	public void insertChatFile(ChatAttach chatAttach);
	public Chat selectChat(int chatNo);
	public void deleteChatFileByChatNo(int chatNo);
	public List<ChatMem> selectChatMem(int chatroomNo);
	public List<ChatRoom> selectChatRoom(int chatroomNo);
	public void updateChatroomMemCount(int chatroomNo);
}
