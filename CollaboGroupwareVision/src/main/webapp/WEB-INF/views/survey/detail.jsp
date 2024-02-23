<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<meta name="_csrf" th:content="${_csrf.token}"/>
<meta name="_csrf_header" th:content="${_csrf.headerName}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" th:content="${_csrf.token}" />
<meta name="_csrf_header" th:content="${_csrf.headerName}" />
</head>
<body class="jumping">

    <!-- PAGE CONTAINER -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <div id="root" class="root mn--max hd--expanded">

        <!-- CONTENTS -->
        <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
        <section id="content" class="content">
            <div class="content__header content__boxed overlapping">
                <div class="content__wrap">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="./index.html">홈</a></li>
                            <li class="breadcrumb-item"><a href="./blog-apps.html">게시판</a></li>
                            <li class="breadcrumb-item active" aria-current="page">자유게시판</li>
                        </ol>
                    </nav>
                    <!-- END : Breadcrumb -->

                    <h1 class="page-title mb-0 mt-2">자유게시글 조회</h1>

                    <p class="lead">
                                                    <p class="mb-3"></p>
                            <p class="mb-3"></p>
                                <p class="mb-3"></p>
                                <p class="mb-3"></p>
                    </p>
                </div>
            </div>

            <div class="content__boxed">
                <div class="content__wrap">
                    <div class="card">
                        <div class="card-body">

                            <!-- Invoice header -->
                            <div class="d-flex border-bottom pb-3">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1 ms-1 h2 mb-0">${board.boardTitle }</div>
                                </div>
                                <div class="ms-auto">
                                    <h2>게시글 번호 : ${board.boardNo }</h2>
                                </div>
                            </div>
                            <!-- END : Invoice header -->

                            <!-- Invoice info -->
                            <div class="d-md-flex mt-4">
                                <address class="mb-4 mb-md-0">
                                    <h5 class="mb-2">${board.boardContent }</h5>
                                </address>

                                <ul class="list-group list-group-borderless ms-auto">
                                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-0 pb-1">
                                        <div class="me-5 h5 mb-0">조회수 : </div>
                                        <span class="ms-auto text-info fw-bold">${board.inqCnt }</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-0 pb-1">
                                        <div class="me-5 h5 mb-0">작성자 : </div>
                                        <span class="badge bg-success rounded-pill">${board.empNo }</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-0 pb-1">
                                        <div class="me-5 h5 mb-0">작성일 : </div>
                                        <span class="ms-auto">${board.regDate }</span>
                                    </li>
                                </ul>
                            </div>
                            <!-- END : Invoice info -->

                            <!-- Print button and confirm payment -->
                            <div class="d-flex justify-content-end gap-2 my-4 d-print-none">
                                <a href="javascript:window.print()" class="btn btn-light btn-icon"><i class="demo-pli-printer fs-5"></i></a>
                                <a href="#" class="btn btn-primary">Confirm Payment</a>
                            </div>
                            <!-- END : Print button and confirm payment -->

                            <!-- Footer information -->
                            <div class="bg-light p-3 rounded bg-opacity-50 mt-5">
                                <c:forEach items="${boardAttachList }" var="boardAttach">
	                                <p class="mb-3">첨부파일 : ${boardAttach.fileName }</p>
                                </c:forEach>
                            </div>
                            <!-- END : Footer information -->
                        </div>
                        </div>
                        
                        <p></p>
                        
                           	<div align="left">
		<input type="button" class="btn btn-primary rounded-pill" id="updateBtn" value="수정하기"/>
		<input type="button" class="btn btn-primary rounded-pill" id="deleteBtn" value="삭제하기"/>
		<input type="button" class="btn btn-primary rounded-pill" id="listBtn" value="목록으로"/>
	</div>
	
				<p></p>
                        
                    <div class="card mb-3">
                        <div class="card-body">
                        	<div class="col-md-6 mb-3">
                           		<div class="card">
                                	<div class="card-body">

                                    <h5 class="card-title">댓글 목록</h5>

                                    <!-- Striped rows -->
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>댓글번호</th>
                                                    <th>작성자</th>
                                                    <th>댓글내용</th>
                                                    <th>작성날짜</th>
                                                </tr>
                                            </thead>
                                            <tbody>
		<c:choose>
			<c:when test="${empty replyList }">
				<tr>
					<td colspan="4">댓글이 존재하지 않습니다...</td>
				</tr>
			</c:when>
			<c:otherwise>
<%-- 				<c:forEach items="${replyList }" var="reply">
					<tr>
						<td>${reply.replyNo}</td>
						<td>${reply.empNo}</td>
						<td>${reply.replyContent}</td>
						<td>${reply.regDate}</td>
					</tr>
				</c:forEach> --%>
				<c:forEach items="${replyList}" var="reply">
    <tr>
        <td>${reply.replyNo}</td>
        <td>${reply.empNo}</td>
        <td>${reply.replyContent}</td>
        <td>${reply.regDate}</td>
        <td>
            <!-- 수정 버튼 -->
            <%-- <button type="button" class="btn btn-success rounded-pill updateReplyBtn" id="updateReplyBtn" data-replyNo="${reply.replyNo}">수정</button> --%>
            
            <!-- 삭제 버튼 -->
            <button type="button" class="btn btn-danger rounded-pill deleteReplyBtn" id="deleteReplyBtn" data-replyNo="${reply.replyNo}">삭제</button>
        </td>
    </tr>
</c:forEach>
				
			</c:otherwise>
		</c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- END : Striped rows -->

                                </div>
                            </div>
                        </div>
                    </div>    
               	</div>

				<p></p>

                    <!-- Submit comment form -->
                    <div class="card mb-3">
                        <div class="card-body">

                            <h5 class="card-title">댓글 작성</h5>
							<form class="mt-4 row" action="/board/replyInsert" method="post" id="insertReplyForm">
						        <input type="hidden" name="boardNo" value="${board.boardNo }" />
							    <div class="col-md-4">
							        <div class="col-md-8">
							            <textarea id="boardReplyContent" class="form-control" rows="9" name="replyContent" placeholder="댓글 내용을 작성하세요"></textarea>
							        </div>
							        <p></p>
							        <button class="btn btn-primary mb-3 mb-md-0" id="insertReplyBtn" type="submit">댓글 등록하기</button>
							    </div>
							    <sec:csrfInput />
							</form>
                        </div>
                    </div>
                    <!-- END : Submit comment form -->
                   

                    
                </div>
            </div>
            </section>
            </div>
</body>
            
<body>         
	<form action="/board/delete" method="post" id="delForm">
		<input type="hidden" name="boardNo" value="${board.boardNo }"/>
		<sec:csrfInput />
	</form>
</body>  

<body>         
	<form action="/board/replyDelete" method="post" id="delReplyForm">
		<input type="hidden" name="replyNo" value="${reply.replyNo }"/>
		<sec:csrfInput />
	</form>
</body> 

<script type="text/javascript">
$(function reloadDivArea(){
	console.log(location.href+' #replyList');
	$('#replyList').load(location.href+' #replyList');
	
/* 	setTimeout(() => {
		console.log("delay100_1");
		delay100();
	}, 100); */
});

/* $(function delay100(){
	console.log("delay100_2");
	$(".commentSaveBtn").click(function() {
		rereply(this);
	});
}); */

$(function(){
	var updateBtn = $("#updateBtn")
	var deleteBtn = $("#deleteBtn")
	var listBtn = $("#listBtn")
	var delForm = $("#delForm")
	
/* 	updateBtn.on("click", function(){
		delForm.attr("method", "get");
		delForm.attr("action", "/board/update");
		delForm.submit();
	}); */
	
	updateBtn.on("click", function(){
	    delForm.prop("method", "get");
	    delForm.prop("action", "/board/update");
	    delForm.submit();
	});
	
	deleteBtn.on("click", function(){
		if(confirm("정말로 삭제하시겠습니까?")){
			delForm.submit();
		}
	});
	
	listBtn.on("click", function(){
		location.href = "/board/free/list";
	});
	
});

$(function(){
	var insertReplyForm = $("#insertReplyForm");
	var insertReplyBtn = $("#insertReplyBtn");
	
	var deleteReplyBtn = $(".deleteReplyBtn")
	var delReplyForm = $("#delReplyForm");
	
/* 	var updateReplyForm = $("#updateReplyForm");
	var updateReplyBtn = $("#updateReplyBtn"); */
	
    var csrfToken = $("meta[name='_csrf']").attr("content");
    var csrfHeader = $("meta[name='_csrf_header']").attr("content");
	
	insertReplyBtn.on("click", function() {
		var boardReplyContent = $("#boardReplyContent").val();

		if (boardReplyContent == null || boardReplyContent === "") {
			alert("내용을 입력해주세요.");
			return false;
		}

/* 		if ($(this).val() == "수정") {
			insertReplyForm.attr("action", "/board/replyUpdate");
		} */
		
        // 서버에서 전달한 에러 파라미터를 확인하여 알림 표시
        var errorParam = new URLSearchParams(window.location.search).get('error');
        if (errorParam) {
            alert("댓글 작성에 실패했습니다. 다시 시도해주세요.");
        }

		insertReplyForm.submit();
	});
	    
    deleteReplyBtn.on("click", function(){
        var replyNo = parseInt($(this)[0].dataset.replyno);
        console.log(replyNo);
        if (confirm("정말로 삭제하시겠습니까?")) {
            $.ajax({
                type: "POST",
                url: "/board/replyDelete",
                data: { replyNo: replyNo },
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function(response) {
                	console.log(response)
                	console.log(11111111111)
                	console.log('/board/detail?boardNo=270')
                	window.location.reload()
                },
                error: function(error) {
                    console.error("댓글 삭제 실패: ", error);
                }
            });
        }
    });
    
/*     updateReplyBtn.on("click", function(){
    	var boardReplyContent = $("#boardReplyContent").val();
    	
		if (boardReplyContent == null || boardReplyContent === "") {
			alert("내용을 입력해주세요.");
			return false;
		}
		
        // 서버에서 전달한 에러 파라미터를 확인하여 알림 표시
        var errorParam = new URLSearchParams(window.location.search).get('error');
        if (errorParam) {
            alert("댓글 작성에 실패했습니다. 다시 시도해주세요.");
        }
        
        insertReplyForm.submit();
    	
    }); */
    
	    
/* 	    deleteReplyBtn.on("click", function(){
	        var replyNo = parseInt($(this)[0].dataset.replyno);
	        var boardNo = $("#boardNo2").val();
	        console.log(replyNo);
	        if (confirm("정말로 삭제하시겠습니까?")) {
	            $.ajax({
	                type: "POST",					// method 방식
	                url: "/board/replyDelete",		// url 요청할 목적지
	                data: JSON.stringify({ replyNo: replyNo }),		// 서버로 넘길 데이터
	               	contentType : "application/json;charset=utf-8",	// 미디어타입 죽, MimeType을 설정할때
	                beforeSend: function(xhr) {		// 시큐리티 운용시 필수로 보내야하는 헤더 토큰값
	                    xhr.setRequestHeader(csrfHeader, csrfToken);
	                },
	                success: function(response) {	// 성공 시 callback
	                	console.log(response)
	                	console.log(11111111111)
	                	console.log('/board/detail?boardNo=270')
	                	//window.location.reload();
	                	//location.replace("/board/detail?boardNo="+boardNo);
	                	
	                	console.log(response);

	                    // 예시: 댓글이 삭제된 후에 특정 영역 업데이트
	                    $("#commentArea").html("<p>댓글이 성공적으로 삭제되었습니다.</p>");

	                    console.log("댓글 삭제 성공!");
	                	
	                },
	                error: function(error) {		// 실패 시 callback
	                    console.error("댓글 삭제 실패: ", error);
	                }
	            }); */
	    
	});
	
</script>
</html>





















