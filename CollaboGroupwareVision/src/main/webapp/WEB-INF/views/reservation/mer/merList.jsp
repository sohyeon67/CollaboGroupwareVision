<%@ page isELIgnored="false" language="java"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="./merRegister.jsp" %>

<!-- 해당 날짜의 회의실예약내역 불러오기 -->
<c:if test="${not empty merRsvtListByDay }">
	<c:forEach items="${merRsvtListByDay }" var="merRsvt">
		<div>
			<input type="hidden" class="mRsvtNo" value="${merRsvt.getMRsvtNo() }" />
			<input type="hidden" class="merNo" value="${merRsvt.getMerNo() }" />
			<input type="hidden" class="empNo" value="${merRsvt.getEmpNo() }" />
			<input type="hidden" class="rsvtDate" value="${merRsvt.getRsvtDate() }" /> 
			<input type="hidden" class="strtRsvtDate" value="${merRsvt.getStrtRsvtDate() }" /> 
			<input type="hidden" class="endRsvtDate" value="${merRsvt.getEndRsvtDate() }" /> 
			<input type="hidden" class="ppus" value="${merRsvt.getPpus() }" /> 
			<input type="hidden" class="merCancel" value="${merRsvt.getMerCancel() }" /> 
			<input type="hidden" class="resrceRsvtStatus" value="${merRsvt.getResrceRsvtStatus() }" />
			<input type="hidden" class="mRsvtTitle" value="${merRsvt.getMRsvtTitle() }" />
		</div>
	</c:forEach>
</c:if>

<!-- 좌측 상단 -->
<div class="content__header content__boxed overlapping">
	<div class="content__wrap">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item"><a href="#">예약</a></li>
				<li class="breadcrumb-item active" aria-current="page">회의실예약</li>
			</ol>
		</nav>
		<br />
	</div>
</div>



<div class="content__boxed">
	<div class="content__wrap">
		<div class="card d-felx justify-content-center">
			<div class="card-body ">
				<!-- 회의실 예약내역 본문 -->
				<div class="card">
					<div class="card-body">
						<h1 class="card-title">회의실 예약내역 조회</h1>
						<div class="d-md-flex">
							<div class="me-auto">
								<form action="/mer/selectDay" method="get" id="merDateForm"
									class="row row-cols-md-auto g-3 align-items-center">
									<div class="col-12">
										<input type="date" class="form-control" name="merDate"
											id="merDate" value="${merDate }">
									</div>
									<sec:csrfInput />
								</form>
							</div>
							<div class="align-self-center">
								<button type="button" onclick="modalOpen()"
									class="btn btn-success btn-lg hstack gap-2">회의실 예약하기</button>
							</div>
						</div>

						<!-- Striped rows -->
						<div class="table-responsive">
							<br />
							<table class="table">
								<thead>
									<tr>
										<th width="5%;">time</th>
										<c:choose>
											<c:when test="${empty merList }">
												<th>조회가능한 회의실이 없습니다.</th>
											</c:when>
											<c:otherwise>
												<c:forEach items="${merList }" var="mer">
													<c:if test="${mer.enabled eq 'Y' }">
														<th width="7%" class="merList" data-mer_no="${mer.merNo }">${mer.merName }</th>
													</c:if>
												</c:forEach>
											</c:otherwise>
										</c:choose>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="i" begin="7" end="22">    
										<tr class="merDetailTR">
											<td class="time">${i}</td>
											<c:forEach items="${merList }" var="mer">
												<c:if test="${mer.enabled eq 'Y' }">
													<td class="reserve" data-mer_no="${mer.merNo }"
														data-mer_time="${i}"></td>
												</c:if>
											</c:forEach>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- END : Striped rows -->
					</div>
				</div>
			</div>
			<!-- card-body 끝 -->
		</div>
	</div>
</div>
<!-- content__boxed 끝 -->

<style>
h1, th, td {
	text-align: center;
}
.table{
	color: black;
}
</style>
<script>
	/* $("[data-mer_no=11]").each(function(idx,item){
		$(item).css("display","none");
	}) */

	$(function() {
		var mRsvtNo = $(".mRsvtNo"); 					// 회의실 예약 번호 클래스
		var merNo = $(".merNo"); 						// 회의실 번호 클래스
		var empNo = $(".empNo"); 						// 사원번호 클래스
		var rsvtDate = $(".rsvtDate"); 					// 등록날짜 클래스
		var strtRsvtDate = $(".strtRsvtDate"); 			// 시작날짜 클래스
		var endRsvtDate = $(".endRsvtDate"); 			// 끝날짜 클래스
		var ppus = $(".ppus"); 							// 사용목적 클래스
		var merCancel = $(".merCancel"); 				// 취소사유 클래스
		var resrceRsvtStatus = $(".resrceRsvtStatus"); 	// 예약상태 클래스(00-취소,01-예약중,02-예약만료)
		var mRsvtTitle = $(".mRsvtTitle");				// 예약제목
		
		var merList = $(".merList"); // 회의실 목록 클래스
		var reserve = $(".reserve"); // 예약중인 타임을 체크할 클래스
		
		var merRegisterBtn = $("#merRegisterBtn");	// 등록버튼
		var merRegisterForm = $("#merRegisterForm");	// 등록폼

		var reservations = []; // 회의실 예약정보를 받은 배열
		
		var merInsert = $("#merInsert");	// 회의실 선택 Ele
		var merDateInsert = $("#merDateInsert");	// 날짜 선택 Ele
		var merFlag = false;	// 회의실 선택과 날짜 선택 모두 값이 입력되었을때 true로 전환한다.
		
		// 배열에 컨트롤러에서 담은 값 넣기
		for (var i = 0; i < mRsvtNo.length; i++) {
			reservations.push({
				mRsvtNo : mRsvtNo.eq(i).val(),
				merNo : merNo.eq(i).val(),
				empNo : empNo.eq(i).val(),
				rsvtDate : rsvtDate.eq(i).val(),
				strtRsvtDate : strtRsvtDate.eq(i).val(),
				endRsvtDate : endRsvtDate.eq(i).val(),
				ppus : ppus.eq(i).val(),
				merCancel : merCancel.eq(i).val(),
				resrceRsvtStatus : resrceRsvtStatus.eq(i).val(),
				mRsvtTitle : mRsvtTitle.eq(i).val()
			});
		}

		// 예약시간 띄우기
		reserve.each(function() {
			var merNo = $(this).data('mer_no'); // 회의실 번호 가져오기
			var merTime = $(this).data('mer_time'); // 예약된 시간 가져오기
			
			// 예약된 시간에 해당하는 회의실 예약 정보 찾기
			var matchingReservation = reservations.filter(function(reservation) {
				return reservation.merNo == merNo
						&& (reservation.resrceRsvtStatus === '01' || reservation.resrceRsvtStatus === '02')
						&& parseInt(reservation.strtRsvtDate.split(' ')[1].split(':')[0]) == merTime;
			});

			// 예약이 있다면 해당 TD와 예약 시간에 대한 배경색 변경
			if (matchingReservation.length > 0) {
				var reservationStartTime = parseInt(matchingReservation[0].strtRsvtDate.split(' ')[1].split(':')[0]);
				var reservationEndTime = parseInt(matchingReservation[0].endRsvtDate.split(' ')[1].split(':')[0]);
				var reservationDuration = reservationEndTime - reservationStartTime;
				var reservationTitle = matchingReservation[0].mRsvtTitle;
				var reservationStatus = matchingReservation[0].resrceRsvtStatus;
				var mRsvtNo = matchingReservation[0].mRsvtNo;
				
				// 해당 TD와 예약 시간에 대한 배경색 변경
				for (var i = merTime; i < merTime + reservationDuration; i++) {
					var matchingTD = reserve.filter('[data-mer_no="'+ merNo + '"][data-mer_time="' + i + '"]');
					if(i == merTime){
						if(reservationStatus == '01'){
							matchingTD.css('background-color', '#3399FF');
						}else{
							matchingTD.css('background-color', 'lightgray');
						}
						matchingTD.attr("disabled","true");				// disabled 넣기
						matchingTD.attr("rowspan",reservationDuration);	// 행합치기
						matchingTD.text(reservationTitle);				// 예약제목 넣기
						matchingTD.addClass("merDetailTD");				// 상세보기를 도와줄 클래스 추가하기
						matchingTD.attr("data-m_rsvt_no",mRsvtNo);		// 예약번호 속성 넣어주기
					}else{
						matchingTD.remove();
					}
				}
			}
		});

		// 날짜 체인지 이벤트
		$("#merDate").on("change", function() {
			$("#merDateForm").submit();
		});
		
		// 회의실 등록 모달에서 회의실 선택했을 때 이벤트
		merInsert.on("change", function(e){
			var merInsertVal = e.target.value;
			var merDateVal = $("#merDateInsert").val();
			
			// 회의실 선택과 날짜 두가지 중 한개라도 비어있게되면 조건을 부여할 값으로 타당하지 않기 때문에 
			// 두개의 값이 무조건 입력된 상태에서 회의실 예약정보를 확인한다.
			if((merDateVal == null || merDateVal == "") ||
					(merInsertVal == null || merInsertVal == "")){
				//alert("회의실 및 날짜를 입력해주세요!");
				return false;
			}else{
				var data = {
					merNo : merInsertVal,
					rsvtDate : merDateVal
				}
				
				$.ajax({
					url : "/mer/checkReserve",
					type: "post",
					data: JSON.stringify(data), 
					beforeSend:function(xhr){
						xhr.setRequestHeader(header,token);
	                },
					contentType : "application/json;charset=utf-8",
					success: function(res){
						res.map(function(v, i){
							var strtRsvtDate = v.strtRsvtDate.split(" ");
							var rightStrtRsvtTime = strtRsvtDate[1].split(":")[0];
							var endRsvtDate = v.endRsvtDate.split(" ");
							var rightEndRsvtTime = endRsvtDate[1].split(":")[0];
							
							$("#startTimeInsert option").map(function(i,e){
								if(e.value >= parseInt(rightStrtRsvtTime) && e.value < (parseInt(rightEndRsvtTime))){
									e.disabled = true;
									e.style.backgroundColor = "silver";
								}
							});
							$("#endTimeInsert option").map(function(i,e){
								if(e.value > parseInt(rightStrtRsvtTime) && e.value <= (parseInt(rightEndRsvtTime))){
									e.disabled = true;
									e.style.backgroundColor = "silver";
								}
							});
						});
					}
				});
			}
		});
		
		// 회의실 등록 모달에서 날짜 선택했을 때 이벤트
		merDateInsert.focusout(function(){
			var merDateVal = $("#merDateInsert").val();
			var merInsertVal = $("#merInsert").val();
			
			// 회의실 선택과 날짜 두가지 중 한개라도 비어있게되면 조건을 부여할 값으로 타당하지 않기 때문에 
			// 두개의 값이 무조건 입력된 상태에서 회의실 예약정보를 확인한다.
			if((merDateVal == null || merDateVal == "") ||
					(merInsertVal == null || merInsertVal == "")){
				//alert("회의실 및 날짜를 입력해주세요!");
				return false;
			}else{
				var data = {
					merNo : merInsertVal,
					rsvtDate : merDateVal
				}
				
				$.ajax({
					url : "/mer/checkReserve",
					type: "post",
					data: JSON.stringify(data), 
					beforeSend:function(xhr){
						xhr.setRequestHeader(header,token);
	                },
					contentType : "application/json;charset=utf-8",
					success: function(res){
						res.map(function(v, i){
							var strtRsvtDate = v.strtRsvtDate.split(" ");
							var rightStrtRsvtTime = strtRsvtDate[1].split(":")[0];
							var endRsvtDate = v.endRsvtDate.split(" ");
							var rightEndRsvtTime = endRsvtDate[1].split(":")[0];
							
							$("#startTimeInsert option").map(function(i,e){
								if(e.value >= parseInt(rightStrtRsvtTime) && e.value < (parseInt(rightEndRsvtTime))){
									e.disabled = true;
									e.style.backgroundColor = "silver";
								}
							});
							$("#endTimeInsert option").map(function(i,e){
								if(e.value > parseInt(rightStrtRsvtTime) && e.value <= (parseInt(rightEndRsvtTime))){
									e.disabled = true;
									e.style.backgroundColor = "silver";
								}
							});
						});
					}
				});
			}
		});
		
		// 회의실 등록 클릭 이벤트
		merRegisterBtn.on("click", function(){
			var mer = parseInt($("#merInsert option:selected").val());				// 선택한 회의실
			var merDate = $("#merDateInsert").val();								// 선택한 날짜
			//alert($("#startTimeInsert option:selected").val());
			var startTime = parseInt($("#startTimeInsert option:selected").val());	// 선택한 시작시간
			//alert($("#endTimeInsert option:selected").val());
			var endTime = parseInt($("#endTimeInsert option:selected").val());		// 선택한 종료시간
			var title = $("#titleInsert").val();									// 작성한 예약제목
			var ppus = $("#ppusInsert").val();										// 작성한 사용목적
			
			console.log("mer:"+mer)
			if(mer == null || mer == ""){
				Swal.fire({
					icon : 'warning',
					text : `회의실을 선택해주세요!`,
				});
				return false;
			}
			if(merDate == null || merDate == ""){
				Swal.fire({
					icon : 'warning',
					text : `날짜를 선택해주세요!`,
				});
				return false;
			}
			console.log("startTime:",startTime,"endTime:",endTime);
			
			if( isNaN(startTime) || startTime == null || startTime == ""){
				Swal.fire({
					icon : 'warning',
					text : `시작시간을 선택해주세요!`,
				});
				return false;
			}
			if( isNaN(endTime) || endTime == null || endTime == ""){
				Swal.fire({
					icon : 'warning',
					text : `종료시간을 선택해주세요!`,
				});
				return false;
			}
	        if(startTime >= endTime){
	        	Swal.fire({
					icon : 'warning',
					text : `시작시간과 종료시간을 다시 확인해주세요!`,
				});
				return false;
	        }
	        
	     	// 현재날짜
			var date = new Date();     
			var year = date.getFullYear(); //년도    
			var month = date.getMonth()+1; //월    
			var day = date.getDate(); //일
			var hour = date.getHours(); // 시간
			
	        var merDateArr = merDate.split('-');	// 선택한 날짜 
	                 
	        var merDateCompare = new Date(merDateArr[0], parseInt(merDateArr[1])-1, merDateArr[2], endTime);
	        var toDayCompare = new Date(year, month-1, day, hour);
	        
	        if(toDayCompare.getTime() >= merDateCompare.getTime()) {
	        	Swal.fire({
					icon : 'warning',
					text : `지난 날짜는 선택할 수 없습니다. 다시 선택해주세요`,
				})
	            return false;
	        }
	        
			if(title == null || title == ""){
				Swal.fire({
					icon : 'warning',
					text : `제목을 입력해주세요!`,
				})
				return false;
			}
			if(ppus == null || ppus == ""){
				Swal.fire({
					icon : 'warning',
					text : `사용목적을 입력해주세요!`,
				})
				return false;
			}
			
			// 폼데이터에 값넣기
			formData = new FormData();
			formData.append("mer",mer);
			formData.append("merDate",merDate);
			formData.append("startTime",startTime);
			formData.append("endTime",endTime);
			formData.append("title",title);
			formData.append("ppus",ppus);
			
			$.ajax({
				url : "/mer/merRegister",
				type : "post",
				beforeSend:function(xhr){
					xhr.setRequestHeader(header,token);
                },
                processData:false,
                contentType:false,
				data : formData,
				success : function(res){
					location.href = "/mer/selectDay?merDate="+merDate;
				}
			});
		});
		
		// 예약상세보기
		$(".merDetailTR").on("click",".merDetailTD", function(){
			console.log("예약상세보기");
			console.log($(this).data("m_rsvt_no"));
			var mRsvtNo = $(this).data("m_rsvt_no");
			location.href = "/mer/merDetail?mRsvtNo="+mRsvtNo;
		});
	});
	

</script>