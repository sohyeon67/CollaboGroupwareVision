package kr.or.ddit.dclz.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.dclz.vo.PaginationInfoVO;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.Drafting;

public interface DclzMapper {

	public Dclz selectEmpTime(String empNo);

	public int updateLeaveTime(String dclzNo);
	
	public int updateLeaveTimeStat(String dclzNo);

	public int insertStartTime(String empNo);

	public List<Dclz> selectEmpCal(String empNo);

	//public List<String> selectAllCalTitles();

	public int selectDclzCount(@Param("empNo") String empNo, @Param("calTitle") String calTitle);

	public List<Dclz> selectDclzDept(String empNo);

	public String checkQRCode(String empNo);

	public void insertDraftToDclz(Approval approval);

	public int selectDrftToDclzRestCount(PaginationInfoVO<Drafting> pagingVORest);

	public List<Drafting> selectDrftToDclzRestList(PaginationInfoVO<Drafting> pagingVORest);

	public int selectDrftToDclzTripCount(PaginationInfoVO<Drafting> pagingVOTrip);

	public List<Drafting> selectDrftToDclzTripList(PaginationInfoVO<Drafting> pagingVOTrip);

}
