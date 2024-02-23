package kr.or.ddit.email.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.email.vo.Mail;
import kr.or.ddit.email.vo.MailAttach;
import kr.or.ddit.email.vo.MailPaginationInfo;
import kr.or.ddit.email.vo.MailReceive;

public interface EmailService {
	public void insertMail(HttpServletRequest req, Mail mail);
	public List<Mail> selectMailReceiveList(MailPaginationInfo<Mail> pagingVO);
	public List<Mail> selectMailSentList(MailPaginationInfo<Mail> pagingVO);
	public int selectNoReadCount(String empNo);
	public Mail selectDetailMail(int mailNo);
	public MailAttach selectFileInfo(int fileNo);
	public List<Mail> selectMailTrashList(MailPaginationInfo<Mail> pagingVO);
	public void updateReadYes(int mailNo, String empNo);
	public int selectMailReceiveCount(MailPaginationInfo<Mail> pagingVO);
	public int selectMailSentCount(MailPaginationInfo<Mail> pagingVO);
	public int selectMailTrashCount(MailPaginationInfo<Mail> pagingVO);
	public ServiceResult inboxTempDelMail(int mailNo, String empNo);
	public ServiceResult sentBoxTempDelMail(int mailNo);
	public List<MailReceive> selectDetailMailReceive(int mailNo);
	public ServiceResult restoreIndexMail(int mailNo, String empNo);
	public ServiceResult restoreSentMail(int mailNo);
	public ServiceResult deleteIndexMail(int mailNo, String empNo);
	public ServiceResult deleteSentMail(int mailNo);
	public int selectImportantCount(MailPaginationInfo<Mail> pagingVO);
	public List<Mail> selectImportantList(MailPaginationInfo<Mail> pagingVO);
	public ServiceResult updateInboxImportantMail(int mailNo, String empNo, String importantYN);
	public ServiceResult updateSentMailImportantMail(int mailNo, String importantYN);
	
	
}
