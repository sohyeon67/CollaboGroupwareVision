package kr.or.ddit.drafting.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.ApprovalBookmark;
import kr.or.ddit.drafting.vo.ApprovalBookmarkList;
import kr.or.ddit.drafting.vo.Drafting;
import kr.or.ddit.drafting.vo.DraftingAttach;
import kr.or.ddit.drafting.vo.DraftingForm;
import kr.or.ddit.util.PaginationInfoVO;

public interface DraftingService {
	
	public List<Drafting> selectMainToSign(String empNo);
	
	public List<Drafting> selectMainDrafting(String empNo);

	public List<DraftingForm> selectDraftingFormList();
	
	public DraftingForm selectDraftingForm(int drftFormNo);
	
	public String selectDraftingDayCount();

	public ServiceResult insertDrafting(HttpServletRequest req, Drafting drafting);

	public List<Drafting> selectToSign(PaginationInfoVO<Drafting> pagingVO);

	public List<Drafting> selectWriting(PaginationInfoVO<Drafting> pagingVO);
	
	public List<Drafting> selectToApproval(PaginationInfoVO<Drafting> pagingVO);
	
	public int toSignCount(PaginationInfoVO<Drafting> pagingVO);
	
	public int writingCount(PaginationInfoVO<Drafting> pagingVO);
	
	public int toApprvCount(PaginationInfoVO<Drafting> pagingVO);
	
	public Map<String, Object> detailDrafting(String drftNo);

	public DraftingAttach draftingAttachDownload(int drftFileNo);

	public List<Approval> signerNow();
	
	public ServiceResult acceptSign(Approval approval);
	
	public ServiceResult rejectSign(Approval approval);
	
	public void acceptDrafting(String drftNo);
	
	public void rejectDrafting(String drftNo);

	public int insertBookmark(ApprovalBookmark bookmark);

	public List<ApprovalBookmark> selectBookmark(String apprvBookmarkEmpNo);

	public List<ApprovalBookmarkList> selectBookmarkList(int apprvBookmarkNo);

	public int deleteBookmark(int apprvBookmarkNo);
	
}
