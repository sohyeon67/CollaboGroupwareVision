<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
#tableDiv {
	min-height: 650px;
	max-height: 650px;
}

#chartDiv {
	width: 250px;
}
</style>

<c:if test="${not empty accessError }">
<script>
Swal.fire({
    icon: 'error',
    title: '접근 오류',
    text: '${accessError }'
});
</script>
</c:if>
<c:if test="${not empty projectCounts }">
	<c:set var="total" value="${projectCounts.TOTAL }"/>
	<c:set var="pending" value="${projectCounts.PENDING }"/>
	<c:set var="ongoing" value="${projectCounts.ONGOING }"/>
	<c:set var="suspended" value="${projectCounts.SUSPENDED }"/>
	<c:set var="completed" value="${projectCounts.COMPLETED }"/>
</c:if>

<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/index">Home</a></li>
				<li class="breadcrumb-item active" aria-current="page">프로젝트</li>
			</ol>
		</nav>
		<br />

	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap order-2 flex-fill min-w-0">
		<div class="card">
			<div class="card-body">
				<div class="row">
					<div class="col-12">
						<h3 class="fw-bold my-3 px-3">참여한 프로젝트 수</h3>
					</div>
					
					<!-- 왼쪽 -->
					<div class="col-xl-3 px-3">
						<div class="row g-sm-1 mb-3 d-flex justify-content-center">
						<div class="display-1 h5 mb-3">${total }</div>
							<div class="col-sm-6">

								<div class="card bg-purple text-white mb-1 mb-xl-1">
									<div class="p-3 text-center">
										<span class="display-6">${pending }</span>
										<p>대기</p>
									</div>
								</div>

								<div class="card bg-warning text-white mb-1 mb-xl-1">
									<div class="p-3 text-center">
										<span class="display-6">${suspended }</span>
										<p>보류</p>
									</div>
								</div>

							</div>
							<div class="col-sm-6">

								<div class="card bg-info text-white mb-1 mb-xl-1">
									<div class="p-3 text-center">
										<span class="display-6">${ongoing }</span>
										<p>진행</p>
									</div>
								</div>

								<div class="card bg-success text-white mb-1 mb-xl-1">
									<div class="p-3 text-center">
										<span class="display-6">${completed }</span>
										<p>완료</p>
									</div>
								</div>

							</div>
							<div class="col-12 mt-3" id="chartDiv">
								<canvas id="myChart"></canvas>
							</div>
						</div>
					</div>

					<!-- 오른쪽 -->
					<div class="col-xl-9 ps-5">

						<div class="table-responsive mw-100" id="tableDiv">
							<table class="table table-striped align-middle">
								<thead>
									<tr>
										<th>상태</th>
										<th>프로젝트 아이디</th>
										<th>프로젝트명</th>
										<th>리더명</th>
										<th class="text-center">인원수</th>
										<th class="text-center">프로젝트 기간</th>
									</tr>
								</thead>
								<tbody>
									<c:set value="${pagingVO.dataList }" var="projectList"/>
									<c:if test="${empty projectList }">
										<tr>
											<td colspan="6">
												<p class="text-center mt-3">참여중인 프로젝트가 없습니다.</p>
											</td>
										</tr>
									</c:if>
									<c:if test="${not empty projectList }">
										<c:forEach items="${projectList }" var="project">
											<tr>
												<td>${project.projectStatus }</td>
												<td>${project.projectId }</td>
												<td><a href="/project/${project.projectId }/overview">${project.projectName }</a></td>
												<td>${project.leaderName }</td>
												<td class="text-center">${project.memCount }</td>
												<td class="text-center">
									                <c:set var="startDate" value="${project.projectStartDay}" />
									                <c:set var="endDate" value="${project.projectEndDay}" />
									                
									                <%-- String to java.util.Date --%>
									                <fmt:parseDate var="parsedStartDate" value="${startDate}" pattern="yyyyMMdd" />
									                <fmt:parseDate var="parsedEndDate" value="${endDate}" pattern="yyyyMMdd" />
									
									                <%-- yyyy-MM-dd --%>
									                <fmt:formatDate value="${parsedStartDate}" pattern="yyyy-MM-dd" /> -
									                <fmt:formatDate value="${parsedEndDate}" pattern="yyyy-MM-dd" />
									            </td>
											</tr>
										</c:forEach>
									</c:if>
								</tbody>
							</table>

							<!-- 페이징 -->
							<nav class="text-align-center my-3" aria-label="Table navigation" id="pagingArea">
								${pagingVO.pagingHTML}
							</nav>

							<!-- 검색 -->
							<form method="post" id="searchForm">
								<div
									class="d-flex flex-wrap align-items-end justify-content-center gap-2 mb-3pb-3 ">
									<div
										class="d-md-flex flex-wrap align-items-center gap-2 mb-3 mb-sm-0">
										<input type="hidden" name="page" id="page"/>
										<select class="form-select w-auto" aria-label="Categories"
											name="projectStatus">
											<option value="">(선택)</option>
											<c:forEach var="map" items="${commonCodes}">
												<c:if test="${map['COMMON_CODE_GROUP_ID'] == '1000'}">
													<option value="${map['COMMON_CODE']}"
														<c:if test="${search.projectStatus eq map['COMMON_CODE']}">selected</c:if>>${map['COMMON_CODE_NAME']}</option>
												</c:if>
											</c:forEach>
										</select>
										<select class="form-select w-auto" aria-label="Categories"
											name="searchType">
											<option value="projectId" <c:if test="${searchType eq 'projectId' }">selected</c:if>>프로젝트 아이디</option>
											<option value="projectName"<c:if test="${searchType eq 'projectName' }">selected</c:if>>프로젝트명</option>
										</select>
									</div>
									<div class="searchbox input-group">
										<input class="searchbox__input form-control"
											name="searchWord" value="${searchWord }" type="search"
											placeholder="검색" aria-label="Search">
										<div class="searchbox__btn-group">
											<button
												class="searchbox__btn btn btn-icon shadow-none border-0 btn-sm"
												type="submit">
												<i class="demo-pli-magnifi-glass"></i>
											</button>
										</div>
	
									</div>
								</div>
								<sec:csrfInput/>
							</form>
							<!-- 검색 끝 -->
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
document.addEventListener("DOMContentLoaded", function() {
	var pagingArea = document.querySelector("#pagingArea");
	var searchForm = document.querySelector("#searchForm");
	
	pagingArea.addEventListener("click", function(event) {
		if(event.target.tagName === 'A') {	// a태그일때
			event.preventDefault();
			var pageNo = event.target.dataset.page;
			searchForm.querySelector("#page").value = pageNo;
			searchForm.submit();
		}
	});
	
	const ctx = document.querySelector('#myChart');
	var myChartApi = new Chart(ctx, {
		type: 'pie',
        data: {
            labels: ['대기', '진행', '보류', '완료'],
            datasets: [
                {
                    label: '내 프로젝트 수',
                    data: ["${pending}", "${ongoing}", "${suspended}", "${completed}"],
                    backgroundColor: ['rgba(170,90,240,0.75)', 'rgba(90,165,255,0.75)', 'rgba(255,180,50,0.75)', 'rgba(100,210,80,0.75)']
                }
            ]
        }
	});
});


</script>