<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<style>
#passCard {
	width: 320px;
	height: 250px;
}
</style>
<div
	class="content__boxed w-100 min-vh-100 d-flex flex-column align-items-center justify-content-center">
	<div class="content__wrap">

		<div id="passCard" class="card shadow-lg">
			<div class="card-body">

				<div class="text-center">
					<h1 class="h3 pb-3 fw-bold">비밀번호 확인</h1>
				</div>

				<form class="mt-4" action="/account/checkPassword" method="post">

					<div class="mb-3">
						<input type="password" name="password" class="form-control"
							placeholder="비밀번호">
					</div>

					<div class="d-grid mt-5">
						<button class="btn btn-info btn-lg" type="submit">확인</button>
					</div>
					<sec:csrfInput />
				</form>

			</div>
		</div>
	</div>
</div>
