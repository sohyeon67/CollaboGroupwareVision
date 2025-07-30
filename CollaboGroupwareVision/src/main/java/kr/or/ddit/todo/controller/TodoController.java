package kr.or.ddit.todo.controller;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.todo.service.TodoService;
import kr.or.ddit.todo.vo.TodoList;
import lombok.extern.slf4j.Slf4j;

/**
 * 캘린더 - todolist 컨트롤러
 * @author 김민채
 */

@Slf4j
@Controller
@RequestMapping("/todo")
public class TodoController {
	
	@Inject
	private TodoService todoService;

	// todoMain 및 리스트 호출 (select)
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/todoMain")
	public String todoMain(Model model) {
		log.info("todoMain() 실행..!");
		model.addAttribute("title", "TodoList");
		model.addAttribute("activeMain", "cal"); //메인네비게이터 상위분류
		model.addAttribute("active", "todo"); //메인네비게이터 하위분류

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("todoList 시큐리티 확인");
		Employee employee = user.getEmployee();
		
		//최근 todoList 조회
		List<TodoList> todoList = todoService.selectTodoList(employee.getEmpNo());
		model.addAttribute("todoList", todoList);
		
		//완료 todoList 조회
		List<TodoList> completeTodoList = todoService.selectCompleteTodoList(employee.getEmpNo());
		model.addAttribute("cTodoList", completeTodoList);
				
		return "todo/todoMain";

	}
	
	
	// todoList (insert)
	//////////////////////////////////////////////////////////////////////////////////////////////
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/todoInsert")
	public ResponseEntity<String> todoInsert(@RequestBody String todoContent) {
	    log.info("todoInsert() 실행..!");
	    
	    // [스프링 시큐리티] 시큐리티 세션을 활용
	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    log.info("todoList 시큐리티 확인");
	    Employee employee = user.getEmployee();
	    	    
	    // TodoList 객체에 empNo 설정
	    TodoList todo = new TodoList();
	    todo.setEmpNo(employee.getEmpNo());
	    todo.setTodoContent(todoContent);
	    
	    // TodoList 객체를 전달하여 insertTodoList 메서드 호출
	    todoService.insertTodoList(todo);
	                    
	    return new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
	}
	
	
	
	// todoList (update)
	//////////////////////////////////////////////////////////////////////////////////////////////
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/todoUpdate")
	public ResponseEntity<String> todoUpdate(@RequestBody TodoList todoList) {
	    log.info("todoUpdate() 실행..!");

	    todoService.updateTodoList(todoList);

	    return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
	}

	// todoUncheck (update)
	//////////////////////////////////////////////////////////////////////////////////////////////
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/todoUncheck")
	public ResponseEntity<String> todoUncheck(@RequestBody TodoList todoList) {
		log.info("todoUncheck() 실행..!");
		
		todoService.updateTodoUncheck(todoList);
		
		return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
	}
	
	// todoDelete (update)
	//////////////////////////////////////////////////////////////////////////////////////////////
	@ResponseBody
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/todoDelete")
	public ResponseEntity<String> todoDelete(@RequestBody TodoList todoList) {
		log.info("todoDelete() 실행..!");
		
		todoService.updateTodoDelete(todoList);
		
		return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
	}
	
	
}
