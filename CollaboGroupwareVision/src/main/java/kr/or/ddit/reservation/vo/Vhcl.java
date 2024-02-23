package kr.or.ddit.reservation.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Vhcl {

	private String vhclNo;			//차량번호	
	private String vhclName;		//차량이름
	private String enabled;			//사용가능 여부 
	private String vhclImgPath;		//차량 이미지 경로	
	private MultipartFile imgFile;

	
}

