package kr.or.ddit.org.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.mapper.OrgMapper;
import kr.or.ddit.org.vo.Dept;
import kr.or.ddit.util.FormatUtils;

@Service
public class OrgServiceImpl implements OrgService {

	@Inject
	private OrgMapper orgMapper;
	
	@Override
	public List<Map<String, Object>> getOrgTree() {
		return orgMapper.getOrgTree();
	}

	@Override
	public Employee getOrgDetails(String empNo) {
		Employee emp = orgMapper.getOrgDetails(empNo);
		
	    String formattedPhone = FormatUtils.formatPhone(emp.getEmpTel());
	    emp.setEmpTel(formattedPhone);

	    String formattedExt = FormatUtils.formatPhone(emp.getExtNo());
	    emp.setExtNo(formattedExt);

	    String formattedJoinDay = FormatUtils.formatDate(emp.getJoinDay());
	    emp.setJoinDay(formattedJoinDay);
		
		return emp;
	}

	@Override
	public ServiceResult createDept(Dept dept) {
		ServiceResult result = null;
		
		int status = orgMapper.createDept(dept);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult softDeleteDept(int deptCode) {
		ServiceResult result = null;
		
		int status = orgMapper.softDeleteDept(deptCode);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public Dept getDeptInfo(int deptCode) {
		return orgMapper.getDeptInfo(deptCode);
	}

	@Override
	public ServiceResult updateDeptName(Dept dept) {
		ServiceResult result = null;
		
		int status = orgMapper.updateDeptName(dept);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult transferDept(Map<String, Object> params) {
		ServiceResult result = null;
		
		int status = orgMapper.transferDept(params);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public List<Dept> getDeletedDeptData() {
		List<Dept> deletedDeptList = orgMapper.getDeletedDeptData();
		
		for (Dept deleted : deletedDeptList) {
			String formattedRegDay = FormatUtils.formatDate(deleted.getDeptRegDay());
			String formattedDelDay = FormatUtils.formatDate(deleted.getDeptDelDay());
			deleted.setDeptRegDay(formattedRegDay);
			deleted.setDeptDelDay(formattedDelDay);
		}
		
		return deletedDeptList;
	}

	@Override
	public ServiceResult hardDeleteDept(List<Integer> deptCodes) {
		ServiceResult result = null;
		
		int status = orgMapper.hardDeleteDept(deptCodes);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult recoveryDept(List<Integer> deptCodes) {
		ServiceResult result = null;
		
		int status = orgMapper.recoveryDept(deptCodes);
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> getDeletedEmpData() {
		List<Map<String, Object>> deletedEmpList = orgMapper.getDeletedEmpData();
		
		for (Map<String, Object> emp : deletedEmpList) {
			String tel = (String) emp.get("EMP_TEL");
			emp.put("EMP_TEL", FormatUtils.formatPhone(tel));
			
			String delDay = (String) emp.get("EMP_DEL_DAY");
			emp.put("EMP_DEL_DAY", FormatUtils.formatDate(delDay));
		}
		
		return deletedEmpList;
	}

	@Override
	public List<Dept> getDeptList() {
		return orgMapper.getDeptList();
	}


}
