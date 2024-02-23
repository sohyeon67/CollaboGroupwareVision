package kr.or.ddit.community.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Cmny {
	
	private int cmnyNo;
	private int boardCode;
	private String cmnyName;
	private String cmnyTop;
	private String cmnyIntro;
	private String openDay;
	private String closeDay;
	private int memberCount;
	private String cmnyReturn;
	private String cmnyApproval;
	private String cmnyStatus;
	private String cmnyImgPath;
	private MultipartFile imgFile;
	
	private CmnyMem cmnyMem;
}

