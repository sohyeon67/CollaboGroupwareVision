package kr.or.ddit;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.board.notice.service.NoticeService;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.calendar.service.ICalendarService;
import kr.or.ddit.calendar.vo.Calendar;
import kr.or.ddit.dclz.service.DclzService;
import kr.or.ddit.dclz.vo.Dclz;
import kr.or.ddit.notification.service.NotiService;
import kr.or.ddit.project.service.ProjectService;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.todo.service.TodoService;
import kr.or.ddit.todo.vo.TodoList;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {

	@Inject
	private NotiService notiService;
	
	//TODO
	@Inject
	private TodoService todoService;
	
	//근태
	@Inject
	private DclzService dclzService;
	
	// 공지
	@Inject
	private NoticeService noticeService;

	// 캘린더
	@Inject
	private ICalendarService calendarService;
	
	// 프로젝트
	@Inject
	private ProjectService projectService;
	
	// 서버 runtime시, 최초 1회 동작
	@PostConstruct
	public void init() {
		String chatUploadLocate = "C:/chatupload";
		File file = new File(chatUploadLocate);
		if(!file.exists()) {
			file.mkdirs();
		}
	}
	
	// 일반 홈
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping(value = { "/", "/index" })
	public String mainHome(HttpSession session, Model model) {
		model.addAttribute("generator", "Hugo 0.87.0");
		model.addAttribute("activeMain", "home");
		model.addAttribute("title", "CollaboGroupwareVision");
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		String empNo = employee.getEmpNo();
		if (employee != null) {
			session.setAttribute("loginEmpNo", employee.getEmpNo());
			
			
			// 근태
			Dclz dclzTime = dclzService.selectEmpTime(employee.getEmpNo());
			model.addAttribute("dclzTime", dclzTime);
			
			// 알람
			int notiCount = notiService.selectNotiListCount(employee.getEmpNo());
			model.addAttribute("notiCount", notiCount);
			
			// 실시간뉴스
			
			//TODO
			//최근 todoList 조회
			List<TodoList> todoList = todoService.selectTodoList(employee.getEmpNo());
			model.addAttribute("todoList", todoList);
			
			//완료 todoList 조회
			List<TodoList> completeTodoList = todoService.selectCompleteTodoList(employee.getEmpNo());
			model.addAttribute("cTodoList", completeTodoList);
			
			// 캘린더
			List<Calendar> calendarList = new ArrayList<Calendar>();
			String array = "'0','1','2'";
			
			Map<String, String> key = new HashMap<String, String>();
			key.put("empNo", employee.getEmpNo());
			key.put("array", array);
			calendarList = calendarService.getCalender(key);
			
			for(int i = 0; i < calendarList.size(); i++) {
			      Calendar cal = calendarList.get(i);
			      log.info("getCalno: " + cal.getCalNo());
			      log.info("getEmpno: " + cal.getEmpNo());
			      log.info("getCaltitle: " + cal.getCalTitle());
			      log.info("getCalregDate: " + cal.getCalRegDate());
			      log.info("getCalcontent : " + cal.getCalContent());
			      log.info("getCalstartDate: " + cal.getCalStartDate());
			      log.info("getCalendDate : " + cal.getCalEndDate());
			      log.info("getCalrepeatUnit: " + cal.getCalRepeatUnit());
			      log.info("getCaltype: " + cal.getCalType());
			      log.info("getCalrepeatYn: " + cal.getCalRepeatYn());
			      log.info("getCalcolor : " + cal.getCalColor());
			      log.info("getCalRepeatDate : " + cal.getCalRepeatDate());
			      log.info("getcalday : + " + cal.getCalAll());
			   }
			log.info("calendarList"+calendarList);
			model.addAttribute("calendarList", calendarList);

			log.info("calendarList 값 : " + calendarList);
			
			
			// 공지사항 게시글
			List<Board> noticeListMain = noticeService.noticeListMain();
			
			log.info("noticeListMain" + noticeListMain);
			model.addAttribute("noticeListMain", noticeListMain);
			
			
			// 프로젝트
			// 전체, 프로젝트 상태별 수
			Map<String, Object> projectCounts = projectService.getMyProjectCounts(empNo);
			model.addAttribute("projectCounts", projectCounts);
			
		}
		return "main/index";
	}
	
	// 관리자 홈
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/admin")
	public String adminHome() {
		return "redirect:/stat/statDclz";
	}

}
