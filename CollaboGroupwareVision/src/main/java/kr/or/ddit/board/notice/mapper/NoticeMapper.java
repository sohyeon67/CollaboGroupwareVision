package kr.or.ddit.board.notice.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;

public interface NoticeMapper {

	public int noticeListCount(PaginationInfo<Board> pagingVO);

	public List<Board> noticeList(PaginationInfo<Board> pagingVO);

	public List<BoardAttach> noticeSelectAttachList(Map<String, Object> paramMap);

	public int noticeInsert(Board board);

	public void noticeInsert2(BoardAttach boardAttach);

	public Board noticeDetail(int boardNo);

	public List<BoardAttach> noticeDetail2(int boardNo);

	public int noticeDelete(int boardNo);

	public int noticeUpdate(Board board);

	public int noticeUpdate2(int boardNo);

	public BoardAttach selectFileInfo(Integer fileId);

	public void noticeDeleteBoardFileList(Integer[] delBoardNo);

	public void noticeInsertBoardAttach(BoardAttach boardAttach);

	public int noticeUpdateBoardAttach(BoardAttach boardAttach);

	public int noticeUpdateBoardAttach(Board board);

	public List<Board> noticeListMain();

}
