<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!-- 차량예약 모달창 -->
<%@ include file="./vhclRegister.jsp"%>


<style>
h2, th, td {
	text-align: center;
	color: black;
}

img {
	width: 250px;
	height: 150px;
}
td.reserve {
    width: 80px; /* 필요한 경우 너비 조정 */
    height: 30px; /* 필요한 경우 높이 조정 */
    text-align: center; /* 내용 가운데 정렬 */
}
</style>


<!-- 해당 날짜의 차량 예약내역 불러오기 -->
<c:if test="${not empty vhclRsvtListByDay }">
	<c:forEach items="${vhclRsvtListByDay }" var="vhclRsvt">
		<div>
			<input type="hidden" class="vRsvtNo"
				value="${vhclRsvt.getVRsvtNo() }" /> <input type="hidden"
				class="vhclNo" value="${vhclRsvt.getVhclNo() }" /> <input
				type="hidden" class="empNo" value="${vhclRsvt.getEmpNo() }" /> 
				<input
				type="hidden" class="empName" value="${vhclRsvt.getEmpName() }" />
				<input
				type="hidden" class="rsvtDate" value="${vhclRsvt.getRsvtDate() }" />
			<input type="hidden" class="strtRsvtDate"
				value="${vhclRsvt.getStrtRsvtDate() }" /> <input type="hidden"
				class="endRsvtDate" value="${vhclRsvt.getEndRsvtDate() }" /> <input
				type="hidden" class="ppus" value="${vhclRsvt.getPpus() }" /> <input
				type="hidden" class="vhclCancel"
				value="${vhclRsvt.getVhclCancel() }" /> <input type="hidden"
				class="resrceRsvtStatus" value="${vhclRsvt.getResrceRsvtStatus() }" />
		</div>
	</c:forEach>
</c:if>


<!-- 좌측 상단 -->
<div class="content__header content__boxed overlapping">
	<div class="content__wrap">
		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item"><a href="/vhcl/vhclList">예약</a></li>
				<li class="breadcrumb-item active" aria-current="page">차량예약</li>
			</ol>
		</nav>
		<!-- Breadcrumb 끝-->
		<br />
	</div>
</div>


<!-- 본문 -->
<div class="content__boxed">
	<div class="content__wrap">
		<div class="card d-felx justify-content-center">
			<div class="card-body ">
				<br />
				<h2 class="card-title">법인차량 예약내역 조회</h2>
				<div class="d-md-flex">
					<div class="me-auto">
						<form action="/vhcl/selectDay" method="get" id="vhclDateForm"
							class="row row-cols-md-auto g-3 align-items-center">
							<div class="col-12">
								<input type="date" class="form-control" name="vhclDate"
									id="vhclDate" value="${vhclDate }">
							</div>
							<sec:csrfInput />
						</form>
					</div>
					<div class="align-self-center">
						<button type="button" onclick="modalOpen()"
							class="btn btn-primary btn-lg hstack gap-2">차량예약</button>
					</div>
				</div>

				<!-- Striped rows -->
				<div class="table-responsive">
					<br />
					<table class="table">
						<thead>
							<tr>
								<th width="20px">차량 / time</th>
								<!-- Iterate over time slots -->
								<c:forEach var="i" begin="7" end="22">
									<th>${i}시</th>
								</c:forEach>
							</tr>
						</thead>
						<tbody>
							<!-- Iterate over vehicles -->
							<c:forEach items="${vhclList }" var="vhcl">
								<c:if test="${vhcl.enabled eq 'Y' }">
									<tr class="vhclDetailTR">
										<td class="vhclList" data-vhcl_no="${vhcl.vhclNo }"><img
											src="${pageContext.request.contextPath}${vhcl.vhclImgPath}"
											alt="${vhcl.vhclName}"> <br />${vhcl.vhclName}</td>
										<!-- Iterate over time slots -->
										<c:forEach var="i" begin="7" end="22">
											<td class="reserve" data-vhcl_no="${vhcl.vhclNo }"
												data-vhcl_time="${i}"></td>
										</c:forEach>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- END : Striped rows -->



			</div>
			<!-- card-body 끝 -->
		</div>
		<!-- card 끝 -->
	</div>
	<!-- content__wrap 끝 -->
</div>
<!-- content__boxed 끝 -->




<script>
	$(function() {
		var vRsvtNo = $(".vRsvtNo"); // 차량 예약 번호 클래스
		var vhclNo = $(".vhclNo"); // 차량 번호 클래스
		var empNo = $(".empNo"); // 사원번호 클래스
		var empName = $(".empName"); // 사원이름 클래스
		var rsvtDate = $(".rsvtDate"); // 등록날짜 클래스
		var strtRsvtDate = $(".strtRsvtDate"); // 시작날짜 클래스
		var endRsvtDate = $(".endRsvtDate"); // 끝날짜 클래스
		var ppus = $(".ppus"); // 사용목적 클래스
		var vhclCancel = $(".vhclCancel"); // 취소사유 클래스
		var resrceRsvtStatus = $(".resrceRsvtStatus"); // 예약상태 클래스(00-취소,01-예약중,02-예약만료)
		var mRsvtTitle = $(".mRsvtTitle"); // 예약제목

		var vhclList = $(".vhclList"); // 차량 목록 클래스
		var reserve = $(".reserve"); // 예약중인 타임을 체크할 클래스

		var vhclRegisterBtn = $("#vhclRegisterBtn"); // 등록버튼
		var vhclRegisterForm = $("#vhclRegisterForm"); // 등록폼

		var reservations = []; // 차량 예약정보를 받은 배열

		var vhclInsert = $("#vhclInsert"); // 차량 선택 Ele
		var vhclDateInsert = $("#vhclDateInsert"); // 날짜 선택 Ele
		var vhclFlag = false; // 차량 선택과 날짜 선택 모두 값이 입력되었을때 true로 전환한다.

		// 배열에 컨트롤러에서 담은 값 넣기
		for (var i = 0; i < vRsvtNo.length; i++) {
			reservations.push({
				vRsvtNo : vRsvtNo.eq(i).val(),
				vhclNo : vhclNo.eq(i).val(),
				empNo : empNo.eq(i).val(),
				empName : empName.eq(i).val(),
				rsvtDate : rsvtDate.eq(i).val(),
				strtRsvtDate : strtRsvtDate.eq(i).val(),
				endRsvtDate : endRsvtDate.eq(i).val(),
				ppus : ppus.eq(i).val(),
				vhclCancel : vhclCancel.eq(i).val(),
				resrceRsvtStatus : resrceRsvtStatus.eq(i).val(),
			});
		}

		// 예약시간 띄우기
		reserve.each(function () {
		    var vhclNo = $(this).data('vhcl_no');
		    var vhclTime = $(this).data('vhcl_time');
		
		    var matchingReservation = reservations.filter(function (reservation) {
		        return reservation.vhclNo == vhclNo
		            && (reservation.resrceRsvtStatus === '01' || reservation.resrceRsvtStatus === '02')
		            && parseInt(reservation.strtRsvtDate.split(' ')[1].split(':')[0]) == vhclTime;
		    });
		
		    if (matchingReservation.length > 0) {
		        var reservationStartTime = parseInt(matchingReservation[0].strtRsvtDate.split(' ')[1].split(':')[0]);
		        var reservationEndTime = parseInt(matchingReservation[0].endRsvtDate.split(' ')[1].split(':')[0]);
		        var reservationDuration = reservationEndTime - reservationStartTime;
		        var reservationTitle = matchingReservation[0].empName;
		        var reservationStatus = matchingReservation[0].resrceRsvtStatus;
		        var vRsvtNo = matchingReservation[0].vRsvtNo;
		
		        // 해당 TD와 예약 시간에 대한 배경색 변경
		        var matchingTD = reserve.filter('[data-vhcl_no="' + vhclNo + '"][data-vhcl_time="' + vhclTime + '"]');
		        if (reservationStatus == '01') {
		            matchingTD.css('background-color', 'orange');
		        } else {
		            matchingTD.css('background-color', 'lightgray');
		        }
		        matchingTD.attr("disabled", "true"); // disabled 넣기
		        matchingTD.attr("colspan", reservationDuration); // 열 합치기
		        matchingTD.text(reservationTitle); // 예약 제목 넣기
		        matchingTD.addClass("vhclDetailTD");
		        matchingTD.attr("data-v_rsvt_no", vRsvtNo); // 예약 번호 속성 넣기
		
		        // 중복된 시간대의 셀 제거
		        for (var i = 1; i < reservationDuration; i++) {
		            var nextMatchingTD = matchingTD.next();
		            nextMatchingTD.remove();
		        }
		    }
		});

		// 날짜 체인지 이벤트
		$("#vhclDate").on("change", function() {
			$("#vhclDateForm").submit();
		});

		// 차량 등록 모달에서 차량 선택했을 때 이벤트
		vhclInsert
				.on(
						"change",
						function(e) {
							var vhclInsertVal = e.target.value;
							var vhclDateVal = $("#vhclDateInsert").val();

							// 차량 선택과 날짜 두가지 중 한개라도 비어있게되면 조건을 부여할 값으로 타당하지 않기 때문에 
							// 두개의 값이 무조건 입력된 상태에서 차량 예약정보를 확인한다.
							if ((vhclDateVal == null || vhclDateVal == "")
									|| (vhclInsertVal == null || vhclInsertVal == "")) {
								return false;
							} else {
								var data = {
									vhclNo : vhclInsertVal,
									rsvtDate : vhclDateVal
								}

								$
										.ajax({
											url : "/vhcl/checkReserve",
											type : "post",
											data : JSON.stringify(data),
											beforeSend : function(xhr) {
												xhr.setRequestHeader(header,
														token);
											},
											contentType : "application/json;charset=utf-8",
											success : function(res) {
												res
														.map(function(v, i) {
															var strtRsvtDate = v.strtRsvtDate
																	.split(" ");
															var rightStrtRsvtTime = strtRsvtDate[1]
																	.split(":")[0];
															var endRsvtDate = v.endRsvtDate
																	.split(" ");
															var rightEndRsvtTime = endRsvtDate[1]
																	.split(":")[0];

															$(
																	"#startTimeInsert option")
																	.map(
																			function(
																					i,
																					e) {
																				if (e.value >= parseInt(rightStrtRsvtTime)
																						&& e.value < (parseInt(rightEndRsvtTime))) {
																					e.disabled = true;
																					e.style.backgroundColor = "silver";
																				}
																			});
															$(
																	"#endTimeInsert option")
																	.map(
																			function(
																					i,
																					e) {
																				if (e.value > parseInt(rightStrtRsvtTime)
																						&& e.value <= (parseInt(rightEndRsvtTime))) {
																					e.disabled = true;
																					e.style.backgroundColor = "silver";
																				}
																			});
														});
											}
										});
							}
						});

		// 차량 등록 모달에서 날짜 선택했을 때 이벤트
		vhclDateInsert
				.focusout(function() {
					var vhclDateVal = $("#vhclDateInsert").val();
					var vhclInsertVal = $("#vhclInsert").val();

					// 차량 선택과 날짜 두가지 중 한개라도 비어있게되면 조건을 부여할 값으로 타당하지 않기 때문에 
					// 두개의 값이 무조건 입력된 상태에서 차량 예약정보를 확인한다.
					if ((vhclDateVal == null || vhclDateVal == "")
							|| (vhclInsertVal == null || vhclInsertVal == "")) {
						return false;
					} else {
						var data = {
							vhclNo : vhclInsertVal,
							rsvtDate : vhclDateVal
						}

						$
								.ajax({
									url : "/vhcl/checkReserve",
									type : "post",
									data : JSON.stringify(data),
									beforeSend : function(xhr) {
										xhr.setRequestHeader(header, token);
									},
									contentType : "application/json;charset=utf-8",
									success : function(res) {
										res
												.map(function(v, i) {
													var strtRsvtDate = v.strtRsvtDate
															.split(" ");
													var rightStrtRsvtTime = strtRsvtDate[1]
															.split(":")[0];
													var endRsvtDate = v.endRsvtDate
															.split(" ");
													var rightEndRsvtTime = endRsvtDate[1]
															.split(":")[0];

													$("#startTimeInsert option")
															.map(
																	function(i,
																			e) {
																		if (e.value >= parseInt(rightStrtRsvtTime)
																				&& e.value < (parseInt(rightEndRsvtTime))) {
																			e.disabled = true;
																			e.style.backgroundColor = "silver";
																		}
																	});
													$("#endTimeInsert option")
															.map(
																	function(i,
																			e) {
																		if (e.value > parseInt(rightStrtRsvtTime)
																				&& e.value <= (parseInt(rightEndRsvtTime))) {
																			e.disabled = true;
																			e.style.backgroundColor = "silver";
																		}
																	});
												});
									}
								});
					}
				});

		// 차량 등록 클릭 이벤트
		vhclRegisterBtn.on("click", function() {
			var vhcl = $("#vhclInsert option:selected").val(); // 선택한 차량
			var vhclDate = $("#vhclDateInsert").val(); // 선택한 날짜
			var startTime = parseInt($("#startTimeInsert option:selected")
					.val()); // 선택한 시작시간
			var endTime = parseInt($("#endTimeInsert option:selected").val()); // 선택한 종료시간
			//var title = $("#titleInsert").val();									// 작성한 예약제목
			var ppus = $("#ppusInsert").val(); // 작성한 사용목적

			console.log("vhcl:" + vhcl)
			if (vhcl == null || vhcl == "" || vhcl == "--선택--") {
				Swal.fire({
					icon : 'warning',
					text : `차량을 선택해주세요!`,
				})
				return false;
			}
			if (vhclDate == null || vhclDate == "") {
				Swal.fire({
					icon : 'warning',
					text : `날짜를 선택해주세요!`,
				})
				return false;
			}

			// 현재날짜
			var date = new Date();
			var year = date.getFullYear(); //년도    
			var month = date.getMonth() + 1; //월    
			var day = date.getDate(); //일
			var hour = date.getHours(); // 시간

			var vhclDateArr = vhclDate.split('-'); // 선택한 날짜 

			var vhclDateCompare = new Date(vhclDateArr[0],
					parseInt(vhclDateArr[1]) - 1, vhclDateArr[2], endTime);
			var toDayCompare = new Date(year, month - 1, day, hour);

			if (toDayCompare.getTime() >= vhclDateCompare.getTime()) {
				Swal.fire({
					icon : 'warning',
					text : `지난 날짜는 선택할 수 없습니다. 다시 선택해주세요!`,
				})
				return;
			}
			if (startTime == null || startTime == "" || vhcl == "--선택--") {
				Swal.fire({
					icon : 'warning',
					text : `시작시간을 선택해주세요!`,
				})
				return false;
			}
			if (endTime == null || endTime == "" || vhcl == "--선택--") {
				Swal.fire({
					icon : 'warning',
					text : `종료시간을 선택해주세요!`,
				})
				return false;
			}
			if (startTime >= endTime) {
				Swal.fire({
					icon : 'warning',
					text : `시작시간 및 종료시간을 확인해주세요!`,
				})
				return false;
			}
			/* 			if(title == null || title == ""){
			 Swal.fire("제목을 입력해주세요!");
			 return false;
			 } */
			if (ppus == null || ppus == "") {
				Swal.fire({
					icon : 'warning',
					text : `사용목적을 입력해주세요!`,
				})
				return false;
			}

			// 폼데이터에 값넣기
			formData = new FormData();
			formData.append("vhcl", vhcl);
			formData.append("vhclDate", vhclDate);
			formData.append("startTime", startTime);
			formData.append("endTime", endTime);
			//formData.append("title",title);
			formData.append("ppus", ppus);

			$.ajax({
				url : "/vhcl/vhclRegister",
				type : "post",
				beforeSend : function(xhr) {
					xhr.setRequestHeader(header, token);
				},
				processData : false,
				contentType : false,
				data : formData,
				success : function(res) {
					if (res == "OK") {
						location.href = "/vhcl/selectDay?vhclDate=" + vhclDate;
					}
				}
			});

			/* var xhr = new XMLHttpRequest();

			xhr.open("POST", "/vhcl/vhclRegister");  
			xhr.setRequestHeader(header,token); 
			xhr.send(formData); */
		});

		// 예약상세보기
		$(".vhclDetailTR").on("click", ".vhclDetailTD", function() {
			console.log("예약상세보기");
			console.log($(this).data("v_rsvt_no"));
			var vRsvtNo = $(this).data("v_rsvt_no");
			location.href = "/vhcl/vhclDetail?vRsvtNo=" + vRsvtNo;
		});
	});
</script>
