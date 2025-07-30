package kr.or.ddit.chat.vo;

import java.util.List;

import lombok.Data;

@Data
public class ChatRoom {
	private int chatroomNo;					// 채팅방번호(시퀀스), 기본키
	private String empNo;					// 채팅방 방장, 외래키
	private String chatroomName;			// 채팅방 이름
	private int chatroomMemCount;			// 채팅방 멤버수
	private String chatroomCreateDate;		// 채팅방 생성 날짜, sysdate
	
	private List<ChatMem> chatMemList;		// 채팅방 멤버 리스트
	
}
