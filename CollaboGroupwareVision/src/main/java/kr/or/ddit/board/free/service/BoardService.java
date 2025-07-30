package kr.or.ddit.board.free.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.board.vo.Reply;


public interface BoardService {

	public List<Board> list(PaginationInfo<Board> pagingVO);
	public int listCount(PaginationInfo<Board> pagingVO);
	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap);
	
	public int insert(Board board, HttpServletRequest req);
	public Board detail(int boardNo);
	public int update(Board board);
	public int update2(int boardNo);
	
	
	public int delete(int boardNo);
	
	
	public int insert2(BoardAttach boardAttach);
	public BoardAttach getBoardAttach(int boardNo);
	public List<BoardAttach> detail2(int boardNo);
	
	public int replyInsert(Reply reply);
	
	public int updateBoardAttach(Board board);
	// 게시글과 첨부 파일 정보를 함께 수정하는 트랜잭션 메서드
    @Transactional
    int updateBoardAttach(Board board, BoardAttach boardAttach);

	public BoardAttach selectFileInfo(int fileNo);

	public String getEmpNo(int boardNo);

	public ServiceResult update(HttpServletRequest req, Board board) throws Exception;

	public int replyDelete(int replyNo);
    
	
	
	
	
	
	

}
