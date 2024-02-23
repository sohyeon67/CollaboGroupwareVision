package kr.or.ddit.account.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;

public interface AccountService {

	public ServiceResult register(HttpServletRequest req, Employee employee);
	public List<Map<String, Object>> getCommonCodeList();
	public List<Employee> getEmpList();
	public ServiceResult empDisable(List<String> empNoList);
	public Employee getEmpDetails(String empNo);
	public ServiceResult update(HttpServletRequest req, Employee employee);
	public Employee getMyProfile(String myEmpNo);

}
