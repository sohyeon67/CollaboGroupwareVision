package kr.or.ddit.statistics.service;

import java.util.List;

import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.org.vo.Dept;

public interface StatisticService {
	public int selectAllDclzCount(String calTitle);
	public List<Integer> selectDclzYear();
	public int someDclzStatusCount(String someday, String calTitle);
	public List<Dclz> selectEmpDclzListByDay(String day);
	public List<Dept> selectAllDept();
	public List<Dclz> selectDeptDclzList(int deptCode, String calTitle, String someday);
	public List<Dclz> selectAllDeptDclzList(int deptCode, String someday);
	public List<Approval> selectApprovalList(String someday);
	public List<Integer> selectApprvYear();
	public List<Approval> selectEmpDraftList(String startDate, String endDate, Integer deptCode);
	public List<String> selectRejectReasonList();
}
