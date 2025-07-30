package kr.or.ddit.account.mapper;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.account.vo.Employee;

public interface LoginMapper {

	public Employee readByUserId(String username);
	public int findByEmpNoAndPsnEmail(Employee employee);
	public void updatePassword(@Param("empNo") String empNo, @Param("empPw") String empPw);

}
