package kr.or.ddit.account.service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;

public interface LoginService {

	public ServiceResult findPassword(Employee employee);

}
