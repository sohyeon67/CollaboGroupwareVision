package kr.or.ddit.todo.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.todo.mapper.TodoMapper;
import kr.or.ddit.todo.vo.TodoList;

@Service
public class TodoServiceImpl implements TodoService {
	
	@Inject
	private TodoMapper todoMapper;

	@Override
	public List<TodoList> selectTodoList(String empNo) {		
		return todoMapper.selectTodoList(empNo);
	}

	@Override
	public void insertTodoList(TodoList todo) {
		todoMapper.insertTodoList(todo);
	}

	@Override
	public List<TodoList> selectCompleteTodoList(String empNo) {
		return todoMapper.selectCompleteTodoList(empNo);
	}

	@Override
	public void updateTodoList(TodoList todoList) {
		todoMapper.updateTodoList(todoList);
		
	}

	@Override
	public void updateTodoUncheck(TodoList todoList) {
		todoMapper.todoUncheck(todoList);
		
	}

	@Override
	public void updateTodoDelete(TodoList todoList) {
		todoMapper.updateTodoDelete(todoList);
		
	}

	
	
	
	
}
