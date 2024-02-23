package kr.or.ddit.chat.vo;

import kr.or.ddit.account.vo.Employee;
import lombok.Data;

@Data
public class ChatMem {
	private int chatMemNo;		// 채팅멤버번호(기본키)
	private int chatroomNo;		// 채팅방번호(외래키)
	private String empNo;		// 사원번호(외래키)
	private int readChatNo;		// 해당 멤버가 읽지않은 채팅수
	private String entryDate;	// 입장일
	private String exitDate;	// 퇴장일
	private String chatEnabled;	// 활동여부(1:활동,0:퇴장)
	
	private Employee employee;				// 직원리스트
}
