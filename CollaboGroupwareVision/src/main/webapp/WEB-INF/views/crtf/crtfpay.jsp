<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    


<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item"><a href="/dclz/dclzhome">서류발급</a></li>
				<li class="breadcrumb-item active" aria-current="page">급여명세서 발급</li>
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

				<div class="d-md-flex gap-4">







					<!-- Full calendar container -->
					<div class="flex-fill">

						<!-- Horizontal Form -->



						<div class="card mx-auto">
							<div class="card-header mb-3">
								<h3 class="btn-group mt-4 float-start fb">급여명세서 조회</h3>

								<!-- 급여월 -->
								<!-- Dark dropdowns -->
								<div class="btn-group m-3 float-end" >
									<select id="payMonth" class="form-select bg-primary text-white">
										<option value="">급여월</option>
										<c:forEach begin="1" end="12" varStatus="vs">
											<option value="${vs.count }" <c:if test="${workM eq vs.count }">selected</c:if>>${vs.count }</option>
										</c:forEach>
									</select>
								</div>
								<!-- END : Dark dropdowns -->
								<!-- 급여연도 -->
								<!-- Dark dropdowns -->
								<div class="btn-group m-3 float-end">
									<select id="payYear" class="form-select bg-primary text-white">
										<option value="">급여연도</option>
										<option value="2024" <c:if test="${workY eq 2024 }">selected</c:if>>2024</option>
										<option value="2023" <c:if test="${workY eq 2023 }">selected</c:if>>2023</option>
										<option value="2022" <c:if test="${workY eq 2022 }">selected</c:if>>2022</option>
									</select>
								</div>
							<form action="/crtf/crtfpay" method="post" id="searchForm">
								<input type="hidden" name="page" id="page"/>
								<input type="hidden" name="workY" id="payYearHd" value="${workY }"/>
								<input type="hidden" name="workM" id="payMonthHd" value="${workM }"/>
								<sec:csrfInput/>
							</form>
						</div>






							<div class="card-body">
								<div class="table-responsove">
									<table class="table table-striped">
										<thead>
											<tr class="text-center">
												<th>발급번호</th>
												<th>급여연도</th>
												<th>급여월</th>
												<th>출력</th>
											</tr>
										</thead>
										<tbody>

											<c:set value="${pagingVO.dataList }" var="payList" />

											<c:choose>

												<c:when test="${empty payList }">
													<tr class="text-center">
														<td colspan="4">급여명세서 발급 내역이 존재하지 않습니다.</td>
													</tr>
												</c:when>

												<c:otherwise>

													<c:forEach items="${payList }" var="pay">
														<tr class="text-center">
															<td>${pay.crtfPayNo}</td>
															<td>${pay.workY}</td>
															<td>${pay.workM}</td>
															<td class="fs-5">
																<a href="paypdf?workY=${pay.workY}&workM=${pay.workM}" class="btn btn-danger btn-sm">출력</a>
																<!-- <button type="button" class="btn btn-danger btn-sm"></button> -->
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
					<!-- END : Full calendar container -->

				</div>


			</div>
		</div>

	</div>
</div>



<script>
	$(function() {
		var payYear = $("#payYear");
		var payMonth = $("#payMonth");
		
		//페이징을 처리할 때 사용할 Element
		//pagingArea div안에 ul과 li로 구성된 페이징 정보가 존재
		//그 안에는 a태그로 구성된 페이지 정보가 들어있음
		//a태그 안에 들어있는 page번호를 가져와서 페이징처리를 진행
		var pagingArea = $("#pagingArea");
		var searchForm = $("#searchForm");

		pagingArea.on("click", "a", function(event) {

			event.preventDefault(); //a태그의 이벤트를 block
			var pageNo = $(this).data("page");
			searchForm.find("#page").val(pageNo);
			searchForm.submit();

		});

		// 급여연도 or 급여월을 클릭했을때 검색 이벤트 실행
		payYear.on("change", function(){
			var yearVal = $("#payYear").val();
			$("#payYearHd").val(yearVal);
			$("#searchForm").submit();
		});

		payMonth.on("change", function(){
			var monthVal = $("#payMonth").val();
			$("#payMonthHd").val(monthVal);
			$("#searchForm").submit();
		});
		
	});
</script>

