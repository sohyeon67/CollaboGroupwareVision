package kr.or.ddit.drafting.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.drafting.mapper.DraftingMapper;
import kr.or.ddit.drafting.vo.Approval;
import kr.or.ddit.drafting.vo.ApprovalBookmark;
import kr.or.ddit.drafting.vo.ApprovalBookmarkList;
import kr.or.ddit.drafting.vo.Drafting;
import kr.or.ddit.drafting.vo.DraftingAttach;
import kr.or.ddit.drafting.vo.DraftingForm;
import kr.or.ddit.util.PaginationInfoVO;

@Service
public class DraftingServiceImpl implements DraftingService{

	@Inject
	private DraftingMapper draftingMapper;

	@Override
	public List<Drafting> selectMainToSign(String empNo) {
		return draftingMapper.selectMainToSign(empNo);
	}

	@Override
	public List<Drafting> selectMainDrafting(String empNo) {
		return draftingMapper.selectMainDrafting(empNo);
	}
	
	
	@Override
	public List<DraftingForm> selectDraftingFormList() {
		return draftingMapper.selectDraftingFormList();
	}

	@Override
	public DraftingForm selectDraftingForm(int drftFormNo) {
		return draftingMapper.selectDraftingForm(drftFormNo);
	}

	@Override
	public String selectDraftingDayCount() {
		return draftingMapper.selectDraftingDayCount();
	}

	@Override
	@Transactional
	public ServiceResult insertDrafting(HttpServletRequest req, Drafting drafting) {
		ServiceResult result = null;
		
		int drftStatus = draftingMapper.insertDrafting(drafting);
		
		if(drftStatus > 0) {	// 기안 등록 성공
			// drafting에 담긴 결재자 정보 가져오기
			List<Approval> approvalList = drafting.getApprovalList();
			
			insertApproval(approvalList, drafting.getDrftNo()); //결재자 등록
			
			// drafting에 담긴 파일 정보 가져오기
			List<DraftingAttach> draftingAttachList = drafting.getDraftingAttachList();
			try {
				// 결재 파일 업로드 처리
				insertDraftingAttach(draftingAttachList, drafting.getDrftNo(), req);
			} catch (Exception e) {
				e.printStackTrace();
			}
			result = ServiceResult.OK;
		}else {	// 기안 등록 실패
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	@Transactional(rollbackFor = Exception.class)
	private void insertApproval(List<Approval> approvalList, String drftNo) {
		if(approvalList.size() > 0) {
			for(Approval approval : approvalList) { // approval <- approvalList
				approval.setDrftNo(drftNo);	// 기안번호 등록
				draftingMapper.insertApproval(approval);
			}
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	private void insertDraftingAttach(List<DraftingAttach> draftingAttachList, 
			String drftNo, HttpServletRequest req) throws IOException {
		
		if(draftingAttachList.size() > 0) {
			for(DraftingAttach draftingAttach : draftingAttachList) {	// draftingAttach <- draftingAttachList
				draftingAttach.setDrftNo(drftNo);	// 기안 번호 설정
				draftingMapper.insertDraftingAttach(draftingAttach);	// 기안 파일 데이터 추가
				
			}
		}
	}
	
	@Override
	public List<Drafting> selectToSign(PaginationInfoVO<Drafting> pagingVO) {
		return draftingMapper.selectToSign(pagingVO);
	}

	@Override
	public List<Drafting> selectWriting(PaginationInfoVO<Drafting> pagingVO) {
		return draftingMapper.selectWriting(pagingVO);
	}

	@Override
	public List<Drafting> selectToApproval(PaginationInfoVO<Drafting> pagingVO) {
		return draftingMapper.selectToApproval(pagingVO);
	}

	@Override
	public int toSignCount(PaginationInfoVO<Drafting> pagingVO) {
		return draftingMapper.toSignCount(pagingVO);
	}

	@Override
	public int writingCount(PaginationInfoVO<Drafting> pagingVO) {
		return draftingMapper.writingCount(pagingVO);
	}

	@Override
	public int toApprvCount(PaginationInfoVO<Drafting> pagingVO) {
		return draftingMapper.toApprvCount(pagingVO);
	}

	@Override
	public Map<String, Object> detailDrafting(String drftNo) {
		Drafting drafting = draftingMapper.detailDrafting(drftNo);
		List<Approval> approvalList = draftingMapper.detailApproval(drftNo);
		List<DraftingAttach> draftingAttachList = draftingMapper.detailDraftingAttach(drftNo);
		
		Map<String, Object> draftingMap = new HashMap<String, Object>();
		draftingMap.put("drafting", drafting);
		draftingMap.put("approvalList", approvalList);
		draftingMap.put("draftingAttachList", draftingAttachList);
		
		return draftingMap;
	}

	@Override
	public DraftingAttach draftingAttachDownload(int drftFileNo) {
		DraftingAttach draftingAttach = draftingMapper.draftingAttachDownload(drftFileNo);
		if(draftingAttach == null) {
			throw new RuntimeException();
		}
		
		draftingMapper.incrementDrftFileDowncount(drftFileNo);	// 다운로드 횟수 증가
		return draftingAttach;
	}

	@Override
	public List<Approval> signerNow() {
		return draftingMapper.signerNow();
	}

	@Override
	public ServiceResult acceptSign(Approval approval) {
		ServiceResult result = null;
		int status = draftingMapper.acceptSign(approval);
		if(status > 0) {	// 승인 완료
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult rejectSign(Approval approval) {
		ServiceResult result = null;
		int status = draftingMapper.rejectSign(approval);
		if(status > 0) {	// 반려 완료
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public void acceptDrafting(String drftNo) {
		draftingMapper.acceptDrafting(drftNo);

	}

	@Override
	public void rejectDrafting(String drftNo) {
		draftingMapper.rejectDrafting(drftNo);
	}

	@Override
	@Transactional
	public int insertBookmark(ApprovalBookmark bookmark) {
		
		int status = draftingMapper.insertBookmark(bookmark);
		int status2 = 0;
		int bookmarkNo = 0;
		if(status > 0) { // 즐겨찾기 등록 완료
			List<String> empNoList = bookmark.getEmpNoList();
			
			int apprvBookmarkNo = 0;
			apprvBookmarkNo = bookmark.getApprvBookmarkNo();
			
			if(apprvBookmarkNo != 0) {
				status2 = insertBookmarkList(empNoList, apprvBookmarkNo); // insertBookmark 메서드가 반환한 값
			}
		}
		if (status2 > 0) {
			bookmarkNo = bookmark.getApprvBookmarkNo();
		}
		
		return bookmarkNo;
	}

	@Transactional(rollbackFor = Exception.class)
	private int insertBookmarkList(List<String> empNoList, int apprvBookmarkNo) {
		int status = 0;
		if(empNoList.size() > 0) {
			for(int i=0; i<empNoList.size(); i++) {
				String empNo = empNoList.get(i);
				
				ApprovalBookmarkList bookmarkList = new ApprovalBookmarkList();
				bookmarkList.setApprvBookmarkOrder(i+1);
				bookmarkList.setApprvBookmarkNo(apprvBookmarkNo);
				bookmarkList.setEmpNo(empNo);
				
				status = draftingMapper.insertBookmarkList(bookmarkList);
			}
		}
		return status;
	}

	@Override
	public List<ApprovalBookmark> selectBookmark(String apprvBookmarkEmpNo) {
		return draftingMapper.selectBookmark(apprvBookmarkEmpNo);
	}

	@Override
	public List<ApprovalBookmarkList> selectBookmarkList(int apprvBookmarkNo) {
		return draftingMapper.selectBookmarkList(apprvBookmarkNo);
	}

	@Override
	public int deleteBookmark(int apprvBookmarkNo) {
		int status = draftingMapper.deleteBookmarkList(apprvBookmarkNo);
		int result = 0;
		if(status > 0) {
			result = draftingMapper.deleteBookmark(apprvBookmarkNo);
		}
		return result;
	}

	
}



































