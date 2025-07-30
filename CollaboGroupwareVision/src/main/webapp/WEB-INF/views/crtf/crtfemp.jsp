<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>


<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item"><a href="/dclz/dclzhome">서류발급</a></li>
				<li class="breadcrumb-item active" aria-current="page">재직증명서 발급</li>
			</ol>
		</nav>
		<!-- Breadcrumb 끝-->
		<br />

	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card">
			<div class="card-body">

				<div class="d-md-flex gap-4 d-flex align-items-center">

					<div id="leftTime" class="alert col-md-3">

						<h3 class="card-title">재직증명서 신청 폼</h3>
						<hr />
						<br>

						<!-- Horizontal Form -->
						<form action="/crtf/crtfempinsert" id="usePlaceInput"
							method="post">
							<div class="row mb-3">
								<label class="col-sm-2 col-form-label">사용처</label>
								<div class="col-sm-10">
									<textarea class="form-control" placeholder="사용처를 입력하세요"
										rows="10" style="resize: none;" id="usePlace" name="usePlace"></textarea>
								</div>
							</div>

							<div class="row mb-3">
								<div class="col-sm-10 offset-sm-2">
									<div class="form-check">
										<input id="chkbox" class="form-check-input" type="checkbox">
										본 재직증명서는 직접 입력한 사용처 이외의 다른 목적으로 사용되지 않음을 확인합니다.
									</div>
								</div>
							</div>

							<sec:csrfInput />
						</form>
						<div class="text-center">
							<input type="button" class="btn btn-primary" id="insertBtn"
								value="신청"> <input type="button" class="btn btn-danger"
								id="cancelBtn" value="취소">
						</div>
						<!-- END : Horizontal Form -->






					</div>
					<!-- 좌측공간  -->



					<!-- 우측공간 -->
					<div class="flex-fill">

						<div class="card">
							<div class="card-header mb-3">
								<h3 class="card-title mb-3 float-start">재직증명서 발급 조회</h3>


								<!-- 검색폼!!!!!!!!!!!!  -->
								<!-- action이 없으면 자기 자신을 반환함 -->
								<form
									class="input-group input-group-sm bg-primary text-white float-end "
									method="post" action="/crtf/crtfemp" id="searchForm"
									style="width: 440px;">
									<input type="hidden" name="page" id="page" /> <select
										class="form-control bg-primary text-white fs-5" name="searchType">
										<option value="crtfNo"
											<c:if test="${searchType eq 'crtfNo' }">selected</c:if>>발급번호</option>
										<option value="usePlace"
											<c:if test="${searchType eq 'usePlace' }">selected</c:if>>사용처</option>
									</select> <input type="text" name="searchWord" value="${searchWord}"
										class="form-control float-right bg-primary text-white fs-5"
										placeholder="Search">
									<div class="input-group-append">
										<button type="submit"
											class="btn btn-default bg-primary text-white fs-5">
											<i class="fas fa-search"></i>검색
										</button>
									</div>
									<sec:csrfInput />
								</form>


							</div>



							<div class="card-body">
								<div class="table-responsove">
									<table class="table table-striped">
										<thead>
											<tr class="text-center">
												<th>발급번호</th>
												<th>발급일시</th>
												<th>사원번호</th>
												<th>사용처</th>
												<th>출력</th>
											</tr>
										</thead>
										<tbody>

											<c:set value="${pagingVO.dataList }" var="empList" />

											<c:choose>

												<c:when test="${empty empList }">
													<tr class="text-center">
														<td colspan="5">재직증명서 발급 내역이 존재하지 않습니다.</td>
													</tr>
												</c:when>

												<c:otherwise>

													<c:forEach items="${empList }" var="empcrtf">
														<tr class="text-center">
															<td>${empcrtf.crtfEmpNo}</td>
															<td>${empcrtf.crtfEmpDate}</td>
															<td>${empcrtf.empNo}</td>
															<td>${empcrtf.usePlace}</td>
															<td class="fs-5"><a
																href="emppdf?crtfEmpNo=${empcrtf.crtfEmpNo}"
																class="btn btn-danger btn-sm">출력</a> <!-- <button type="button" class="btn btn-danger btn-sm"></button> -->
															</td>

														</tr>
													</c:forEach>

												</c:otherwise>

											</c:choose>
										</tbody>
									</table>
								</div>


								<div class="card-footer clearfix d-flex justify-content-center"
									id="pagingArea">${pagingVO.pagingHTML }</div>



							</div>
						</div>



						<br /> <br />

					</div>
					<!-- 우측공간 끝 -->

				</div>


			</div>
		</div>

	</div>
</div>


<script>
	$(function() {
		//페이징을 처리할 때 사용할 Element
		//pagingArea div안에 ul과 li로 구성된 페이징 정보가 존재
		//그 안에는 a태그로 구성된 페이지 정보가 들어있음
		//a태그 안에 들어있는 page번호를 가져와서 페이징처리를 진행
		var pagingArea = $("#pagingArea");
		var searchForm = $("#searchForm");
		var insertBtn = $("#insertBtn"); // 신청 버튼 element
		var usePlaceForm = $("#usePlaceInput"); //신청 폼 element
		var cancelBtn = $("#cancelBtn"); //취소 버튼 element

		pagingArea.on("click", "a", function(event) {

			event.preventDefault(); //a태그의 이벤트를 block
			var pageNo = $(this).data("page");
			searchForm.find("#page").val(pageNo);
			searchForm.submit();

		}); //pagingArea 클릭이벤트 끝

		//신청 버튼 클릭 시, 신청 진행
		insertBtn.on("click", function() {
			var usePlace = $("#usePlace").val();
			if (usePlace == null || usePlace == "") {
				Swal.fire({
					icon : 'warning',
					text : `사용처를 입력해주세요!`,
				})
				$("#usePlace").focus();
				return false;
			}

			var checked = $('#chkbox').is(':checked');
			if (!checked) {
				Swal.fire({
					icon : 'warning',
					text : `체크박스 체크 후 신청이 가능합니다.`,
				})
				$("#chkbox").focus();
				return false;
			}

			usePlaceForm.submit(); //전송

		});

		//취소버튼 클릭시, 상세보기 화면으로 이동
		cancelBtn.on("click", function() {
			location.href = "/crtf/crtfemp";
		});

	});
</script>


