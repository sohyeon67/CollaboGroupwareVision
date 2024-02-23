package kr.or.ddit.notification.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.notification.mapper.NotiMapper;
import kr.or.ddit.notification.vo.Notification;

@Service
public class NotiServiceImpl implements NotiService {

	@Inject
	private NotiMapper notiMapper;
	
	@Override
	public List<Notification> selectNotiList(String empNo) {
		return notiMapper.selectNotiList(empNo);
	}

	@Override
	public void updateNotiRead(String empNo,String notiKind) {
		notiMapper.updateNotiRead(empNo,notiKind);
	}

	@Override
	public int selectNotiListCount(String empNo) {
		return notiMapper.selectNotiListCount(empNo);
		
	}

}
