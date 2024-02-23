package kr.or.ddit.board.vo;

import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BoardAttach {
	private MultipartFile item;
	private int fileNo;
	private int boardNo;
	private String fileName;
	private String fileSavepath;
	private String fileMimetype;
	private long fileSize;
	private String fileFancysize;
	private int fileDowncount;

	public BoardAttach() {}
	
	public BoardAttach(MultipartFile item) {
		this.item = item;
		this.fileName = item.getOriginalFilename();
		this.fileMimetype = item.getContentType();
		this.fileSize = item.getSize();
		this.fileFancysize = FileUtils.byteCountToDisplaySize(fileSize);
	}

	public boolean isEmpty() {
		// TODO Auto-generated method stub
		return false;
	}
	
}
