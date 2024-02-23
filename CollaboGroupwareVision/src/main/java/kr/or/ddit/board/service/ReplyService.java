package kr.or.ddit.board.service;

import java.util.List;

import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.Reply;

public interface ReplyService {

	public int replyInsert(Reply reply);
	public List<Reply> replyList(int boardNo);


	public int noticeReplyInsert(Reply reply);
	public int noticeReplyDelete(int boardNo);
	public String findBoardNoByReplyNo(Integer integer);
	public Board noticeDetail(int boardNo);
	public int replyDelete(int replyNo);
	public Board replyDetail(int boardNo);
	public int replyUpdate(Board board);
	
	public String getEmpNo(int replyNo);
	
}
