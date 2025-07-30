package kr.or.ddit.email.vo;


import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MailAttach {
	private MultipartFile item;
	private int fileNo;
	private int mailNo;
	private String fileName;
	private String fileSavepath;
	private String fileMimetype;
	private long fileSize;
	private String fileFancysize;
	
	public MailAttach() {}
	
	public MailAttach(MultipartFile item) {
		this.item = item;
		this.fileName = item.getOriginalFilename();
		this.fileMimetype = item.getContentType();
		this.fileSize = item.getSize();
		this.fileFancysize = FileUtils.byteCountToDisplaySize(fileSize);
	}
}
