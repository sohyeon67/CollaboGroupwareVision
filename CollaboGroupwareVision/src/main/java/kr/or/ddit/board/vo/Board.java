package kr.or.ddit.board.vo;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.BoardCategory;
import lombok.Data;

@Data
public class Board {
	
	private int boardNo;
	private String empNo;
	private int boardCode;
	private String boardTitle;
	private String boardContent;
	private Date regDate;
	private Date updateDate;
	private int inqCnt;
	private String tempYn;
	private Integer[] delBoardNo;
	private String empName;
	
	private int deptCode;	//부서별 부서게시판 
	
	public void setEmpNo(String empNo) {
	    this.empNo = empNo;
	}
	
	private BoardAttach boardAttach;
	private MultipartFile[] boFile;
	public List<BoardAttach> boardAttachList;
	
	private BoardCategory boardCategory;
	
	private Employee employee;
//	private Employee empName;
//    public Employee getempName() {
//        return empName;
//    }
	
	public void setBoFile(MultipartFile[] boFile) {
		this.boFile = boFile;
		if(boFile != null) {
			List<BoardAttach> boardAttachList = new ArrayList<BoardAttach>();
			for(MultipartFile item : boFile) {
				if(StringUtils.isBlank(item.getOriginalFilename())) {
					continue;
				}
				
				BoardAttach boardAttach = new BoardAttach(item);
				boardAttachList.add(boardAttach);
			}
			this.boardAttachList = boardAttachList;
		}
	}
}
