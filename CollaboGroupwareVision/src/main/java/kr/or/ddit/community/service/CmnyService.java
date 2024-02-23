package kr.or.ddit.community.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.community.vo.Cmny;
import kr.or.ddit.community.vo.CmnyMem;
import kr.or.ddit.util.PaginationInfoVO;

public interface CmnyService {

	public int selectCmnyCount(PaginationInfoVO<Cmny> pagingVO);

	public List<Cmny> selectCmnyList(PaginationInfoVO<Cmny> pagingVO);

	public void comInsert(HttpServletRequest req, Cmny cmny);

	public Cmny getCommunityDetail(int cmnyNo);

	public List<Cmny> getMyCommunityList(String empNo);

	public List<CmnyMem> selectCmnyMemList(int cmnyNo);

	public void comSubmitMem(CmnyMem cmnyMem);

	public void withdrawMem(CmnyMem cmnyMem);

	public int cmnycloseMemCnt(int cmnyNo);

	public void updateCmnyStatus(int cmnyNo);





}
