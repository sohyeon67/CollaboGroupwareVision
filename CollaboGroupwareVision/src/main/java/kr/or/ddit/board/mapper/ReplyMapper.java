package kr.or.ddit.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.Reply;

@Mapper
public interface ReplyMapper {

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
