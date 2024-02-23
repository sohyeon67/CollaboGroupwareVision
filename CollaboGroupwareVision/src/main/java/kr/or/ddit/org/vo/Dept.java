package kr.or.ddit.org.vo;

import java.util.List;

import kr.or.ddit.account.vo.Employee;
import lombok.Data;

@Data
public class Dept {
	private int deptCode;
	private String deptName;
	private String deptRegDay;
	private String deptDelDay;
	
	private List<Employee> deptMemList;
}
