package kr.or.ddit.calendar.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.calendar.vo.Calendar;

public interface ICalendarService {

	
	public ServiceResult insertCal(Calendar calendarVO);
	
	public List<Calendar> getCalender(Map<String, String> map);
	
	public ServiceResult updateCal(Calendar calendarVO);
	
	public ServiceResult deleteCal(int calNo);
	
	


}
