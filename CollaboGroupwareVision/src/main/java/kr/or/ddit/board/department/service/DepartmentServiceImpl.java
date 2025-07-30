package kr.or.ddit.board.department.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.board.controller.FileUploadUtils;
import kr.or.ddit.board.department.mapper.DepartmentMapper;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.org.vo.Dept;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class DepartmentServiceImpl implements DepartmentService {

	@Inject
	private DepartmentMapper departmentMapper;

	@Override
	public int departmentInsert(Board board, HttpServletRequest req) {
		return departmentMapper.departmentInsert(board);
	}

	@Override
	public Board departmentDetail(int boardNo) {
		return departmentMapper.departmentDetail(boardNo);
	}
	
	@Override
	public List<Board> list(PaginationInfo<Board> pagingVO) {
		return departmentMapper.list(pagingVO);
	}

	@Override
	public int listCount(PaginationInfo<Board> pagingVO) {
		return departmentMapper.listCount(pagingVO);
	}

	@Override
	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap) {
		return departmentMapper.selectAttachList(paramMap);
	}

	@Override
	public List<Board> getDepartmentBoards(int departmentCode) {
		return departmentMapper.getDepartmentBoards(departmentCode);
	}

	@Override
	public List<Dept> selectDepartMentList() {
		return departmentMapper.selectDepartMentList();
	}

	@Override
	public String getEmpNo(int boardNo) {
		return departmentMapper.getEmpNo(boardNo);
	}

	@Override
	public int departmentDelete(int boardNo) {
		return departmentMapper.departmentDelete(boardNo);
	}

	@Override
	public List<BoardAttach> departmentBoardAttach(int boardNo) {
		return departmentMapper.departmentBoardAttach(boardNo);
	}

	@Override
	public ServiceResult departmentUpdate(HttpServletRequest req, Board board) throws Exception {
		ServiceResult result = null;
		int status = departmentMapper.departmentUpdate(board);
		if(status > 0) {
			List<BoardAttach> boardAttachList = board.getBoardAttachList();
//			FileUploadUtils.boardFileUpload(boardAttachList, board.getBoardNo(), req, mapper);
			
			Integer[] delBoardNo = board.getDelBoardNo();
		 	if(delBoardNo != null) {
		 		departmentMapper.deleteBoardFileList(delBoardNo);
		 	}
		 	result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public int departmentUpdate2(int boardNo) {
		return departmentMapper.departmentUpdate2(boardNo);
	}

	@Override
	public List<Dept> getDepartments() {
		return departmentMapper.getDepartments();
	}

	@Override
	public List<Board> getDeptBoards(int loginEmpDeptCode) {
		return departmentMapper.getDeptBoards(loginEmpDeptCode);
	}
}
