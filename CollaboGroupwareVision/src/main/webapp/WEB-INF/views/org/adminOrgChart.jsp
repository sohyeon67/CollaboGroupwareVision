<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<style>
#modifyBtn, #confirmBtn, #cancelBtn {
	display: none;
}

#deptMemListDiv {
	display: none;
}

</style>

<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="./index.html">Home</a></li>
				<li class="breadcrumb-item active" aria-current="page">조직설계</li>
			</ol>
		</nav>
		<!-- Breadcrumb 끝 -->
		<br />

	</div>

</div>

<div class="content__boxed">
	<div class="content__wrap">

		<div class="row">

			<!-- 조직도 -->
			<div class="col-md-4 mb-3">
				<div class="card h-100">
					<div class="card-body" style="min-height:750px;">
						<h3 class="card-header fw-bold">조직설계</h3>
						<br />
						<div class="card-text d-flex flex-row align-items-center m-3 gap-1">
							<p class="h5 m-2 fw-bold">부서</p>
							<button type="button" id="deptAddBtn"
								class="btn btn-light"><i class="ti-plus"></i></button>
							<button type="button" id="deptDelBtn"
								class="btn btn-light"><i class="ti-minus"></i></button>
							<a type="button" class="btn btn-light"
								href="/adminOrg/deptDelList">삭제목록</a>
						</div>
						<input type="text" id="searchInput" class="form-control mb-2 w-50"
							placeholder="검색" style="margin-left: auto;">
						<div id="jstree"
							class="border border-2 p-3 mainnav__top-content scrollable-content"
							style="max-height: 500px;"></div>
					</div>
				</div>
			</div>
			<!-- 조직도 끝 -->

			<!-- 부서정보, 부서원 -->
			<div class="col-md-8 mb-3">
				<div class="card h-100">
					<h4 class="card-header m-2 fw-bold">부서정보</h4>
					<div class="card-body">
						<!-- 테이블 -->
						<div class="table-responsive d-flex justify-content-center">
                            <table class="table table-bordered" style="max-width: 500px;">
	                            <tr>
	                                <td class="w-25 fw-bold">부서코드</td>
	                                <td id="deptCode">-</td>
	                            </tr>
	                            <tr>
	                                <td class="fw-bold">부서명</td>
	                                <td id="deptName">-</td>
	                            </tr>
	                            <tr>
	                                <td class="fw-bold">생성일</td>
	                                <td id="deptRegDay">-</td>
	                            </tr>
                            </table>
                        </div>
                        <!-- 테이블 끝 -->
                        <div class="d-grid gap-2 d-md-flex justify-content-md-center">
	                        <button id="modifyBtn" type="button" class="btn btn-info">수정</button>
	                        <button id="confirmBtn" type="button" class="btn btn-info">확인</button>
	                        <button id="cancelBtn" type="button" class="btn btn-info">취소</button>
                        </div>
					</div>
				
					
					<h4 class="card-header m-2 fw-bold">부서원 목록</h4>
					<div class="card-body">
						<div class="overflow-scroll scrollable-content" style="min-height: 350px;max-height: 350px;">
							<div id="emptyText" class="fs-3 text-center pt-5">부서를 선택해주세요.</div>
							<div id="deptMemListDiv">
								<div class="d-grid gap-2 d-md-flex justify-content-md-left">
	                                <div class="btn-group mb-2">
	                                    <button type="button" class="btn btn-outline-light dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">부서이동</button>
	                                    <ul id="deptList" class="dropdown-menu"></ul>
	                                </div>
		                        </div>
								<div id="deptMemDiv" class="table-responsive d-flex justify-content-center"></div>
							</div>
                        </div>
					</div>
				</div>
			</div>
			<!-- 부서정보, 부서원 끝 -->
			
		</div>
		<!-- 조직도, 사원정보 끝 -->

	</div>
</div>

<script>
var jsTreeObj;
var deptCode;
var deptName;
var deptRegDay;

var modifyBtn;
var confirmBtn;
var cancelBtn;
var oldName;		// 수정 전 부서명

var deptMemDiv;
var deptList;		// 드롭다운 부서 리스트
var deptCodeVal;	// 현재 보고있는 부서코드

var deptMemListDiv;	// 부서이동 버튼, 부서원테이블
var emptyText;	// 부서를 선택하지 않았을 때 띄울 문구

$(function() {
	jsTreeObj = $("#jstree");
	var searchInput = $("#searchInput");
	var deptAddBtn = $("#deptAddBtn");
	var deptDelBtn = $("#deptDelBtn");
	
	modifyBtn = $("#modifyBtn");
	confirmBtn = $("#confirmBtn");
	cancelBtn = $("#cancelBtn");
	
	deptCode = $("#deptCode");
	deptName = $("#deptName");
	deptRegDay = $("#deptRegDay");
	
	deptMemDiv = $("#deptMemDiv");
	deptList = $("#deptList");
	
	deptMemListDiv = $("#deptMemListDiv");
	emptyText = $("#emptyText");
	
	// jstree 불러오기
	treelist();
	
	// 검색어 입력란에 입력이 있을 때마다 트리를 검색하도록 이벤트 리스너 등록
    searchInput.on("input", function() {
        var searchWord = $(this).val();
        // 검색어로 트리를 검색하는 함수 호출
        searchTree(searchWord);
    });
	
	// 부서 추가 - sweetalert2 입력 이용
	deptAddBtn.on("click", function() {
		Swal.fire({
			title: '부서 추가',
	        input: 'text',
	        inputPlaceholder: '생성할 부서명',
	        showCancelButton: true,
	        confirmButtonText: '저장',
	        cancelButtonText: '취소',
	        preConfirm: (deptName) => {
	            if (!deptName) {
	                Swal.showValidationMessage('부서명을 입력하세요.');
	            } else {
	            	var data = { deptName: deptName };
	                // Ajax 요청 처리
	                $.ajax({
	                    type: 'post',
	                    url: '/adminOrg/createDept',
	                    contentType: 'application/json',
	                    data: JSON.stringify(data),
	                    dataType: 'json',
	                    beforeSend : function(xhr) {	// 데이터 전송 전 헤더에 csrf값 설정
	        				xhr.setRequestHeader(header, token);
	        			},
	                    success: function(result) {
	                    	alertSuccess('부서가 추가되었습니다.');
	                    	updateTree();
	                    },
	                    error: function(xhr, status, error) {
	                    	alertError('부서 추가 중 오류가 발생했습니다.');
	                    }
	                });	// ajax 끝
	            }
	        }
	    })
	});
	
	// 부서 임시 삭제
	deptDelBtn.on("click", function() {
		var selectArr = jsTreeObj.jstree('get_selected', true);
		
		if(selectArr.length == 0) {	// 노드를 선택하지 않았을 경우
			alertWarning('삭제할 부서를 선택해주세요.');
		} else {	// 노드를 선택했을 경우
			var selNode = selectArr[0];
			if(selNode.type === "employee") {	// 사원 노드가 선택된 거면 무시
				return;
			}
			
			// 해당 부서에 사람이 있다면 삭제 불가
			if(selNode.children.length > 0) {
				alertWarning('부서원이 존재하여 삭제할 수 없습니다.');
				return;
			}

			// 임시 삭제 기능 구현 --------------------------------------
			Swal.fire({
                icon: 'warning',
                html: '삭제된 이후 부서 데이터는<br> <b>[삭제 부서 목록]</b>에서 이관할 수 있습니다.<br> 부서를 삭제하시겠습니까?',
               	showCancelButton: true,
       	        confirmButtonText: '삭제',
       	        cancelButtonText: '취소',
            }).then((result) => {
            	if(result.isConfirmed) {
            		var data = { deptCode : parseInt(selNode.id) };
        			// 부서 임시 삭제
        			$.ajax({
        				type : 'post',
        				url : '/adminOrg/softDeleteDept',
        				contentType : 'application/json',
        				data : JSON.stringify(data),
        				dataType : 'text',
        				beforeSend : function(xhr) {	// 데이터 전송 전 헤더에 csrf값 설정
            				xhr.setRequestHeader(header, token);
            			},
        				success : function(result) {
        					alertSuccess('정상적으로 이관되었습니다.');
        					// 트리 업데이트
        					updateTree();
        					// 부서정보 내용 지우기
        					clearDeptInfo();
        				},
        				error: function(xhr, status, error) {
        					alertError('부서 삭제 중 오류가 발생했습니다.');
                        }
        			});
            	}
            });
			
		}
	});	// 부서 삭제 끝
	
	// 수정 버튼을 눌렀을 때 확인, 취소 버튼 띄우기
	modifyBtn.on("click", function() {
		oldName = deptName.text();
		modifyBtn.css('display', 'none');
		confirmBtn.css('display', 'inline-block');
		cancelBtn.css('display', 'inline-block');
		
		var str = "<input type='text' id='newName' value='"+ oldName +"'>";
		deptName.html(str);
	});
	
	// 취소 버튼을 눌렀을 때, 수정 버튼 띄우기
	cancelBtn.on("click", function() {
		deptName.html(oldName);
		modifyBtn.css('display', 'inline-block');
		confirmBtn.css('display', 'none');
		cancelBtn.css('display', 'none');
	});
	
	// 부서명 수정 기능
	confirmBtn.on("click", function() {
		var deptCode = parseInt($("#deptCode").text());
		var newName = $("#newName").val();
		var data = {
			deptCode : deptCode,
			deptName : newName 
		};
		$.ajax({
			type: 'post',
	        url: '/adminOrg/updateDeptName',
	        contentType: 'application/json',
	        data: JSON.stringify(data),
	        beforeSend : function(xhr) {	// 데이터 전송 전 헤더에 csrf값 설정
				xhr.setRequestHeader(header, token);
			},
	        success: function(result) {
	        	alertSuccess('부서명 변경을 완료하였습니다.');
	        	oldName = newName;
	        	updateTree();
	        },
	        error: function(xhr, status, error) {
	            console.log('AJAX 오류:', status, error);
	        }
		});
	});
	
	
}); // $function 끝

// 부서 정보 내용 지우기
function clearDeptInfo() {
	deptCode.html("-");
	deptName.html("-");
	deptRegDay.html("-");
	modifyBtn.css('display', 'none');
	confirmBtn.css('display', 'none');
	cancelBtn.css('display', 'none');
	deptMemListDiv.css('display', 'none');
	emptyText.css('display', 'block');
}

function updateTree() {
	jsTreeObj.jstree(true).destroy();
	treelist();
}

function searchTree(searchWord) {
	// jstree에서 제공하는 검색 함수
	jsTreeObj.jstree(true).search(searchWord);
}

//트리 리스트 출력
function treelist() {
	//트리 데이터 가져오기
	$.ajax({
		type : 'get',
		url : '/org/getOrgTree',
		dataType : 'json',
		success : function(data) {
			var treeData = data.map(function(node) {
				return { id:node.ID, parent:node.PARENT, text:node.TEXT, type:node.TYPE }
			});
			
			var menus = "";
			$.each(treeData, function(i, v) {
				if(v.type === 'dept') {
					menus += "<li><a class='dropdown-item' href='#' data-dept-code='"+v.id+"'>"+v.text+"</a></li>";
				}
			});
			deptList.html(menus);
			
			jsTreeObj.jstree({
				'core' : {
					'data' : treeData,
					'multiple' : false	// 다중 노드 선택 막음
				},
				'state' : {
					'opened' : false
				},
				'types' : {
					'employee' : {
						'icon' : '${pageContext.request.contextPath }/resources/assets/vendors/ionicons/svg/person.svg',
					},
					'dept' : {
						'icon' : '${pageContext.request.contextPath }/resources/assets/vendors/ionicons/svg/home.svg',
					}
				},
				'plugins' : [ 'types', 'search' ]
			
		    // 트리 선택 이벤트
			}).on('select_node.jstree', handleNodeSelection);
		}, // success 끝
		error : function(xhr, status, error) {
			console.log('AJAX 오류:', status, error);
		}
	}); //ajax 끝
} //treelist 끝

// 노드 선택 시 실행될 함수
function handleNodeSelection(event, data) {
	//console.log("확인",data);
	
	if(data.node.type === 'employee') {
		confirmBtn.css('display', 'none');
		cancelBtn.css('display', 'none');
	}
	
    // 노드 선택 이벤트
    // 부서 노드를 클릭한 경우 하위 노드 토글, 수정버튼 띄우기
    if (data.node.type === 'dept') {
        jsTreeObj.jstree(true).toggle_node(data.node);
    }
    
    // 부서가 없는 사람들 클릭(회장, 사장, 상무)
    if(data.node.type === 'employee' && data.node.parent === '#') {
    	// 부서정보 내용 지우기
		clearDeptInfo();
    	return;
    }

    // 부서 또는 부서원 클릭 시 부서 코드값 가져오기
    deptCodeVal = getDeptCodeVal(data.node);
    //console.log("해당 부서 코드값:", deptCodeVal);
	// 정보 가져오기
    getDeptInfo(deptCodeVal);
	
    modifyBtn.css('display', 'inline-block');	// 부서 혹은 그 부서원 클릭 시 수정 버튼
    confirmBtn.css('display', 'none');
    cancelBtn.css('display', 'none');
    deptMemListDiv.css('display', 'block');
    emptyText.css('display', 'none');
}

//부서 또는 부서원 클릭 시 부서 코드값 가져오기
function getDeptCodeVal(node) {
    // 노드가 # (루트)인 경우 자기 자신의 ID 반환
    if (node.parent === '#') {
        return node.id;
    }
    
    return node.parent;
}

// 부서 정보와 부서원 목록 가져오기 =====================================
function getDeptInfo(deptCodeVal) {
    
    // 해당 직원의 상세 정보를 가져오는 AJAX 요청
    $.ajax({
        type: 'get',
        url: '/adminOrg/getDeptInfo',
        data: { deptCode: parseInt(deptCodeVal) },
        dataType: 'json',
        success: function(dept) {
            // 가져온 상세 정보를 각각 뿌려주기
            //console.log("부서정보", dept);
            
        	deptCode.html(formatDeptCode(dept.deptCode));
        	deptName.html(dept.deptName);
        	deptRegDay.html(dept.deptRegDay);
        	var table = "<table class='table table-bordered'>";
        	table += "<thead><tr><th style='width: 5%'><input type='checkbox' id='selectAll' onchange='selectAll(this)' class='form-check-input'></th><th style='width: 30%'>사번</th><th>이름</th><th>직급</th></tr></thead>";
        	table += "<tbody>";

        	if(dept.deptMemList.length == 0) {	// 부서원이 없을 때
        		table += "<tr><td colspan='4' class='fs-3 text-center p-5'>부서원이 존재하지 않습니다.</td></tr>";
        	} else {
	        	$.each(dept.deptMemList, function(i, emp) {
	        		table += "<tr>";
	        		table += "<td><input type='checkbox' class='form-check-input empCheck' onchange='empSelect(this)' value='" + emp.empNo + "'></td>";
	                table += "<td>" + emp.empNo + "</td>";
	                table += "<td>" + emp.empName + "</td>";
	                table += "<td>" + emp.position + "</td>";
	                table += "</tr>";
	        		
	        	});
        	}
        	table += "</tbody></table>";
            deptMemDiv.html(table);
        },
        error: function(xhr, status, error) {
            console.log('AJAX 오류:', status, error);
        }
    });
}

// 부서코드 포맷팅
function formatDeptCode(code) {
    // ex) 1 -> 001
    code = String(code);
    while (code.length < 3) {
        code = '0' + code;
    }
    return code;
}

// 체크박스 이벤트
function selectAll(e) {
	$(".empCheck").prop("checked", $(e).prop("checked"));
}

function empSelect(e) {
	var allChecked = $(e).prop("checked").length === $(e).length;
    $("#selectAll").prop("checked", allChecked);
}

// 정적으로 생성된 상위 요소에 이벤트 리스너
$("body").on("click", ".dropdown-item", function() {
	// a태그 링크 동작 막기
	event.preventDefault();
	
	// 클릭한 메뉴의 부서, data-dept-code 속성 값을 가져온다.
	var targetDeptCode = $(this).data('dept-code');	// number
	
	if(deptCodeVal == null) {
		alertWarning('부서를 선택해주세요.');
		return;
	}
	
	if(targetDeptCode == deptCodeVal) {
		alertWarning('현재 속해있는 부서입니다.');
		return;
	}
	
	console.log("현재부서", deptCodeVal);
	console.log("이동할부서", targetDeptCode);
	
	var checkMemDOM = $(".empCheck:checked");
	if(!checkMemDOM.length) return;	// 부서에 멤버가 없을 때 부서 이동 못하도록
	
	var empNoList = [];
	$.each(checkMemDOM, function(i, v) {
		var empNo = $(v).val();
		empNoList.push(empNo);
	});
	
	transferDept(targetDeptCode, empNoList);
});

function transferDept(targetDeptCode, empNoList) {
	var data = {
		targetDeptCode: parseInt(targetDeptCode),
		empNoList: empNoList
	};
	
	$.ajax({
		type: 'post',
        url: '/adminOrg/transferDept',
        contentType: 'application/json',
        data: JSON.stringify(data),
        beforeSend : function(xhr) {	// 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader(header, token);
		},
        success: function(result) {
        	alertSuccess('부서 이동을 성공적으로 완료하였습니다.');
        	updateTree();	// 트리 업데이트
        	getDeptInfo(deptCodeVal);	// 현재 부서정보, 부서원 목록 다시 가져오기
        },
        error: function(xhr, status, error) {
            console.log('AJAX 오류:', status, error);
        }
	});
}

</script>