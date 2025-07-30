<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- QR 스크립트  -->
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/dclz/qrcode.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/dclz/qrcode.min.js"></script>

<!-- 회원 폼 관련 스크립트 -->
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/account/form.js"></script>

<style>
label {
	color: black;
}
</style>

<c:if test="${not empty errorMsg }">
<script>
alertError('${errorMsg }');
</script>
</c:if>
<c:if test="${not empty successMsg }">
<script>
alertSuccess('${successMsg }')
</script>
</c:if>

<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/index">Home</a></li>
				<li class="breadcrumb-item active" aria-current="page">마이페이지</li>
			</ol>
		</nav>
		<br />
	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">

		<div class="card h-100 p-3">
			<h3 class="m-3 fw-bold">마이페이지</h3>
			<div class="card-body">

				<form class="row g-3" method="post" id="myForm" enctype="multipart/form-data">
					<input type="hidden" name="empNo" value="${emp.empNo }"/>
					<input type="hidden" name="profileImgPath" value="${emp.profileImgPath }"/>
					<!-- 기존 서명 사진 base64 값 저장 후 컨트롤러에서 디코딩 -->
					<input type="hidden" name="base64signImg" value="${base64signImg }"/>

					<div class="col-md-6 d-flex align-items-end mb-3">
						<img class="me-3" width="130" id="profileImg" src="${emp.profileImgPath }"
							alt="Profile Picture" style="object-fit: contain;"> <label
							for="profileImgFile" class="col-form-label btn btn-secondary btn-lg">사진
							등록</label> <input style="display: none;" id="profileImgFile"
							name="profileImgFile" class="form-control" type="file"
							accept="image/*">
					</div>
					<div class="col-md-6 d-flex justify-content-end">
						<div id="qrcode"></div>
					</div>
					<hr />

					<div class="col-md-6">
						<label for="empName" class="form-label">이름<span class="text-danger">*</span></label> <input
							id="empName" name="empName" type="text" value="${emp.empName }" class="form-control" required>
					</div>

					<div class="col-md-6">
					    <label for="empRrn1" class="form-label">주민번호<span class="text-danger">*</span></label>
					    <div class="input-group">
					        <input id="empRrn1" type="text" value="${fn:substring(emp.empRrn, 0, 6)}" maxlength="6" class="form-control" required>
					        <span class="px-3 d-flex align-items-center"> - </span>
        					<input id="empRrn2" type="text" value="${fn:substring(emp.empRrn, 6, 13)}" maxlength="7" class="form-control" required>
					    </div>
					    <input type="hidden" id="empRrn" name="empRrn" value="${emp.empRrn}" />
					</div>

					<div class="col-md-6">
						<label for="empPw" class="form-label">비밀번호<span class="text-danger">*</span></label> <input
							id="empPw" name="empPw" type="password" class="form-control" required>
					</div>

					<div class="col-md-6">
						<label for="confirmPw" class="form-label">비밀번호 확인<span class="text-danger">*</span></label> <input
							id="confirmPw" type="password" class="form-control" required>
						<div id="pwCheck"></div>
					</div>

					<div class="col-md-6">
						<label for="empTel" class="form-label">연락처<span class="text-danger">*</span></label> <input
							id="empTel" name="empTel" type="tel" value="${emp.empTel }" class="form-control" maxlength="11" required>
					</div>

					<div class="col-md-6">
						<label for="empTel" class="form-label">내선번호</label> <input
							id="extNo" name="extNo" type="tel" value="${emp.extNo }" class="form-control" maxlength="11" readonly>
					</div>

					<div class="col-md-6">
						<label for="empPsnEmail" class="form-label">개인이메일<span class="text-danger">*</span></label> <input
							id="empPsnEmail" name="empPsnEmail" type="email" value="${emp.empPsnEmail }"
							class="form-control" required>
					</div>

					<div class="col-md-6">
						<label for="empEmail" class="form-label">사내이메일<span class="text-danger">*</span></label> <input
							id="empEmail" name="empEmail" type="email" value="${emp.empEmail }" class="form-control" readonly>
					</div>

					<div class="col-md-6">
						<label for="empBirth" class="form-label">생년월일<span class="text-danger">*</span></label> <input
							id="empBirth" name="empBirth" type="date" class="form-control" required>
					</div>

					<div class="col-md-6">
						<label for="joinDay" class="form-label">입사일<span class="text-danger">*</span></label> <input
							id="joinDay" name="joinDay" type="date" class="form-control" readonly>
					</div>

					<div class="col-md-6">
						<label for="deptCode" class="form-label">부서</label> <select
							id="deptCode" name="deptCode" class="form-select" disabled>
							<option value="" <c:if test="${empty emp.deptCode }">selected</c:if>>(없음)</option>
							<c:forEach var="dept" items="${deptList }">
								<option value="${dept.deptCode }" <c:if test="${emp.deptCode eq dept.deptCode }">selected</c:if>>${dept.deptName }</option>
							</c:forEach>
						</select>
					</div>

					<div class="col-md-6">
						<label for="positionCode" class="form-label">직위<span class="text-danger">*</span></label> <select
							id="positionCode" name="positionCode" class="form-select" disabled>
							<option value="" <c:if test="${empty emp.positionCode }">selected</c:if>>(없음)</option>
							<c:forEach var="entry" items="${positionMap}">
							    <option value="${entry.key}" <c:if test="${emp.positionCode eq entry.key}">selected</c:if>>
							        ${entry.value}
							    </option>
							</c:forEach>
						</select>
					</div>

					<div class="col-12">
						<div class="col-md-6">
							<label for="dutyCode" class="form-label">직책</label> <select
								id="dutyCode" name="dutyCode" class="form-select" disabled>
								<option value="" <c:if test="${empty emp.dutyCode }">selected</c:if>>(없음)</option>
								<c:forEach var="entry" items="${dutyMap}">
								    <option value="${entry.key}" <c:if test="${emp.dutyCode eq entry.key}">selected</c:if>>
								        ${entry.value}
								    </option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="col-md-4">
						<label for="empZip" class="form-label">우편번호<span class="text-danger">*</span></label>
						<div class="input-group">
							<input id="empZip" name="empZip" type="text" value="${emp.empZip }" class="form-control" required>
							<button type="button" class="btn btn-secondary btn-lg"
								onclick="daumPostcode()">우편번호 찾기</button>
						</div>
					</div>

					<div class="col-12">
						<div class="row g-3">
							<div class="col-md-6">
								<label for="empAddr1" class="form-label">주소<span class="text-danger">*</span></label> <input
									id="empAddr1" name="empAddr1" type="text" value="${emp.empAddr1 }" class="form-control" required>
							</div>
							<div class="col-md-6">
								<label for="empAddr2" class="form-label">상세주소<span class="text-danger">*</span></label> <input
									id="empAddr2" name="empAddr2" type="text" value="${emp.empAddr2 }" class="form-control" required>
							</div>
						</div>
					</div>

					<div class="col-md-6">
						<label for="bankCode" class="form-label">은행<span class="text-danger">*</span></label> <select
							id="bankCode" name="bankCode" class="form-select">
							<c:forEach var="entry" items="${bankMap}">
							    <option value="${entry.key}" <c:if test="${emp.bankCode eq entry.key}">selected</c:if>>
							        ${entry.value}
							    </option>
							</c:forEach>
						</select>
					</div>

					<div class="col-md-6">
						<label for="accountNo" class="form-label">계좌번호<span class="text-danger">*</span></label> <input
							id="accountNo" name="accountNo" type="text" value="${emp.accountNo }" class="form-control" required>
					</div>

					<div class="col-12">
						<label for="signImgFile" class="col-sm-3 col-form-label">서명이미지</label>
						<div class="col-sm-6">
							<img id="signImg" 
								<c:if test="${not empty base64signImg }">src="data:image/png;base64,${base64signImg}"</c:if> 
							 	alt="Signature Image" width="150" style="object-fit: contain;">
							<input id="signImgFile" name="signImgFile" class="form-control" type="file" accept="image/*">
								
						</div>
					</div>
					
					<div class="col-md-6">
						<label for="leaveDay" class="form-label">퇴사일</label> <input
							id="leaveDay" name="leaveDay" type="date" class="form-control" disabled>
					</div>
					
					<div class="col-md-6">
						<label for="hffcStatus" class="form-label">상태</label> <select
							id="hffcStatus" name="hffcStatus" class="form-select" disabled>
							<c:forEach var="entry" items="${hffcMap}">
							    <option value="${entry.key}" <c:if test="${emp.hffcStatus eq entry.key}">selected</c:if>>
							        ${entry.value}
							    </option>
							</c:forEach>
						</select>
					</div>
					
					<div class="col-12">
						<label class="form-check-label">관리자 여부<span class="text-danger">*</span></label>
						<div class="row g-3">
							<div class="col-sm-9 pt-3">
								<div class="form-check form-check-inline">
									<input id="adminY" class="form-check-input" type="radio"
										name="adminYn" value="Y" disabled
										<c:if test="${emp.adminYn eq 'Y' }">checked</c:if>
										> <label for="adminY"
										class="form-check-label">예</label>
								</div>

								<div class="form-check form-check-inline">
									<input id="adminN" class="form-check-input" type="radio"
										name="adminYn" value="N" disabled
										<c:if test="${emp.adminYn eq 'N' }">checked</c:if>
										> <label
										for="adminN" class="form-check-label">아니오</label>
								</div>
							</div>
						</div>
					</div>

					<div class="col-12 gap-1 pt-3 d-flex justify-content-center">
						<button type="submit" class="btn btn-danger btn-lg">수정</button>
						<button type="button" id="cancelBtn" class="btn btn-dark btn-lg">되돌리기</button>
					</div>
					<sec:csrfInput />
				</form>

			</div>
		</div>
	</div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
	const myForm = document.querySelector("#myForm");
	var profileImgFile = document.querySelector("#profileImgFile");
	var signImgFile = document.querySelector("#signImgFile");
	
	var empBirth = document.querySelector("#empBirth");
	var joinDay = document.querySelector("#joinDay");
	var leaveDay = document.querySelector("#leaveDay");
	
	var cancelBtn = document.querySelector("#cancelBtn");
	
	var empPw = document.querySelector("#empPw");
	var confirmPw = document.querySelector("#confirmPw");
	var pwCheck = document.querySelector("#pwCheck");
	
	// QR 코드 생성
	var qrValue = "${emp.empQr}";
	const qrContainer = document.querySelector("#qrcode");
	const qrCode = new QRCode(qrContainer, {
		text: qrValue,
		width: 150,
		height: 150,
		colorDark: "#000000",
		colorLight: "#ffffff",
		correctLevel: QRCode.CorrectLevel.H
	});
	
	// 날짜 데이터(ex.20200124) input type date에 설정
	getInputTypeDateDatas(empBirth, "${emp.empBirth}");
	getInputTypeDateDatas(joinDay, "${emp.joinDay}");
	getInputTypeDateDatas(leaveDay, "${emp.leaveDay}");
	
	cancelBtn.addEventListener("click", setInitialValue);
	profileImgFile.addEventListener("change", printImg);
	signImgFile.addEventListener("change", printImg);
	
	// 비밀번호 일치 여부 확인
	confirmPw.addEventListener("keyup", function() {
		vpwd = empPw.value;
		vpwdconfirm = confirmPw.value;

		if (vpwd === vpwdconfirm && vpwd.length > 0 && vpwdconfirm.length > 0) {
			pwCheck.innerText = '비밀번호가 일치합니다.';
			pwCheck.className = "valid-feedback";
			confirmPw.classList.remove("is-invalid");
			empPw.classList.remove("is-invalid");
			confirmPw.classList.add("is-valid");
			empPw.classList.add("is-valid");
		} else {
			pwCheck.innerText = '비밀번호가 일치하지 않습니다.';
			pwCheck.className = "invalid-feedback";
			confirmPw.classList.remove("is-valid");
			empPw.classList.remove("is-valid");
			confirmPw.classList.add("is-invalid");
			empPw.classList.add("is-invalid");
		}
	});
	
	// 폼 전송
	myForm.addEventListener("submit", function() {
		event.preventDefault();
		
		// 주민등록번호 앞자리 + 뒷자리를 empRrn에 세팅
		// 입력값 검증
	    var empRrn1 = document.querySelector("#empRrn1").value;
	    var empRrn2 = document.querySelector("#empRrn2").value;
	    var fullEmpRrn = empRrn1 + empRrn2;
	    document.querySelector("#empRrn").value = fullEmpRrn;
	    var empTel = document.querySelector("#empTel").value;
	    var extNo = document.querySelector("#extNo").value;
		
		var isValid = validateEmployeeInfo(fullEmpRrn, empTel, extNo, empPw.value, confirmPw.value);
	    if(isValid) {
	    	var formElems = myForm.elements;
			for(var i=0; i<formElems.length; i++) {
				formElems[i].disabled = false;
			}
			myForm.submit();
	    }
	});
});

// 초기화 되는 값들 다시 기존 값으로 세팅
function setInitialValue() {
	event.preventDefault();
	myForm.reset();
	
	// 날짜
	getInputTypeDateDatas(empBirth, "${emp.empBirth}");
	getInputTypeDateDatas(joinDay, "${emp.joinDay}");
	getInputTypeDateDatas(leaveDay, "${emp.leaveDay}");
	// 이미지
	document.querySelector("#profileImg").src = "${emp.profileImgPath }";
	document.querySelector("#signImg").src = "data:image/png;base64,${base64signImg}";
}
</script>
