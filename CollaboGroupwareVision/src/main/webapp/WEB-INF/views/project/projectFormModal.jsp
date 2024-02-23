<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<style>
#projectFormModal {
	position: fixed;
	width: 100%;
	height: 100%; /* fixed인 경우 작동 */
	left: 0px;
	top: 0px;
	background-color: rgb(200, 200, 200, 0.5);
	display: none;
	z-index: 1000; /* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
}

#projectFormModalCont {
	margin: 5% auto; /* 수평가운데 정렬 */
	width: 1000px;
	height: auto;
	background-color: rgb(255, 255, 255);
}

#divtree {
	min-width: 400px !important;
	padding: 0 50px;
}

#jstree {
	max-height: 300px !important;
}

#projectForm label {
	font-weight: bold;
	font-size: 0.9rem;
	color: black;
}

.memListTr {
	vertical-align: middle;
}
</style>

<div id="projectFormModal">
	<div class="card" id="projectFormModalCont">

		<div class="d-flex align-content-stretch">

			<jsp:include page="../org/orgChart.jsp"/>

			<form id="projectForm" action="/adminProject/create" method="post" class="flex-fill">
				<div class="card-body mt-3 overflow-scroll scrollable-content" style="min-height: 700px;max-height: 700px;">
					<label for="projectName" class="form-label">프로젝트명</label> <input
						id="projectName" name="projectName" type="text" class="form-control" placeholder="프로젝트명"><br/>
					<label for="projectDescription" class="form-label">프로젝트 설명</label>
					<textarea
						id="projectDescription" name="projectDescription" rows="4" class="form-control" placeholder="프로젝트 설명"></textarea><br/>
					<label for="projectStartDay" class="form-label">시작일</label> <input
						id="projectStartDay" name="projectStartDay" type="date" class="form-control"><br/>
					<label for="projectEndDay" class="form-label">종료일</label> <input
						id="projectEndDay" name="projectEndDay" type="date" class="form-control"><br/>
					<label for="projectStatus" class="form-label">상태</label> <select
						id="projectStatus" name="projectStatus" class="form-select">
						<option value="" <c:if test="${status ne 'u' }">selected</c:if> disabled hidden>(선택)</option>
						<c:forEach var="map" items="${commonCodes }">
							<c:if test="${map['COMMON_CODE_GROUP_ID'] == '1000'}">
								<option value="${map['COMMON_CODE'] }" <c:if test="${project.projectStatus eq map['COMMON_CODE'] }">selected</c:if>>${map['COMMON_CODE_NAME'] }</option>
							</c:if>
						</c:forEach>
					</select><br/>
					<label for="projectMemList" class="form-label">프로젝트 멤버</label> 
					<div class="table-responsive">
		                <table class="table table-bordered text-center">
		                    <thead>
		                        <tr>
		                        	<th>프로필</th>
		                            <th>이름</th>
		                            <th>부서</th>
		                            <th>직위</th>
		                            <th>구분</th>
		                            <th>삭제</th>
		                        </tr>
		                    </thead>
		                    <tbody id="memList">
                       			<tr id="emptyText">
                       				<td class="fs-4 text-center p-5" colspan="6">프로젝트 멤버를 추가해주세요.</td>                    			
                    			</tr>
		                    </tbody>
		                </table>
		            </div>
				</div>
				<div class="mb-3 gap-1 d-flex align-text-bottom justify-content-center">
					<button type="button" id="createBtn" class="btn btn-success btn-lg">생성</button>
					<button type="button" class="btn btn-danger btn-lg"
						onclick="projectFormModalClose()">닫기</button>
					<button type="button" id="demoBtn" onclick="setDemoValues()" class="btn btn-light btn-lg">시연용</button>
				</div>
			<sec:csrfInput/>
			</form>
		</div>
		
		


	</div>
	
</div>


<script>
var $memList;
var projectForm;
var $createBtn;
var $demoBtn;

$(function() {
	$createBtn = $("#createBtn");
	$memList = $("#memList");
	$demoBtn = $("#demoBtn");
	
	projectForm = document.querySelector("#projectForm");
	
	// jstree는 제이쿼리 사용
	jsTreeObj.on("select_node.jstree", function(event, data) {
		// 부서 노드를 클릭한 경우 하위 노드 토글
		if (data.node.type === 'dept') {
			jsTreeObj.jstree(true).toggle_node(data.node);
		} else if (data.node.type === 'employee') { // 클릭한 노드가 사원일 경우
			console.log("누른것은", data.node);
			addProjectMember(data.node.id);
		}
	});
	
	// 프로젝트 생성
	$createBtn.on("click", function() {
		// 프로젝트명, 시작일, 종료일 값 확인
	    var name = document.querySelector("#projectName").value.trim();
	    var startDay = document.querySelector("#projectStartDay").value.trim();
	    var endDay = document.querySelector("#projectEndDay").value.trim();
	    var status = document.querySelector("#projectStatus").value.trim();
	    
	    // 프로젝트 멤버 확인
		var memCount = $memList.find('input[name^="projectMemList"]').length;
	    console.log("멤버수", memCount);
		
		if(name == "" || name.length == 0) {
			Swal.fire({
	        	icon: 'warning',
	        	title: '입력',
	        	text: '프로젝트명을 입력해주세요.'
	        });
			return;
		}
		
		if(startDay == "" || startDay.length == 0) {
			Swal.fire({
	        	icon: 'warning',
	        	title: '입력',
	        	text: '프로젝트 시작일을 입력해주세요.'
	        });
			return;
		}
		
		if(endDay == "" || endDay.length == 0) {
			Swal.fire({
	        	icon: 'warning',
	        	title: '입력',
	        	text: '프로젝트 종료일을 입력해주세요.'
	        });
			return;
		}
		
		if (endDay < startDay) {
	        Swal.fire({
	            icon: 'warning',
	            title: '경고',
	            text: '종료일을 확인해주세요.'
	        });
	        return;
	    }
		
		if(status == "" || status.length == 0) {
			Swal.fire({
	        	icon: 'warning',
	        	title: '입력',
	        	text: '프로젝트 상태를 입력해주세요.'
	        });
			return;
		}

		if(memCount === 0) {
			Swal.fire({
	        	icon: 'warning',
	        	title: '입력',
	        	text: '프로젝트 멤버를 추가해주세요.'
	        });
			return;
		}
		
		var leaderCount = $memList.find("select[name^='projectMemList'] option:selected[value='Y']").length;
		console.log("리더 수", leaderCount);
		if(leaderCount != 1) {
			Swal.fire({
	        	icon: 'warning',
	        	title: '선택',
	        	text: '리더를 1명 선택해주세요.'
	        });
			return;
		}
		
		projectForm.submit();
	});
});

// 조직도에서 노드 클릭 시 프로젝트 멤버 추가
function addProjectMember(nodeId) {
	var str = "";
	var isExist = false;
	
	// 이미 추가했는지 검사
	$memList.find("input[name^='projectMemList']").each(function(i, v) {
		if(nodeId == $(v).val()) {
			isExist = true;
			return;
		}
	});
	
	if(isExist) {
		Swal.fire({
        	icon: 'error',
        	title: '중복',
        	text: '이미 추가된 사원입니다.'
        });
		return;
	}
	
	$.ajax({
		type: 'get',
		url: '/org/getOrgDetails',
		data: {empNo: nodeId},
		dataType: 'json',
		success: function(emp) {
			var memIndex = $memList.find('input[name^="projectMemList"]').length;
			console.log("멤버 인덱스 ", memIndex);
			
			str = `
				<tr class="memListTr">
					<input type="hidden" name="projectMemList[\${memIndex}].empNo" value="\${emp.empNo}"/>
					<td><img class="img-md" src="\${emp.profileImgPath}" alt="profile" style="object-fit: contain;"></td>
					<td>\${emp.empName}</td>
					<td>\${emp.deptName}</td>
					<td>\${emp.position}</td>
					<td>
						<select id="leaderYn" name="projectMemList[\${memIndex}].leaderYn" class="form-select">
							<option value="Y">리더</option>
							<option value="N" selected>팀원</option>
						</select>
					</td>
					<td>
						<button type="button" class="btn btn-danger btn-sm" onclick="removeProjectMember(this)"><i class="ti-trash"></i></button>
					</td>
				</tr>
			`;
			$memList.append(str);
			showEmptyText();
		}
	});
}

function removeProjectMember(button) {
    $(button).parents('tr').remove();
    showEmptyText();
}

function showEmptyText() {
    if ($memList.find("tr").length === 0) {
    	$("#emptyText").show();	// 모달 닫은 후 다시 생길 수 있으므로 위에서 변수 선언을 하지 않음
    } else {
    	$("#emptyText").hide();
    }
}

// 프로젝트 생성 모달 열기
function projectFormModalOpen() {
	$createBtn.html("생성");
	$demoBtn.show();	// 시연용 버튼 보이기
	projectForm.action = "/adminProject/create";
	projectFormModal.style.display = "block";
}

// 프로젝트 수정 모달 열기 - 프로젝트 정보를 불러와 뿌려준다.
function projectEditFormModalOpen(projectId) {
		
	$createBtn.html("수정");
	$demoBtn.hide();	// 시연용 버튼 숨기기
	projectForm.action = "/project/update/"+projectId + "?from=${param.from}";
	
	var xhr = new XMLHttpRequest();
	xhr.open("get", "/project/getProjectDetails/"+projectId, true);
	xhr.onreadystatechange = function() {
		if(xhr.readyState == 4 && xhr.status == 200) {
			let project = JSON.parse(xhr.responseText);
			document.querySelector("#projectName").value = project.projectName;
			document.querySelector("#projectDescription").value = project.projectDescription;
			document.querySelector("#projectStartDay").value = getInputTypeDateDatas(project.projectStartDay);
			document.querySelector("#projectEndDay").value = getInputTypeDateDatas(project.projectEndDay);
			document.querySelector("#projectStatus").value = project.projectStatus;
			
			
			project.projectMemList.forEach(function(mem) {
				var memIndex = $memList.find('input[name^="projectMemList"]').length;
				console.log("멤버 인덱스 ", memIndex);
				var str = `
					<tr class="memListTr">
						<input type="hidden" name="projectMemList[\${memIndex}].empNo" value="\${mem.empNo}"/>
						<td><img class="img-md" src="\${mem.profileImgPath}" alt="profile" style="object-fit: contain;"></td>
						<td>\${mem.empName}</td>
						<td>\${mem.deptName}</td>
						<td>\${mem.position}</td>
						<td>
							<select id="leaderYn" name="projectMemList[\${memIndex}].leaderYn" class="form-select">
								<option value="Y" \${mem.leaderYn === 'Y' ? 'selected' : ''}>리더</option>
								<option value="N" \${mem.leaderYn === 'N' ? 'selected' : ''}>팀원</option>
							</select>
						</td>
						<td>
							<button type="button" class="btn btn-danger btn-sm" onclick="removeProjectMember(this)"><i class="ti-trash"></i></button>
						</td>
					</tr>
				`;
				$memList.append(str);
				showEmptyText();
			});
		}
	}
	xhr.send();

	projectFormModal.style.display = "block";
}



// 모달 닫기
function projectFormModalClose() {
	var text = `
		<tr id="emptyText">
			<td class="fs-4 text-center p-5" colspan="6">프로젝트 멤버를 추가해주세요.</td>                    			
		</tr>
	`;
	projectFormModal.style.display = "none";
	projectForm.reset();
	$memList.html(text);
	jsTreeObj.jstree("close_all");
}

//날짜 데이터(ex.20200124) input type date에 설정
function getInputTypeDateDatas(dateStr) {
	var formattedDate = `\${dateStr.slice(0, 4)}-\${dateStr.slice(4, 6)}-\${dateStr.slice(6, 8)}`;
	return formattedDate;
}

function setDemoValues() {
	$("#projectName").val("항공예약시스템");
	$("#projectStartDay").val("2024-02-16");
	$("#projectEndDay").val("2024-03-29");
	$("#projectStatus").prop('selectedIndex', 1);
}
</script>

