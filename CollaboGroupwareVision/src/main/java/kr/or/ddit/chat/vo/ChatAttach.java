package kr.or.ddit.chat.vo;


import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ChatAttach {
	private MultipartFile item;
	private int chatFileNo;				// 채팅 파일번호(기본키)
	private int chatNo;					// 채팅 번호(외래키)
	private String chatFileName;		// 채팅파일이름
	private Long chatFileSize;			// 채팅파일크기
	private String chatFileFancysize;	// 채팅파일최대사이즈
	private String chatFileMimetype;	// 채팅미디어타입
	private String chatFileSavepath;	// 채팅저장경로
	private String chatFileDowncount;	// 채팅다운로드수
	
	public ChatAttach() {}
	
	public ChatAttach(MultipartFile item) {
		this.item = item;
		this.chatFileName = item.getOriginalFilename();
		this.chatFileMimetype = item.getContentType();
		this.chatFileSize = item.getSize();
		this.chatFileFancysize = FileUtils.byteCountToDisplaySize(chatFileSize);
	}
}
