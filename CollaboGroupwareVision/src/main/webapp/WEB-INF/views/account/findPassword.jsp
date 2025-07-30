<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<c:if test="${not empty successMsg }">
<script>
Swal.fire({
    icon: 'success',
    title: '성공',
    text: '${successMsg }'
});
<c:remove var="successMsg" scope="request"/>
<c:remove var="successMsg" scope="session"/>
</script>
</c:if>
<c:if test="${not empty errorMsg }">
<script>
Swal.fire({
    icon: 'error',
    title: '오류',
    text: '${errorMsg }'
});
<c:remove var="errorMsg" scope="request"/>
<c:remove var="errorMsg" scope="session"/>
</script>
</c:if>

<div class="content__boxed w-100 min-vh-100 d-flex flex-column align-items-center justify-content-center">
    <div class="content__wrap">

        <div class="card shadow-lg">
            <div class="card-body">

                <div class="text-center m-2">
                    <h1 class="h3 fw-bold">비밀번호 찾기</h1>
                    <p class="fs-5 mt-3">임시 비밀번호를 개인 이메일로 전송합니다.</p>
                </div>

                <form class="mt-4" action="/accounts/findPassword" method="post" id="findPwForm">

                    <div class="mb-3">
                        <input type="text" id="empNo" name="empNo" value="${empNo }" class="form-control" placeholder="사원번호" autofocus>
                    </div>
                    
                    <div class="mb-3">
                        <input type="email" id="empPsnEmail" name="empPsnEmail" value="${empPsnEmail }" class="form-control" placeholder="개인이메일">
                    </div>

                    <div class="d-grid mt-5">
                        <button id="sendBtn" class="btn btn-warning btn-lg" type="button">임시 비밀번호 발송</button>
                    </div>
                    <sec:csrfInput/>
                </form>

                <div class="text-center mt-3">
                    <a href="/accounts/login" class="btn-link text-decoration-none">로그인 페이지로</a>
                </div>

            </div>
        </div>

    </div>
</div>
<script type="text/javascript">
$(function() {
	var findPwForm = $("#findPwForm");
	var sendBtn = $("#sendBtn");
	
	var empNo = $("#empNo");
	var empPsnEmail = $("#empPsnEmail");
	
	sendBtn.on("click", function() {
		var id = empNo.val();
		var email = empPsnEmail.val();
		
		if(id == null || id == "") {
			Swal.fire({
			    icon: 'warning',
			    title: '경고',
			    text: '사원번호를 입력해주세요.'
			});
			empNo.focus();
			return false;
		}
		if(email == null || email == "") {
			Swal.fire({
			    icon: 'warning',
			    title: '경고',
			    text: '개인이메일을 입력해주세요.'
			});
			empPsnEmail.focus();
			return false;
		}
		
		findPwForm.submit();
	});
	
	$("#empNo, #empPsnEmail").on("keydown", function(event) {
        if(event.which === 13) {
        	sendBtn.click();
        }
    });
});
</script>