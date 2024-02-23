<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- QR 스크립트  -->
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/dclz/qrcode.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/dclz/qrcode.min.js"></script>

<style>
label {
	color: black;
}
</style>

<c:if test="${not empty errorMsg }">
<script>
Swal.fire({
    icon: 'error',
    title: '오류',
    text: '${errorMsg }'
});
</script>
</c:if>
<c:set value="등록" var="name"/>
<c:if test="${status eq 'u' }">
	<c:set value="수정" var="name"/>
</c:if>
<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/index">Home</a></li>
				<li class="breadcrumb-item active" aria-current="page">사원통합관리</li>
			</ol>
		</nav>
		<br />
	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">

		<div class="card h-100 p-3">
			<h3 class="m-3 fw-bold">사원${name }</h3>
			<div class="card-body">

				<form class="row g-3" action="/account/register" method="post"
					id="registerForm" enctype="multipart/form-data">
					<c:if test="${status eq 'u' }">
						<input type="hidden" name="empNo" value="${emp.empNo }"/>
						<input type="hidden" name="profileImgPath" value="${emp.profileImgPath }"/>
						<!-- 기존 서명 사진 base64 값 저장 후 컨트롤러에서 디코딩 -->
						<input type="hidden" name="base64signImg" value="${base64signImg }"/>
					</c:if>

					<div class="col-md-6 d-flex align-items-end mb-3">
						<img class="img-xl me-3" id="profileImg" 
							<c:if test='${status ne "u" }'>src="/resources/assets/img/profile-photos/3.png"</c:if>
							<c:if test='${status eq "u" }'>src="${emp.profileImgPath }"</c:if>
							alt="Profile Picture" style="object-fit: contain;"> <label
							for="profileImgFile" class="col-form-label btn btn-secondary btn-lg">사진
							등록</label> <input style="display: none;" id="profileImgFile"
							name="profileImgFile" class="form-control" type="file"
							accept="image/*">
					</div>
					<div class="col-md-6 d-flex justify-content-end">
					<div id="qrcode"></div>
						<c:if test="${status ne 'u' }">
							<input type="hidden" id="empQr" name="empQr">
						</c:if>
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
							id="extNo" name="extNo" type="tel" value="${emp.extNo }" maxlength="11" class="form-control">
					</div>

					<div class="col-md-6">
						<label for="empPsnEmail" class="form-label">개인이메일<span class="text-danger">*</span></label> <input
							id="empPsnEmail" name="empPsnEmail" type="email" value="${emp.empPsnEmail }"
							class="form-control" required>
					</div>

					<div class="col-md-6">
						<label for="empEmail" class="form-label">사내이메일<span class="text-danger">*</span></label> <input
							id="empEmail" name="empEmail" type="email" value="${emp.empEmail }" class="form-control" required>
					</div>

					<div class="col-md-6">
						<label for="empBirth" class="form-label">생년월일<span class="text-danger">*</span></label> <input
							id="empBirth" name="empBirth" type="date" class="form-control" required>
					</div>

					<div class="col-md-6">
						<label for="joinDay" class="form-label">입사일<span class="text-danger">*</span></label> <input
							id="joinDay" name="joinDay" type="date" class="form-control" required>
					</div>

					<div class="col-md-6">
						<label for="deptCode" class="form-label">부서</label> <select
							id="deptCode" name="deptCode" class="form-select">
							<option value="" <c:if test="${status ne 'u' }">selected</c:if> disabled hidden>(선택)</option>
							<option value="" <c:if test="${not empty emp and empty emp.deptCode }">selected</c:if>>(없음)</option>
							<c:forEach var="dept" items="${deptList }">
								<option value="${dept.deptCode }" <c:if test="${emp.deptCode eq dept.deptCode }">selected</c:if>>${dept.deptName }</option>
							</c:forEach>
						</select>
					</div>

					<div class="col-md-6">
						<label for="positionCode" class="form-label">직위<span class="text-danger">*</span></label> <select
							id="positionCode" name="positionCode" class="form-select">
							<option value="" <c:if test="${status ne 'u' }">selected</c:if> disabled hidden>(선택)</option>
							<option value="" <c:if test="${not empty emp and empty emp.positionCode }">selected</c:if>>(없음)</option>
							<c:forEach var="map" items="${commonCodes }">
								<c:if test="${map['COMMON_CODE_GROUP_ID'] == '100'}">
									<option value="${map['COMMON_CODE'] }" <c:if test="${emp.positionCode eq map['COMMON_CODE'] }">selected</c:if>>${map['COMMON_CODE_NAME'] }</option>
								</c:if>
							</c:forEach>
						</select>
					</div>

					<div class="col-12">
						<div class="col-md-6">
							<label for="dutyCode" class="form-label">직책</label> <select
								id="dutyCode" name="dutyCode" class="form-select">
								<option value="" <c:if test="${status ne 'u' }">selected</c:if> disabled hidden>(선택)</option>
								<option value="" <c:if test="${not empty emp and empty emp.dutyCode }">selected</c:if>>(없음)</option>
								<c:forEach var="map" items="${commonCodes }">
									<c:if test="${map['COMMON_CODE_GROUP_ID'] == 101}">
										<option value="${map['COMMON_CODE'] }" <c:if test="${emp.dutyCode eq map['COMMON_CODE'] }">selected</c:if>>${map['COMMON_CODE_NAME'] }</option>
									</c:if>
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
							<option value="" <c:if test="${status ne 'u' }">selected</c:if> disabled hidden>(선택)</option>
							<c:forEach var="map" items="${commonCodes }">
								<c:if test="${map['COMMON_CODE_GROUP_ID'] == 103}">
									<option value="${map['COMMON_CODE'] }" <c:if test="${emp.bankCode eq map['COMMON_CODE'] }">selected</c:if>>${map['COMMON_CODE_NAME'] }</option>
								</c:if>
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
								<c:if test="${status eq 'u' and not empty base64signImg }">src="data:image/png;base64,${base64signImg}"</c:if> 
								<c:if test="${status ne 'u' }">style="display: none;"</c:if> 
							 	alt="Signature Image" width="150" style="object-fit: contain;">
							<input id="signImgFile" name="signImgFile" class="form-control" type="file" accept="image/*">
								
						</div>
					</div>
					
					<c:if test="${status eq 'u' }">
						<div class="col-md-6">
							<label for="leaveDay" class="form-label">퇴사일</label> <input
								id="leaveDay" name="leaveDay" type="date" class="form-control">
						</div>
						
						<div class="col-md-6">
							<label for="hffcStatus" class="form-label">상태</label> <select
								id="hffcStatus" name="hffcStatus" class="form-select">
								<option value="" <c:if test="${status ne 'u' }">selected</c:if> disabled hidden>(선택)</option>
								<c:forEach var="map" items="${commonCodes }">
									<c:if test="${map['COMMON_CODE_GROUP_ID'] == 104}">
										<option value="${map['COMMON_CODE'] }" <c:if test="${emp.hffcStatus eq map['COMMON_CODE'] }">selected</c:if>>${map['COMMON_CODE_NAME'] }</option>
									</c:if>
								</c:forEach>
							</select>
						</div>
					</c:if>

					<div class="col-12">
						<label class="form-check-label">관리자 여부<span class="text-danger">*</span></label>
						<div class="row g-3">
							<div class="col-sm-9 pt-3">
								<div class="form-check form-check-inline">
									<input id="adminY" class="form-check-input" type="radio"
										name="adminYn" value="Y" 
										<c:if test="${emp.adminYn eq 'Y' }">checked</c:if>
										> <label for="adminY"
										class="form-check-label">예</label>
								</div>

								<div class="form-check form-check-inline">
									<input id="adminN" class="form-check-input" type="radio"
										name="adminYn" value="N" <c:if test="${status ne 'u' }">checked</c:if> 
										<c:if test="${emp.adminYn eq 'N' }">checked</c:if>
										> <label
										for="adminN" class="form-check-label">아니오</label>
								</div>
							</div>
						</div>
					</div>

					<div class="col-12 gap-1 pt-3 d-flex justify-content-center">
						<button type="submit" class="btn btn-danger btn-lg">${name }</button>
						<button type="button" id="cancelBtn" class="btn btn-dark btn-lg">취소</button>
						<a href="/account/empManage" class="btn btn-success btn-lg">목록</a>
						<c:if test="${status ne 'u' }">
							<button type="button" class="btn btn-light btn-lg" onclick="setDemoValues()">시연용</button>
						</c:if>
					</div>
					<sec:csrfInput />
				</form>

			</div>
		</div>
	</div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
	const registerForm = document.querySelector("#registerForm");
	var status = "${status}";
	var profileImgFile = document.querySelector("#profileImgFile");
	var signImgFile = document.querySelector("#signImgFile");
	var empQr = document.querySelector("#empQr");
	
	var empBirth = document.querySelector("#empBirth");
	var joinDay = document.querySelector("#joinDay");
	var leaveDay = document.querySelector("#leaveDay");
	
	var empPw = document.querySelector("#empPw");
	var confirmPw = document.querySelector("#confirmPw");
	var pwCheck = document.querySelector("#pwCheck");
	
	// QR 코드 생성
	var qrValue;
	if(status === 'u') {
		qrValue = "${emp.empQr}";
	} else {
		qrValue = generateUniqueString();
	}
	
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
	registerForm.addEventListener("submit", function() {
		event.preventDefault();
		
		if(status === 'u') {	// 수정
			registerForm.action = "/account/update";
		} else {	// 등록
			empQr.value = qrValue;	// QR 코드 값 세팅
		}
		
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
			registerForm.submit();
	    }
	});
	
	cancelBtn.addEventListener("click", setInitialValue);
	profileImgFile.addEventListener("change", printImg);
	signImgFile.addEventListener("change", printImg);
	
	
});

function validateEmployeeInfo(fullEmpRrn, empTel, extNo, password, confirmPassword) {
    // 주민등록번호 숫자 및 길이 검증
    if (!/^\d{13}$/.test(fullEmpRrn)) {
        showWarning('올바른 주민등록번호를 입력해주세요!');
        return false;
    }

    // 연락처 숫자 및 길이 검증
    if (!/^\d{11}$/.test(empTel)) {
        showWarning('연락처는 특수문자 없이 11자리를 입력해주세요!');
        return false;
    }

    // 내선번호 숫자 검증
    if (!/^\d{11}$/.test(extNo)) {
        showWarning('내선번호는 특수문자 없이 11자리를 입력해주세요!');
        return false;
    }
    
	// 비밀번호 확인
    if(password !== confirmPassword) {
    	showWarning('비밀번호를 확인해주세요!');
    	return false;
    }

    // 모든 조건 통과 시 true 반환
    return true;
}

function showWarning(message) {
    Swal.fire({
        icon: 'warning',
        title: '경고',
        text: message
    });
}

//초기화 되는 값들 다시 기존 값으로 세팅
function setInitialValue() {
	event.preventDefault();
	registerForm.reset();
	
	// 날짜
	getInputTypeDateDatas(empBirth, "${emp.empBirth}");
	getInputTypeDateDatas(joinDay, "${emp.joinDay}");
	getInputTypeDateDatas(leaveDay, "${emp.leaveDay}");
	// 이미지
	document.querySelector("#profileImg").src = "${emp.profileImgPath }";
	document.querySelector("#signImg").src = "data:image/png;base64,${base64signImg}";
}

//날짜 데이터(ex.20200124) input type date에 설정
function getInputTypeDateDatas(dateObj, dateStr) {
	if(dateStr == "" || dateStr.length == 0) {
		return;
	}
	var formattedDate = `\${dateStr.slice(0, 4)}-\${dateStr.slice(4, 6)}-\${dateStr.slice(6, 8)}`;
	//console.log("날짜데이터 포맷", formattedDate);
	if(dateObj != null) {	// 등록 폼에 없고 수정 페이지만 있는 input이 있을 수 있음
		dateObj.value = formattedDate;
	}
}

//현재 시각을 기반으로 한 랜덤 문자열 생성 함수, DB에 저장할 값
function generateUniqueString() {
	const timestamp = new Date().getTime();
	const randomString = Math.random().toString(36).substring(2, 8);
	console.log("생성된값", timestamp + "_" + randomString);
	return timestamp + "_" + randomString;
}

// base64 형태의 이미지 표시
function printImg() {
	var file = event.target.files[0];
	var imgId = event.target.id === "profileImgFile" ? "profileImg" : "signImg";

	if (isImageFile(file)) {
		var reader = new FileReader();
		reader.onload = function(e) { // 파일 읽기 완료 후 콜백
			document.querySelector("#"+imgId).src = e.target.result;
			document.querySelector("#"+imgId).style.display = "block";
		}
		reader.readAsDataURL(file); // 파일을 데이터 URL로 읽어옴. 데이터가 result 속성에 담긴다.
	} else {
		Swal.fire({
	        icon: 'error',
	        title: '오류',
	        text: '이미지 파일을 선택해주세요!'
	    });
	}
}

// 이미지 파일인지 체크
function isImageFile(file) {
	var ext = file.name.split(".").pop().toLowerCase(); // 확장자
	var extArr = [ "jpg", "jpeg", "gif", "png" ];
	return extArr.includes(ext);
}

//daum 주소 API(주소찾기)
function daumPostcode() {
	new daum.Postcode({
		oncomplete : function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var addr = ''; // 주소 변수
			var extraAddr = ''; // 참고항목 변수

			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				addr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				addr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
			if (data.userSelectedType === 'R') {
				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraAddr += (extraAddr !== '' ? ', '
							+ data.buildingName : data.buildingName);
				}
			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById('empZip').value = data.zonecode;
			document.getElementById("empAddr1").value = addr;
			// 커서를 상세주소 필드로 이동한다.
			document.getElementById("empAddr2").focus();
		}
	}).open();
}

// 발표 시연용 데이터 세팅
function setDemoValues() {
	$('#empName').val('강동원');
	$('#empRrn1').val('900101');
	$('#empRrn2').val('1234567');
	$('#empPw').val('1234');
	$('#confirmPw').val('1234');
	$('#empTel').val('01012345678');
	$('#extNo').val('07012341234');
	$('#empPsnEmail').val('dongwon.gang@gmail.com');
	$('#empEmail').val('dongwon.gang@ddit.or.kr');
	$('#empBirth').val('1990-01-01');
	$('#joinDay').val('2024-02-18');
	$('#deptCode').prop('selectedIndex', 5);
	$('#positionCode').prop('selectedIndex', 10);
	$('#dutyCode').prop('selectedIndex', 1);
	$('#empZip').val('13485');
	$('#empAddr1').val('경기 성남시 분당구 판교로 20');
	$('#empAddr2').val('3동 306호');
	$('#bankCode').prop('selectedIndex', 4);
	$('#accountNo').val('123-456-7890');
	$('#adminN').prop('checked', true);
}
</script>
