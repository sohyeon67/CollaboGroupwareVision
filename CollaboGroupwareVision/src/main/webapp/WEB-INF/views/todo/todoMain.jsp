<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<style>
.listDiv {
	overflow: auto;
}
</style>



<script type="text/javascript">
	/* 실행 함수 구간 */
	$(function() {

		// todo 추가 버튼 클릭 시
		$("#addTodoBtn").on("click", function() {
			console.log("추가 버튼 클릭");

			// 입력된 todo 내용 가져오기
			var todoContent = $("#todoContent").val();
			console.log(todoContent);

			if (todoContent == "" || todoContent == null) {
				console.log("내용을 입력하세요!!");
				alertWarning();
				return false;
			}

			// Ajax 호출
			$.ajax({
				type : "POST",
				url : "/todo/todoInsert",
				contentType : "application/json",
				data : todoContent,
				beforeSend : function(xhr) {
					xhr.setRequestHeader(header, token);
				},
				success : function(res) {
					console.log("Todo 추가 성공:", res);
					location.reload(); // 새로고침(이동된 todo 바로 보이도록!)
				},
				error : function(error) {
					console.error("Todo 추가 실패:", error);
				}
			});

		}); //addTodoBtn click 이벤트 끝

		// 삭제버튼 클릭 시
		$("ul.list-group2").on("click", "button", function() {
			
			// 현재 클릭된 버튼이 속한 리스트 아이템을 찾아서 삭제
		    var listItem = $(this).closest("li");			
		    
		    var todoNo = listItem.find("input[type=checkbox]").data("todo-no");
		    var empNo = listItem.find("input[type=checkbox]").data("emp-no");

		    var data = {
		        todoNo: todoNo,
		        empNo: empNo
		    }


		    $.ajax({
		        type : "POST",
		        url : "/todo/todoDelete",
		        contentType : "application/json",
		        data : JSON.stringify(data),
		        beforeSend : function(xhr) {
		            xhr.setRequestHeader(header, token);
		        },
		        success : function(res) {
		            console.log("Todo 삭제 성공:", res);
		            // 리스트 삭제
		            listItem.remove();
		            $("#todoContent").focus();
		            
		        },
		        error : function(error) {
		            console.error("Todo 삭제 실패:", error);
		        }
		    });

		});//체크박스 이벤트 끝
		
		// 최근 To-Do List에서 체크박스 체크 시
		$("ul.list-group").on("change", "input[type=checkbox]", function() {

			var isChecked = $(this).prop("checked");
			var todoNo = $(this).data("todo-no");
			var empNo = $(this).data("emp-no");
			var data = {
				todoNo : todoNo,
				empNo : empNo
			}

			if (isChecked) {
				// 체크되면 completed로 이동
				$.ajax({
					type : "POST",
					url : "/todo/todoUpdate",
					contentType : "application/json",
					data : JSON.stringify(data),
					beforeSend : function(xhr) {
						xhr.setRequestHeader(header, token);
					},
					success : function(res) {
						console.log("Todo 이동 성공:", res);
						location.reload(); // 새로고침(이동된 todo 바로 보이도록!)
					},
					error : function(error) {
						console.error("Todo 이동 실패:", error);
					}
				});
			}
		});//체크박스 이벤트 끝

		$("ul.list-group2").on("change", "input[type=checkbox]", function() {

			var unChecked = !$(this).prop("checked");
			var todoNo = $(this).data("todo-no");
			var empNo = $(this).data("emp-no");
			var data = {
				todoNo : todoNo,
				empNo : empNo
			}

			if (unChecked) {
				// 체크 해제 시 todolist로 다시 이동
				$.ajax({
					type : "POST",
					url : "/todo/todoUncheck",
					contentType : "application/json",
					data : JSON.stringify(data),
					beforeSend : function(xhr) {
						xhr.setRequestHeader(header, token);
					},
					success : function(res) {
						console.log("Todo 체크 해제 성공:", res);
						location.reload(); // 새로고침(이동된 todo 바로 보이도록!)
					},
					error : function(error) {
						console.error("Todo 체크 해제 실패:", error);
					}
				});
			}
		});//체크박스 이벤트 끝

		
	}); //function 끝

	/* 내용 미입력 시 alert */
	function alertWarning() {
		Swal.fire({
			icon : 'warning',
			text : `내용을 입력해주세요!`,
		})
	}
</script>




<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item"><a href="/calendar/calendarhome">일정</a></li>
				<li class="breadcrumb-item active" aria-current="page">TodoList</li>
			</ol>
		</nav>
		<!-- Breadcrumb 끝-->

		<!-- Page title and information -->

		<br />
		<!-- END : Page title and information -->

	</div>
</div>


<div class="content__boxed">
	<div class="content__wrap">
		<div class="row d-flex justify-content-center">
			<div class="input-group mt-3" style="width: 71%; margin: 0% 2%;">
				<input type="text" class="form-control form-control-sm"
					name="todoContent" id="todoContent" placeholder="Add new list"
					aria-label="Add new list" aria-describedby="button-addon">
				<button id="addTodoBtn"
					class="btn btn-sm btn-secondary hstack gap-2 fs-4" type="button">
					<i class="demo-psi-add text-white-50 fs-4"></i> Add New
				</button>
			</div>


			<!-- 첫번째 칸 -->
			<div class="col-xl-4 mb-3 mb-xl-0" style="height: 600px; margin: 2%;">

				<h4 class="mb-3 card">
					<i class="ti-pin-alt"
						style="font-size: x-large !important; padding: 4%; font-weight: bold;">
						To-do list</i>
				</h4>
				<div class="card h-100 listDiv" style="padding: 8%;">

					<div class="col-md-15">

						<ul class="list-group list-group-borderless">

							<c:set value="${todoList}" var="todo" />

							<c:choose>
								<c:when test="${empty todo}">
									<li class="list-group-item px-0">
										<div class="form-check ">등록된 todoList가 없습니다.</div>
									</li>
								</c:when>
								<c:otherwise>
									<c:forEach items="${todoList}" var="todo" varStatus="loop">
										<c:if test="${todo.todoDelYn eq 'N'}">
											<li class="list-group-item px-0">
												<div class="form-check ">
													<c:if test="${todo.todoDelYn eq 'N'}">
														<input id="_dm-todoList${loop.index}"
															class="form-check-input" type="checkbox"
															data-todo-no="${todo.todoNo}" data-emp-no="${todo.empNo}"
															<c:if test="${todo.todoCheckYn eq 'Y'}">checked</c:if>>
														<label for="_dm-todoList${loop.index}"
															class="form-check-label"> ${todo.todoContent} </label>
													</c:if>
												</div>
											</li>
										</c:if>
									</c:forEach>
								</c:otherwise>
							</c:choose>

						</ul>


						<!-- END : TODO List -->

					</div>
					<!-- To Do List 끝 -->
				</div>

			</div>
			<!-- 첫번째 칸 끝-->


			<!-- 두번째 칸 -->
			<div class="col-xl-4 mb-3 mb-xl-0" style="height: 600px; margin: 2%;">

				<h4 class="mb-3 card">
					<i class="ti-check-box"
						style="font-size: x-large !important; padding: 4%; font-weight: bold;">
						Completed </i>
				</h4>
				<div class="card h-100 listDiv" style="padding: 8%;">

					<div class="col-md-8">


						<ul class="list-group2 list-group-borderless">

							<c:set value="${cTodoList}" var="cTodoList" />

							<c:choose>
								<c:when test="${empty cTodoList}">
									<li class="list-group-item px-0">
										<div class="form-check" style="margin-left: -30px;">완료된 todoList가 없습니다.</div>
									</li>
								</c:when>
								<c:otherwise>
									<c:forEach items="${cTodoList}" var="ctodo" varStatus="loop">
										<li class="list-group-item px-0">
											<div class="form-check" style="margin-left: -30px;">
												<input id="_dm-todoList${loop.index}"
													class="form-check-input" type="checkbox"
													data-todo-no="${ctodo.todoNo}" data-emp-no="${ctodo.empNo}"
													<c:if test="${ctodo.todoCheckYn eq 'Y'}">checked</c:if> >
												<label for="_dm-todoList${loop.index}"
													class="form-check-label text-decoration-line-through"> ${ctodo.todoContent} </label>
												<button class="float-end" style="background-color: lightgray;" id="delBtn">삭제</button>											
											</div>
										</li>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</ul>

						<!-- END : TODO List -->

					</div>
					<!-- To Do List 끝 -->
				</div>

			</div>
			<!-- 두번째 칸 끝-->


		</div>

	</div>
</div>


