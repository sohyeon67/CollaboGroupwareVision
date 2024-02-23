<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<body>
	<div class="content__header content__boxed overlapping">
		<div class="content__wrap">

			<!-- 상위에 표시된 해당 페이지 경로 -->
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb mb-0">
					<li class="breadcrumb-item"><a href="./index.html">홈</a></li>
					<li class="breadcrumb-item"><a href="./blog-apps.html">게시판</a></li>
					<li class="breadcrumb-item active" aria-current="page">공지사항</li>
				</ol>
			</nav>
			<!-- 상위에 표시된 해당 페이지 경로 끝 -->

			<!-- 주제와 설명 -->
			<h1
				class="page-title d-flex flex-wrap just justify-content-center mb-2 mt-4">공지사항</h1>
			<p class="text-center">회사 내 주요 공지를 확인할 수 있는 게시판입니다.</p>
			<!-- 주제와 설명 끝 -->

			<!-- 검색 폼 -->
			<form id="searchForm">
				<input type="hidden" name="page" id="page" />
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
									<c:if test="${searchType eq 'title' }">selected</c:if>>공지 제목</option>
								<option value="content"
									<c:if test="${searchType eq 'content' }">selected</c:if>>공지 내용</option>
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

<%--    <p>일단 넘어온 값 체킁1:${pagingVO}</p>
   <p>일단 넘어온 값 체킁2:${pagingVO.dataList}</p> --%>
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
        <th class="text-center">공지글 번호</th>
        <th class="text-center">공지 제목</th>
        <th class="text-center">작성자</th>
        <th class="text-center">공지 날짜</th>
        <th class="text-center">조회수</th>
    </tr>
</thead>
<!-- 게시판 항목명 끝 -->

<!-- 게시글 -->
<%-- <tbody>
    <c:set value="${pagingVO.dataList}" var="boardList" />
    <c:choose>
        <c:when test="${not empty boardList}">
            <c:forEach items="${boardList}" var="board">
                <tr>
                    <td class="text-center">${board.boardNo}</td>
                    <td class="text-center"><a href="/board/detail?boardNo=${board.boardNo}">${board.boardTitle}</a></td>
                    <td class="text-center">${board.regDate}</td>
                    <td class="text-center">${board.inqCnt}</td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="4">조회하신 공지글이 존재하지 않습니다...</td>
            </tr>
        </c:otherwise>
    </c:choose>
</tbody> --%>
<!-- 게시글 끝 -->

<!-- 게시글 -->
<tbody>
    <c:set value="${pagingVO.dataList}" var="boardList" />
    <c:choose>
        <c:when test="${not empty boardList}">
<c:forEach items="${boardList}" var="board" varStatus="loop">
                <c:if test="${board.boardCode eq 1}">
    <tr>
        <td class="text-center">${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize + loop.index)}</td>
        <td class="text-left"><a href="/notice/detail?boardNo=${board.boardNo}">${board.boardTitle}</a></td>
        <td class="text-center">${board.employee.empName}</td>
        <td class="text-center">${board.regDate}</td>
        <td class="text-center">${board.inqCnt}</td>
    </tr>
                </c:if>
</c:forEach>

        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="4">조회하신 공지글이 존재하지 않습니다...</td>
            </tr>
        </c:otherwise>
    </c:choose>
</tbody>

<!-- 게시글 끝 -->



						</table>
					</div>
					<!-- Thymeleaf 템플릿에서 사용자 권한 확인 부분 -->
					<div class="card-footer" align="right" th:if="${not isAdmin}">
					    <button type="button" class="btn btn-primary rounded-pill" id="addBtn">공지글 등록</button>
					</div>

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
		var isAdmin = ${isAdmin};

		pagingArea.on("click", "a", function(event) {
			event.preventDefault();
			var pageNo = $(this).data("page");
			searchForm.find("#page").val(pageNo);
			searchForm.submit();
		});

		addBtn.on("click", function() {
            if (isAdmin) {
                location.href = "/notice/form";
            } else {
                Swal.fire({
                    icon: 'error',
                    title: '등록 권한 없음',
                    text: '등록 권한이 없습니다.',
                    showConfirmButton: false,
                    timer: 1500
                });
            }
        });
    });
</script>
</html>



























