package kr.or.ddit.dclz.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.dclz.mapper.DclzMapper;
import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.dclz.vo.PaginationInfoVO;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.Drafting;

@Service
public class DclzServiceImpl implements DclzService {
	
	@Inject
	private DclzMapper dclzMapper;

	@Override
	public Dclz selectEmpTime(String empNo) {
		return dclzMapper.selectEmpTime(empNo);
	}

	@Override
	public int updateLeaveTime(String dclzNo) {		
		return dclzMapper.updateLeaveTime(dclzNo);
	}
	
	@Override
	public int updateLeaveTimeStat(String dclzNo) {		
		return dclzMapper.updateLeaveTimeStat(dclzNo);
	}

	@Override
	public int insertStartTime(String empNo) {
		return dclzMapper.insertStartTime(empNo);
	}

	@Override
	public List<Dclz> selectEmpCal(String empNo) {
		return dclzMapper.selectEmpCal(empNo);
	}

//	@Override
//	public List<String> selectAllCalTitles() {
//		return dclzMapper.selectAllCalTitles();
//	}

	@Override
	public int selectDclzCount(String empNo, String calTitle) {
		return dclzMapper.selectDclzCount(empNo, calTitle);
	}

	@Override
	public List<Dclz> selectDclzDept(String empNo) {
		return dclzMapper.selectDclzDept(empNo);
	}

	@Override
	public String checkQRCode(String empNo) {
		return dclzMapper.checkQRCode(empNo);
	}

	@Override
	public void insertDraftToDclz(Approval approval) {
		dclzMapper.insertDraftToDclz(approval);
		
	}

	@Override
	public int selectDrftToDclzRestCount(PaginationInfoVO<Drafting> pagingVORest) {
		return dclzMapper.selectDrftToDclzRestCount(pagingVORest);
	}

	@Override
	public List<Drafting> selectDrftToDclzRestList(PaginationInfoVO<Drafting> pagingVORest) {
		return dclzMapper.selectDrftToDclzRestList(pagingVORest);
	}

	@Override
	public int selectDrftToDclzTripCount(PaginationInfoVO<Drafting> pagingVOTrip) {
		return dclzMapper.selectDrftToDclzTripCount(pagingVOTrip);
	}

	@Override
	public List<Drafting> selectDrftToDclzTripList(PaginationInfoVO<Drafting> pagingVOTrip) {
		return dclzMapper.selectDrftToDclzTripList(pagingVOTrip);
	}

}
