// 폼 데이터 체크
function validateEmployeeInfo(fullEmpRrn, empTel, extNo, password, confirmPassword) {
    // 주민등록번호 숫자 및 길이 검증
    if (!/^\d{13}$/.test(fullEmpRrn)) {
        alertWarning('올바른 주민등록번호를 입력해주세요!');
        return false;
    }

    // 연락처 숫자 및 길이 검증
    if (!/^\d{11}$/.test(empTel)) {
        alertWarning('연락처는 특수문자 없이 11자리를 입력해주세요!');
        return false;
    }

    // 내선번호 숫자 검증
    if (!/^\d{11}$/.test(extNo)) {
        alertWarning('내선번호는 특수문자 없이 11자리를 입력해주세요!');
        return false;
    }
    
	// 비밀번호 확인
    if(password !== confirmPassword) {
    	alertWarning('비밀번호를 확인해주세요!');
    	return false;
    }

    // 모든 조건 통과 시 true 반환
    return true;
}

// 이미지 파일인지 체크
function isImageFile(file) {
	var ext = file.name.split(".").pop().toLowerCase(); // 확장자
	var extArr = [ "jpg", "jpeg", "gif", "png" ];
	return extArr.includes(ext);
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
		alertError('이미지 파일을 선택해주세요!');
	}
}

//날짜 데이터(ex.20200124) input type date에 설정
function getInputTypeDateDatas(dateObj, dateStr) {
	if(dateStr == "" || dateStr.length == 0) {
		return;
	}
	var formattedDate = `${dateStr.slice(0, 4)}-${dateStr.slice(4, 6)}-${dateStr.slice(6, 8)}`;
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