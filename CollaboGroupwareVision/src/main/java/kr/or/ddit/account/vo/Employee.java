package kr.or.ddit.account.vo;

import java.io.Serializable;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Employee implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// 나중에 수정 필요!
	private String empNo;
	
	private Integer deptCode;	// 공통코드 아님
	private String deptName;
	
	private String empName;
	private String empPw;
	private String empTel;
	private String extNo;
	private String empEmail;
	private String empPsnEmail;
	private String empBirth;
	private String empRrn;
	private String empZip;
	private String empAddr1;
	private String empAddr2;
	
	private MultipartFile profileImgFile;
	private String profileImgPath;
	
	private MultipartFile signImgFile;
	private byte[] signImg;
	
	private String accountNo;
	private String joinDay;
	private String leaveDay;
	private int yrycCount;
	
	private String positionCode;// 공통코드
	private String position;
	
	private String dutyCode;	// 공통코드
	private String duty;
	
	private String bankCode;	// 공통코드
	private String bank;
	
	private String hffcStatus;	// 공통코드
	private String hffc;
	
	private int enabled;
	private String adminYn;
	
	private List<Auth> authList;	// 한 명의 직원에게 여러 권한
	
	private String empDelDay;
	private String empQr;
	
}
