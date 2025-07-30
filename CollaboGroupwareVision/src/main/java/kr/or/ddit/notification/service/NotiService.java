package kr.or.ddit.notification.service;

import java.util.List;

import kr.or.ddit.board.vo.Board;
import kr.or.ddit.notification.vo.Notification;

public interface NotiService {
	public List<Notification> selectNotiList(String empNo) ;
	public void updateNotiRead(String empNo,String notiKind);
	public int selectNotiListCount(String empNo);
}
