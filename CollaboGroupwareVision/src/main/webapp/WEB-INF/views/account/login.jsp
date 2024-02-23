<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<div class="content__boxed w-100 min-vh-100 d-flex flex-column align-items-center justify-content-center">
    <div class="content__wrap">

        <div class="card shadow-lg p-2">
            <div class="card-body">

                <div class="text-center m-2">
                    <h1 class="h3">Collabo Groupware Vision</h1>
                    <p class="fs-5 mt-3">로그인 정보를 입력하세요.</p>
                </div>

                <form class="mt-4" action="/login" method="post" id="loginForm">

                    <div class="mb-3">
                        <input type="text" name="username" id="empNo" class="form-control" placeholder="사원번호" autofocus>
                    </div>

                    <div class="mb-3">
                        <input type="password" name="password" id="empPw" class="form-control" placeholder="비밀번호">
                    </div>

                    <div class="d-grid mt-5">
                        <button class="btn btn-primary btn-lg" type="button" id="loginBtn">로그인</button>
                    </div>
                    <sec:csrfInput/>
                </form>

                <div class="d-flex flex-row-reverse justify-content-between mt-4">
                    <a href="/accounts/findPassword" class="btn-link text-decoration-none">비밀번호 찾기</a>
                </div>

            </div>
        </div>

    </div>
</div>
<script type="text/javascript">
$(function() {
	var loginForm = $("#loginForm");
	var loginBtn = $("#loginBtn");
	
	var empNo = $("#empNo");
	var empPw = $("#empPw");
	
	loginBtn.on("click", function() {
		var id = empNo.val();
		var pw = empPw.val();
		
		if(id == null || id == "") {
			Swal.fire({
			    icon: 'warning',
			    title: '경고',
			    text: '사원번호를 입력해주세요.'
			});
			empNo.focus();
			return false;
		}
		if(pw == null || pw == "") {
			Swal.fire({
			    icon: 'warning',
			    title: '경고',
			    text: '비밀번호를 입력해주세요.'
			});
			empPw.focus();
			return false;
		}
		
		loginForm.submit();
	});
	
	$("#empNo, #empPw").on("keydown", function(event) {
        if(event.which === 13) {
            loginBtn.click();
        }
    });
});
</script>

