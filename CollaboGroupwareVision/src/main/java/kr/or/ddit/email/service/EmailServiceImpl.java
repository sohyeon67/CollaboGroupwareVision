package kr.or.ddit.email.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.email.mapper.EmailMapper;
import kr.or.ddit.email.vo.Mail;
import kr.or.ddit.email.vo.MailAttach;
import kr.or.ddit.email.vo.MailPaginationInfo;
import kr.or.ddit.email.vo.MailReceive;

@Service
public class EmailServiceImpl implements EmailService {

	@Inject
	private EmailMapper emailMapper;

	@Override
	public void insertMail(HttpServletRequest req, Mail mail) {
		// mail insert
		int status = emailMapper.insertMail(mail);
		if(status > 0) {
			// 수신자 insert
			if(mail.getEmpToArr() != null) {
				for(int i=0; i<mail.getEmpToArr().size(); i++) {
					MailReceive mailReceive = new MailReceive();
					mailReceive.setEmpNo(mail.getEmpToArr().get(i));
					mailReceive.setMailNo(mail.getMailNo());
					emailMapper.insertMailReceiver(mailReceive);
				}
			}
			
			// 파일 insert
			List<MailAttach> mailAttachList = mail.getMailAttachList();
			
			try {
				mailFileUpload(mailAttachList, mail.getMailNo(), req);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private void mailFileUpload(List<MailAttach> mailAttachList, int mailNo, HttpServletRequest req) throws IOException {
		String savePath = "/resources/mail/";
		
		if(mailAttachList != null) {	
			if(mailAttachList.size() > 0) {
				for(MailAttach mailAttach : mailAttachList) {
					String saveName = UUID.randomUUID().toString();	
					
					saveName = saveName + "_" + mailAttach.getFileName().replaceAll(" ", "_");
					String endFilename = mailAttach.getFileName().split("\\.")[1];	
					
					String saveLocate = req.getServletContext().getRealPath(savePath + mailNo);
					File file = new File(saveLocate);
					if(!file.exists()) {
						file.mkdirs();
					}
					saveLocate += "/" + saveName;
					
					mailAttach.setMailNo(mailNo);					
					mailAttach.setFileSavepath(saveLocate);	
					emailMapper.insertMailAttach(mailAttach);	
				
					File saveFile = new File(saveLocate);
					mailAttach.getItem().transferTo(saveFile); 	
				}
			}
		}
		
	}

	@Override
	public List<Mail> selectMailReceiveList(MailPaginationInfo<Mail> pagingVO) {
		return emailMapper.selectMailReceiveList(pagingVO);
	}

	@Override
	public List<Mail> selectMailSentList(MailPaginationInfo<Mail> pagingVO) {
		return emailMapper.selectMailSentList(pagingVO);
	}

	@Override
	public int selectNoReadCount(String empNo) {
		return emailMapper.selectNoReadCount(empNo);
	}

	@Override
	public Mail selectDetailMail(int mailNo) {
		return emailMapper.selectDetailMail(mailNo);
	}

	@Override
	public MailAttach selectFileInfo(int fileNo) {
		return emailMapper.selectFileInfo(fileNo);
	}

	@Override
	public List<Mail> selectMailTrashList(MailPaginationInfo<Mail> pagingVO) {
		return emailMapper.selectMailTrashList(pagingVO);
	}

	@Override
	public void updateReadYes(int mailNo, String empNo) {
		emailMapper.updateReadYes(mailNo,empNo);
	}

	@Override
	public int selectMailReceiveCount(MailPaginationInfo<Mail> pagingVO) {
		return emailMapper.selectMailReceiveCount(pagingVO);
	}

	@Override
	public int selectMailSentCount(MailPaginationInfo<Mail> pagingVO) {
		return emailMapper.selectMailSentCount(pagingVO);
	}

	@Override
	public int selectMailTrashCount(MailPaginationInfo<Mail> pagingVO) {
		return emailMapper.selectMailTrashCount(pagingVO);
	}

	@Override
	public ServiceResult inboxTempDelMail(int mailNo, String empNo) {
		ServiceResult result = null;
		
		int status = emailMapper.inboxTempDelMail(mailNo, empNo);
		if(status > 0) {
			emailMapper.updateMailBoxStatus(mailNo,"01");
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult sentBoxTempDelMail(int mailNo) {
		ServiceResult result = null;
		
		int status = emailMapper.sentBoxTempDelMail(mailNo);
		if(status > 0) {
			emailMapper.updateMailBoxStatus(mailNo,"02");
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public List<MailReceive> selectDetailMailReceive(int mailNo) {
		return emailMapper.selectDetailMailReceive(mailNo);
	}

	@Override
	public ServiceResult restoreIndexMail(int mailNo, String empNo) {
		ServiceResult result = null;
		
		int status = emailMapper.restoreIndexMail(mailNo, empNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult restoreSentMail(int mailNo) {
		ServiceResult result = null;
		
		int status = emailMapper.restoreSentMail(mailNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult deleteIndexMail(int mailNo, String empNo) {
		ServiceResult result = null;
		
		int status = emailMapper.deleteIndexMail(mailNo, empNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult deleteSentMail(int mailNo) {
		ServiceResult result = null;
		
		int status = emailMapper.deleteSentMail(mailNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public int selectImportantCount(MailPaginationInfo<Mail> pagingVO) {
		return emailMapper.selectImportantCount(pagingVO);
	}

	@Override
	public List<Mail> selectImportantList(MailPaginationInfo<Mail> pagingVO) {
		return emailMapper.selectImportantList(pagingVO);
	}

	@Override
	public ServiceResult updateInboxImportantMail(int mailNo, String empNo, String importantYN) {
		
		ServiceResult result = null;
		
		int status = emailMapper.updateInboxImportantMail(mailNo, empNo, importantYN);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult updateSentMailImportantMail(int mailNo, String importantYN) {
		ServiceResult result = null;
		
		int status = emailMapper.updateSentMailImportantMail(mailNo, importantYN);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

}
