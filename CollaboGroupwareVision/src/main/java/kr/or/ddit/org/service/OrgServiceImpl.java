package kr.or.ddit.org.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.org.mapper.OrgMapper;
import kr.or.ddit.org.vo.Dept;

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
		return orgMapper.getOrgDetails(empNo);
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
		return orgMapper.getDeletedDeptData();
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
		return orgMapper.getDeletedEmpData();
	}

	@Override
	public List<Dept> getDeptList() {
		return orgMapper.getDeptList();
	}


}
