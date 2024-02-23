package kr.or.ddit.board.department.mapper;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.org.vo.Dept;

@Mapper
public interface DepartmentMapper {

	public int departmentInsert(Board board);

	public Board departmentDetail(int boardNo);

	public int listCount(PaginationInfo<Board> pagingVO);

	public List<Board> list(PaginationInfo<Board> pagingVO);

	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap);

	public List<Board> getDepartmentBoards(int departmentCode);

	public List<Dept> selectDepartMentList();

	public String getEmpNo(int boardNo);

	public int departmentDelete(int boardNo);

	public List<BoardAttach> departmentBoardAttach(int boardNo);

	public int departmentUpdate(Board board);
	
	public int departmentUpdate2(int boardNo);

	public void deleteBoardFileList(Integer[] delBoardNo);

	public List<Dept> getDepartments();

	public List<Board> getDeptBoards(int loginEmpDeptCode);

}
