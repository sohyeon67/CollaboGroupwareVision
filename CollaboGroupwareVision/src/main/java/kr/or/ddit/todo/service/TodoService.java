package kr.or.ddit.todo.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.todo.vo.TodoList;

public interface TodoService {

	public List<TodoList> selectTodoList(String empNo);

	public void insertTodoList(TodoList todo);

	public List<TodoList> selectCompleteTodoList(String empNo);

	public void updateTodoList(TodoList todoList);

	public void updateTodoUncheck(TodoList todoList);

	public void updateTodoDelete(TodoList todoList);
}
