package kr.or.ddit.board.department.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.org.vo.Dept;

public interface DepartmentService {

	public int departmentInsert(Board board, HttpServletRequest req);

	public Board departmentDetail(int boardNo);

	public List<Board> list(PaginationInfo<Board> pagingVO);
	public int listCount(PaginationInfo<Board> pagingVO);
	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap);

	public List<Board> getDepartmentBoards(int departmentCode);
	
	/**
	 * 부서게시판 부서목록 가져오기
	 * @return
	 */
	public List<Dept> selectDepartMentList();

	public String getEmpNo(int boardNo);

	public int departmentDelete(int boardNo);

	public List<BoardAttach> departmentBoardAttach(int boardNo);

	public int departmentUpdate2(int boardNo);

	public ServiceResult departmentUpdate(HttpServletRequest req, Board board) throws Exception;

	static final List<Integer> ALLOWED_DEPARTMENTS = Arrays.asList(1, 2, 3);

    public default boolean hasAccessToDepartment(int loginEmpDeptCode) {
        // 사용자의 부서코드가 허용된 부서 목록에 포함되어 있는지 확인
        return ALLOWED_DEPARTMENTS.contains(loginEmpDeptCode);
    }

	public List<Dept> getDepartments();

	public List<Board> getDeptBoards(int loginEmpDeptCode);

}
