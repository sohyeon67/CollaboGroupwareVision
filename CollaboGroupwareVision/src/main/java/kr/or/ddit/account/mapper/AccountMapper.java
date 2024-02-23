package kr.or.ddit.account.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.account.vo.Auth;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.vo.Dept;

public interface AccountMapper {

	public int register(Employee employee);
	public List<Map<String, Object>> getCommonCodeList();
	public void insertAuth(Auth userRole);
	public List<Employee> getEmpList();
	public int empDisable(List<String> empNoList);
	public int update(Employee employee);
	public void deleteAuth(String empNo);
	public Employee getMyProfile(String myEmpNo);

}
