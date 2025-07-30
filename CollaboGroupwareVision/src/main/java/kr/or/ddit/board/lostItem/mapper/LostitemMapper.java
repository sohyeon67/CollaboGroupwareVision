package kr.or.ddit.board.lostItem.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.board.vo.BoardLostitem;

@Mapper
public interface LostitemMapper {

	public void lostitemInsert(BoardLostitem boardLostitem);

}
