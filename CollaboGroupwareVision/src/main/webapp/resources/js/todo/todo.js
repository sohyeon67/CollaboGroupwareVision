
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
