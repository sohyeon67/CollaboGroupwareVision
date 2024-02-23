package kr.or.ddit.board.vo;

import java.sql.Date;

import kr.or.ddit.account.vo.Employee;
import lombok.Data;

@Data
public class Reply {
	private int replyNo;
	private int boardNo;
	private String empNo;
	private String replyContent;
	private Date regDate;
	private Date modDate;
	
	private Employee employee;
	
}