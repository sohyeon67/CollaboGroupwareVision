package kr.or.ddit.email.vo;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.account.vo.Employee;
import lombok.Data;

@Data
public class Mail {
	private int mailNo;			// 메일번호(시퀀스)
	private String empNo;		// 보낸사람 사번
	private String mailTitle;	// 메일제목
	private String mailContent;	// 메일내용
	private String sendDate;	// 보낸날짜
	private String reserveDate;	// 예약날짜
	private String important;	// 중요여부(Y:중요/N:일반)
	private String mailStatus;	// 메일상태(01:정상/00:휴지통)
	private String mailBoxStatus;	// 휴지통에서 어디서 온 메일인지 알려주는 상태: 받은메일함 :'01', 보낸메일함:'02'
	private String mailDelYn;		// 삭제여부
	
	private Employee employee;
	
	private List<String> empToArr;	// 보낸사람 여러명
	private List<MailReceive> mailReceiveList;
	
	private Integer[] delMailNo;	// 삭제할 메일번호
	private MultipartFile[] mailFile;
	private List<MailAttach> mailAttachList;
	
	public void setEmpToArr(List<String> empToArr) {
		this.empToArr = empToArr;
		if(empToArr != null) {
			List<MailReceive> mailReceiveList = new ArrayList<MailReceive>();
			for(String empTo : empToArr) {
				MailReceive mailReceive = new MailReceive(empTo);
				mailReceiveList.add(mailReceive);
			}
			this.mailReceiveList = mailReceiveList;
		}
		
	}
	
	public void setMailFile(MultipartFile[] mailFile) {
		this.mailFile = mailFile;
		if(mailFile != null) {
			List<MailAttach> mailAttachList = new ArrayList<MailAttach>();
			for(MultipartFile item : mailFile) {
				if(StringUtils.isBlank(item.getOriginalFilename())) {
					continue;
				}
				MailAttach mailAttach = new MailAttach(item);
				mailAttachList.add(mailAttach);
			}
			this.mailAttachList = mailAttachList;
		}
	}
}
