<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<body>
	<div class="content__header content__boxed overlapping">
		<div class="content__wrap">

			<!-- 상위에 표시된 해당 페이지 경로 -->
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb mb-0">
					<li class="breadcrumb-item"><a href="./index.html">홈</a></li>
					<li class="breadcrumb-item"><a href="./blog-apps.html">게시판</a></li>
					<li class="breadcrumb-item active" aria-current="page">부서게시판</li>
				</ol>
			</nav>
			<!-- 상위에 표시된 해당 페이지 경로 끝 -->

			<!-- 주제와 설명 -->
			<h1 class="page-title d-flex flex-wrap just justify-content-center mb-2 mt-4">부서게시판</h1>
			<p class="text-center">자신이 속한 부서의 게시판입니다.</p>
			<!-- 주제와 설명 끝 -->
    </div>
</div>
<div class="content__boxed">
    <div class="content__wrap">
    	<div class="row">
			<!-- 검색 폼 -->
			<form id="searchForm">
				<input type="hidden" name="page" id="page" />
				<input type="hidden" name="code" value="${pagingVO.deptCode }"/>
				<div class="col-md-8 offset-md-2 mb-3">
					<div
						class="d-flex flex-wrap align-items-end justify-content-center gap-2 mb-3 pb-3">
						<div
							class="d-md-flex flex-wrap align-items-center gap-2 mb-3 mb-sm-0">
							<div class="text-center mb-2 mb-md-0">항목별 검색</div>
							<select class="form-select w-auto" aria-label="Categories"
								name="searchType">
								<!-- 	                                <option value="none">-항목 선택-</option> -->
								<option value="title"
									<c:if test="${searchType eq 'title' }">selected</c:if>>제목</option>
								<option value="writer"
									<c:if test="${searchType eq 'writer' }">selected</c:if>>작성자</option>
								<option value="content"
									<c:if test="${searchType eq 'content' }">selected</c:if>>내용</option>
							</select>
						</div>
						<div class="searchbox input-group">
							<input class="searchbox__input form-control form-control-lg"
								name="searchWord" value="${searchWord }" type="search"
								placeholder="Search posts. . ." aria-label="Search">
							<div class="searchbox__btn-group">
								<button
									class="searchbox__btn btn btn-icon shadow-none border-0 btn-sm"
									type="submit">
									<i class="demo-pli-magnifi-glass"></i>
								</button>
							</div>
						</div>
						<button class="btn btn-light mb-3 mb-sm-0">검색</button>
					</div>
				</div>
				<!-- 검색 폼 끝 -->
				<sec:csrfInput />
			</form>
		</div>
	</div>
</div>

	<!-- 메인 목록 -->
	<div class="content__boxed">
		<div class="content__wrap">
			<div class="card">
				<div class="card-body">

					<!-- 게시판 목록 -->
					<div class="table-responsive">
						<table class="table table-striped align-middle">

							<!-- 게시판 항목명 -->
							<thead>
								<tr>
									<th class="text-center">사진 미리보기</th>
									<th class="text-center">게시글번호</th>
									<th class="text-center">제목</th>
									<th class="text-center">작성자</th>
									<th class="text-center">작성날짜</th>
									<th class="text-center">조회수</th>
								</tr>
							</thead>
							<!-- 게시판 항목명 끝 -->
							
<%-- <p>코드 넘어오나? ${deptCode }</p> --%>

							<!-- 게시글 -->
							<tbody>
								<c:set value="${pagingVO.dataList }" var="boardList" />
								<%-- <c:if test="${employee.deptCode eq board.employee.deptCode}"> --%>
								<c:choose>
									
									<c:when test="${empty boardList }">
										<tr>
											<td colspan="5">조회하신 게시글이 존재하지 않습니다...</td>
										</tr>
									</c:when>
									<c:otherwise>
										<c:forEach items="${boardList }" var="board" varStatus="loop">
											<tr>
												<td class="text-center">
												<c:if test="${not empty boardAttachList }">
												<c:set var="firstImage" value="${false}" />
													<c:forEach items="${boardAttachList }" var="item">
														<c:if test="${board.boardNo eq item.boardNo and not firstImage}">
														    <c:choose>
																<c:when test="${fn:split(item.fileMimetype, '/')[0] eq 'image' }">
																	<img class="img-sm rounded" src="${pageContext.request.contextPath }/resources/free/${board.boardNo}/${fn:split(item.fileSavepath, '/')[1]}"/>	
																	<c:set var="firstImage" value="${true}" />
																</c:when>
																<c:otherwise>
																	<img class="img-sm rounded" src="${pageContext.request.contextPath}/resources/assets/img/megamenu/img-4.jpg" alt="이미지 아닐때">
																	<c:set var="firstImage" value="${true}" />
																</c:otherwise> 
															</c:choose>
														</c:if>
													</c:forEach>
												</c:if>
												</td>
												<td class="text-center">${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize + loop.index)}</td>
												<td class="text-left">
												<a href="/department/departmentDetail?boardNo=${board.boardNo }">${board.boardTitle}</a>
												</td>
												<td class="text-center">${board.employee.empName}</td>
												<td class="text-center">${board.regDate}</td>
												<td class="text-center">${board.inqCnt}</td>
											</tr>
										</c:forEach>
									</c:otherwise>
								</c:choose>
								<%-- </c:if> --%>
							</tbody>
							<!-- 게시글 끝 -->
							
						</table>
					</div>
					<!-- <div class="card-footer" align="right">
						<button type="button" class="btn btn-primary rounded-pill"
							id="addBtn">자유게시글 등록</button>
					</div> -->
					<%-- <div class="card-footer clearfix" id="pagingArea">
                            	${paging.pagingHTML }
                            </div> --%>
					<!-- 게시판 목록 끝 -->

					<!-- 페이지 숫자목록 조회 -->
					<div class="mt-4 d-flex justify-content-center" id="pagingArea">
						${pagingVO.pagingHTML }</div>
					<!-- 페이지 숫자목록 조회 끝 -->

				</div>
			</div>

		</div>
	</div>

	<!-- 메인 목록 끝 -->

</body>
<script type="text/javascript">
	$(function() {
		var pagingArea = $("#pagingArea");
		var searchForm = $("#searchForm");
		var addBtn = $("#addBtn");

		pagingArea.on("click", "a", function(event) {
			event.preventDefault();
			var pageNo = $(this).data("page");
			searchForm.find("#page").val(pageNo);
			searchForm.submit();
		});

		addBtn.on("click", function() {
			location.href = "/board/form";
		});
	});
</script>
</html>



























