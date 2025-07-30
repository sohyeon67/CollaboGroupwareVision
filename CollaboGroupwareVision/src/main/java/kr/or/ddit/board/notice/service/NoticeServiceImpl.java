package kr.or.ddit.board.notice.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.board.controller.FileUploadUtils;
import kr.or.ddit.board.free.mapper.BoardMapper;
import kr.or.ddit.board.notice.mapper.NoticeMapper;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NoticeServiceImpl implements NoticeService {

	@Inject
	private NoticeMapper mapper;
	
//	@Inject
//	private BoardMapper boardMapper;
	
	@Override
	public int noticeListCount(PaginationInfo<Board> pagingVO) {
		return mapper.noticeListCount(pagingVO);
	}
	
	@Override
	public List<Board> noticeList(PaginationInfo<Board> pagingVO) {
		return mapper.noticeList(pagingVO);
	}
	
	@Override
	public List<BoardAttach> noticeSelectAttachList(Map<String, Object> paramMap) {
		return mapper.noticeSelectAttachList(paramMap);
	}

	@Override
	public int noticeInsert(Board board, HttpServletRequest req) {
		log.info("BoardServiceImpl insert() 실행...!");
		int status = mapper.noticeInsert(board);
		if(status > 0) {	// 게시글 등록이 성공햇을 때
			List<BoardAttach> boardAttachList = board.getBoardAttachList();			
			log.debug("체킁 1: {}",boardAttachList);
			
			 try {
				 //공지사항 파일 업로드
				boardFileUpload(boardAttachList, board.getBoardNo(), req);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		return status;
	}
	
	private void boardFileUpload(List<BoardAttach> boardAttachList, int boardNo, HttpServletRequest req) throws IOException {
		log.info("BoardServiceImpl boardFileUpload() 실행...!");
		String savePath = "/resources/notice/" + boardNo;
		
		String saveUploadPath = req.getServletContext().getRealPath(savePath);
		String saveLocate = "";	// 최종적으로 저장하게될 경로 
		
		log.debug("체킁 2: {}",boardAttachList);
		
		File saveUploadFolder = new File(saveUploadPath);
		if(!saveUploadFolder.exists()) {
			saveUploadFolder.mkdirs();
		}
		
		if(boardAttachList != null) {	//넘겨받은 파일 데이터가 존재할 때
			if(boardAttachList.size() > 0) {
				for(BoardAttach boardAttach : boardAttachList) {
					String saveName = UUID.randomUUID().toString();	// UUID의 랜덤 파일명 생성
					
					// 파일명을 설정할 때, 원본 파일명의 공백을 "_"로 변경한다.
					saveName = saveName + "_" + boardAttach.getFileName().replaceAll(" ", "_");
					// 디버깅 및 확장자 추출 참고
					String endFilename = boardAttach.getFileName().split("\\.")[1];	

					saveLocate = saveUploadPath + "/" + saveName;

					boardAttach.setBoardNo(boardNo);// 게시글 번호 설정
					boardAttach.setFileSavepath(saveLocate);	// 파일 업로드 경로 설정
					mapper.noticeInsert2(boardAttach);	// 게시글 파일 데이터 추가
					
					
					log.debug("요긴강:" + saveLocate);
					
					// 방법 1
					File saveFile = new File(saveLocate);
//					InputStream is = noticeFileVO.getItem().getInputStream();
//					FileUtils.copyInputStreamToFile(is, saveFile);
					
					log.debug("요긴강2:" + saveFile);
					// 방법2
					boardAttach.getItem().transferTo(saveFile); 	// 파일 복사
				}
			}
		}
	}

	@Override
	public Board noticeDetail(int boardNo) {
		return mapper.noticeDetail(boardNo);
	}

	@Override
	public List<BoardAttach> noticeDetail2(int boardNo) {
		return mapper.noticeDetail2(boardNo);
	}

	@Override
	public int noticeDelete(int boardNo) {
		return mapper.noticeDelete(boardNo);
	}

	@Override
	public ServiceResult noticeUpdate(HttpServletRequest req, Board board) throws Exception {
		ServiceResult result = null;
		log.info("BoardServiceImpl update() 실행...!");
		// 일반적인 데이터로 수정
		int status = mapper.noticeUpdate(board);
		if(status > 0) {	// 일반데이터 수정 완료
			// 새롭게 추가될 (수정하겠다고 넘긴 새로운 파일) 파일을 등록
			List<BoardAttach> boardAttachList = board.getBoardAttachList();
			FileUploadUtils.noticeBoardFileUpload(boardAttachList, board.getBoardNo(), req, mapper);

			// delete버튼을 눌러서 삭제하겠다고 넘겨준 파일 넘버를 이용해서 삭제를 진행
			Integer[] delBoardNo = board.getDelBoardNo();
		 	if(delBoardNo != null) {
		 		// 넘겨받은 배열 형태의 boardNo 집합 데이터를 삭제 처리하기 위해 전달
		 		mapper.noticeDeleteBoardFileList(delBoardNo);	// 파일 번호에 해당하는 파일 데이터를 삭제
		 	}
			result = ServiceResult.OK;
		}else {	// 일반데이터 수정 실패
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	@Transactional
	public int noticeUpdateBoardAttach(Board board, BoardAttach boardAttach) {
	    try {
	        // 게시글 정보 업데이트
	        int updatedBoard = mapper.noticeUpdate(board);

	        // 첨부 파일 정보 업데이트
	        int updatedBoardAttach = mapper.noticeUpdateBoardAttach(boardAttach);

	        return updatedBoard + updatedBoardAttach; // 성공하면 2, 실패하면 0
	    } catch (Exception e) {
	        // 예외 발생 시 롤백
	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        throw e;
	    }
	}

	@Override
	public int noticeUpdate2(int boardNo) {
		return mapper.noticeUpdate2(boardNo);
	}

	@Override
	public BoardAttach selectFileInfo(Integer fileId) {
		return mapper.selectFileInfo(fileId);
	}

	@Override
	public int noticeUpdate(Board board) {
		return mapper.noticeUpdate(board);
	}

	@Override
	public int updateBoardAttach(Board board) {
		return mapper.noticeUpdateBoardAttach(board);
	}

	@Override
	public List<Board> noticeListMain() {
		return mapper.noticeListMain();
	}








	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}
