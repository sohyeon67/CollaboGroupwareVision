package kr.or.ddit.suggestion.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;

public interface SuggestionService {

	//관리자는 모든 목록 확인 가능
	public List<Board> suggestionlist(PaginationInfo<Board> pagingVO);

	public int insert(Board board, HttpServletRequest req);

	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap);

	public int listCount(PaginationInfo<Board> pagingVO);

	public List<Board> list(PaginationInfo<Board> pagingVO);

	public Board suggestiondetail(int boardNo);

	public List<BoardAttach> detail2(int boardNo);

	public int updateBoardAttach(Board board, BoardAttach boardAttach);

	public String getEmpNo(int boardNo);

	public int suggestiondelete(int boardNo);

	public ServiceResult update(HttpServletRequest req, Board board) throws Exception;
	
	public int getBoardNo();

	
}
