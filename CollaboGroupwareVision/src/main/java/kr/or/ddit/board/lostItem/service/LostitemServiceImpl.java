package kr.or.ddit.board.lostItem.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.board.lostItem.mapper.LostitemMapper;
import kr.or.ddit.board.vo.BoardLostitem;

@Service
public class LostitemServiceImpl implements LostitemService {
	
	@Inject
	private LostitemMapper mapper;
	
	@Override
	public void lostitemInsert(BoardLostitem boardLostitem) {
		mapper.lostitemInsert(boardLostitem);
	}

}
