package kr.or.ddit.notification.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.notification.vo.Notification;

public interface NotiMapper {

	public List<Notification> selectNotiList(String empNo);
	public void updateNotiRead(@Param("empNo") String empNo,@Param("notiKind") String notiKind);
	public int selectNotiListCount(String empNo);
	public void insertNoti(Notification notiVO);

}
