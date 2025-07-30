package kr.or.ddit.reservation.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.reservation.vo.Vhcl;
import kr.or.ddit.reservation.vo.VhclRsvt;

public interface VhclService {

	public List<Vhcl> selectVhclList();
	
	public List<VhclRsvt> selectVhclRsvtList(); //직접추가

	public List<VhclRsvt> selectVhclRsvtListByDay(String vhclDate);

	public List<VhclRsvt> checkReserve(VhclRsvt vhclRsvt);

	public int insertVhclRsvt(Map<String, Object> paramMap);

	public VhclRsvt selectDetailVhclRsvt(int vRsvtNo);

	public void vhclCancel(int vRsvtNo);

	// 관리자 메소드 //
	
	public void adminVhclInsert(HttpServletRequest req, Vhcl vhcl);

	public void adminVhclUpdate(HttpServletRequest req, Vhcl vhcl);

	public int adminVhclDelete(String vhclNo);
	
	public void adminVhclUpdate2(HttpServletRequest req, Vhcl vhcl);





}
