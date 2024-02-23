package kr.or.ddit.todo.mapper;

import java.util.List;

import kr.or.ddit.todo.vo.TodoList;

public interface TodoMapper {

	public List<TodoList> selectTodoList(String empNo);

	public void insertTodoList(TodoList todo);

	public List<TodoList> selectCompleteTodoList(String empNo);

	public void updateTodoList(TodoList todoList);

	public void todoUncheck(TodoList todoList);

	public void updateTodoDelete(TodoList todoList);
	
	

}
