<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="https://cdn.jsdelivr.net/npm/ag-grid-community/dist/ag-grid-community.min.js"></script>
<style>
#gridWrapper {
	height: 520px;
}

#myGrid {
	height: 100%;
}
</style>
<div class="content__header content__boxed overlapping">
    <div class="content__wrap">
    
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/index">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page">조직 삭제목록</li>
            </ol>
        </nav>
		<br/>
        
    </div>

</div>

<div class="content__boxed">
    <div class="content__wrap">
        <div class="card">
            <div class="card-body">

                <div class="d-md-flex gap-4">

                    <!-- 사이드바 -->
                    <div class="w-md-160px w-xl-250px flex-shrink-0 mb-3 border-end border-2">

                        <!-- 삭제목록 종류 -->
                        <h4 class="px-3 mt-2 mb-3 fw-bold">조직 삭제목록</h4>
                        <div class="px-2 list-group list-group-borderless gap-1">
                            <a href="/adminOrg/deptDelList" class="list-group-item list-group-item-action  
                            	<c:if test='${flag eq "dept" }'>active</c:if>">
                                <i class="ti-briefcase fs-5 me-2"></i>부서 삭제목록
                            </a>
                            <a href="/adminOrg/empDelList" class="list-group-item list-group-item-action  
                            	<c:if test='${flag eq "emp" }'>active</c:if>">
                                <i class="ti-user fs-5 me-2"></i>사원 삭제목록
                            </a>
                        </div>
                        <!-- 삭제목록 종류 끝 -->

                    </div>
                    <!-- 사이드바 끝 -->

                    <!-- 본문 -->
                    <div class="flex-fill min-w-0" style="min-height: 750px; max-height: 750px;">
                        <div class="d-md-flex align-items-center border-bottom pb-3 mb-3">
                            <h3 class="mt-2 fw-bold text-primary">
                            	<c:if test="${flag eq 'dept' }">부서 삭제목록</c:if>
                            	<c:if test="${flag eq 'emp' }">사원 삭제목록</c:if>
                            </h3>
                        </div>

                        <!-- 부서 관리 toolbar -->
                        <c:if test="${flag eq 'dept' }">
	                        <div class="d-md-flex">
	                            <div class="d-flex flex-wrap gap-1 align-items-center justify-content-center mb-3">
	                                <button id="hardDelBtn" class="btn btn-lg btn-outline-danger">
	                                    <i class="ti-close me-2"></i> 영구삭제
	                                </button>
	                                <button id="recoveryBtn" class="btn btn-lg btn-outline-info">복구</button>
	                            </div>
	                        </div>
                        </c:if>
                        <!-- 부서 관리 toolbar 끝 -->

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
</div>
<script>
var gridApi;		// AG Grid API 객체
var hardDelBtn;		// 부서 영구삭제 버튼
var recoveryBtn;	// 부서 복구 버튼
var flag;			// dept인지 emp인지

// 컬럼들 정의 - 부서
const deptColumnDefs = [
	{ field: "deptCode",  headerName:"부서코드", headerCheckboxSelection: true, checkboxSelection: true, headerCheckboxSelectionCurrentPageOnly: true },
	{ field: "deptName",  headerName:"부서명" },
	{ field: "deptRegDay", headerName:"등록일" },
	{ field: "deptDelDay", headerName:"삭제일" }
];

// 컬럼들 정의 - 사원
const empColumnDefs = [	// resultType="hashMap"
	{ field: "EMP_NO",  headerName:"사번" },
	{ field: "EMP_NAME",  headerName:"이름" },
	{ field: "POSITION", headerName:"직위" },
	{ field: "EMP_TEL", headerName:"연락처" },
	{ field: "EMP_DEL_DAY", headerName:"삭제일" },
];


// 일단 빈 데이터 설정(초기값)
const rowData = [];

//설정 옵션: 중요, 위에 정의한 것들이 여기서 통합됨에 주목
const gridOptionsDept = {
	columnDefs: deptColumnDefs,
	rowData: rowData,
	defaultColDef: {
		flex:1,       // 자동으로 같은 사이즈로
		filter:true,
		resizable:true,
		minWidth:100,
		headerClass: "centered"
	},
	rowSelection: 'multiple',	// 모두 선택/해제를 위해
	// 페이지 설정
	pagination:true,
	paginationPageSizeSelector: false,
	paginationPageSize:10,
};

const gridOptionsEmp = {
	columnDefs: empColumnDefs,
	rowData: rowData,
	defaultColDef: {
		flex:1,       // 자동으로 같은 사이즈로
		filter:true,
		resizable:true,
		minWidth:100,
		headerClass: "centered"
	},
	// 페이지 설정
	pagination:true,
	paginationPageSizeSelector: false,
	paginationPageSize:10,
};

// 부서 삭제목록 데이터 불러오기
async function getDeletedDeptData(){
	try {
		const response = await fetch("/adminOrg/getDeletedDeptData", {
			method: "GET",
			headers: {
				"Accept": "application/json"
			}
		});
		
		if(!response.ok) {
			throw new Error("서버 오류");
		}
		
		const rslt = await response.json();
		gridApi.setGridOption('rowData', rslt);
	} catch (error) {
		alertError("삭제된 부서 목록을 불러오지 못했습니다.");
	}
}

// 사원 삭제목록 데이터 불러오기
async function getDeletedEmpData() {
	try {
		const response = await fetch("/adminOrg/getDeletedEmpData", {
			method: "GET",
			headers: {
				"Accept": "application/json"
			}
		});
		
		if(!response.ok) {
			throw new Error("서버 오류");
		}
		
		const rslt = await response.json();
		gridApi.setGridOption('rowData', rslt);
	} catch (error) {
		alertError("삭제된 사원 목록을 불러오지 못했습니다.");
	}
}

// 부서 영구 삭제
async function hardDeleteDept() {
	let selectedRows = gridApi.getSelectedRows();
    let deptCodes = selectedRows.map(row => row.deptCode);
    
    if(selectedRows.length == 0) {
    	alertWarning('부서를 선택해주세요!');
    	return;
    }

    const result = await Swal.fire({
        icon: 'warning',
        html: '<h3 class="fw-bold">선택한 부서를 영구 삭제하시겠습니까?</h3><p>(부서에 포함된 모든 자료도 같이 삭제되며, <br>이후 복구할 수 없습니다.)</p>',
       	showCancelButton: true,
	        confirmButtonText: '영구삭제',
	        cancelButtonText: '취소',
    });
    
    if(!result.isConfirmed) return;
    
    try {
    	const response = await fetch('/adminOrg/hardDeleteDept', {
    		method: 'POST',
    		headers: {
    			'Content-Type': 'application/json',
    			[header]: token // csrf 토큰
    		},
    		body: JSON.stringify(deptCodes)
    	});
    	
    	if(!response.ok) throw new Error('삭제 실패');
    	
    	alertSuccess('영구삭제가 완료되었습니다.');
    	getDeletedDeptData();
    } catch (error) {
    	alertError('삭제 중 오류가 발생했습니다.');
    }
}

// 부서 복구
async function recoveryDept() {
	let selectedRows = gridApi.getSelectedRows();
    let deptCodes = selectedRows.map(row => row.deptCode);
    
    if(selectedRows.length == 0) {
    	alertWarning('부서를 선택해주세요!');
    	return;
    }
    
    const result = await Swal.fire({
        icon: 'question',
        html: '<h3 class="fw-bold">선택한 부서를 복구하시겠습니까?</h3>',
       	showCancelButton: true,
	        confirmButtonText: '복구',
	        cancelButtonText: '취소',
    });
    
    if(!result.isConfirmed) return;
    
    try {
    	const response = await fetch('/adminOrg/recoveryDept', {
    		method: 'POST',
    		headers: {
    			'Content-Type': 'application/json',
    			[header]: token
    		},
    		body: JSON.stringify(deptCodes)
    	});
    	
    	if(!response.ok) throw new Error('복구 실패');
    	
    	alertSuccess('부서 복구를 성공적으로 완료하였습니다.');
    	getDeletedDeptData();
    } catch (error) {
    	alertError('복구 중 오류가 발생했습니다.');
    }
}


//그리드 셋업
document.addEventListener('DOMContentLoaded', () => {
	flag = "${flag}";
	//console.log("flag", flag);
	
	const gridDiv = document.querySelector('#myGrid');
	
	if(flag === 'dept') {
		gridApi = agGrid.createGrid(gridDiv, gridOptionsDept);
		getDeletedDeptData();  // 데이터 불러오기
		
		// 부서 삭제목록 일 때만 있는 버튼들 이벤트
		
		// 영구삭제 이벤트
		hardDelBtn = document.querySelector('#hardDelBtn');
		hardDelBtn.addEventListener('click', hardDeleteDept);
		
		// 복구 이벤트
		recoveryBtn = document.querySelector('#recoveryBtn');
	    recoveryBtn.addEventListener('click', recoveryDept);
	    
	} else {
		gridApi = agGrid.createGrid(gridDiv, gridOptionsEmp);
		myGrid.style.marginTop = "50px";
		getDeletedEmpData();  // 데이터 불러오기
	}
	
});

</script>