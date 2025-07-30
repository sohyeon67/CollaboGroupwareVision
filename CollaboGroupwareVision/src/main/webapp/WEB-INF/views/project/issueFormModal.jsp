<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<style>
#issueFormModal {
	position: fixed;
	width: 100%;
	height: 100%; /* fixed인 경우 작동 */
	left: 0px;
	top: 0px;
	background-color: rgb(200, 200, 200, 0.5);
	display: none;
	z-index: 1000; /* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
}

#issueFormModalCont {
	margin: 1% auto; /* 수평가운데 정렬 */
	width: 800px;
	height: auto;
	max-height: 900px;
	background-color: rgb(255, 255, 255);
}

label {
	color: black;
}
</style>

<div id="issueFormModal">
	<div class="card h-100 p-3 overflow-scroll scrollable-content" id="issueFormModalCont">
		<h3 class="m-3 fw-bold"><i class="ti-pencil"></i> <span id="modalTitle">새 일감등록</span></h3>
		<div class="card-body">

			<form id="issueForm" class="row g-3" method="post" action="/project/issue/register" enctype="multipart/form-data">
				<input type="hidden" id="projectId" name="projectId" value="${project.projectId }">
				<div class="col-md-6">
					<label for="issueType" class="form-label">유형<span
						class="text-danger">*</span></label> <select id="issueType"
						name="issueType" class="form-select" required>
						<c:forEach var="entry" items="${issueTypeMap}">
						    <option value="${entry.key}" >${entry.value}</option>
						</c:forEach>
					</select>
				</div>

				<div class="col-12">
					<label for="issueTitle" class="form-label">제목<span
						class="text-danger">*</span></label> <input id="issueTitle"
						name="issueTitle" type="text" class="form-control">
				</div>

				<div class="col-md-6">
					<label for="issueStatus" class="form-label">상태<span class="text-danger">*</span></label>
					<select id="issueStatus" name="issueStatus" class="form-select" required>
						<c:forEach var="entry" items="${issueStatusMap}">
						    <option value="${entry.key}">${entry.value}</option>
						</c:forEach>
					</select>
				</div>

				<div class="col-md-6">
					<label for="issuePriority" class="form-label">우선순위<span
						class="text-danger">*</span></label> <select id="issuePriority"
						name="issuePriority" class="form-select" required>
						<c:forEach var="entry" items="${issuePriorityMap}">
						    <option value="${entry.key}">${entry.value}</option>
						</c:forEach>
					</select>
				</div>

				<div class="col-12">
					<label for="issueContent" class="form-label">내용</label>
					<textarea id="issueContent" name="issueContent"
						class="form-control"></textarea>
				</div>

				<div class="col-md-6">
					<label for="issueStartDay" class="form-label">시작일</label> <input
						id="issueStartDay" name="issueStartDay" type="date"
						class="form-control">
				</div>

				<div class="col-md-6">
					<label for="issueEndDay" class="form-label">종료일</label> <input
						id="issueEndDay" name="issueEndDay" type="date"
						class="form-control">
				</div>

				<div class="col-md-6">
					<label for="issueCharger" class="form-label">담당자<span
						class="text-danger">*</span></label> <select id="issueCharger"
						name="issueCharger" class="form-select" required>
						<c:forEach var="mem" items="${project.projectMemList }">
							<option value="${mem.empNo }">${mem.empName }</option>
						</c:forEach>
					</select>
				</div>

				<div class="col-md-6">
					<label for="issueProgress" class="form-label">진척도</label> <select
						id="issueProgress" name="issueProgress" class="form-select">
						<option selected="selected" value="0">0 %</option>
						<option value="10">10 %</option>
						<option value="20">20 %</option>
						<option value="30">30 %</option>
						<option value="40">40 %</option>
						<option value="50">50 %</option>
						<option value="60">60 %</option>
						<option value="70">70 %</option>
						<option value="80">80 %</option>
						<option value="90">90 %</option>
						<option value="100">100 %</option>
					</select>
				</div>

				<div class="col-md-6">
						<label for="issueFile" class="col-sm-3 col-form-label">파일</label>
						<input id="issueFile" class="form-control"
							type="file" multiple="multiple">
				</div>

				<div class="col-md-6">
					<!-- 파일 출력 시작  -->
					<div class="table-responsive">
						<table class="table">
							<thead></thead>
							<tbody id="fileList"></tbody>
						</table>
					</div>
					<!-- 파일 출력 끝 -->
				</div>


				<div class="col-12 gap-1 pt-3 d-flex justify-content-center">
					<button type="button" id="registerBtn" class="btn btn-success btn-lg">등록</button>
					<button type="button" onclick="issueFormModalClose()" class="btn btn-danger btn-lg">닫기</button>
					<button type="button" id="demoBtn" class="btn btn-light btn-lg" onclick="setDemoValues()">시연용</button>
				</div>
				<sec:csrfInput/>
			</form>

		</div>
	</div>
</div>

<script>
var ajaxData = [];
var fileNo = 0;
var registerBtn;
var issueForm;
var fileList;
var modalTitle;
var demoBtn;

$(function() {
	CKEDITOR.replace("issueContent", {
		filebrowserUploadUrl : '/imageUpload?${_csrf.parameterName}=${_csrf.token}'
	});
	CKEDITOR.config.height = "300px"; // CKEDITOR 높이 설정
	CKEDITOR.config.versionCheck = false;
	
	issueForm = $("#issueForm");
	fileList = $("#fileList");
	registerBtn = $("#registerBtn");
	modalTitle = $("#modalTitle");
	demoBtn = $("#demoBtn");
	
	var issueFile = $("#issueFile");
	var projectId = $("#projectId").val();
	
	
	// 일감 등록/수정
	registerBtn.on("click", function(event) {
		
		var issueTitle = $("#issueTitle");
		var title = issueTitle.val();
		if(title == null || title == "") {
			alertWarning('제목을 입력해주세요!');
			issueTitle.focus();
			return;
		}
		
		var issueStartDay = $("#issueStartDay");
		var startDay = issueStartDay.val();
		if(startDay == null || startDay == "") {
			alertWarning('시작일을 입력해주세요!');
			issueStartDay.focus();
			return;
		}
		
		var issueEndDay = $("#issueEndDay");
		var endDay = issueEndDay.val();
		if(endDay == null || endDay == "") {
			alertWarning('종료일을 입력해주세요!');
			issueEndDay.focus();
			return;
		}
		
		if (endDay < startDay) {
			alertWarning('종료일을 확인해주세요.');
	        return;
	    }
		
		console.log("ajaxData", ajaxData);
		var fileData = ajaxData.map(item => item.data);
		console.log("전송할 데이터들만 ", fileData);
		
		var str = "";
		$.each(fileData, function(i, v) {
			str += `
				<input type="hidden" name="issueAttachList[\${i}].issueFileName" value="\${v.issueFileName}"/>
				<input type="hidden" name="issueAttachList[\${i}].issueFileSize" value="\${v.issueFileSize}"/>
				<input type="hidden" name="issueAttachList[\${i}].issueFileFancysize" value="\${v.issueFileFancysize}"/>
				<input type="hidden" name="issueAttachList[\${i}].issueFileMime" value="\${v.issueFileMime}"/>
				<input type="hidden" name="issueAttachList[\${i}].issueFileSavepath" value="\${v.issueFileSavepath}"/>
			`;
		});
		
		issueForm.append(str);
		issueForm.submit();
	});
	
	// 파일 이벤트 핸들러 등록
	issueFile.on("change", fileChange);
	
	async function fileChange(event) {
		var files = event.target.files;
		
		// Promise 배열 생성
	    var uploadPromises = [];
		
		for(var i=0; i<files.length; i++) {
			var file = files[i];
			// 각 파일에 대해 uploadFile 함수 호출하여 Promise 생성
	        var uploadPromise = uploadFile(file);
	        uploadPromises.push(uploadPromise);
			
		}
		
		try {
			// 모든 Promise를 병렬로 처리하고 결과를 기다림
	        var results = await Promise.all(uploadPromises);
			console.log("성공적으로 처리", results);
		} catch(error) {
			console.error("파일 업로드 에러", error);
		}
		
	}

	// 비동기 파일 업로드
	function uploadFile(file) {
		return new Promise(function(resolve, reject) {
			var formData = new FormData();
			formData.append("projectId", projectId);
			formData.append("file", file);	// key, value
			
			$.ajax({
				type: "post",
				url: "/project/issue/uploadAjax",
				data: formData,
				processData: false,
				contentType: false,
				beforeSend: function(xhr) {
					xhr.setRequestHeader(header, token);
				},
				success: function(data) {
					console.log("파일하나", data);
					
					console.log("파일순번", fileNo);
					ajaxData.push({fileNo, data});	// 0부터
					
					var str = `
						<tr data-num="\${fileNo}">
							<td><i class="ti-file"></i> <a href="/downloadFile?savePath=\${data.issueFileSavepath}">\${data.issueFileName}</a></td>
							<td class="text-end">\${data.issueFileFancysize}</td>
							<td class="text-center"><button type="button" class="btn btn-danger btn-sm" onclick="removeIssueFile(this)"><i class="ti-trash"></i></button></td>
						</tr>
					`;
					fileList.append(str);
					fileNo++;
					
					resolve(data);
				},
				error: function(error) {
					reject(error);
				}
			});
			
		});
	}
	
});

// 일감 생성 모달 열기
function issueFormModalOpen() {
	demoBtn.show();
	modalTitle.html("새 일감등록");
	registerBtn.html("등록");
	issueForm.attr("action", "/project/issue/register");
	console.log("액션", issueForm.attr("action"));
	issueFormModal.style.display = "block";
}

// 일감 수정 모달 열기
function issueEditFormModalOpen() {
	demoBtn.hide();
	modalTitle.html("일감 수정");
	registerBtn.html("수정");
	issueForm.attr("action", "/project/issue/update");
	console.log("액션", issueForm.attr("action"));
	
	issueForm.append("<input type='hidden' name='issueNo' value='${issue.issueNo}'/>");
	
	// 내용 세팅
	$("#issueTitle").val("${issue.issueTitle}");
	CKEDITOR.instances.issueContent.setData(`${issue.issueContent}`);
	$("#issueStartDay").val(getInputTypeDateDatas("${issue.issueStartDay}"));
    $("#issueEndDay").val(getInputTypeDateDatas("${issue.issueEndDay}"));
    $("#issueCharger").val("${issue.issueCharger}");
	$("#issueProgress").val("${issue.issueProgress}");
	
	// 공통코드 세팅
	$("#issueType").val("${issue.issueType}");
	$("#issueStatus").val("${issue.issueStatus}");
	$("#issuePriority").val("${issue.issuePriority}");
	
	// 파일리스트 세팅
	var issueAttachList = JSON.parse('${jsonIssueAttachList}');
	var str = "";
	$.each(issueAttachList, function(i, data) {
		// 파일이 없으면 issueNo에 값이 있고, issueFileNo과 issueFileSize는 0이다.
		if(data.issueFileNo == 0) {
			console.log("파일이 없음");
			return;
		}
		console.log("파일하나", data);
		console.log("파일순번", fileNo);
		
		ajaxData.push({fileNo, data});	// 0부터
		
		str += `
			<tr data-num="\${fileNo}">
				<td><i class="ti-file"></i> <a href="/downloadFile?savePath="+\${data.issueFileSavepath}>\${data.issueFileName}</a></td>
				<td class="text-end">\${data.issueFileFancysize}</td>
				<td class="text-center"><button type="button" class="btn btn-danger btn-sm" onclick="removeIssueFile(this)"><i class="ti-trash"></i></button></td>
			</tr>
		`;
		fileNo++;
	});
	fileList.html(str);
	
	issueFormModal.style.display = "block";
}

//모달 닫기
function issueFormModalClose() {
	issueFormModal.style.display = "none";
	issueForm[0].reset();
	$("#fileList").html("");
	fileNo = 0;
}

//파일 목록에서 삭제
function removeIssueFile(button) {
	var $tr = $(button).parents('tr');
	var fileNo = $tr.data('num');
	console.log("삭제할 파일 인덱스", fileNo);
	
	// 해당 인덱스 요소 제거
	ajaxData = ajaxData.filter(item => item.fileNo !== fileNo);
	
	$tr.remove();
}

function getInputTypeDateDatas(dateStr) {
	var formattedDate = `\${dateStr.slice(0, 4)}-\${dateStr.slice(4, 6)}-\${dateStr.slice(6, 8)}`;
	return formattedDate;
}

function setDemoValues() {
	$("#issueTitle").val("[발표] 최종프로젝트 발표");
	CKEDITOR.instances.issueContent.setData("306호 최종 프로젝트 발표합니다.");
	$("#issueStartDay").val("2024-02-16");
	$("#issueEndDay").val("2024-02-16");
	$("#issueProgress").prop('selectedIndex', 6);
}
</script>