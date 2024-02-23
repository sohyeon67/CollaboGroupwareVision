<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script
	src="https://cdn.jsdelivr.net/npm/ag-grid-enterprise/dist/ag-grid-enterprise.min.js"></script>
<style>
#gridWrapper {
	height: 650px;
}

#myGrid {
	width: 100%;
	height: 100%;
}

</style>

<c:if test="${not empty resultMsg }">
<script>
Swal.fire({
    icon: 'success',
    title: '성공',
    text: '${resultMsg }'
});
</script>
</c:if>

<!-- 프로젝트 생성 모달 -->
<jsp:include page="./projectFormModal.jsp">	
	<jsp:param name="from" value="admin"/>
</jsp:include>

<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/index">Home</a></li>
				<li class="breadcrumb-item active" aria-current="page">프로젝트 관리</li>
			</ol>
		</nav>
		<br />

	</div>

</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card">
			<div class="card-body">

				<!-- 본문 -->
				<div class="row d-flex align-items-center flex-fill min-w-0"
					style="min-height: 750px; max-height: 750px;">
					<div class="col-md-6 ">
						<span class="fs-3 ps-3 mt-3 fw-bold text-primary">프로젝트 관리</span>
					</div>
					<!-- toolbar -->
					<div class="col-md-6 d-flex justify-content-end">
						<div
							class="d-flex flex-wrap gap-1 align-items-center justify-content-center">
							<button onclick="projectFormModalOpen()"
								class="btn btn-outline-info btn-lg">
								<i class="ti-plus me-1"></i> 프로젝트 생성
							</button>
						</div>
					</div>
					<!-- toolbar 끝 -->


					<!-- 부서 임시 삭제 리스트 -->
					<div id="gridWrapper" class="align-items-center">
						<div id="myGrid" class="ag-theme-alpine"></div>
					</div>
					<!-- 부서 임시 삭제 리스트 끝 -->

				</div>
				<!-- 본문 끝 -->

			</div>
		</div>
	</div>
</div>



<script>
var gridApi;		// AG Grid API 객체
var hardDelBtn;		// 부서 영구삭제 버튼
var recoveryBtn;	// 부서 복구 버튼
var flag;			// dept인지 emp인지

// 컬럼들 정의
const columnDefs = [
	{ field: "projectId",  headerName:"프로젝트 아이디" },
	{ field: "projectStatus",  headerName:"상태" },
	{ field: "projectName",  headerName:"프로젝트명" },
	{ field: "leaderName",  headerName:"리더명" },
	{ field: "memCount",  headerName:"인원수" },
	{ field: "projectStartDay", headerName:"시작일" },
	{ field: "projectEndDay", headerName:"종료일" },
	{ headerName: "수정", width: 100, cellRenderer: "editButtonRenderer" },
];

//수정 버튼 Cell Renderer 함수
function editButtonRenderer(params) {
    var projectId = params.data.projectId;
    var buttonHtml = '<button type="button" class="btn btn-warning btn-sm" onclick="projectEditFormModalOpen(\''+projectId+'\')">수정</button>';
    return buttonHtml;
}

// 일단 빈 데이터 설정(초기값)
const rowData = [];

//설정 옵션: 중요, 위에 정의한 것들이 여기서 통합됨에 주목
const gridOptions = {
	columnDefs: columnDefs,
	components: {
		editButtonRenderer: editButtonRenderer,
	},
	rowData: rowData,
	defaultColDef: {
		flex: 1,
		filter:true,
		resizable:true,
		minWidth:100,
		headerClass: "centered",
		autoHeight: true
	},
	// 페이지 설정
	pagination:true,
	paginationPageSize:15,
	paginationPageSizeSelector: [10, 15, 20, 50, 100]
};


// 프로젝트 목록 불러오기
function getProjectListData(){
    var xhr = new XMLHttpRequest();
    xhr.open("get", "/adminProject/getProjectList", true);
    xhr.onreadystatechange = function(){
        if(xhr.readyState == 4 && xhr.status == 200){
            let rslt = JSON.parse(xhr.responseText);
            gridApi.setGridOption('rowData', rslt);
        }
    }
    xhr.send();
}

//그리드 셋업
document.addEventListener('DOMContentLoaded', () => {
	const gridDiv = document.querySelector('#myGrid');
	
	gridApi = agGrid.createGrid(gridDiv, gridOptions);
	getProjectListData();  // 데이터 불러오기
});


</script>