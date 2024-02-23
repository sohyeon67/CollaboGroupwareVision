package kr.or.ddit.community.mapper;

import java.util.List;


import kr.or.ddit.community.vo.Cmny;
import kr.or.ddit.community.vo.CmnyMem;
import kr.or.ddit.util.PaginationInfoVO;

public interface CmnyMapper {

	public int selectCmnyCount(PaginationInfoVO<Cmny> pagingVO);

	public List<Cmny> selectCmnyList(PaginationInfoVO<Cmny> pagingVO);

	public void comInsert(Cmny cmny);

	public void comInsertMem(CmnyMem cmnyMem);

	public Cmny getCommunityDetail(int cmnyNo);

	public List<Cmny> getMyCommunityList(String empNo);

	public List<CmnyMem> selectCmnyMemList(int cmnyNo);

	public void comSubmitMem(CmnyMem cmnyMem);

	public void withdrawMem(CmnyMem cmnyMem);

	public int cmnycloseMemCnt(int cmnyNo);

	public void updateCmnyStatus(int cmnyNo);

	public String getCmnyTopEmpNo(int cmnyNo);






}
