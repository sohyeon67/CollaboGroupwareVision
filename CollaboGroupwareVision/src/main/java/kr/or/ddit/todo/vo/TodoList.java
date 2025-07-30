package kr.or.ddit.todo.vo;

import lombok.Data;

@Data
public class TodoList {
	private int todoNo;
	private String empNo;
	private String todoContent;
	private String todoRegDate;
	private String todoCheckYn;	//체크전 N, 체크 후 Y
	private String todoDelYn;	//사용 N, 삭제 Y
}
