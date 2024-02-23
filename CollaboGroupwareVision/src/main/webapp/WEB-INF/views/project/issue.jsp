<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
.progress {
	height: 20px;
	font-size: 0.8rem;
}

#issueListDiv td {
	vertical-align: middle;
}

#searchForm * {
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

<!-- 프로젝트 일감 등록 모달 -->
<jsp:include page="./issueFormModal.jsp">
	<jsp:param name="from" value="user" />
</jsp:include>


<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/index">Home</a></li>
				<li class="breadcrumb-item"><a href="/project">프로젝트</a></li>
				<li class="breadcrumb-item active" aria-current="page">${project.projectName }</li>
			</ol>
		</nav>
		<br />

	</div>

</div>

<div class="content__boxed">
	<div class="content__wrap order-2 flex-fill min-w-0">

		<div class="tab-base mb-3">
			<ul class="nav nav-tabs" role="tablist">
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/overview"
					class="fs-5 nav-link">개요</a></li>
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/issue"
					class="fs-5 nav-link active">일감</a></li>
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/ganttChart"
					class="fs-5 nav-link">간트차트</a></li>
			</ul>
			<div class="tab-content">
				<div class="row">
					<div class="col-md-6 ">
						<h3 class="fw-bold mt-2 mb-3">
							<i class="ti-pencil-alt me-2"></i>일감목록
						</h3>
					</div>

					<div class="col-md-6 d-flex justify-content-end">
						<div
							class="d-flex flex-wrap gap-1 align-items-center justify-content-center">
							<button onclick="issueFormModalOpen()"
								class="btn btn-info btn-lg">
								<i class="ti-pencil"></i> 일감등록
							</button>
						</div>
					</div>
				</div>

				<!-- 검색 -->
				<form method="post" id="searchForm">
					<input type="hidden" name="page" id="page" />

					<div class="border py-3 px-5 mb-3">
						<div class="row mb-2 d-flex justify-content-center">
							<div class="col-md-3">
								<label for="issueType" class="form-label">유형</label> <select
									id="issueType" name="issueType" class="form-select"
									aria-label="Categories">
									<option value="">(선택)</option>
									<c:forEach var="map" items="${commonCodes}">
										<c:if test="${map['COMMON_CODE_GROUP_ID'] == '901'}">
											<option value="${map['COMMON_CODE']}"
												<c:if test="${search.issueType eq map['COMMON_CODE']}">selected</c:if>>${map['COMMON_CODE_NAME']}</option>
										</c:if>
									</c:forEach>
								</select>
							</div>

							<div class="col-md-3">
								<label for="issueStatus" class="form-label">상태</label> <select
									id="issueStatus" name="issueStatus" class="form-select"
									aria-label="Categories">
									<option value="">(선택)</option>
									<c:forEach var="map" items="${commonCodes}">
										<c:if test="${map['COMMON_CODE_GROUP_ID'] == '902'}">
											<option value="${map['COMMON_CODE']}"
												<c:if test="${search.issueStatus eq map['COMMON_CODE']}">selected</c:if>>${map['COMMON_CODE_NAME']}</option>
										</c:if>
									</c:forEach>
								</select>
							</div>

							<div class="col-md-3">
								<label for="issuePriority" class="form-label">우선순위</label> <select
									id="issuePriority" name="issuePriority" class="form-select"
									aria-label="Categories">
									<option value="">(선택)</option>
									<c:forEach var="map" items="${commonCodes}">
										<c:if test="${map['COMMON_CODE_GROUP_ID'] == '900'}">
											<option value="${map['COMMON_CODE']}"
												<c:if test="${search.issuePriority eq map['COMMON_CODE']}">selected</c:if>>${map['COMMON_CODE_NAME']}</option>
										</c:if>
									</c:forEach>
								</select>
							</div>

						</div>

						<div class="row mb-3 d-flex justify-content-center align-items-end">
							<div class="col-md-3">
								<c:set var="memList" value="${project.projectMemList}" />
								<label for="issueCharger" class="form-label">담당자</label> <select
									id="issueCharger" name="issueCharger" class="form-select"
									aria-label="Categories">
									<option value="">(선택)</option>
									<c:forEach items="${memList}" var="mem">
										<option value="${mem.empNo}" <c:if test="${search.issueCharger eq mem.empNo}">selected</c:if>>${mem.empName}</option>
									</c:forEach>
								</select>
							</div>

							<div class="col-md-4">
								<label for="issueTitle" class="form-label">제목</label> <input
									class="form-control" id="issueTitle"
									name="issueTitle" value="${search.issueTitle}" type="search"
									placeholder="검색" aria-label="Search">
							</div>

							<div class="col-md-2">
								<button class="btn btn-lg btn-secondary" type="submit">
									검색
								</button>
							</div>
						</div>

					</div>

					<sec:csrfInput />
				</form>
				<!-- 검색 끝 -->



				<div id="issueListDiv" class="table-responsive">
					<table class="table table-striped">
						<thead>
							<tr>
								<th>#</th>
								<th>유형</th>
								<th>상태</th>
								<th>우선순위</th>
								<th>제목</th>
								<th class="text-center">담당자</th>
								<th class="text-center">진척도</th>
								<th class="text-center">종료일</th>
							</tr>
						</thead>
						<tbody>
							<c:set value="${pagingVO.dataList }" var="issueList" />
							<c:if test="${empty issueList }">
								<tr>
									<td colspan="8">
										<p class="text-center mt-3">일감이 존재하지 않습니다.</p>
									</td>
								</tr>
							</c:if>
							<c:if test="${not empty issueList }">
								<c:forEach items="${issueList }" var="issue">
									<tr>
										<td>${issue.issueNo }</td>
										<td>${issue.type }</td>
										<td>${issue.status }</td>
										<td>${issue.priority }</td>
										<td><a href="/project/issue/${issue.issueNo }"><c:out
													value="${issue.issueTitle }" /></a></td>
										<td class="text-center"><img
											class="img-sm rounded-circle" alt="profile"
											src="${issue.issueChargerProfile }"
											style="object-fit: contain;"> ${issue.issueChargerName }</td>
										<td class="text-center">
											<div class="progress">
												<div
													class="progress-bar progress-bar 
									                <c:if test="${issue.issueProgress < 25}">bg-success</c:if>
									                <c:if test="${issue.issueProgress >= 25 && issue.issueProgress < 50}">bg-info</c:if>
									                <c:if test="${issue.issueProgress >= 50 && issue.issueProgress < 75}">bg-warning</c:if>
									                <c:if test="${issue.issueProgress >= 75}">bg-danger</c:if>"
													role="progressbar" style="width: ${issue.issueProgress}%"
													aria-valuenow="${issue.issueProgress}" aria-valuemin="0"
													aria-valuemax="100">${issue.issueProgress }%</div>
											</div>
										</td>
										<td class="text-center"><fmt:parseDate var="parsedEndDay"
												value="${issue.issueEndDay}" pattern="yyyyMMdd" /> <c:if
												test="${empty parsedEndDay }">
												-
											</c:if> <c:if test="${not empty parsedEndDay }">
												<fmt:formatDate value="${parsedEndDay}" pattern="yyyy-MM-dd" />
											</c:if></td>
									</tr>
								</c:forEach>
							</c:if>


						</tbody>
					</table>
				</div>

				<!-- 페이징 -->
				<nav class="text-align-center mb-3" aria-label="Table navigation"
					id="pagingArea">${pagingVO.pagingHTML}</nav>
			</div>
		</div>


	</div>
</div>
<script>
	$(function() {
		var pagingArea = $("#pagingArea");
		var searchForm = $("#searchForm");

		pagingArea.on("click", "a", function(event) {
			event.preventDefault();
			var pageNo = $(this).data("page");
			searchForm.find("#page").val(pageNo);
			searchForm.submit();
		});
	});
</script>