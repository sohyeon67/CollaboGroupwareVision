<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
img {
	width: 10px;
	height: 10px;
	margin: auto 0;
}
</style>




						<div id="leftTime"
							class="alert col-md-3 d-felx justify-content-center"
							style="width: 25%; margin-right: 8%;">
							<div class="table-responsive">
								<table class="table">
									<tbody>
										<tr>
											<td colspan="2" class="w-60" style="font-size: 2em;"
												id="currentDate"></td>
										</tr>
										<tr>
											<td colspan="2" rowspan="2" style="font-size: 5em;"
												id="currentTime"></td>
										</tr>
										<tr>
										</tr>
										<tr>
											<td style="font-size: 1.3em;"><i class="demo-pli-clock"></i>
												출근시각</td>
											<td style="font-size: 1.3em;" id="startWorkTime">${fn:split(dclzTime.gowkDate," ")[1]}</td>
										</tr>
										<tr>
											<td style="font-size: 1.3em;"><i class="demo-pli-clock"></i>
												퇴근시각</td>
											<td style="font-size: 1.3em;" id="leaveWorkTime">${fn:split(dclzTime.lvwkDate," ")[1]}</td>
										</tr>
										<tr>
											<td rowspan="2" class="w-50">
												<button type="button" style="font-size: 1.5em;"
													class="btn btn-info btn-lg w-100 text-center" id="startBtn">출근</button>
											</td>
											<td rowspan="2" class="w-50">
												<button type="button" style="font-size: 1.5em;"
													class="btn btn-info btn-lg w-100 text-center" id="leaveBtn">퇴근</button>
											</td>
										</tr>
									</tbody>
								</table>


								<!-- content -->


							</div>
							
							<div class="d-flex justify-content-center">
								<img src="${pageContext.request.contextPath}/resources/img/dclz/green.png" alt="출근">&nbsp;출근&nbsp;
								<img src="${pageContext.request.contextPath}/resources/img/dclz/orange.png" alt="지각">&nbsp;지각&nbsp;
								<img src="${pageContext.request.contextPath}/resources/img/dclz/blue.png" alt="퇴근">&nbsp;퇴근&nbsp;
								<img src="${pageContext.request.contextPath}/resources/img/dclz/yellow.png" alt="출장">&nbsp;출장&nbsp;
								<img src="${pageContext.request.contextPath}/resources/img/dclz/purple.png" alt="연차">&nbsp;연차&nbsp;
								<img src="${pageContext.request.contextPath}/resources/img/dclz/pink.png" alt="반차">&nbsp;반차&nbsp;
								<img src="${pageContext.request.contextPath}/resources/img/dclz/red.png" alt="병가">&nbsp;병가&nbsp;
							</div>
							<br/>
							
							<h3 class="text-center">당월 근태 현황</h3>
							<div
								class="card-body d-flex justify-content-center align-items-center flex-wrap gap-4 p-3">


								<hr class="d-md-none my-5">
								<div class="vr d-none d-md-block"></div>

								<!-- 근무 누적  -->
								<div class="w-md-170px">
									<div class="text-center">
										<h5>근무</h5>
										<div class="mt-4">
											<span class="display-6 h5 fw-bold" id="workStatus"></span>
										</div>
									</div>
								</div>
								<!-- 근무 누적 끝-->

								<hr class="d-md-none my-5">
								<div class="vr d-none d-md-block"></div>



								<!-- 지각 누적  -->
								<div class="w-md-170px">
									<div class="text-center">
										<h5>지각</h5>
										<div class="mt-4">
											<span class="display-6 h5 fw-bold" id="lateStatus"></span>
										</div>
									</div>
								</div>
								<!-- 지각 누적 끝-->

								<hr class="d-md-none my-5">
								<div class="vr d-none d-md-block"></div>


								<!-- 출장 누적  -->
								<div class="w-md-170px">

									<div class="text-center">
										<h5>출장</h5>
										<div class="mt-4">
											<span class="display-6 h5 fw-bold" id="tripStatus"></span>
										</div>
									</div>
								</div>
								<!-- 출장 누적 끝-->
								<div class="vr d-none d-md-block"></div>



							</div>
							<div
								class="card-body d-flex justify-content-center align-items-center flex-wrap gap-4 p-4">


								<hr class="d-md-none my-5">
								<div class="vr d-none d-md-block"></div>

								<!-- 연차 누적  -->
								<div class="w-md-170px">
									<div class="text-center">
										<h5>연차</h5>
										<div class="mt-4">
											<span class="display-6 h5 fw-bold" id="annualStatus"></span>
										</div>
									</div>
								</div>
								<!-- 연차 누적 끝-->

								<hr class="d-md-none my-5">
								<div class="vr d-none d-md-block"></div>



								<!-- 반차 누적  -->
								<div class="w-md-170px">
									<div class="text-center">
										<h5>반차</h5>
										<div class="mt-4">
											<span class="display-6 h5 fw-bold" id="halfStatus"></span>
										</div>
									</div>
								</div>
								<!-- 반차 누적 끝-->

								<hr class="d-md-none my-5">
								<div class="vr d-none d-md-block"></div>


								<!-- 병가/결근 누적  -->
								<div class="w-md-170px">

									<div class="text-center">
										<h5>병가</h5>
										<div class="mt-4">
											<span class="display-6 h5 fw-bold" id="sickAndAbsentStatus"></span>
										</div>
									</div>
								</div>
								<!-- 병가/결근 누적 끝-->
								<div class="vr d-none d-md-block"></div>

								<!-- 누적근황 끝 -->

							</div>
							<!-- 좌측공간 끝 -->



						</div> 