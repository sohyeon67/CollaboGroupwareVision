package kr.or.ddit.crtf.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.crtf.mapper.CrtfMapper;
import kr.or.ddit.crtf.vo.CrtfEmp;
import kr.or.ddit.crtf.vo.CrtfPay;
import kr.or.ddit.util.PaginationInfoVO;

@Service
public class CrtfServiceImpl implements CrtfService {
	
	@Inject
	private CrtfMapper crtfMapper;

	@Override
	public int selectPayCount(PaginationInfoVO<CrtfPay> pagingVO) {
		return crtfMapper.selectPayCount(pagingVO);
	}

	@Override
	public List<CrtfPay> selectPayList(PaginationInfoVO<CrtfPay> pagingVO) {
		return crtfMapper.selectPayList(pagingVO);
	}

	@Override
	public List<CrtfPay> selectCrtfPay(String empNo) {		
		return crtfMapper.selectCrtfPay(empNo);
	}

	@Override
	public int selectEmpCount(PaginationInfoVO<CrtfEmp> pagingVO) {
		return crtfMapper.selectEmpCount(pagingVO);
	}

	@Override
	public List<CrtfEmp> selectEmpList(PaginationInfoVO<CrtfEmp> pagingVO) {
		return crtfMapper.selectEmpList(pagingVO);
	}

	@Override
	public ServiceResult insertCrtfEmp(CrtfEmp crtfemp) {
		ServiceResult result = null;
		
		int status = crtfMapper.insertCrtfEmp(crtfemp);
		
		if(status > 0) { //insert 성공
			result = ServiceResult.OK;
		}else { //등록 실패
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public List<CrtfEmp> selectCrtfEmp(String empNo) {		
		return crtfMapper.selectCrtfEmp(empNo);
	}
	

}
