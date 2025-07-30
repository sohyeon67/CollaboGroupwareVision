package kr.or.ddit.org.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.vo.Dept;

public interface OrgMapper {

	public List<Map<String, Object>> getOrgTree();
	public Employee getOrgDetails(String empNo);
	public int createDept(Dept dept);
	public int softDeleteDept(int deptCode);
	public Dept getDeptInfo(int deptCode);
	public int updateDeptName(Dept dept);
	public int transferDept(Map<String, Object> params);
	public List<Dept> getDeletedDeptData();
	public int hardDeleteDept(List<Integer> deptCodes);
	public int recoveryDept(List<Integer> deptCodes);
	public List<Map<String, Object>> getDeletedEmpData();
	public List<Dept> getDeptList();

}
