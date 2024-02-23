package kr.or.ddit.reservation.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.reservation.vo.Mer;
import kr.or.ddit.reservation.vo.MerRsvt;

@Mapper
public interface MerMapper {
	public List<Mer> selectMerList();
	public List<MerRsvt> selectMerRsvtList();
	public List<MerRsvt> selectMerRsvtListByDay(String merDate);
	public void updateRsvtStatus(int mRsvtNo);
	public int insertMerRsvt(MerRsvt merRsvt);
	public List<MerRsvt> checkReserve(MerRsvt merRsvt);
	public MerRsvt selectDetailMerRsvt(int mRsvtNo);
	public void merCancel(int mRsvtNo);
	public void adminMerInsert(Mer mer);
	public void adminMerUpdate(Mer mer);
	public int adminMerDelete(int merNo);
}
