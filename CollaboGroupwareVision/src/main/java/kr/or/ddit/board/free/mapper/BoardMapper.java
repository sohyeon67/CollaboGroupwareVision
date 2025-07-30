package kr.or.ddit.board.free.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.board.vo.Reply;

@Mapper
public interface BoardMapper {

	public List<Board> list(PaginationInfo<Board> pagingVO);
	public int insert(Board board);
	public Board detail(int boardNo);
	public int update(Board board);
	public int update2(int boardNo);
	public int listCount(PaginationInfo<Board> pagingVO);
	
	public int insert2(BoardAttach boardAttach);
	public List<BoardAttach> detail2(int boardNo);
	
	public int replyInsert(Reply reply);
	public int replyDelete(int replyNo);
	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap);
	
	public int delete(int boardNo);
	public int updateBoardAttach(Board board);
	public int updateBoardAttach(BoardAttach boardAttach);
	
	public BoardAttach selectFileInfo(int fileNo);
	
	public String getEmpNo(int boardNo);
	public void deleteBoardFileList(Integer[] delBoardNo);
	public void insertBoardAttach(BoardAttach boardAttach);
	
	/*
	 * @Delete("deleteBoardAttach") public void deleteBoardAttach(int boardNo);
	 */
	
	/*
	 * @Delete("DELETE FROM board WHERE board_no = #{boardNo}") int deleteBoard(int
	 * boardNo);
	 * 
	 * @Delete("DELETE FROM board_attach WHERE board_no = #{boardNo}") void
	 * deleteBoardAttach(int boardNo);
	 */

	
}
