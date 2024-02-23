package kr.or.ddit.calendar.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.calendar.mapper.ICalendarMapper;
import kr.or.ddit.calendar.service.ICalendarService;
import kr.or.ddit.calendar.vo.Calendar;

@Service
public class CalendarServiceImpl implements ICalendarService {

	@Inject
	private ICalendarMapper calendarMapper;

	
	@Override
	public List<Calendar> getCalender(Map<String, String> map) {
		return calendarMapper.getCalender(map);
	}


	@Override
	public ServiceResult insertCal(Calendar calendarVO) {
		ServiceResult result = null;
		
		int status = calendarMapper.insertCal(calendarVO);
		if(status > 0) { // 등록성공시
			result = ServiceResult.OK;
		}else {	// 등록 실패시
			result = ServiceResult.FAILED;
		}
		
		
		return result;
	}

	
	@Override
	public ServiceResult deleteCal(int calNo) {
		ServiceResult result = null;
		
		int status = calendarMapper.deleteCalendar(calNo);
		if(status > 0) { // 삭제 성공
			result = ServiceResult.OK;
		}else { // 삭제 실패
				result = ServiceResult.FAILED;
		}
		
		return result;
	}


	@Override
	public ServiceResult updateCal(Calendar calendarVO) {
		ServiceResult result = null;
		
		int status = calendarMapper.updateCalendar(calendarVO);
		if(status > 0) {	// 수정 성공
			result = ServiceResult.OK;
		}else {
				result = ServiceResult.FAILED;
		}
		
		return result;
	}




	
}
