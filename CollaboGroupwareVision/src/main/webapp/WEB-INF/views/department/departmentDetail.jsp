<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.userdetails.UserDetails" %>
<c:if test="${not empty pageContext.request.userPrincipal}">
    <c:set var="loggedInEmpNo" value="${pageContext.request.userPrincipal.name}" />
</c:if>

<c:if test="${empty pageContext.request.userPrincipal}">
    <%-- 로그인하지 않은 경우에 대한 처리 --%>
    <p>로그인이 필요합니다.</p>
</c:if>

<spring:message code="message" var="flashMessage"/>
<c:if test="${not empty flashMessage}">
    <div class="alert alert-info">${flashMessage}</div>
</c:if>
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
                            <li class="breadcrumb-item active" aria-current="page">부서게시판</li>
                        </ol>
                    </nav>
                    <!-- END : Breadcrumb -->

                    <h1 class="page-title mb-0 mt-2">부서게시글 조회</h1>

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

                            <!-- Footer information -->
                            <div class="bg-light p-3 rounded bg-opacity-50 mt-5">
                                <c:forEach items="${boardAttachList }" var="boardAttach">
	                                <p class="mb-3">첨부파일 : ${boardAttach.fileName }</p>
	                                <p class="mb-0 text-xs font-weight-bolder text-info text-uppercase">
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
                        
  	<div align="left">
		<c:if test="${not empty loggedInEmpNo and loggedInEmpNo eq board.empNo}">
		    <!-- 수정 및 삭제 버튼을 보여줄 내용 -->
		    <input type="button" class="btn btn-primary rounded-pill" id="updateBtn" value="수정하기"/>
		    <input type="button" class="btn btn-primary rounded-pill" id="deleteBtn" value="삭제하기"/>
		</c:if>
		<input type="button" class="btn btn-primary rounded-pill" id="listBtn" value="부서별 선택화면으로"/>
	</div>
	

	
	
				<p></p>
                        
 <%--                    <div class="card mb-3">
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
				<c:forEach items="${replyList}" var="reply">
			    <tr>
			        <td>${reply.replyNo}</td>
			        <td>${reply.empNo}</td>
			        <td>${reply.replyContent}</td>
			        <td>${reply.regDate}</td>
			        <td>
			        <c:if test="${not empty loggedInEmpNo and loggedInEmpNo eq reply.empNo}">
			            <button type="button" class="btn btn-danger rounded-pill deleteReplyBtn" 
			            	id="deleteReplyBtn" data-replyNo="${reply.replyNo}">삭제</button>
	            	</c:if>
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
							<form class="mt-4 row" action="/department/replyInsert" method="post" id="insertReplyForm">
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
                    <!-- END : Submit comment form --> --%>
                   

                    
                </div>
            </div>
            </section>
            </div>
</body>
            
<body>         
	<form action="/department/departmentDelete" method="post" id="delForm">
		<input type="hidden" name="boardNo" value="${board.boardNo }"/>
		<sec:csrfInput />
	</form>
</body>  

<body>         
	<form action="/department/replyDelete" method="post" id="delReplyForm">
		<input type="hidden" name="replyNo" value="${reply.replyNo }"/>
		<sec:csrfInput />
	</form>
</body> 

<script type="text/javascript">
$(function reloadDivArea(){
	console.log(location.href+' #replyList');
	$('#replyList').load(location.href+' #replyList');
});

$(function(){
	var updateBtn = $("#updateBtn")
	var deleteBtn = $("#deleteBtn")
	var listBtn = $("#listBtn")
	var delForm = $("#delForm")
	
	updateBtn.on("click", function(){
		
		delForm.prop("method", "get");
	    delForm.prop("action", "/department/departmentUpdate");
	    delForm.submit();
	});
	
	deleteBtn.on("click", function(){
		if(confirm("정말로 삭제하시겠습니까?")){
			delForm.submit();
		}
	});
	
	listBtn.on("click", function(){
		location.href = "/department/departmentList";
	});
	
	$(".fileDownload").on("click", function(){
		var fileNo = $(this).data("file-no");
		console.log($(this))
		console.log(fileNo)
		location.href = "/department/departmentDownload.do?fileNo="+fileNo;
	});
	
});

$(function(){
	var insertReplyForm = $("#insertReplyForm");
	var insertReplyBtn = $("#insertReplyBtn");
	
	var deleteReplyBtn = $(".deleteReplyBtn")
	var delReplyForm = $("#delReplyForm");
	
    var csrfToken = $("meta[name='_csrf']").attr("content");
    var csrfHeader = $("meta[name='_csrf_header']").attr("content");
	
	insertReplyBtn.on("click", function() {
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
	});
	    
    deleteReplyBtn.on("click", function(){
        var replyNo = parseInt($(this)[0].dataset.replyno);
        console.log(replyNo);
        if (confirm("정말로 삭제하시겠습니까?")) {
        	var data = { replyNo: replyNo }; 
        	
            $.ajax({
                type: "POST",
                url: "/department/replyDelete",
                data: JSON.stringify(data),
                contentType : "application/json;charset=utf-8",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function(response) {
                	console.log(response)
                	console.log(11111111111)
                	window.location.reload()
                },
                error: function(error) {
                    console.error("댓글 삭제 실패: ", error);
                }
            });
        }
    });
    
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





















