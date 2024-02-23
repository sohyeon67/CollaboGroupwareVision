package kr.or.ddit.calendar.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.calendar.vo.Calendar;

public interface ICalendarMapper {

	
	public List<Calendar> getCalender(Map<String, String> map);
	
	public int insertCal(Calendar canlendarVO);
	
	public int deleteCalendar(int calNo);

	public int updateCalendar(Calendar calendarVO);



	
}
