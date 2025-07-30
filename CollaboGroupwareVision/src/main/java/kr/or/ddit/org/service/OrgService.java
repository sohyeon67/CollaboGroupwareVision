package kr.or.ddit.org.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.vo.Dept;

public interface OrgService {

	public List<Map<String, Object>> getOrgTree();
	public Employee getOrgDetails(String empNo);
	public ServiceResult createDept(Dept dept);
	public ServiceResult softDeleteDept(int deptCode);
	public Dept getDeptInfo(int deptCode);
	public ServiceResult updateDeptName(Dept dept);
	public ServiceResult transferDept(Map<String, Object> params);
	public List<Dept> getDeletedDeptData();
	public ServiceResult hardDeleteDept(List<Integer> deptCodes);
	public ServiceResult recoveryDept(List<Integer> deptCodes);
	public List<Map<String, Object>> getDeletedEmpData();
	public List<Dept> getDeptList();

}
