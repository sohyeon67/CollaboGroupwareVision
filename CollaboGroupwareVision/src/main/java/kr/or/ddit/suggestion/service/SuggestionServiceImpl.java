package kr.or.ddit.suggestion.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.board.controller.FileUploadUtils;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.suggestion.mapper.suggestionMapper;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SuggestionServiceImpl implements SuggestionService{
	
	@Inject
	private suggestionMapper mapper;

	//관리자는 모든 목록 확인 가능
	@Override
	public List<Board> suggestionlist(PaginationInfo<Board> pagingVO) {
		return mapper.suggestionlist(pagingVO);
	}

	@Override
	public int insert(Board board, HttpServletRequest req) {
		log.info("BoardServiceImpl insert() 실행...!");
		int status = mapper.insert(board);
		if(status > 0) {	// 게시글 등록이 성공햇을 때
			List<BoardAttach> boardAttachList = board.getBoardAttachList();			
			log.debug("체킁 1: {}",boardAttachList);
			
		/*	 try {
				 //공지사항 파일 업로드
				boardFileUpload(boardAttachList, board.getBoardNo(), req);
			} catch (IOException e) {
				e.printStackTrace();
			}*/
		}
		
		return status;
	}
	@Override
	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap) {
		return mapper.list(paramMap);
	}

	@Override
	public int listCount(PaginationInfo<Board> pagingVO) {
		return mapper.listCount(pagingVO);
	}

	@Override
	public List<Board> list(PaginationInfo<Board> pagingVO) {
		return mapper.list(pagingVO);
	}

	@Override
	public Board suggestiondetail(int boardNo) {
		log.info("SuggestionServiceImpl detail() 실행...!");
		return mapper.suggestiondetail(boardNo);
	}

	@Override
	public List<BoardAttach> detail2(int boardNo) {
		log.info("SuggestionServiceImpl detail2() 실행...!");
		return mapper.suggestiondetail2(boardNo);
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
	public String getEmpNo(int boardNo) {
		return mapper.getEmpNo(boardNo);
		}

	@Override
	public int suggestiondelete(int boardNo) {
		log.info("BoardServiceImpl delete() 실행...!");
		return mapper.suggestiondelete(boardNo);
	}
	
	@Override
	public int getBoardNo() {
		log.info("BoardServiceImpl delete() 실행...!");
		return mapper.getBoardNo();
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
	
	
	
}
