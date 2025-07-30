package kr.or.ddit.statistics.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.org.vo.Dept;

@Mapper
public interface StatisticMapper {
	public int selectAllDclzCount(String calTitle);
	public List<Integer> selectDclzYear();
	public int someDclzStatusCount(@Param("someday") String someday,@Param("calTitle") String calTitle);
	public List<Dclz> selectEmpDclzListByDay(String day);
	public List<Dept> selectAllDept();
	public List<Dclz> selectDeptDclzList(@Param("deptCode") int deptCode,@Param("calTitle") String calTitle,@Param("someday") String someday);
	public List<Dclz> selectAllDeptDclzList(@Param("deptCode")int deptCode,@Param("someday") String someday);
	public List<Approval> selectApprovalList(String someday);
	public List<Integer> selectApprvYear();
	public List<Approval> selectEmpDraftList(@Param("startDate") String startDate,@Param("endDate") String endDate,@Param("deptCode") Integer deptCode);
	public List<String> selectRejectReasonList();
}
