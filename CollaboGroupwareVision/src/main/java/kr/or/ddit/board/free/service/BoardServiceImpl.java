package kr.or.ddit.board.free.service;

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
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.board.vo.Reply;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class BoardServiceImpl implements BoardService {

	@Inject
	private BoardMapper mapper;

	@Override
	public List<Board> list(PaginationInfo<Board> pagingVO) {
		return mapper.list(pagingVO);
	}
	
	@Override
	public int listCount(PaginationInfo<Board> pagingVO) {
		log.info("BoardServiceImpl listCount() 실행...!");
		return mapper.listCount(pagingVO);
	}
	
	@Override
	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap) {
		return mapper.selectAttachList(paramMap);
	}

	@Override
	public int insert(Board board, HttpServletRequest req) {
		log.info("BoardServiceImpl insert() 실행...!");
		int status = mapper.insert(board);
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
		String savePath = "/resources/free/" + boardNo;
		
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
					mapper.insert2(boardAttach);	// 게시글 파일 데이터 추가
					
					
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
	public Board detail(int boardNo) {
		log.info("BoardServiceImpl detail() 실행...!");
		return mapper.detail(boardNo);
	}

	@Override
	public ServiceResult update(HttpServletRequest req, Board board) throws Exception {
		ServiceResult result = null;
		log.info("BoardServiceImpl update() 실행...!");
		// 일반적인 데이터로 수정
		int status = mapper.update(board);
		if(status > 0) {	// 일반데이터 수정 완료
			// 새롭게 추가될 (수정하겠다고 넘긴 새로운 파일) 파일을 등록
			List<BoardAttach> boardAttachList = board.getBoardAttachList();
			FileUploadUtils.boardFileUpload(boardAttachList, board.getBoardNo(), req, mapper);

			// delete버튼을 눌러서 삭제하겠다고 넘겨준 파일 넘버를 이용해서 삭제를 진행
			Integer[] delBoardNo = board.getDelBoardNo();
		 	if(delBoardNo != null) {
		 		// 넘겨받은 배열 형태의 boardNo 집합 데이터를 삭제 처리하기 위해 전달
		 		mapper.deleteBoardFileList(delBoardNo);	// 파일 번호에 해당하는 파일 데이터를 삭제
		 	}
			result = ServiceResult.OK;
		}else {	// 일반데이터 수정 실패
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	@Override
	@Transactional
	public int updateBoardAttach(Board board, BoardAttach boardAttach) {
	    try {
	        // 게시글 정보 업데이트
	        int updatedBoard = mapper.update(board);

	        // 첨부 파일 정보 업데이트
	        int updatedBoardAttach = mapper.updateBoardAttach(boardAttach);

	        return updatedBoard + updatedBoardAttach; // 성공하면 2, 실패하면 0
	    } catch (Exception e) {
	        // 예외 발생 시 롤백
	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        throw e;
	    }
	}

	@Override
	public int updateBoardAttach(Board board) {
		return mapper.updateBoardAttach(board);
	}

	@Override
	public int update(Board board) {
		return mapper.update(board);
	}
	
	@Override
	public int update2(int boardNo) {
		log.info("BoardServiceImpl update2() 실행...!");
		return mapper.update2(boardNo);
	}

	@Override
	public int delete(int boardNo) {
		log.info("BoardServiceImpl delete() 실행...!");
		return mapper.delete(boardNo);
	}

	@Override
	public int insert2(BoardAttach boardAttach) {
		log.info("BoardServiceImpl insert2() 실행...!");
		return mapper.insert2(boardAttach);
	}
	
	@Transactional
	public void insertBoardWithFile(Board board, BoardAttach boardAttach) {
		log.info("BoardServiceImpl insertBoardWithFile() 실행...!");
	    // 부모 테이블에 데이터 삽입
	    int status = mapper.insert(board);
	    log.info("board:"+board);
	    if(status > 0) {
	    	// 부모 테이블의 BOARD_NO 값을 자식 테이블에 설정
	    	boardAttach.setBoardNo(board.getBoardNo());
	    	
	    	// 자식 테이블에 데이터 삽입
	    	mapper.insert2(boardAttach);
	    }
	    
	}

	@Override
	public List<BoardAttach> detail2(int boardNo) {
		log.info("BoardServiceImpl detail2() 실행...!");
		return mapper.detail2(boardNo);
	}

	@Override
	public BoardAttach getBoardAttach(int boardNo) {
		log.info("BoardServiceImpl getBoardAttach() 실행...!");
		return null;
	}
	
	

	@Override
	public int replyInsert(Reply reply) {
		return mapper.replyInsert(reply);
	}
	

	@Override
	public BoardAttach selectFileInfo(int fileNo) {
		return mapper.selectFileInfo(fileNo);
	}

	@Override
	public String getEmpNo(int boardNo) {
		return mapper.getEmpNo(boardNo);
	}

	@Override
	public int replyDelete(int replyNo) {
		return mapper.replyDelete(replyNo);
	}

}
