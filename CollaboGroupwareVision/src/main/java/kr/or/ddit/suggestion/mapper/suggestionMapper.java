package kr.or.ddit.suggestion.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;

public interface suggestionMapper {

	//관리자는 모든 목록 확인 가능
	public List<Board> suggestionlist(PaginationInfo<Board> pagingVO);

	public int insert(Board board);

	public int listCount(PaginationInfo<Board> pagingVO);

	public List<Board> list(PaginationInfo<Board> pagingVO);

	public List<BoardAttach> list(Map<String, Object> paramMap);

	public List<BoardAttach> suggestiondetail2(int boardNo);

	public Board suggestiondetail(int boardNo);

	public int update(Board board);

	public int updateBoardAttach(BoardAttach boardAttach);

	public String getEmpNo(int boardNo);

	public int suggestiondelete(int boardNo);

	public void deleteBoardFileList(Integer[] delBoardNo);
	
	public int getBoardNo();
	
}
