package kr.or.ddit.reservation.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.reservation.mapper.MerMapper;
import kr.or.ddit.reservation.vo.Mer;
import kr.or.ddit.reservation.vo.MerRsvt;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MerServiceImpl implements MerService {

	@Inject
	private MerMapper merMapper;
	
	@Override
	public List<Mer> selectMerList() {
		return merMapper.selectMerList();
	}

	@Override
	public List<MerRsvt> selectMerRsvtList() {
		return merMapper.selectMerRsvtList();
	}

	@Override
	public List<MerRsvt> selectMerRsvtListByDay(String merDate) {
		List<MerRsvt> merRsvtList = merMapper.selectMerRsvtListByDay(merDate);
		
		LocalDateTime now = LocalDateTime.now(); 
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		for (MerRsvt merRsvt : merRsvtList) {
		    // 예약 종료 날짜를 String에서 LocalDate로 변환
			LocalDateTime endRsvtDate = LocalDateTime.parse(merRsvt.getEndRsvtDate(), formatter);
		   log.info("endRsvtDate:"+endRsvtDate);
		   // 현재시간이 예약종료시간보다 이후인경우 회의실 예약 상태를 '02'로 바꿈
		   if (now.isAfter(endRsvtDate)) {
			   merMapper.updateRsvtStatus(merRsvt.getMRsvtNo());
			   log.info("endRsvtDate:"+endRsvtDate);
		   }
		}
		return merMapper.selectMerRsvtListByDay(merDate);
	}

	@Override
	public int insertMerRsvt(Map<String, Object> paramMap) {
		int merNo = (int) paramMap.get("merNo");			// 회의실 번호
		String merDate = (String) paramMap.get("merDate");	// 선택한 날짜
		int startTime = (int) paramMap.get("startTime");	// 시작시간
		int endTime = (int) paramMap.get("endTime");		// 종료시간
		String title = (String) paramMap.get("title");		// 예약제목
		String ppus = (String) paramMap.get("ppus");		// 사용목적
		String empNo = (String) paramMap.get("empNo");		// 사원번호
		
		MerRsvt merRsvt = new MerRsvt();
	
		merRsvt.setMerNo(merNo);
		String startDate = merDate + " " + startTime;
		String endDate = merDate + " " + endTime;
		merRsvt.setStrtRsvtDate(startDate);
		merRsvt.setEndRsvtDate(endDate);
		merRsvt.setMRsvtTitle(title);
		merRsvt.setPpus(ppus);
		merRsvt.setEmpNo(empNo);
		
		return merMapper.insertMerRsvt(merRsvt);
	}

	@Override
	public List<MerRsvt> checkReserve(MerRsvt merRsvt) {
		return merMapper.checkReserve(merRsvt);
	}

	@Override
	public MerRsvt selectDetailMerRsvt(int mRsvtNo) {
		return merMapper.selectDetailMerRsvt(mRsvtNo);
	}

	@Override
	public void merCancel(int mRsvtNo) {
		merMapper.merCancel(mRsvtNo);
	}

	@Override
	public void adminMerInsert(Mer mer) {
		merMapper.adminMerInsert(mer);
	}

	@Override
	public void adminMerUpdate(Mer mer) {
		merMapper.adminMerUpdate(mer);
	}

	@Override
	public int adminMerDelete(int merNo) {
		return merMapper.adminMerDelete(merNo);
	}


}
