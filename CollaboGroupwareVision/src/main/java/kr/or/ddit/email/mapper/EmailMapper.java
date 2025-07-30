package kr.or.ddit.email.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.email.vo.Mail;
import kr.or.ddit.email.vo.MailAttach;
import kr.or.ddit.email.vo.MailPaginationInfo;
import kr.or.ddit.email.vo.MailReceive;

@Mapper
public interface EmailMapper {
	public int insertMail(Mail mail);
	public void insertMailReceiver(MailReceive mailReceive);
	public void insertMailAttach(MailAttach mailAttach);
	public List<Mail> selectMailReceiveList(MailPaginationInfo<Mail> pagingVO);
	public List<Mail> selectMailSentList(MailPaginationInfo<Mail> pagingVO);
	public int selectNoReadCount(String empNo);
	public Mail selectDetailMail(int mailNo);
	public void updateReadYes(@Param("mailNo") int mailNo,@Param("empNo") String empNo);
	public MailAttach selectFileInfo(int fileNo);
	public List<Mail> selectMailTrashList(MailPaginationInfo<Mail> pagingVO);
	public int selectMailReceiveCount(MailPaginationInfo<Mail> pagingVO);
	public int selectMailSentCount(MailPaginationInfo<Mail> pagingVO);
	public int selectMailTrashCount(MailPaginationInfo<Mail> pagingVO);
	public int inboxTempDelMail(@Param("mailNo") int mailNo,@Param("empNo") String empNo);
	public int sentBoxTempDelMail(int mailNos);
	public void updateMailBoxStatus(@Param("mailNo") int mailNo,@Param("mailBoxStatus") String mailBoxStatus);
	public List<MailReceive> selectDetailMailReceive(int mailNo);
	public int restoreIndexMail(@Param("mailNo") int mailNo,@Param("empNo") String empNo);
	public int restoreSentMail(int mailNo);
	public int deleteIndexMail(@Param("mailNo") int mailNo,@Param("empNo") String empNo);
	public int deleteSentMail(int mailNo);
	public int selectImportantCount(MailPaginationInfo<Mail> pagingVO);
	public List<Mail> selectImportantList(MailPaginationInfo<Mail> pagingVO);
	public int updateInboxImportantMail(@Param("mailNo") int mailNo,@Param("empNo") String empNo,@Param("importantYN") String importantYN);
	public int updateSentMailImportantMail(@Param("mailNo")int mailNo,@Param("importantYN") String importantYN);
}
