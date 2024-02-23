<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="https://cdn.jsdelivr.net/npm/ag-grid-enterprise/dist/ag-grid-enterprise.min.js"></script>
<style>
#gridWrapper {
	height: 650px;
}

#myGrid {
	width: 100%;
	height: 100%;
}
</style>

<c:if test="${not empty successMsg }">
<script>
Swal.fire({
    icon: 'success',
    title: '성공',
    text: '${successMsg }'
});
</script>
</c:if>

<div class="content__header content__boxed overlapping">
    <div class="content__wrap">
    
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/index">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page">사원통합관리</li>
            </ol>
        </nav>
		<br/>
        
    </div>

</div>

<div class="content__boxed">
    <div class="content__wrap">
        <div class="card">
            <div class="card-body">

                    <!-- 본문 -->
                    <div class="row d-flex align-items-center flex-fill min-w-0" style="min-height: 750px; max-height: 750px;">
                        <div class="col-md-6 ">
                            <span class="fs-3 ps-3 mt-3 fw-bold text-primary">사원통합관리</span>
                        </div>
                        <!-- toolbar -->
	                    <div class="col-md-6 d-flex justify-content-end">
                            <div class="d-flex flex-wrap gap-1 align-items-center justify-content-center">
                                <button onclick="location.href='/account/register'" class="btn btn-outline-info btn-lg">
                                    <i class="ti-user me-1"></i> 사원등록
                                </button>
                                <button id="disableBtn" onclick="empDisable()" class="btn btn-outline-danger btn-lg">
                                	<i class="ti-na me-1"></i>비활성
                                	</button>
                                <!-- <button id="" class="btn btn-outline-info btn-lg">
                                	<i class="ti-upload me-1"></i>업로드
                                </button> -->
                                <button onclick="excelDown()" class="btn btn-outline-success btn-lg">
                                	<i class="ti-download me-1"></i>다운로드
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
	{ field: "empNo",  headerName:"사번", headerCheckboxSelection: true, checkboxSelection: true, headerCheckboxSelectionCurrentPageOnly: true },
	{ field: "profileImgPath",  headerName:"증명사진", cellRenderer: "imageRenderer" },
	{ field: "empName",  headerName:"이름" },
	{ field: "deptName", headerName:"부서" },
	{ field: "position", headerName:"직위", width: 190 },
	{ field: "empEmail", headerName:"이메일" },
	{ field: "empTel", headerName:"연락처" },
	{ field: "hffc", headerName:"상태", width: 110 },
	{ headerName: "수정", width: 100, cellRenderer: "editButtonRenderer" },
];

//수정 버튼 Cell Renderer 함수
function editButtonRenderer(params) {
    var empNo = params.data.empNo;
    var buttonHtml = '<a class="btn btn-warning btn-sm" href="/account/details/'+ empNo +'">수정</a>';
    return buttonHtml;
}

//이미지를 표시하는 Cell Renderer 함수
function imageRenderer(params) {
	return params.value ? `<img src="\${params.value}" alt="profile" style="width: 50%; object-fit: contain;">` : '';
}

// 일단 빈 데이터 설정(초기값)
const rowData = [];

//설정 옵션: 중요, 위에 정의한 것들이 여기서 통합됨에 주목
const gridOptions = {
	columnDefs: columnDefs,
	components: {
		imageRenderer: imageRenderer,  // Cell Renderer 등록
		editButtonRenderer: editButtonRenderer,
	},
	rowData: rowData,
	defaultColDef: {
		filter:true,
		resizable:true,
		minWidth:100,
		headerClass: "centered",
		autoHeight: true
	},
	rowSelection: 'multiple',	// 모두 선택/해제를 위해
	// 페이지 설정
	pagination:true,
	paginationPageSize:10,    // 같이 설정하니 위에 꺼 우선순위
	paginationPageSizeSelector: [10, 20, 50, 100]
};

// 엑셀 다운
function excelDown() {
	gridApi.exportDataAsExcel();
}

// 사원 목록 불러오기
function getEmpListData(){
    var xhr = new XMLHttpRequest();
    xhr.open("get", "/account/getEmpList",true);
    xhr.onreadystatechange = function(){
        if(xhr.readyState == 4 && xhr.status == 200){
            let rslt = JSON.parse(xhr.responseText);
            gridApi.setGridOption('rowData', rslt);
        }
    }
    xhr.send();
}

// 사원 비활성화
function empDisable() {
	let selectedRows = gridApi.getSelectedRows();
    let empNoList = selectedRows.map(row => row.empNo);
    console.log(empNoList);
    
    if(selectedRows.length == 0) {
    	warningText();
    	return;
    }

    Swal.fire({
        icon: 'warning',
        html: '<h3 class="fw-bold">선택한 사원을 비활성화 하시겠습니까?</h3><p>(해당 사원은 모든 기능 사용이 불가하도록 변경됩니다.)</p>',
       	showCancelButton: true,
	        confirmButtonText: '비활성화',
	        cancelButtonText: '취소',
    }).then((result) => {
    	if(result.isConfirmed) {
			var xhr = new XMLHttpRequest();
			xhr.open("delete", "/account/empDisable", true);
			xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
			xhr.setRequestHeader(header, token); // csrf 토큰을 헤더에 추가
			xhr.onreadystatechange = function() {
			    if(xhr.readyState == 4 && xhr.status == 200) {
			    	Swal.fire({
					    icon: 'success',
					    title: '성공',
					    text: '비활성화가 완료되었습니다.'
					});
					getEmpListData();
			    }
			}
			xhr.send(JSON.stringify(empNoList));
    	}
    });
}


function warningText() {
	Swal.fire({
        icon: 'error',
        title: '오류',
        text: '사원을 선택해주세요!'
    });
}


//그리드 셋업
document.addEventListener('DOMContentLoaded', () => {
	const gridDiv = document.querySelector('#myGrid');
	
	gridApi = agGrid.createGrid(gridDiv, gridOptions);
	getEmpListData();  // 데이터 불러오기
});

</script>