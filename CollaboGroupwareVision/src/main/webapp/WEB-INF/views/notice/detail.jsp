<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<meta name="_csrf" th:content="${_csrf.token}"/>
<meta name="_csrf_header" th:content="${_csrf.headerName}"/>
<!DOCTYPE html>
<html>
<style>
  .card {
    margin-top: 30px;
    margin-bottom: 20px;
    margin-left: 100px;
    margin-right: 100px;
  }
  .card-body {
    margin-top: 20px;
    margin-bottom: 20px;
    margin-left: 20px;
    margin-right: 20px;
  }
  .breadcrumb-container {
    margin-top: 30px; 
    margin-left: 30px;
    margin-bottom: 30px;
  }
  .page-title {
  	margin-left: 50px;
  }
  .card-body .my-custom-margin {
    margin-top: 10px;
    margin-bottom: 10px;
  }
  .button-container {
    margin-left: 120px;
  }
  .replyList{
  	width: 50%;
  }
</style>
<head>
<meta charset="UTF-8">
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
                    <p></p><p></p><p></p>
                    <nav class="breadcrumb-container" aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="./index.html">홈</a></li>
                            <li class="breadcrumb-item"><a href="./blog-apps.html">게시판</a></li>
                            <li class="breadcrumb-item active" aria-current="page">공지사항</li>
                        </ol>
                    </nav>
                    <!-- END : Breadcrumb -->
<p></p><p></p><p></p>
                    <h1 class="page-title mb-0 mt-2">공지글 조회</h1>

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
                                <%-- <div class="ms-auto">
                                    <h2>공지글 번호 : ${board.boardNo }</h2>
                                </div> --%>
                            </div>
                            <!-- END : Invoice header -->

                            <!-- Invoice info -->
                            <div class="d-md-flex mt-4">
                                <address class="mb-4 mb-md-0">
                                    <h5 class="mb-2">${board.boardContent }</h5>
                                </address>

                                <ul class="list-group list-group-borderless ms-auto">
                                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-0 pb-1">
                                        <div class="me-5 h5 mb-0">공지번호</div>
                                        <span class="ms-auto text-info fw-bold">${board.boardNo }</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-0 pb-1">
                                        <div class="me-5 h5 mb-0">조회수</div>
                                        <span class="ms-auto text-info fw-bold">${board.inqCnt }</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-0 pb-1">
                                        <div class="me-5 h5 mb-0">작성자</div>
                                        <span>${board.employee.empName}</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-0 pb-1">
                                        <div class="me-5 h5 mb-0">공지일</div>
                                        <span class="ms-auto">${board.regDate }</span>
                                    </li>
                                </ul>
                            </div>
                            <!-- END : Invoice info -->

                            <!-- Footer information -->
                            <div class="bg-light p-3 rounded bg-opacity-50 mt-5">
                                <c:forEach items="${boardAttachList }" var="boardAttach">
	                                <p class="mb-3">
	                                	첨부파일 : ${boardAttach.fileName }
	                                	<button type="button" class="btn btn-primary btn-sm fileDownload" 
											data-file-no="${boardAttach.fileNo }">
											download 
										</button>
                                	</p>
                                </c:forEach>
                            </div>
                            <!-- END : Footer information -->
                        </div>
                        </div>
                        
                        <p></p>
  	<div align="left" class="button-container">
        <input type="button" class="btn btn-primary rounded-pill me-2" id="updateBtn" value="수정하기" th:if="${not isAdmin}"/>
        <input type="button" class="btn btn-primary rounded-pill me-2" id="deleteBtn" value="삭제하기" th:if="${not isAdmin}"/>
   	    <input type="button" class="btn btn-primary rounded-pill" id="listBtn" value="목록으로"/>
	</div>


	
				<p></p>
                        
<%--                                 <div class="card mb-3">
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
				<c:forEach items="${replyList }" var="reply">
					<tr>
						<td>${reply.replyNo}</td>
						<td>${reply.empNo}</td>
						<td>${reply.replyContent}</td>
						<td>${reply.regDate}</td>
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
                    </div> --%>

				<p></p>

                    <!-- Submit comment form -->
<%--                     <div class="card mb-3">
                        <div class="card-body">

                            <h5 class="card-title">댓글 작성</h5>
							<form class="mt-4 row" action="/notice/noticeReplyInsert" method="post" id="insertReplyForm">
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
                    </div> --%>
                    <!-- END : Submit comment form -->
                   

                    
                </div>
            </div>
            </section>
            </div>
</body>
            
<body>         
	<form action="/notice/delete" method="post" id="delForm">
		<input type="hidden" name="boardNo" value="${board.boardNo }"/>
		<sec:csrfInput />
	</form>
</body>  

<script type="text/javascript">
var isAdmin = ${isAdmin}; // 서버 측에서 전달되는 isAdmin 변수가 불리언 값으로 가정됩니다.

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
	var updateBtn = $("#updateBtn");
	var deleteBtn = $("#deleteBtn");
	var listBtn = $("#listBtn");
	var delForm = $("#delForm");

	updateBtn.on("click", function(){
		if(isAdmin){
			delForm.prop("method", "get");
			delForm.prop("action", "/notice/noticeUpdate");
			delForm.submit();
		}else{
			alert("수정 권한이 없습니다.");	
		}
	});

	deleteBtn.on("click", function(){
		if(isAdmin){
			if(confirm("정말로 삭제하시겠습니까?")){
				delForm.submit();
			}else{
				alert("삭제 권한이 없습니다.");
			}
		}else{
			alert("삭제 권한이 없습니다.");
		}
	});

	listBtn.on("click", function(){
		location.href = "/notice/noticeList";
	});
	
	$(".fileDownload").on("click", function(){
		var fileNo = $(this).data("file-no");
		console.log($(this))
		console.log(fileNo)
		location.href = "/notice/download.do?fileNo="+fileNo;
	});
	
});


$(function(){
	var insertReplyForm = $("#insertReplyForm");
	var insertReplyBtn = $("#insertReplyBtn");
	
	insertReplyBtn.on("click", function() {
		var boardReplyContent = $("#boardReplyContent").val();

		if (boardReplyContent == null || boardReplyContent === "") {
			alert("내용을 입력해주세요.");
			return false;
		}

		if ($(this).val() == "수정") {
			insertReplyForm.attr("action", "/reply/update");
		}

		insertReplyForm.submit();
	});
	
});
</script>
</html>





















