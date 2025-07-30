package kr.or.ddit.reservation.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.reservation.vo.Vhcl;
import kr.or.ddit.reservation.vo.VhclRsvt;

@Mapper
public interface VhclMapper {

	public List<Vhcl> selectVhclList();

	public List<VhclRsvt> selectVhclRsvtListByDay(String vhclDate);

	public void updateRsvtStatus(int vRsvtNo);

	public int insertVhclRsvt(VhclRsvt vhclRsvt);

	public List<VhclRsvt> checkReserve(VhclRsvt vhclRsvt);

	public List<VhclRsvt> selectVhclRsvtList();

	public VhclRsvt selectDetailVhclRsvt(int vRsvtNo);

	public void vhclCancel(int vRsvtNo);

	public void adminVhclInsert(Vhcl vhcl);

	public void adminVhclUpdate(Vhcl vhcl);

	public int adminVhclDelete(String vhclNo);


}
