<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<style>
.progress {
	height: 20px;
	font-size: 0.8rem;
}
</style>

<c:if test="${not empty successMsg }">
<script>
	Swal.fire({
		icon : 'success',
		title : '성공',
		text : '${successMsg }'
	});
</script>
</c:if>
<c:if test="${not empty errorMsg }">
<script>
	Swal.fire({
		icon : 'error',
		title : '실패',
		text : '${errorMsg }'
	});
</script>
</c:if>

<!-- 프로젝트 일감 수정 모달 -->
<jsp:include page="./issueFormModal.jsp"></jsp:include>

<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/index">Home</a></li>
				<li class="breadcrumb-item"><a href="/project">프로젝트</a></li>
				<li class="breadcrumb-item active" aria-current="page">${project.projectName }</li>
			</ol>
		</nav>
		<!-- Breadcrumb 끝-->
		<br />

	</div>

</div>


<div class="content__boxed">
	<div class="content__wrap order-2 flex-fill min-w-0">
		<ul class="nav nav-tabs" role="tablist">
			<li class="nav-item" role="presentation"><a
				href="/project/${project.projectId }/overview" class="fs-5 nav-link">개요</a></li>
			<li class="nav-item" role="presentation"><a
				href="/project/${project.projectId }/issue"
				class="fs-5 nav-link active">일감</a></li>
			<li class="nav-item" role="presentation"><a
				href="/project/${project.projectId }/ganttChart"
				class="fs-5 nav-link">간트차트</a></li>
		</ul>

		<div class="row">
			<!-- 왼쪽 -->
			<div class="tab-base col-xl-7 mb-3 mb-xl-0">
				<div class="tab-content h-100">
					<h3 class="fw-bold my-3"><i class="ti-bookmark-alt"></i> 상세정보</h3>

					<table class="table table-bordered">
						<tbody>
							<tr>
								<th style="width: 20%;">일감번호</th>
								<td>${issue.issueNo }</td>
							</tr>
							<tr>
								<td class="fw-bold">유형</td>
								<td>${issue.type }</td>
							</tr>
							<tr>
								<td class="fw-bold">일감명</td>
								<td><c:out value="${issue.issueTitle }"/></td>
							</tr>
							<tr>
								<td class="fw-bold">우선순위</td>
								<td>${issue.priority }</td>
							</tr>
							<tr>
								<td class="fw-bold">상태</td>
								<td>${issue.status }</td>
							</tr>
							<tr>
								<td class="fw-bold">작성자</td>
								<td>${issue.issueWriter }</td>
							</tr>
							<tr>
								<td class="fw-bold">등록일</td>
								<td>${issue.issueRegDate }</td>
							</tr>
							<tr>
								<td class="fw-bold">시작일</td>
								<td>
									<fmt:parseDate var="parsedStartDay" value="${issue.issueStartDay}" pattern="yyyyMMdd" />
									<fmt:formatDate value="${parsedStartDay}" pattern="yyyy-MM-dd" />
								</td>
							</tr>
							<tr>
								<td class="fw-bold">종료일</td>
								<td>
									<fmt:parseDate var="parsedEndDay" value="${issue.issueEndDay}" pattern="yyyyMMdd" />
									<fmt:formatDate value="${parsedEndDay}" pattern="yyyy-MM-dd" />
								</td>
							</tr>
							<tr>
								<td class="fw-bold">담당자</td>
								<td><img class="img-sm rounded-circle" alt="profile" src="${issue.issueChargerProfile }" style="object-fit: contain;"> ${issue.issueChargerName }</td>
							</tr>
							<tr>
								<td class="fw-bold">진척도</td>
								<td>
									<div class="progress">
									    <div class="progress-bar progress-bar 
							                <c:if test="${issue.issueProgress < 25}">bg-success</c:if>
							                <c:if test="${issue.issueProgress >= 25 && issue.issueProgress < 50}">bg-info</c:if>
							                <c:if test="${issue.issueProgress >= 50 && issue.issueProgress < 75}">bg-warning</c:if>
							                <c:if test="${issue.issueProgress >= 75}">bg-danger</c:if>" 
									         role="progressbar" 
									         style="width: ${issue.issueProgress}%" 
									         aria-valuenow="${issue.issueProgress}" 
									         aria-valuemin="0" 
									         aria-valuemax="100">
									        ${issue.issueProgress }%
									    </div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<!-- 오른쪽 -->
			<div class="col-xl-5">
				<div class="row">
					<!-- 내용 -->
					<div class="col-md-12">
						<div class="card">
							<div class="card-body">
								<h3 class="fw-bold my-3"><i class="ti-menu-alt"></i> 내용</h3>
								<c:if test="${empty issue.issueContent }">
									<p>내용이 존재하지 않습니다.</p>
								</c:if>
								<c:if test="${not empty issue.issueContent }">
									${issue.issueContent }
								</c:if>
							</div>
						</div>
					</div>

					<!-- 첨부파일 -->
					<div class="col-md-12 mt-3">
						<div class="card">
							<div class="card-body">
								<h3 class="fw-bold my-3"><i class="ti-save"></i> 첨부파일</h3>
								<c:set var="issueAttachList" value="${issue.issueAttachList }"/>
								<div class="table-responsive">
									<table class="table">
										<thead></thead>
										<tbody>
											<c:choose>
												<c:when test="${empty issueAttachList[0].issueFileName }">
													<p>첨부파일이 존재하지 않습니다.</p>
												</c:when>
												<c:otherwise>
													<c:forEach items="${issueAttachList}" var="attach">
														<tr>
															<td><i class="ti-file"></i> <a href="/downloadFile?savePath=${attach.issueFileSavepath}">${attach.issueFileName}</a></td>
															<td class="text-end">${attach.issueFileFancysize}</td>
														</tr>
													</c:forEach>
												</c:otherwise>
											</c:choose>
										</tbody>
									</table>
								</div>
								
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		
		<form id="delForm" method="post" action="/project/issue/delete">
			<input type="hidden" name="projectId" value="${issue.projectId }"/>
			<input type="hidden" name="issueNo" value="${issue.issueNo }"/>
			<sec:csrfInput/>
		</form>

		<!-- 버튼 -->
		<div class="col-12 gap-1 pt-3 d-flex justify-content-center">
			<button type="button"
				onclick="issueEditFormModalOpen()"
				class="btn btn-success btn-lg">수정</button>
			<button type="button" id="delBtn" class="btn btn-danger btn-lg">삭제</button>
			<a href="/project/${issue.projectId }/issue" class="btn btn-dark btn-lg">목록</a>
		</div>
	</div>
</div>
<script>
$(function() {
	var delForm = $("#delForm");
	var delBtn = $("#delBtn");
	
	delBtn.on("click", function() {
		Swal.fire({
	        icon: 'warning',
	        html: '<h3 class="fw-bold">해당 일감을 삭제하시겠습니까?</h3><p>(삭제된 일감은 복구할 수 없습니다.)</p>',
	       	showCancelButton: true,
		        confirmButtonText: '확인',
		        cancelButtonText: '취소',
	    }).then((result) => {
	    	if(result.isConfirmed) {
				delForm.submit();
	    	}
	    });
	});
});
</script>