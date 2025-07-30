package kr.or.ddit.crtf.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.crtf.vo.CrtfEmp;
import kr.or.ddit.crtf.vo.CrtfPay;
import kr.or.ddit.util.PaginationInfoVO;

public interface CrtfService {

	public int selectPayCount(PaginationInfoVO<CrtfPay> pagingVO);

	public List<CrtfPay> selectPayList(PaginationInfoVO<CrtfPay> pagingVO);

	public List<CrtfPay> selectCrtfPay(String empNo);

	public int selectEmpCount(PaginationInfoVO<CrtfEmp> pagingVO);

	public List<CrtfEmp> selectEmpList(PaginationInfoVO<CrtfEmp> pagingVO);

	public ServiceResult insertCrtfEmp(CrtfEmp crtfemp);

	public List<CrtfEmp> selectCrtfEmp(String empNo);


}
