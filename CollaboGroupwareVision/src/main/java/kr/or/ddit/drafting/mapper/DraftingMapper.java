package kr.or.ddit.drafting.mapper;

import java.util.List;

import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.ApprovalBookmark;
import kr.or.ddit.drafting.vo.ApprovalBookmarkList;
import kr.or.ddit.drafting.vo.Drafting;
import kr.or.ddit.drafting.vo.DraftingAttach;
import kr.or.ddit.drafting.vo.DraftingForm;
import kr.or.ddit.util.PaginationInfoVO;

public interface DraftingMapper {
	
	public List<Drafting> selectMainToSign(String empNo);
	
	public List<Drafting> selectMainDrafting(String empNo);

	public List<DraftingForm> selectDraftingFormList();
	
	public DraftingForm selectDraftingForm(int drftFormNo);
	
	public String selectDraftingDayCount();

	public void insertDraftingAttach(DraftingAttach draftingAttach);

	public int insertDrafting(Drafting drafting);

	public int insertApproval(Approval approval);

	public List<Drafting> selectToSign(PaginationInfoVO<Drafting> pagingVO);

	public List<Drafting> selectWriting(PaginationInfoVO<Drafting> pagingVO);
	
	public List<Drafting> selectToApproval(PaginationInfoVO<Drafting> pagingVO);
	
	public int toSignCount(PaginationInfoVO<Drafting> pagingVO);
	
	public int writingCount(PaginationInfoVO<Drafting> pagingVO);
	
	public int toApprvCount(PaginationInfoVO<Drafting> pagingVO);
	
	public Drafting detailDrafting(String drftNo);
	
	public List<Approval> detailApproval(String drftNo);
	
	public List<DraftingAttach> detailDraftingAttach(String drftNo);

	public void incrementDrftFileDowncount(int drftFileNo);

	public DraftingAttach draftingAttachDownload(int drftFileNo);
	
	public List<Approval> signerNow();
	
	public int acceptSign(Approval approval);
	
	public int rejectSign(Approval approval);
	
	public void acceptDrafting(String drftNo);
	
	public void rejectDrafting(String drftNo);

	public int insertBookmark(ApprovalBookmark bookmark);

	public int insertBookmarkList(ApprovalBookmarkList bookmarkList);

	public List<ApprovalBookmark> selectBookmark(String apprvBookmarkEmpNo);

	public List<ApprovalBookmarkList> selectBookmarkList(int apprvBookmarkNo);

	public int deleteBookmarkList(int apprvBookmarkNo);

	public int deleteBookmark(int apprvBookmarkNo);
	
	
	
}
