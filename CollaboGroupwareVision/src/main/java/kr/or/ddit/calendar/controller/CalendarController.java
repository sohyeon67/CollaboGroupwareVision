package kr.or.ddit.calendar.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.calendar.service.ICalendarService;
import kr.or.ddit.calendar.vo.Calendar;
import kr.or.ddit.chat.vo.ChatRoom;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/calendar")
public class CalendarController {

   @Inject
   private ICalendarService calendarService;
   
   
   @ResponseBody
   @PreAuthorize("hasRole('ROLE_USER')")
   @RequestMapping(value = "/celcheckBox", method = RequestMethod.POST)
   public Map<String, Object> celcheckBox(@RequestParam Map<String, Object> param , Model model, RedirectAttributes ra ){
     System.out.println("--------");
     System.out.println(param);
     Map<String, Object> key = new HashMap<String, Object>();
     
     CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
     Employee employee = user.getEmployee();
     Map<String, String> key2 = new HashMap<String, String>();
     String array = (String) param.get("asd");
     System.out.println(array);
     if(array.equals("") || array.isEmpty()) {
        array = "''";
     }
     key2.put("empNo", employee.getEmpNo());
     key2.put("array", array);
     key.put("result", calendarService.getCalender(key2));
     
      return key;
      
   }
   
   // 페이지 호출 시 조회
   @PreAuthorize("hasRole('ROLE_USER')")
   @RequestMapping(value = "/calendarhome", method = RequestMethod.GET)
   public String getCalendarList(Model model, RedirectAttributes ra ) {
      
      model.addAttribute("title", "Calendar");
      model.addAttribute("activeMain", "cal"); //메인네비게이터 상위분류
      model.addAttribute("active", "cal"); //메인네비게이터 하위분류   
      
   List<Calendar> calendarList = new ArrayList<Calendar>();
   String array = "'0','1','2'";




   CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
   Employee employee = user.getEmployee();
   Map<String, String> key = new HashMap<String, String>();
   key.put("empNo", employee.getEmpNo());
   key.put("array", array);
   
   if(employee != null ) {
      // 채팅리스트 불러오기
      calendarList = calendarService.getCalender(key);

      
   }else {   // 로그인을 진행햐지 않았을 때
      ra.addFlashAttribute("message", "로그인 후에 사용가능합니다");
      return "c/login";
   }
   
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
      System.out.println(calendarList);
      model.addAttribute("calendarList", calendarList);
   
      return "calendar/calendarhome";
   }
   
      // 재 조회
      @PreAuthorize("hasRole('ROLE_USER')")
      @RequestMapping(value = "/calendarhome", method = RequestMethod.POST)
      public String getCalendarList(Model model, RedirectAttributes ra , HttpServletRequest req) {
      List<Calendar> calendarList = new ArrayList<Calendar>();
      String array = req.getParameter("arrayChange");



      CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      Employee employee = user.getEmployee();
      Map<String, String> key = new HashMap<String, String>();
      key.put("empNo", employee.getEmpNo());
      key.put("array", array);
      
      if(employee != null ) {
         calendarList = calendarService.getCalender(key);

         
      }else {   // 로그인을 진행햐지 않았을 때
         ra.addFlashAttribute("message", "로그인 후에 사용가능합니다");
         return "account/login";
      }
      
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
         System.out.println(calendarList);
         model.addAttribute("calendarList", calendarList);
      
         return "calendar/calendarhome";
      }
   
   // 등록
   @PostMapping(value = "/insertCal")
   public String insertCal(
         Calendar calendarVO, Model model, HttpServletRequest ra
         ) {
      System.out.println(calendarVO +"=====================");
      String goPage = "";
      
      CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      Employee employee = user.getEmployee(); 
      calendarVO.setEmpNo(employee.getEmpNo());
      
      ServiceResult result = calendarService.insertCal(calendarVO);
      if(result.equals(ServiceResult.OK)) { // 캘린더 등록 완료
         goPage = "redirect:/calendar/calendarhome";
         
      }else { // 캘린더 등록 실패
         model.addAttribute("message", "서버 에러, 다시 시도해 주세요!");
         model.addAttribute("CalendarVO", calendarVO);
         goPage = "calendar/calList";
      }
      
      return goPage;
   }
   
   
   // 수정
   @PostMapping(value = "/updateCal")
   public String updateCalendar(
         Calendar calendarVO, Model model,
         RedirectAttributes ra
         ) {
      System.out.println(calendarVO +"=====================");
      
      String goPage = "";
      
      ServiceResult result = calendarService.updateCal(calendarVO);
      if(result.equals(ServiceResult.OK)) { // 캘린더 수정 완료
         goPage = "redirect:/calendar/calendarhome";
         ra.addFlashAttribute("message", "캘린더 일정 수정이 완료되었습니다!");
      }else { // 캘린더 수정 실패
         model.addAttribute("message", "서버 에러, 다시 시도해 주세요!");
         goPage = "calendar/calList";
      }
      
      return goPage;
      
   }
   

   
   // 삭제
   @RequestMapping(value = "/deleteCal", method = RequestMethod.POST)
   public String deleteCalendar(
         int calNo, 
         Model model,
         RedirectAttributes ra
         ) {
      
      String goPage = "";
      
      ServiceResult result = calendarService.deleteCal(calNo);
      if(result.equals(ServiceResult.OK)) { // 캘린더 등록 완료
         goPage = "redirect:/calendar/calendarhome";
         ra.addFlashAttribute("message", "캘린더 일정 삭제가 완료되었습니다!");
      }else { // 캘린더 등록 실패
         model.addAttribute("message", "서버 에러, 다시 시도해 주세요!");
         goPage = "calendar/calList";
      }
      
      return goPage;
      
   } 
   
}