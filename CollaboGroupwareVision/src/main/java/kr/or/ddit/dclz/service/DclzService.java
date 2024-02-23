package kr.or.ddit.dclz.service;

import java.util.List;

import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.dclz.vo.PaginationInfoVO;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.Drafting;

public interface DclzService {

	public Dclz selectEmpTime(String empNo);

	public int updateLeaveTime(String dclzNo);

	public int insertStartTime(String empNo);

	public List<Dclz> selectEmpCal(String empNo);

	public int updateLeaveTimeStat(String dclzNo);

	//public List<String> selectAllCalTitles();

	public int selectDclzCount(String empNo, String calTitle);

	public List<Dclz> selectDclzDept(String empNo);

	public String checkQRCode(String empNo);

	public void insertDraftToDclz(Approval approval);

	public int selectDrftToDclzRestCount(PaginationInfoVO<Drafting> pagingVORest);

	public List<Drafting> selectDrftToDclzRestList(PaginationInfoVO<Drafting> pagingVORest);

	public int selectDrftToDclzTripCount(PaginationInfoVO<Drafting> pagingVOTrip);

	public List<Drafting> selectDrftToDclzTripList(PaginationInfoVO<Drafting> pagingVOTrip);

}
