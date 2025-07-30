package kr.or.ddit.board.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.board.mapper.ReplyMapper;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.Reply;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ReplyServiceImpl implements ReplyService {
	
	@Inject
	private ReplyMapper mapper;
	
	@Override
	public int replyInsert(Reply reply) {
		return mapper.replyInsert(reply);
	}

	@Override
	public List<Reply> replyList(int boardNo) {
		return mapper.replyList(boardNo);
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@Override
	public int noticeReplyInsert(Reply reply) {
		return mapper.noticeReplyInsert(reply);
	}

	@Override
	public int noticeReplyDelete(int boardNo) {
		return mapper.noticeReplyDelete(boardNo);
	}

	@Override
	public String findBoardNoByReplyNo(Integer integer) {
		return mapper.findBoardNoByReplyNo(integer);
	}

	@Override
	public Board noticeDetail(int boardNo) {
		return mapper.noticeDetail(boardNo);
	}

	@Override
	public int replyDelete(int replyNo) {
		return mapper.replyDelete(replyNo);
	}

	@Override
	public Board replyDetail(int boardNo) {
		return mapper.replyDetail(boardNo);
	}

	@Override
	public int replyUpdate(Board board) {
		return mapper.replyUpdate(board);
	}

	@Override
	public String getEmpNo(int replyNo) {
		return mapper.getEmpNo(replyNo);
	}


}
