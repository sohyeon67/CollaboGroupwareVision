<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
#chartDiv {
    width: 100%;
}
#myChart {
	width: 85% !important;
	height: 85% !important;
}

.memListTr {
	vertical-align: middle;
	font-size: 0.8rem;
}

#memListDiv {
	min-height: 400px;
	max-height: 400px;
}

#issueCard, #memListCard {
	min-height: 500px;
	max-height: 500px;
}

.btnList {
	z-index: 1000;
}
</style>

<c:if test="${not empty resultMsg }">
	<script>
		alertSuccess('${resultMsg }');
	</script>
</c:if>

<!-- 프로젝트 수정 모달 -->
<jsp:include page="./projectFormModal.jsp">	
	<jsp:param name="from" value="user"/>	
</jsp:include>


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
	
		<div class="tab-base mb-3">
			<ul class="nav nav-tabs" role="tablist">
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/overview"
					class="fs-5 nav-link active">개요</a></li>
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/issue"
					class="fs-5 nav-link">일감</a></li>
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/ganttChart"
					class="fs-5 nav-link">간트차트</a></li>
			</ul>
			<div class="tab-content">
				<div class="col-12">
					<h3 class="fw-bold mt-2">${project.projectName }</h3>
					<%-- String to java.util.Date --%>
			        <fmt:parseDate var="parsedStartDate" value="${project.projectStartDay}" pattern="yyyyMMdd" />
			        <fmt:parseDate var="parsedEndDate" value="${project.projectEndDay}" pattern="yyyyMMdd" />
			
			        <%-- yyyy-MM-dd --%>
			        <div class="fs-4 mb-3">
				        <fmt:formatDate value="${parsedStartDate}" pattern="yyyy-MM-dd" /> -
				        <fmt:formatDate value="${parsedEndDate}" pattern="yyyy-MM-dd" />
					</div>
					<p class="fs-5" id="description">
						<c:out value="${project.projectDescription }" />
					</p>
				</div>
			</div>
		</div>
		
		
		<div class="row">
			<div class="col-md-7">
				<div class="card" id="issueCard">
					<div class="card-body">
						<h3 class="fw-bold my-3"><i class="ti-pie-chart me-2"></i>담당자별 일감통계</h3>

						<div class="mt-3 p-3 d-flex justify-content-center" id="chartDiv">
							<canvas id="myChart"></canvas>
						</div>
					</div>
				</div>
			</div>
			
			<div class="col-md-5">
				<div class="card" id="memListCard">
					<div class="card-body">
						<h3 class="fw-bold my-3"><i class="ti-id-badge me-2"></i>구성원</h3>

						<div id="memListDiv" class="table-responsive overflow-scroll scrollable-content">
							<table class="table table-hover text-center">
								<thead>
									<tr>
										<th>프로필</th>
										<th>사번</th>
										<th>이름</th>
										<th>부서</th>
										<th>직위</th>
										<th>리더/팀원</th>
									</tr>
								</thead>
								<tbody>
									<c:if test="${not empty project.projectMemList }">
										<c:set var="memList" value="${project.projectMemList }"/>
										<c:forEach items="${memList }" var="mem">
											<tr class="memListTr">
												<td><img class="img-md" src="${mem.profileImgPath }" alt="profile" style="object-fit: contain;"></td>
												<td>${mem.empNo }</td>
												<td>${mem.empName }</td>
												<td>${mem.deptName }</td>
												<td>${mem.position }</td>
												<td>
													<c:if test="${mem.leaderYn eq 'Y' }">리더</c:if>
													<c:if test="${mem.leaderYn ne 'Y' }">팀원</c:if>
												</td>
											</tr>
										</c:forEach>
									</c:if>
								</tbody>
							</table>
						</div>

					</div>
				</div>
			</div>
			
			<!-- 버튼 -->
			<div class="mt-3 col-12 gap-1 d-flex justify-content-center btnList">
				<!-- 리더만 보이도록 나중에 바꾸기 -->
				<button type="button" onclick="projectEditFormModalOpen('${project.projectId}')" class="btn btn-danger btn-lg">수정</button>
				<a href="/project" class="btn btn-dark btn-lg">목록</a>
			</div>
			
		</div>
	</div>
</div>
<script>
var labels;
var issueCounts;
var avgProgress;

document.addEventListener("DOMContentLoaded", async () => {
	
    // 담당자별 일감 통계 그래프 출력
    try {
    	const response = await fetch(`/project/${project.projectId}/issueMetrics.json`);
    	if(!response.ok) throw new Error("서버 응답 오류");
    	
    	const rslt = await response.json();
    	labels = rslt.map(item => item.ISSUE_CHARGER_NAME);
        issueCounts = rslt.map(item => item.ISSUE_COUNT);
        avgProgress = rslt.map(item => item.AVG_PROGRESS);
        
        drawChart();
    } catch (error) {
    	alertError("일감 통계 데이터 로드 실패");
    }
});


//차트 데이터를 받아와 차트를 그리는 함수
function drawChart() {
    const ctx = document.querySelector('#myChart');
    var myChartApi = new Chart(ctx, {
        data: {
            labels: labels,
            datasets: [
                {
                    type: 'bar',
                    label: '일감수',
                    data: issueCounts, 
                    backgroundColor: 'rgba(90,165,255,0.75)'
                },
                {
                    type: 'line',
                    label: '완료율',
                    data: avgProgress,
                    backgroundColor: 'rgba(255,180,50,0.75)'
                }
            ]
        },
        
    });
}
</script>