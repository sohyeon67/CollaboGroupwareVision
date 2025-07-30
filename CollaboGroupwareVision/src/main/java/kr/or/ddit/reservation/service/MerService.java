package kr.or.ddit.reservation.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.reservation.vo.Mer;
import kr.or.ddit.reservation.vo.MerRsvt;

public interface MerService {
	public List<Mer> selectMerList();
	public List<MerRsvt> selectMerRsvtList();
	public List<MerRsvt> selectMerRsvtListByDay(String merDate);
	public int insertMerRsvt(Map<String, Object> paramMap);
	public List<MerRsvt> checkReserve(MerRsvt merRsvt);
	public MerRsvt selectDetailMerRsvt(int mRsvtNo);
	public void merCancel(int mRsvtNo);
	public void adminMerInsert(Mer mer);
	public void adminMerUpdate(Mer mer);
	public int adminMerDelete(int merNo);
}
