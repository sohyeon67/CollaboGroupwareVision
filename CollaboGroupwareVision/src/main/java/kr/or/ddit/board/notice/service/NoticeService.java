package kr.or.ddit.board.notice.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;

public interface NoticeService {

	public List<Board> noticeList(PaginationInfo<Board> pagingVO);

	public int noticeInsert(Board board, HttpServletRequest req);
	public Board noticeDetail(int boardNo);
	public int noticeUpdate(Board board);


	public int noticeDelete(int boardNo);

	public int noticeListCount(PaginationInfo<Board> pagingVO);

	public List<BoardAttach> noticeSelectAttachList(Map<String, Object> paramMap); 
	public List<BoardAttach> noticeDetail2(int boardNo);
	
	public int updateBoardAttach(Board board);
	@Transactional
	public int noticeUpdateBoardAttach(Board board, BoardAttach boardAttach);

	public int noticeUpdate2(int boardNo);

	public BoardAttach selectFileInfo(Integer fileId);

	public ServiceResult noticeUpdate(HttpServletRequest req, Board board) throws Exception;

	public List<Board> noticeListMain();










}
