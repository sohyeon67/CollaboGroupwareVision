package kr.or.ddit.statistics.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.org.vo.Dept;
import kr.or.ddit.statistics.mapper.StatisticMapper;

@Service
public class StatisticServiceImpl implements StatisticService {

	@Inject
	private StatisticMapper statisticMapper;
	
	@Override
	public int selectAllDclzCount(String calTitle) {
		return statisticMapper.selectAllDclzCount(calTitle);
	}

	@Override
	public List<Integer> selectDclzYear() {
		return statisticMapper.selectDclzYear();
	}

	@Override
	public int someDclzStatusCount(String someday, String calTitle) {
		return statisticMapper.someDclzStatusCount(someday,calTitle);
	}

	@Override
	public List<Dclz> selectEmpDclzListByDay(String day) {
		return statisticMapper.selectEmpDclzListByDay(day);
	}

	@Override
	public List<Dept> selectAllDept() {
		return statisticMapper.selectAllDept();
	}

	@Override
	public List<Dclz> selectDeptDclzList(int deptCode, String calTitle, String someday) {
		return statisticMapper.selectDeptDclzList(deptCode, calTitle, someday);
	}

	@Override
	public List<Dclz> selectAllDeptDclzList(int deptCode, String someday) {
		return statisticMapper.selectAllDeptDclzList(deptCode, someday);
	}

	@Override
	public List<Approval> selectApprovalList(String someday) {
		return statisticMapper.selectApprovalList(someday);
	}

	@Override
	public List<Integer> selectApprvYear() {
		return statisticMapper.selectApprvYear();
	}

	@Override
	public List<Approval> selectEmpDraftList(String startDate, String endDate, Integer deptCode) {
		return statisticMapper.selectEmpDraftList(startDate,endDate,deptCode);
	}

	@Override
	public List<String> selectRejectReasonList() {
		return statisticMapper.selectRejectReasonList();
	}

}
