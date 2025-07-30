<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			   
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.5.0-alpha1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.2/jspdf.min.js"></script>
<c:if test="${not empty successMessage }">
<script type="text/javascript">
Swal.fire({
	icon: 'success',
	title: '결재',
	text: '${successMessage}'
});
<c:remove var="successMessage" scope="request"/>
<c:remove var="successMessage" scope="session"/>
</script> 
</c:if>   
<c:if test="${not empty failedMessage }">
<script type="text/javascript">
Swal.fire({
	icon: 'error',
	title: '결재 실패',
	text: '${failedMessage}'
});
<c:remove var="failedMessage" scope="request"/>
<c:remove var="successMessage" scope="session"/>
</script> 
</c:if>   
<c:if test="${not empty writeSuccess }">
<script type="text/javascript">
Swal.fire({
	icon: 'success',
	title: '등록',
	text: '${writeSuccess}'
});
<c:remove var="successMessage" scope="request"/>
<c:remove var="successMessage" scope="session"/>
</script> 
</c:if>   

<style>
#approvalTable{
	text-align: center;
}

#approval td{
	padding: 0px;
}

#drftTable{
	width: 800px;
	
}

table tr td{
	border-width: 2px;
	color: black;
}

#drftTable input{
	background-color: #ffffff;
}

.no-flex-shrink {
    flex-shrink: 0 !important;
}

#fileTable tr td{
	border-width: 0px;
}

#rejectModal, #rejectReasonModal {
	position: fixed;
    width: 100%;
    height: 100%; /* fixed인 경우 작동 */
    left: 0px;
    top: 0px;
    background-color: rgb(200, 200, 200, 0.5);
    display: none;  /* 존재하지만 보이지않음 */
    z-index: 1000; /* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
    /* static(브라우저에게 외주), relative(static한 상태에서 내가 조금 조정할게)
        absolute(내가 다 할게, 기준점 브라우저 왼쪽상단 모서리), fixed(고정좌표),
        $$ 부모 relative, 자식 absolute (자식의 기준점이 부모 왼쪽상단 모서리)
    */
}

#rejectModalCont, #rejectReasonModalCont {
    margin: 10% auto;   /* 수평가운데 정렬 */
	width : 500px;
	
}

#content{
	overflow-x: auto;
}

#sideBar{
 	width: fit-content; 
 	min-width: 350px; 
 	max-width: 100%;
 	overflow-x: auto;
}
#contentHeader{
	min-width: 1190px;
}

input{
	font-size: 14px !important;
	color: black !important;
}
</style>

<div id="contentHeader" class="content__header content__boxed overlapping">
    <div class="content__wrap">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/index">Home</a></li>
                <li class="breadcrumb-item"><a href="./main">전자결재</a></li>
                <li class="breadcrumb-item active" aria-current="page">${title }</li>
            </ol>
        </nav>
        <!-- END : Breadcrumb -->
        <br/>
        <br/>
    </div>
</div>
 
<div class="content__boxed">
    <div class="content__wrap">
       	<!-- 결재폼 시작 -->
		<form method="post" id="detailForm">
			<!-- 결재에 사용할 hidden 로그인자 사번 -->
			<input type="hidden" value="${signerFinalYn }" name="apprvFinalYn"/>
			<input type="hidden" value="${draftingMap.drafting.drftFormNo }" name="drftFormNo"/>
	        <!-- 결재폼, 사이드바 옆으로 정렬 -->
	        <div class="d-flex gap-4">
	        	<!-- 캡쳐 시작 -->
				<div id="capture">
					<!-- 메인폼 시작 -->
				    <div class="card no-flex-shrink" style="width: 930px; padding: 50px;">
				        <div class="d-md-flex gap-4">
				            <div class="card-body" style="width: 850px;">
					            <div style="font-size: 30px; text-align: center; color: black; font-weight: bold;">
					                ${draftingMap.drafting.drftFormName}
					            </div>
					            <br/>
					            <br/>
					            
					            <div style="display: flex; justify-content: space-between;">
					            <div style="text-align: left;">
					            	<!-- 결재자 출력 시작 -->
										<div style="display: inline-block; margin-right: 20px;">
											<table border="1">
												<tbody>
													<tr>
														<td class="fw-bold" rowspan="3" style="background-color:#cccccc; height:147px; text-align:center; width:27px" style="font-size:17px">
															<p>신</p>
															<p>청</p>
														</td>
														<td style="height:26px; text-align:center; width:95px">
															${draftingMap.drafting.drftWriterPositionName }
														</td>
													</tr>
													<tr>
														<td style="height:96px; text-align:center; width:95px">
															<img src="data:image/png;base64,${writerSignImg}" alt="Sign Image" width="70px" height="70px">
															<p style="margin: 0px;">${draftingMap.drafting.drftWriterName }</p>
														</td>
													</tr>
													<tr>
														<td style="height:26px; text-align:center; width:95px">
															${formattedDraftingDate }
														</td>
													</tr>
												</tbody>
											</table>
										</div>
										<!-- 신청자 결재 끝 -->
					            </div>
										
									
					           	 	<div style="text-align: right;">
										<!-- 결재자 결재 시작 -->
										<div style="display: inline-block;">
											<table border="1">
												<tbody>
													<tr>
														<td class="fw-bold" rowspan="3" style="background-color:#cccccc; height:147px; text-align:center; width:27px" style="font-size:17px">
															<p>승</p>
															<p>인</p>
														</td>
													<c:forEach items="${draftingMap.approvalList }" var="approval">
														<td style="height:26px; text-align:center; width:95px">
															${approval.apprvSignerPositionName }
														</td>
													</c:forEach>
													</tr>
													<tr>
													<c:forEach items="${draftingMap.approvalList }" var="approval">
														<td style="height:96px; text-align:center; width:95px">
															<c:if test="${approvalMap[approval.empNo] ne null}">
																<img src="data:image/png;base64,${approvalMap[approval.empNo]}" alt="Sign Image" width="70px" height="70px">
															</c:if>
															<p style="margin: 0px;">${approval.apprvSignerName }</p>
														</td>
													</c:forEach>
													</tr>
													<tr>
													<c:forEach items="${draftingMap.approvalList }" var="approval">
														<c:choose>
															<c:when test="${approval.apprvStatus eq '반려' }">
																<td style="height:26px; color:red; text-align:center; width:95px">
																	<fmt:parseDate value="${approval.apprvDate}" pattern="yyyy/MM/dd" var="parsedDate" />
																	<fmt:formatDate value="${parsedDate }" pattern="MM/dd" />
																	(반려)
																</td>
															</c:when>
															<c:otherwise>
																<td style="height:26px; text-align:center; width:95px">
																	${approval.apprvDate }
																</td>
															</c:otherwise>
														</c:choose>
													</c:forEach> 
													</tr>
												</tbody>
											</table> 
										</div>
									</div>
								<!-- 결재자 출력구간 끝 -->
								</div>
								<br/>	
										
								<table border="1" id="drftTable">
									<tbody>
										<tr>
											<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">기안번호</span></strong></td>
											<td><input class="form-control" type="text" id="drftNo" name="drftNo" readonly="readonly" value="${draftingMap.drafting.drftNo }"></td>
										</tr>
										<tr>
											<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">기안자</span></strong></td>
											<td><input class="form-control" type="text" id="drftWriterName" name="drftWriterName" readonly="readonly" value="${draftingMap.drafting.drftWriterName }"></td>
										</tr>
										<tr>
											<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">부서</span></strong></td>
											<td><input class="form-control" type="text" id="drftWriterDeptName" name="drftWriterDeptName" readonly="readonly" value="${draftingMap.drafting.drftWriterDeptName }"></td>
										</tr>
										<tr>
											<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">직위</span></strong></td>
											<td><input class="form-control" type="text" id="drftWriterPositionName" name="drftWriterPositionName" readonly="readonly" value="${draftingMap.drafting.drftWriterPositionName }"></td>
										</tr>
										<tr>
											<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">기안일시</span></strong></td>
											<td><input class="form-control" type="text" id="drftDate" name="drftDate" readonly="readonly" value="${draftingMap.drafting.drftDate }"></td>
										</tr>
										<tr>
											<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">제목</span></strong></td>
											<td><input class="form-control" type="text" id="drftTitle" name="drftTitle" readonly="readonly" value="${draftingMap.drafting.drftTitle }"></td>
										</tr>
									</tbody>
								</table>
									
								<br/>
								<div class="form-group" id="drftContent">
									${draftingMap.drafting.drftContent }
								</div>
								
							</div>
						</div>					
			        </div>
			        <!-- 메인 폼 끝 -->		
		        </div>			
				<!-- 캡쳐 끝 -->		
				<!-- 상세조회 사이드바  시작 -->
				<div class="card" id="sideBar">
		            <div class="d-md-flex gap-4">
						<div class="card-body d-flex justify-content-center">
		                    <div class="w-md-100 w-xl-100 flex-shrink-0 mb-3" style="width: 100%; overflow-x: auto;">
							<!-- 사이드바 내용 시작 -->
							<!-- 신청자 결재 시작 -->
							
							<!-- 버튼 출력 구간  시작 -->
								<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
									<c:if test="${not empty signerEmpNo and empty rejectReason }">
						   				<button type="button" id="acceptBtn" class="btn btn-success fw-bold" style="font-size: 16px;">결재</button>
						   				<button type="button" id="rejectBtn" class="btn btn-danger fw-bold" style="font-size: 16px;" >반려</button>
									</c:if>
									<c:if test="${not empty rejectReason }">
										<button type="button" id="rejectReasonViewBtn" class="btn btn-warning fw-bold" style="font-size: 16px;" >반려사유</button>
									</c:if>
						   			<button type="button" id="downloadBtn" class="btn btn-primary fw-bold" style="font-size: 16px;">출력</button>
						   			<button type="button" id="listBtn" class="btn btn-light fw-bold" style="font-size: 16px;">목록</button>
								</div>
								<!-- 버튼 출력 구간 끝 -->
							
							<!-- 결재자 결재 끝 -->
							<br/><br/>
							<!-- 파일 출력 시작  -->
							<div class="table-responsive pb-4" style="max-height: 950px;"> 
		                        <table class="table table-striped align-middle" id="fileTable">
		                            <thead>
		                                <tr>
		                                    <th class="w-100w">파일명</th>
		                                    <th class="text-center" style="width: 100px">크기</th>
		                                </tr>
		                            </thead>
		                            <tbody>
		                            	<c:choose>
			                           	 	<c:when test="${empty draftingMap.draftingAttachList }">
			                           	 		<tr>
			                           	 			<td colspan="3" class="fw-bold">첨부파일이 존재하지 않습니다.</td>
			                           	 		</tr>
			                           	 	</c:when>
			                           	 	<c:otherwise>
												<c:forEach items="${draftingMap.draftingAttachList }" var="draftingAttach">
					                                <tr>
					                                	<td>
					                                		<div class="d-flex align-items-center position-relative">
						                 						<div class="flex-shrink-0 text-primary">
					                                                <i class="demo-psi-file-html fs-3"></i>
	                                                            </div>
	                                                            <div class="flex-grow-1 ms-2">
																	<a href="/downloadFile?savePath=${draftingAttach.drftFileSavepath }"> 
							                                			${draftingAttach.drftFileName }
							                                		</a>
	                                                            </div>
	                                                        </div>
					                                	</td>
					                                	<td class="text-center">
					                                		${draftingAttach.drftFileFancysize }
					                                	</td>
					                                </tr>
												</c:forEach>
			                           	 	</c:otherwise>
		                            	</c:choose>
		                            </tbody>
								</table>
							</div>	
							<!-- 파일 출력 끝 -->
							<!-- 상세조회 사이드바 내용 끝 -->
		                   	 </div>
							<br/>
						</div>		
		            </div>					
		        </div>
                <!-- 전자결재 사이드바  끝 -->
			
	        <!-- 결재폼, 사이드바 옆으로 정렬 끝 -->	
      	</div>
			<!-- 반려 모달창 시작  -->
			<div id="rejectModal">
				<div class="col-md-6 mb-3" id="rejectModalCont">
				    <div class="card">
				        <div class="card-body">
				            <h3 class="card-title fw-bold">반려사유</h3>
							<textarea id="rejectTextArea" name="apprvReject" rows="10" cols="55" placeholder="반려사유를 입력해주세요."></textarea>				            
				            <!-- 버튼 시작 -->
							<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
							    <button type="button" class="btn btn-danger fw-bold" style="font-size: 16px;" id="rejectSubmitBtn">반려</button>
							    <button type="button" class="btn btn-light  fw-bold" style="font-size: 16px;" onclick="rejectModalClose()">닫기</button>
							    <button type="button" class="btn btn-info   fw-bold" style="font-size: 16px;" id="presentationRejectModalInsert">시연용</button>
							</div>
				            <!-- 버튼 끝 -->
				        </div>
				    </div>
				</div>
			</div>
			<!-- 반려 모달창 끝  -->
			
			<!-- 반려 사유 모달창 시작  -->
			<div id="rejectReasonModal">
				<div class="col-md-6 mb-3" id="rejectReasonModalCont">
				    <div class="card">
				        <div class="card-body">
				            <h3 class="card-title fw-bold">반려사유</h3>
							<textarea id="rejectReasonTextArea" rows="10" cols="55" readonly="readonly">${rejectReason }</textarea>				            
				            <!-- 버튼 시작 -->
							<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">
								<c:if test="${not empty resurgence }">
								    <button type="button" class="btn btn-success fw-bold" style="font-size: 16px;" id="resurgenceBtn">재기안</button>
								</c:if>
							    <button type="button" class="btn btn-danger  fw-bold" style="font-size: 16px;" onclick="rejectReasonModalClose()">닫기</button>
							</div>
			
				            <!-- 버튼 끝 -->
			                
				        </div>
				    </div>
				</div>
			</div>
			<!-- 반려 모달창 끝  -->
	        <sec:csrfInput/>
		</form>
		<!-- 결재폼 끝 -->		
		
    </div>
</div>





<script type="text/javascript">
var previousPageUrl = document.referrer;
// 이전 페이지 URL을 가공하여 목록 페이지로 이동하는 함수
function goToPreviousListPage() {
    // 정규 표현식을 사용하여 필요한 부분을 추출(/drafting 뒤에 '/'또는 '?'또는 문자열 끝)
    var match = previousPageUrl.match(/\/drafting\/(.*?)(\/|$|\?)/);
    console.log("previousPageUrl: ", previousPageUrl);
    console.log("match: " + JSON.stringify(match));
//	  console.log("match[1]: " + JSON.stringify(match[1]));
    
    if (!match || !match[1] || (match[1] !== 'main' && match[1] !== 'waitingApprovalList' && match[1] !== 'draftingList' && match[1] !== 'approvalList')) {
        location.href = "/drafting/main";
    } else if (match[1] == 'main' || match[1] == 'waitingApprovalList' || match[1] == 'draftingList' || match[1] == 'approvalList') {
        // 추출된 부분을 이용하여 목록 페이지로 이동
        location.href = "/drafting/" + match[1];
    }  

}
	
	
function rejectModalClose(){
	$("#rejectTextArea").val(''); // textarea 값을 비움
	rejectModal.style.display = "none";    // block을 none으로 변경해서 모달창 닫기
}

function rejectReasonModalClose(){
	rejectReasonModal.style.display = "none";    // block을 none으로 변경해서 모달창 닫기
}

	
$(function(){
	var listBtn = $("#listBtn");	// 목록 버튼 Element
	var acceptBtn = $("#acceptBtn");	// 승인 버튼 Element
	var drftNoValue = $("#drftNo").val();	// 기안번호 Element
	var detailForm = $("#detailForm");		// form Element
	var rejectBtn = $("#rejectBtn");	// 반려 버튼 Element
	var rejectSubmitBtn = $("#rejectSubmitBtn");	// 반려 결재 버튼  Element
	var rejectReasonViewBtn = $("#rejectReasonViewBtn");	// 반려사유 버튼 Element
	var resurgenceBtn = $("#resurgenceBtn");	// 재기안 버튼 Element
	
	
	// 목록 버튼 클릭 시 들어온 경로로 리턴, 폼일 경우 전자결재 홈으로 이동
	listBtn.on("click", function() {
		goToPreviousListPage();
	});
	
	// 승인 버튼 클릭 시
	acceptBtn.on("click", function() {
		Swal.fire({
			icon: 'warning',
			title: '결재 승인',
			text: '결재를 승인하시겠습니까?',
			
		 	showCancelButton: true, // cancel버튼 보이기. 기본은 원래 없음
		   	confirmButtonColor: '#3085d6', // confrim 버튼 색깔 지정
		   	cancelButtonColor: '#d33', // cancel 버튼 색깔 지정
		   	confirmButtonText: '승인', // confirm 버튼 텍스트 지정
		   	cancelButtonText: '취소' // cancel 버튼 텍스트 지정
		   
		}).then(result => {
			   // 만약 Promise리턴을 받으면,
			   if (result.isConfirmed) { // confirm 버튼을 눌렀다면
				    console.log("drftNoValue", drftNoValue);
			   		
					// 폼 action 속성 변경
		            detailForm.attr('action', '/drafting/acceptSign');
		            
		            // 폼 서브밋
		            detailForm.submit();			   		
	        	}
		});
	});
	
	
	
	// 반려 버튼 클릭 시 
	rejectBtn.on("click", function() {
		rejectModal.style.display = "block";
		
	});	
	
	// 반려사유 버튼 클릭 시
	rejectSubmitBtn.on("click", function(){
		Swal.fire({
			icon: 'warning',
			title: '결재 반려',
			text: '결재를 반려하시겠습니까?',
			
		 	showCancelButton: true, // cancel버튼 보이기. 기본은 원래 없음
		   	confirmButtonColor: 'rgb(210, 50, 50)', // confrim 버튼 색깔 지정
		   	cancelButtonColor: 'rgb(150, 150, 150)', // cancel 버튼 색깔 지정
		   	confirmButtonText: '반려', // confirm 버튼 텍스트 지정
		   	cancelButtonText: '취소' // cancel 버튼 텍스트 지정
		   
		}).then(result => {
			// 반려사유 입력 모달 열기
			// 만약 Promise리턴을 받으면,
			   if (result.isConfirmed) { // confirm 버튼을 눌렀다면
					var rejectTextAreaValue = $("#rejectTextArea").val();
				    // 반려사유가 공백인지 확인
				    if (!rejectTextAreaValue.trim()) {
				        // 공백일 경우 알림을 띄움
				        Swal.fire({
				            icon: 'error',
				            title: '미입력',
				            text: '반려사유를 입력해주세요.',
				        });
				        return; // 함수 종료
				    } 
				 	// 폼 action 속성 변경
		            detailForm.attr('action', '/drafting/rejectSign');
		            
		            // 폼 서브밋
		            detailForm.submit();	
				    
			   }
		});
	    
		// action경로 변경
		// submit
	});
	
	
	// 반려사유 조회 클릭 시
	rejectReasonViewBtn.on("click", function(){
		rejectReasonModal.style.display = "block";
	});
	
	// 재기안 버튼 클릭 시
	resurgenceBtn.on("click", function(){
		Swal.fire({
			icon: 'warning',
			title: '재기안',
			text: '재기안 하시겠습니까?',
			
		 	showCancelButton: true, // cancel버튼 보이기. 기본은 원래 없음
		 	confirmButtonColor: '#9FCC2E', // confrim 버튼 색깔 지정
		   	cancelButtonColor: '#d33', // cancel 버튼 색깔 지정
		   	confirmButtonText: '재기안', // confirm 버튼 텍스트 지정
		   	cancelButtonText: '취소' // cancel 버튼 텍스트 지정
		   
		}).then(result => {
			// 만약 Promise리턴을 받으면,
			   if (result.isConfirmed) { // confirm 버튼을 눌렀다면
		            // 로직
				   location.href = "/drafting/resurgenceForm?drftNo=" + drftNoValue;
			   }
		});
		
		
	});
	
    $("#downloadBtn").click(function (e) {
	    // 화면을 좌측으로 스크롤 이동
	    $('#content').animate({ scrollLeft: 0 }, 'fast', function () {
	        // 스크롤 이동이 완료된 후에 html2canvas 실행
	        html2canvas(document.getElementById("capture")).then(function (canvas) {
	        	// 위쪽 10px, 아래쪽 10px 잘라내기
	            var croppedCanvas = document.createElement('canvas');
	            var context = croppedCanvas.getContext('2d');
	            var sourceHeight = canvas.height - 20; // 위쪽 10px, 아래쪽 10px 제거
	            croppedCanvas.width = canvas.width;
	            croppedCanvas.height = sourceHeight;
	            context.drawImage(canvas, 0, 10, canvas.width, sourceHeight, 0, 0, canvas.width, sourceHeight);

	            var el = document.createElement("a");
	            var drftNo = "${draftingMap.drafting.drftNo}";
	            var drftFormName = "${draftingMap.drafting.drftFormName}";
	            var fileName = drftNo + "_" + drftFormName + ".pdf";

	            // jsPDF 인스턴스 생성
	            var pdf = new jsPDF('p', 'mm', 'a4');

	            // 캔버스를 데이터 URL로 변환
	            var imgData = croppedCanvas.toDataURL("image/jpeg");

	            // PDF에 이미지 추가
	            pdf.addImage(imgData, 'JPEG', 10, 10, 190, 0);

	            // PDF 저장
	            pdf.save(fileName);
	        });
	    });
	});
	
	$("#presentationRejectModalInsert").on("click", function(){
		var rejectTextArea = $("#rejectTextArea");
		var strReject = '예상비용 절감 후 재기안 바랍니다.';
		rejectTextArea.val(strReject);
		
	});
	
});

setTimeout(() => {
	check();
}, 30);
</script>
