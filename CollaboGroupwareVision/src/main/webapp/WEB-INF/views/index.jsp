<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- todo 스크립트 -->
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/todo/todo.js"></script>

<!-- 근태관련 필수 코드 -->
<!-- 근태관련 필수 코드 -->

<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- QR 스크립트  -->
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/dclz/jsQR.js"></script>

<!-- QR 생성 스크립트 -->
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/dclz/qrcode.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/dclz/qrcode.min.js"></script>

<!-- 랜덤메뉴 모달 -->
<%@ include file="./randomMenu/randomMenu.jsp"%>

<style type="text/css">
img {
	width: 10px;
	height: 10px;
	margin: auto 0;
}

div#frame {
	border: 2px solid #005666;
	background-color: #FFFFFF;
	margin-left: 10px;
	margin-right: 10px;
	padding-left: 8px;
	padding-right: 8px;
	padding-top: 8px;
	padding-bottom: 8px;
}

div#outputLayer {
	text-align: left;
}

canvas {
	width: 100%;
	height: 100%;
}

.listDiv {
	overflow: auto;
}
</style>


<!-- 풀캘린더 스크립트 -->
<%-- <script src="${pageContext.request.contextPath }/resources/js/dclz/fullcalendar-dclzhome.js" defer></script> --%>
<script
	src="${pageContext.request.contextPath }/resources/assets/vendors/fullcalendar/main.min.js"
	defer></script>


<!-- 날짜 및 시간(실시간) 스크립트 -->
<script type="text/javascript">
/* 전역변수 */
var currentTime = getCurrentTime();
/* 실행되는 함수 구간 */
$(function () {
// 	addCalendarEventServer(); //서버에 저장된 캘린더 일정 가져오기
	updateDateTime(); // 초기 호출
    setInterval(updateDateTime, 1000);
    
	var dclzNo = "${dclzTime.dclzNo}";
	var empNo = "${dclzTime.empNo}";
	var lvwkDate = "${dclzTime.lvwkDate}";
	var gowkDate = "${dclzTime.gowkDate}";
	
	startBtnStatus();
    
	// 퇴근시간 스크립트
    $("#leaveBtn").on("click", function() {
    	currentTime = getCurrentTime();
        if (gowkDate == null || gowkDate.trim() == "") {
        	alertWarning();
            return;
        }else{
            $('#leaveWorkTime').text(currentTime);
            //console.log("퇴근버튼 클릭");
            
            $.ajax({
                url: '/dclz/dclzhomeleave',
                type: 'post',
                data: {dclzNo: dclzNo},
                dataType: 'json',
                beforeSend:function(xhr){
                    xhr.setRequestHeader(header,token);
                },
                success:function(data){
                    //console.log(data);
//                     addCalendarEventServer();
                },
	            error : function (jqXHR, textStatus, errorThrown){
   	         		/* console.log("jqXHR:",jqXHR);  //응답 메시지
   	         		console.log("textStatus:",textStatus); //"error"로 고정인듯함
   	         		console.log("errorThrown:",errorThrown); */
     	        }
              
            }); //ajax 끝
        }
    });

    // 출근시간 스크립트 (QR사용) 
    $("#startBtn").on("click", function() {
    	//console.log("출근 버튼 클릭됨");
    	$('#QRModal').modal('show');
    	//console.log("모달창 열림");
    	$('#QRModal').on('shown.bs.modal',function(){
    	//console.log("jsqr 활성화");
    			var video = document.createElement("video");		
    			var canvasElement = document.getElementById("canvas");
    			var canvas = canvasElement.getContext("2d");
    			var loadingMessage = document.getElementById("loadingMessage");
    			var outputContainer = document.getElementById("output");
    			var outputMessage = document.getElementById("outputMessage");
    			var outputData = document.getElementById("outputData");
    			
    			function drawLine(begin, end, color) {
    				canvas.beginPath();
    				canvas.moveTo(begin.x, begin.y);
    				canvas.lineTo(end.x, end.y);
    				canvas.lineWidth = 4;
    				canvas.strokeStyle = color;
    				canvas.stroke();
    	        } // drawLine 끝

    		    // 카메라 사용시
    			navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } }).then(function(stream) {
      		        video.srcObject = stream;
      		        video.setAttribute("playsinline", true);      // iOS 사용시 전체 화면을 사용하지 않음을 전달
         			video.play();
      		        requestAnimationFrame(tick);
    			});
    	        
    			// startWorkTime 요소 찾기
    		    var startWorkTime = $("#startWorkTime");
    			function tick() {
    				loadingMessage.innerText = "⌛ 스캔 기능을 활성화 중입니다."

					if(video.readyState === video.HAVE_ENOUGH_DATA) {
						loadingMessage.hidden = true;
						canvasElement.hidden = false;
						outputContainer.hidden = false;
	
	     		      // 읽어들이는 비디오 화면의 크기
	     		      canvasElement.height = video.videoHeight;
	     	 	      canvasElement.width = video.videoWidth;
	     		      canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height);
	     		      var imageData = canvas.getImageData(0, 0, canvasElement.width, canvasElement.height);
	     		      var code = jsQR(imageData.data, imageData.width, imageData.height, {
	                                 inversionAttempts : "dontInvert",
	     		      });
	
	                    // QR코드 인식에 성공한 경우
	                    if(code) {
	                           // 인식한 QR코드의 영역을 감싸는 사용자에게 보여지는 테두리 생성
	                          drawLine(code.location.topLeftCorner, code.location.topRightCorner, "#FF0000");
	                          drawLine(code.location.topRightCorner, code.location.bottomRightCorner, "#FF0000");
	                          drawLine(code.location.bottomRightCorner, code.location.bottomLeftCorner, "#FF0000");
	                          drawLine(code.location.bottomLeftCorner, code.location.topLeftCorner, "#FF0000");
	                          outputMessage.hidden = true;
	                          outputData.parentElement.hidden = false;
	
	                          // QR코드 메시지 출력
	                          //outputData.innerHTML = code.data;
	                          
	                       	  // 여기서 code.data 값은 QR 코드에서 읽은 데이터
	                          // 이 값을 서버로 전송하여 검증합니다.
	                          var scannedQRValue = code.data;	
	                       	  
	                          
	                         // 로그인한 사원의 QR코드와 일치하는지 확인할 ajax
				             $.ajax({
				                url: '/dclz/dclzQR',
				                type: 'post',
				                data: JSON.stringify({ scannedQRValue: scannedQRValue }),
				                dataType: 'json',
				                contentType: 'application/json',
				                beforeSend: function(xhr){
				                    xhr.setRequestHeader(header, token);
				                },
				                success: function(data) {
				                	// 여기에서 서버에서 받은 응답에 따라 처리
				                    if (data.isValid) {
				                      // QR 코드가 유효한 경우 출근 처리
			                          startWorkTime.text(currentTime);
			                          $("#startBtn").prop('disabled', true);
			                          $("#startBtn").css('background-color', '#808080').css('border','#808080');
			
			                          $('#QRModal').modal('hide');
			                          
			                          
			                          $.ajax({
			          	                url: '/dclz/dclzhomestart',
			          	                type: 'post',
			          	                dataType: 'text',
			          	                beforeSend:function(xhr){
			          	                    xhr.setRequestHeader(header,token);
			          	                },
			         	                	success: function() {
			         	                		//console.log(" 출근 입력 성공!");
				      	                          // 출근 성공 alert
				      	                          alertSuccess();
		
// 			         	                		setTimeout(() => {
// 				         	                		addCalendarEventServer();
// 												}, 300);
		
			
			         	                    },
			             	             	error : function (jqXHR, textStatus, errorThrown){
			             	             	/*console.log("jqXHR:",jqXHR);  //응답 메시지
			             	         		console.log("textStatus:",textStatus); //"error"로 고정인듯함
			             	         		console.log("errorThrown:",errorThrown); */
			             	         		}
			          	              
			          	              }); //출근 등록 ajax 끝

				                    }else{
				                    	// QR 코드가 유효하지 않은 경우 처리
		                    			Swal.fire({
											icon : 'warning',
											text : `QR코드가 일치하지 않습니다.`,
										})
				                    } 
				                }, //success 끝
				                error: function(jqXHR, textStatus, errorThrown) {
				                   /*  console.log("jqXHR:", jqXHR);  // 응답 메시지
				                    console.log("textStatus:", textStatus); // "error"로 고정인듯함
				                    console.log("errorThrown:", errorThrown); */
				                }
				             }); //QR인식 success 끝
	                    } else {// QR코드 인식에 실패한 경우 
	                          outputMessage.hidden = false;
	                          outputData.parentElement.hidden = true;
	                    } //else 끝
					} //if문 끝
    	      		      requestAnimationFrame(tick);
    			} //tick 끝
        }); // 모달에 jsqr 띄우기, shown.bs.modal 끝        	
    	
    }); // 출근 버튼 클릭 끝
    // 출근시간 스크립트 끝 
    
}); /* function 끝 */


//출근시각 유무에 따른 출근 버튼 색 상태 변경 
function startBtnStatus() {
		
	   var startWorkTime = $("#startWorkTime").text();
	
	   if (startWorkTime && startWorkTime.trim() !== "") { 
	       // 이미 출근한 경우
	       $("#startBtn").prop('disabled', true);
	       $("#startBtn").css('background-color', '#808080').css('border','#808080');
	       
		   if (startWorkTime && startWorkTime.trim() === "00:00:00") { 
		       $("#startBtn").prop('disabled', true);
		       $("#startBtn").css('background-color', '#808080').css('border','#808080');       
		       $("#leaveBtn").prop('disabled', true);
		       $("#leaveBtn").css('background-color', '#808080').css('border','#808080');
		   }
	   } else {
	       // 아직 출근하지 않은 경우
	       $("#startBtn").prop('disabled', false);
	       $("#startBtn").addClass("btn-info");
	       $("#startBtn").css('border', '').css('background-color', '');
	   }
}



 	//캘린더에 일정 추가(서버에서 가져온 값 띄우기)
	function addCalendarEventServer() {

		$.ajax({
			url : "/dclz/dclzstartsave",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success: function(res){
				
				const calendar = new FullCalendar.Calendar(document.getElementById("_dm-calendar"), {
			        

			        themeSystem: "bootstrap",

			        bootstrapFontAwesome: {
			            close: " demo-psi-cross",
			            prev: " demo-psi-arrow-left",
			            next: " demo-psi-arrow-right",
			            prevYear: " demo-psi-arrow-left-2",
			            nextYear: " demo-psi-arrow-right-2"
			        },
					events : res,
				});
				calendar.render();
				
			}
		});
	} 

	/* 출근 체크 시 성공 alert */
	function alertSuccess() {
		Swal.fire({
			icon : 'success',
			text : `출근 등록이 완료되었습니다.`,
		})
	}

	/* 퇴근 체크 시 오류 alert */
	function alertWarning() {
		Swal.fire({
			icon : 'warning',
			text : `출근 시간 등록 후 퇴근이 가능합니다.`,
		})
	}

	// 날짜 및 시간 업데이트 함수   
	function updateDateTime() {
		var today = getTodayDate();
		var date = new Date(); // 현재 날짜와 시간을 가져오는 객체 생성
		var hours = date.getHours();
		var minutes = date.getMinutes();
		var seconds = date.getSeconds();

		var currentTime = hours + ":" + ("0" + minutes).slice(-2) + ":"
				+ ("0" + seconds).slice(-2);

		// #currentDate는 <td> 엘리먼트이므로 val() 메서드를 사용할 수 없음.
		// 대신 text() 메서드를 사용하여 내용을 설정
		$('#currentDate').text(today);
		$('#currentTime').text(currentTime);
	}

	// 날짜
	function getTodayDate() {
		var date = new Date(); // 현재 날짜와 시간을 가져오는 객체 생성
		var week = date.getDay();
		//console.log("체크:", week); //제대로 출력됨

		var dayOfWeek = "";
		switch (week) {
		case 0:
			dayOfWeek = "일";
			break;
		case 1:
			dayOfWeek = "월";
			break;
		case 2:
			dayOfWeek = "화";
			break;
		case 3:
			dayOfWeek = "수";
			break;
		case 4:
			dayOfWeek = "목";
			break;
		case 5:
			dayOfWeek = "금";
			break;
		case 6:
			dayOfWeek = "토";
			break;
		default:
			dayOfWeek = "";
		}

		return date.getFullYear() + "."
				+ ("0" + (date.getMonth() + 1)).slice(-2) + "."
				+ ("0" + (date.getDate())).slice(-2) + "(" + dayOfWeek + ")";
	}

	// 시간
	function getCurrentTime() {
		var date = new Date(); // 현재 날짜와 시간을 가져오는 객체 생성
		var hours = date.getHours();
		var minutes = date.getMinutes();
		var seconds = date.getSeconds();

		return ("0" + hours).slice(-2) + ":" + ("0" + minutes).slice(-2) + ":"
				+ ("0" + seconds).slice(-2);
	}
</script>

<!-- QR 모달창 구간  -->

<div class="modal fade" id="QRModal">
	<div class="modal-dialog modal-dialog-centered modal-md">
		<div class="modal-content">
			<!-- Modal body -->
			<div class="modal-body text-center">
				<!-- jsQR 들어올 곳 -->
				<h1 class="fw-bold">출근 체크</h1>
				<hr />
				<div id="output">
					<div id="outputLayer" hidden>
						<span id="outputData"></span>
					</div>
				</div>
				<div>
					<div id="frame">
						<div id="loadingMessage">
							🎥 비디오 스트림에 액세스 할 수 없습니다<br />웹캠이 활성화되어 있는지 확인하십시오
						</div>
						<canvas id="canvas"></canvas>
						<br /> <br />
						<div id="outputMessage">본인의 QR코드를 카메라에 인식시켜 주세요</div>
						<br />
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- QR 모달창 구간 끝 -->

<!-- 근태관련 필수 코드 -->
<!-- 근태관련 필수 코드 -->

<div class="content__header content__boxed overlapping">
	<div class="content__wrap"></div>
</div>



<div class="content__boxed">
	<div class="content__wrap">
		<div class="row">
			<div class="col-xl-4 mb-xl-0" style="height: 420px;">

				<div class="card h-90" style="height: 420px; padding: 5%;">
					<!-- 근태시작 -->
					<div class="table-responsive">
						<table class="table">
							<tbody>
								<tr>
									<td colspan="2" class="fw-bold w-60" style="font-size: 2em; color: black;"
										id="currentDate"></td>
								</tr>
								<tr>
									<td colspan="2" class="fw-bold" rowspan="2" style="font-size: 3em; color: black;"
										id="currentTime"></td>
								</tr>
								<tr>
								</tr>
								<tr>
									<td style="font-size: 1.2em;"><i class="demo-pli-clock"></i>
										출근시각</td>
									<td style="font-size: 1.2em;" id="startWorkTime">
										${fn:split(dclzTime.gowkDate," ")[1]}</td>
								</tr>
								<tr>
									<td style="font-size: 1.2em;"><i class="demo-pli-clock"></i>
										퇴근시각</td>
									<td style="font-size: 1.2em;" id="leaveWorkTime">${fn:split(dclzTime.lvwkDate," ")[1]}</td>
								</tr>
								<tr>
									<td rowspan="2" class="w-50">
										<button type="button" style="font-size: 1.2em;"
											class="btn btn-info btn-lg w-100 text-center fw-bold" id="startBtn">출근</button>
									</td>
									<td rowspan="2" class="w-50">
										<button type="button" style="font-size: 1.2em;"
											class="btn btn-primary btn-lg w-100 text-center fw-bold" id="leaveBtn">퇴근</button>
									</td>
								</tr>
							</tbody>
						</table>
						<!-- content -->
					</div>

					<!-- 근태끝 -->
				</div>
			</div>
			<div class="col-xl-8">
				<div class="row">

					<!-- To Do List 시작 -->
					<div class="col-sm-8">

						<div class="card text-white overflow-hidden"
							style="height: 420px;">

							<div class="row d-flex justify-content-center">
								<!-- 좌측 TODOLIST ///////////////////////////////////////////////////////// -->
								<div class="col-xl-5 mb-xl-0" style="height: 290px; margin: 3%;">
									<!-- col-xl-5 클래스는 중간 크기의 화면에서 5개의 열을 차지 -->

									<h4 class="">
										<i class="ti-pin-alt"
											style="font-size: x-large !important; font-weight: bold;">
											To-do list</i>
									</h4>

									<div class="card bg-yellow h-100 listDiv" style="padding: 1% 5%;">

										<div class="col-md-8" style="width:100%">

											<ul class="list-group list-group-borderless">

												<c:set value="${todoList}" var="todo" />

												<c:choose>
													<c:when test="${empty todo}">
														<li class="list-group-item px-0">
															<div class="form-check fw-bold" style="color:black;">등록된 todoList가 없습니다.</div>
														</li>
													</c:when>
													<c:otherwise>
														<c:forEach items="${todoList}" var="todo" varStatus="loop">
															<c:if test="${todo.todoDelYn eq 'N'}">
																<li class="list-group-item px-0">
																	<div class="form-check " style="color:black;">
																		<c:if test="${todo.todoDelYn eq 'N'}">
																			<input id="_dm-todoList${loop.index}"
																				class="form-check-input" type="checkbox"
																				data-todo-no="${todo.todoNo}" data-emp-no="${todo.empNo}"
																				<c:if test="${todo.todoCheckYn eq 'Y'}">checked</c:if>>
																			<label for="_dm-todoList${loop.index}"
																				class="form-check-label"> ${todo.todoContent} </label>
																		</c:if>
																	</div>
																</li>
															</c:if>
														</c:forEach>
													</c:otherwise>
													
												</c:choose>
											</ul>
										</div>
									</div>
								</div>
								<!-- 좌측 TODOLIST 끝 ///////////////////////////////////////////////////////// -->

								<!-- 우측 TODOLIST ///////////////////////////////////////////////////////// -->
								<div class="col-xl-5 mb-xl-0" style="height: 290px; margin: 3%;">
									<!-- col-xl-5 클래스는 중간 크기의 화면에서 5개의 열을 차지 -->

									<h4 class="">
										<i class="ti-check-box"
											style="font-size: x-large !important; font-weight: bold;">
											Completed </i>
									</h4>

									<div class="card bg-green h-100 listDiv" style="padding: 1% 5%;">

										<div class="col-md-8" style="width:100%;">

											<ul class="list-group2 list-group-borderless">

												<c:set value="${cTodoList}" var="cTodoList" />

												<c:choose>
													<c:when test="${empty cTodoList}">
														<li class="list-group-item px-0">
															<div class="form-check fw-bold" style="margin-left: -30px; color:black;">완료된
																todoList가 없습니다.</div>
														</li>
													</c:when>
													<c:otherwise>
														<c:forEach items="${cTodoList}" var="ctodo"
															varStatus="loop">
															<li class="list-group-item px-0">
																<div class="form-check" style="margin-left: -30px; color:black;">
																	<input id="_dm-todoList${loop.index}"
																		class="form-check-input" type="checkbox"
																		data-todo-no="${ctodo.todoNo}"
																		data-emp-no="${ctodo.empNo}"
																		<c:if test="${ctodo.todoCheckYn eq 'Y'}">checked</c:if>>
																	<label for="_dm-todoList${loop.index}"
																		class="form-check-label text-decoration-line-through">
																		${ctodo.todoContent} </label>
																</div>
															</li>
														</c:forEach>
													</c:otherwise>
												</c:choose>
											</ul>
										</div>
									</div>
								</div>
								<!-- 우측 TODOLIST 끝 ///////////////////////////////////////////////////////// -->
							</div>
							<!-- row class :: row 클래스는 부트스트랩의 그리드 시스템에서 열을 나타내는 중요한 클래스 -->
							<hr/>
							<!-- 추가버튼///////////////////////////////////////////////////////// -->
							<div class="input-group mt-3" style="width: 90%; margin: 5%;">
								<input type="text" class="form-control form-control-sm"
									name="todoContent" id="todoContent" placeholder="Add new list"
									aria-label="Add new list" aria-describedby="button-addon">
								<button id="addTodoBtn"
									class="btn btn-sm btn-primary hstack gap-2" type="button">
									<i class="demo-psi-add text-white-50 fs-4"></i> Add New
								</button>
							</div>
							<!-- 추가버튼 끝///////////////////////////////////////////////////////// -->
						</div>
					</div>
					<!--  To Do List 끝 -->




					<!-- 프로젝트 시작 -->
					<div class="col-sm-4">

						<!-- Tile - Earnings -->
						<div class="card overflow-hidden mb-3"
							style="height: 340px; padding: 5%;">
							
							<c:if test="${not empty projectCounts }">
								<c:set var="total" value="${projectCounts.TOTAL }"/>
								<c:set var="pending" value="${projectCounts.PENDING }"/>
								<c:set var="ongoing" value="${projectCounts.ONGOING }"/>
								<c:set var="suspended" value="${projectCounts.SUSPENDED }"/>
								<c:set var="completed" value="${projectCounts.COMPLETED }"/>
							</c:if>
							
							
							<!-- 왼쪽 -->
							<div class="px-3">
								<div class="row g-sm-1 mb-3 d-flex justify-content-center">
								<div class="h3 mb-3 fw-bold">프로젝트 진행상황</div>
									<div class="col-sm-6">
		
										<div class="card bg-purple text-white mb-1 mb-xl-1">
											<div class="p-3 text-center">
												<span class="display-6">${pending }</span>
												<p>대기</p>
											</div>
										</div>
		
										<div class="card bg-warning text-white mb-1 mb-xl-1">
											<div class="p-3 text-center">
												<span class="display-6">${suspended }</span>
												<p>보류</p>
											</div>
										</div>
		
									</div>
									<div class="col-sm-6">
		
										<div class="card bg-info text-white mb-1 mb-xl-1">
											<div class="p-3 text-center">
												<span class="display-6">${ongoing }</span>
												<p>진행</p>
											</div>
										</div>
		
										<div class="card bg-success text-white mb-1 mb-xl-1">
											<div class="p-3 text-center">
												<span class="display-6">${completed }</span>
												<p>완료</p>
											</div>
										</div>
									</div>
								</div>
							</div>
	
							<!-- Line Chart -->
							<div class="py-0" style="height: 70px; margin: 0 -5px -5px;">
								<canvas id="_dm-earningChart"></canvas>
							</div>
							<!-- END : Line Chart -->

						</div>
						<!-- END : Tile - Earnings -->


						<!-- 프로젝트 끝 -->

						<!-- 랜덤메뉴 시작 -->
						<div class="card" id="randomMenuArea">
							<div class="card-body text-center"></div>
						</div>
						<!-- 랜덤메뉴 끝 -->
						<!-- 근태끝 -->
					</div>
				</div>
			</div>
		</div>

	</div>
</div>

<!-- 하단 공간 -->
<div class="content__boxed bg-gray-500 my-3">
	<div class="content__wrap">
		<div class="row">
			<!-- 오늘일정 -->
			<div class="col-md-4 mb-3 mb-xl-0">
				<div class="card" style="padding: 3%; height: 405px;">
				
					<!-- 캘린더 -->
					<div class="flex-fill" style="height: 405px;">
	                  <div id="_dm-calendar"></div>
	               </div>
				<!-- 캘린더 -->
				
				</div>
			</div>
			<!-- 오늘일정 끝 -->

			<div class="col-xl-8">
				<div class="row">

					<div class="col-sm-15">


						<div class="card overflow-hidden "
							style="padding: 3%;  height: 405px; width: 100%;">
												<!-- 게시판 목록 -->
							<h5 class="mb-1 fw-bold" style="font-size: 20px;">
								<a href="/notice/noticeList" style="cursor: pointer; text-decoration: none; color: inherit;">공지사항 </a>
                            </h5>
							<div class="table-responsive">
								<table class="table table-striped align-middle">
		
									
									
									<!-- 게시판 항목명 -->
									<thead>
									    <tr>
									        <th class="text-left">공지 제목</th>
									        <th class="text-center">작성자</th>
									        <th class="text-center">공지 날짜</th>
									        <th class="text-center">조회수</th>
									    </tr>
									</thead>
									<!-- 게시판 항목명 끝 -->
									
									<!-- 게시글 -->
									<tbody>
									    <c:set value="${noticeListMain}" var="noticeList" />
									    <c:choose>
									        <c:when test="${not empty noticeList}">
									<c:forEach items="${noticeList}" var="notice" varStatus="loop">
										<c:if test="${notice.boardCode eq 1}">
										    <tr>
										        <td class="text-left"><a href="/notice/detail?boardNo=${notice.boardNo}">${notice.boardTitle}</a></td>
										        <td class="text-center">${notice.empName}</td>
										        <td class="text-center">${notice.regDate}</td>
										        <td class="text-center">${notice.inqCnt}</td> 
										    </tr>
									    </c:if>
									</c:forEach>
									        </c:when>
									        <c:otherwise>
									            <tr>
									                <td colspan="4">조회하신 공지글이 존재하지 않습니다...</td>
									            </tr>
									        </c:otherwise>
									    </c:choose>
									</tbody>
									<!-- 게시글 끝 -->
								</table>
								
							</div>
							<!-- 	<div style="text-align: right;">
										<a href="/notice/noticeList" style="cursor: pointer">더보기...</a>
								</div> -->
						</div>

					</div>

				</div>
			</div>

		</div>

	</div>
</div>
<!-- footer 영역 -->
<!-- header 영역 -->
<!-- mainNavigator 영역 -->
<!-- setting 영역 -->

<script
	src="${pageContext.request.contextPath }/resources/assets/js/demo-purpose-only.js"
	defer></script>
<script
	src="${pageContext.request.contextPath }/resources/assets/vendors/chart.js/chart.min.js"
	defer></script>
<script
	src="${pageContext.request.contextPath }/resources/assets/pages/dashboard-1.js"
	defer></script>
	
<script>
document.addEventListener('DOMContentLoaded', function() {
	  /*      console.log('==============');
	       var A =[];
	       <c:forEach var="vo" items="${calendarList}" varStatus ="status">
	        console.log("${status.index}")
	        A[${status.index}] = "vo";
	        </c:forEach> */
	       var calendarEl = document.getElementById('_dm-calendar');
	       var calendar = new FullCalendar.Calendar(calendarEl, {
	       initialView : 'dayGridMonth',
	       locale : 'ko',  
	       
	
	            
	         navLinks: false,       // day/week 클릭시 단위별 보여주는 화면으로 넘어감
	         editable: true,       // 드래그 수정 가능 길게 확장가능
	         dayMaxEvents: true,   // +more 표시 전 최대 이벤트 갯수 true는 셀 높이에 의해 결정
	         selectable: true,      // 캘린더에서 날짜 영역을 선택할 수 있는지 여부결정
	         businessHours: true,    // display business hours(영업시간표사??)
	         droppable: true,      // 와부 요소나 다른 캘린더 이벤트 등을 캘린더 영억에 끌어서 떨어뜨릴 수 있는 지 여부를 결정
	         
	         events: [          
	                  <c:forEach var="vo" items="${calendarList}">
	                     

	                {
	                   calendarNo: '<c:out value="${vo.calNo}"/>',         //일정번호
	                    title: '<c:out value="${vo.calTitle}"/>',         //일정제목
	                    start: '<c:out value="${vo.calStartDate}"/>',      //캘린더 시작날짜
	                    end: '<c:out value="${vo.calEndDate}"/>',         //캘린더 끝나는날짜
	                    content: '<c:out value="${vo.calContent}"/>',      //캘린더 상세내용                                                
	                    repeatDate: '<c:out value="${vo.calRepeatDate}"/>',   // 일정반복종료
	                    calRepeatUnit: '<c:out value="${vo.calRepeatUnit}"/>', // 일정반복 단위
	                    calType: '<c:out value="${vo.calType}"/>',         // 일정 종류
	                    
	             <c:choose>       
	                  <c:when test="${vo.calType eq '0'}"> 
	                     color: "green",
	                     borderColor : "green",
	                     </c:when> 
	                  <c:when test="${vo.calType eq '1'}"> 
	                     color: "blue",
	                     borderColor : "blue",
	                     </c:when>      
	                  <c:when test="${vo.calType eq '2'}"> 
	                     color: "red",
	                 borderColor : "red",
	                 </c:when>   
	            </c:choose>
	            
	                    <c:choose>      
	                    <c:when test="${vo.calAll eq 'Y'}"> 
	                       allDay: true,
	                       allDayYN : "Y"
	                    </c:when> 
	                    <c:when test="${vo.calAll eq 'N'}"> 
	                       allDay: false,
	                       allDayYN : "N"
	                    </c:when>

	                    
	                </c:choose>
	                    
	                    
	                },
	                </c:forEach>
	                ],
	                
	                dateClick: function(info) {
	                   // 클릭된 날짜 정보 출력
	                    console.log('Clicked on: ' + info.dateStr);
	                   console.log(moment(info.date).format('YYYY-MM-DD HH:mm:ss'));
	                   var date = new Date(info.date);
	                   var startDate = moment(date).format('YYYY-MM-DD HH:mm:ss');
	                   date.setDate(date.getDate() + 1);
	                   var endDate = moment(date).format('YYYY-MM-DD HH:mm:ss')
	                   var repeatDate = moment(date).format('YYYY-MM-DD')
	                   
	                    // 여기에 클릭된 날짜에 대한 추가 동작을 구현할 수 있습니다.
	                    // 예를 들어, 모달 창 열기, 이벤트 추가 등의 동작을 수행할 수 있습니다.
	                    $("#calModal #calTitle").val("");
	                    $("#calModal #calStartDate").val(startDate);
	                    $("#calModal #calEndDate").val(endDate);
	                    $("#calModal #calContent").val("");
	                    
	                    // 등록 버튼의 스타일을 파란색으로 변경
	                    $("#insertCal")
	                        .removeClass("btn-danger font-weight-bold")
	                        .addClass("btn-primary");
	                    $("#calModal").modal("show");
	                    $(".modal-header .modal-title").html("<strong style='color: red;'>일간</strong> 일정 등록");
	                    },
	                    select: function(info) {
	                        // 선택된 날짜 범위 정보 출력
	                        console.log('Selected from: ' + info.startStr + ' to: ' + info.endStr  );
	                        // 여기에 선택된 날짜 범위에 대한 추가 동작을 구현할 수 있습니다.
	                        // 예를 들어, 모달 창 열기, 이벤트 추가 등의 동작을 수행할 수 있습니다.
	                      
	                        
	                        info.startStr = moment(info.startStr).format('YYYY-MM-DD HH:mm:ss');
	                        info.endStr  = moment(info.endStr).format('YYYY-MM-DD HH:mm:ss');
	                    
	                    
	                    
	           
	                    
	                 
	                        // info.end를 Moment.js 객체로 변환
	                     var momentEnd = moment(info.end);
	                     // Moment.js 객체인 경우에만 clone 메서드 사용
	                     if (momentEnd.isValid()) {
	                         // 여기에서 수정된 날짜를 사용하여 추가 작업 수행
	                           $("#calModal #calTitle").val("");
	                           $("#calModal #calStartDate").val(info.startStr);
	                           $("#calModal #calEndDate").val(info.endStr);
	                           $("#calModal #calRepeatDate").val(info.repeatStr);
	                           $("#calModal #calContent").val("");
	                           $("#calModal #calRepeatUnit").val("calRepeatUnit");
	                
	                         $("#calModal").modal("show");
	                         $(".modal-header .modal-title").html("<strong style='color: blue;'>주간</strong> 일정 등록");
	                     } else {
	                         console.error('info.end is not a valid Moment.js object');
	                     }
	                    },
	                    selectMinDistance: 4, // 기본값은 0입니다. 원하는 값으로 조정하세요.
	                    
	                    
	                    eventDrop: function(info) {
	                       
	                       var calType = info.event._def.extendedProps["calType"];
	                        var calColor = info.event["borderColor"];   
	                       var calAll = info.event._def.extendedProps["allDayYN"];
	                       var calRepeatUnit = info.event._def.extendedProps["calRepeatUnit"];
	                       info.repeatStr = moment(info.repeatStr).format('YYYY-MM-DD');
	                       
	                       const json = JSON.stringify(info.repeatStr);
	                       const Unit = calRepeatUnit;
	                       const all = calAll
	                       const type = calType
	                       
	                        // 드래그한 이벤트의 정보 출력
	                        console.log('Event dropped: ' + info.event.title);
	                        console.log('Calendar No: ' + info.event.extendedProps.calendarNo);
	                        console.log('New start date: ' + info.event.startStr);
	                        console.log('New end date: ' + info.event.endStr);
	                        console.log('New repeat date: ' + json);
	                        console.log('all: ' + all);                  
	                        console.log('Event title: ' + info.event.title);
	                        console.log('Event content: ' + info.event.extendedProps.content);
	                        console.log('Event calAll: ' + all);
	                        console.log('Event calColor: ' + calColor);
	                        console.log('Event type: ' + type);
	                     console.log(info);
	                     // info.event.startStr와 info.event.endStr는 ISO 형식의 날짜 문자열입니다.
	                        var startDate = new Date(info.event.startStr);
	                        var endDate = new Date(info.event.endStr);
	                       
	                        
	                        console.log("startDate : " + startDate);
	                        console.log("endDate : " + endDate);
	                        console.log("repeatDate : " + json);
	                        if(endDate == 'Invalid Date') {
	                        endDate = startDate;
	                        }
	                        
	                        /* if(startDate != endDate){
	                        // 하루 뒤로 미룸
	                        startDate.setDate(startDate.getDate() + 1);
	                        endDate.setDate(endDate.getDate() + 1);
	                        }else {
	                        endDate.setDate(endDate.getDate() + 1);
	                        } */
	                        // 날짜를 'YYYY-MM-DD' 형식으로 변환
	                        var formattedStartDate = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
	                        var formattedEndDate = moment(endDate).format('YYYY-MM-DD HH:mm:ss');
	                        var formattedRepeatDate = moment(json).format('YYYY-MM-DD');
	                        console.log('New start date: ' + formattedStartDate);
	                        console.log('New end date: ' + formattedEndDate);
	                        console.log('New Repeat date: ' + formattedRepeatDate);
	                        // 여기에 드래그한 이벤트에 대한 추가 동작을 구현할 수 있습니다.
	                        // 예를 들어, 이벤트의 업데이트, 모달 창 열기 등의 동작을 수행할 수 있습니다.
	                        
	                        $("#calForm #calendarNo").remove();
	                        $("#calForm").prepend("<input id='calendarNo' name='calNo' type='hidden' value='"+info.event.extendedProps.calendarNo+"' />");
	                        
	                        $("#calForm #calTitle").remove();
	                        $("#calForm label[for=calTitle]").prepend("<input id='calTitle' name='calTitle' type='hidden' value='"+info.event.title+"' />");
	                        
	                        $("#calForm #calContent").remove();
	                        $("#calForm label[for=calStartDate]").prepend("<input id='calContent' name='calContent' type='hidden' value='"+info.event.extendedProps.content+"' />");
	                        
	                        $("#calForm #calStartDate").remove();
	                        $("#calForm label[for=calStartDate]").prepend("<input id='calStartDate' name='calStartDate' type='hidden' value='"+formattedStartDate+"' />");
	                      
	                        $("#calForm #calEndDate").remove();
	                        $("#calForm label[for=calEndDate]").prepend("<input id='calEndDate' name='calEndDate' type='hidden' value='"+formattedEndDate+"' />");
	                        
	                        $("#calForm #calRepeatDate").remove();
	                        $("#calForm label[for=calRepeatDate]").prepend("<input id='calRepeatDate' name='calRepeatDate' type='hidden' value='"+formattedRepeatDate+"' />");
	                        
	                        $("#calForm #calRepeatUnit").remove();
	                        $("#calForm label[for=calRepeatUnit]").prepend("<input id='calRepeatUnit' name='calRepeatUnit' type='hidden' value='"+Unit+"' />");
	                                                               
	                        $("#calForm #calAll").remove();
	                        $("#calForm label[for=all]").prepend("<input id='all' name='all' type='hidden' value='"+all+"' />");
	                        
	                        $("#calForm #calType").remove();
//	                         $("#calForm label[for=calType]").prepend("<input id='calType' name='calType' type='hidden' value='"+type+"' />");
	                  var calTypes = $("#calForm").find("input[name=calType]");
	                  calTypes.map(function(i,v){
	                     if(calType == v.value){
	                        v.checked = true;                  
	                     }
	                  });
	                        
	                      
	                         $("#calForm").attr("action", "/calendar/updateCal");
	                         $("#calForm").submit();      
	           },
	           
	                    // 이벤트 클릭
	                    eventClick: function(info) {
	                       console.log("eventClick");
	                       console.log(info);
	                    // 클릭된 이벤트의 정보 출력
	                        console.log('클릭한 이벤트: ', info.event);
	                        // 시작일 및 종료일이 null이 아닌지 확인
	                        var startDate = moment(info.event.start).format('YYYY-MM-DD HH:mm:ss');
	                        var endDate = moment(info.event.end).format('YYYY-MM-DD HH:mm:ss');
	                        var repeatDate = moment(info.event.repeat).format('YYYY-MM-DD');
	                        var calType = info.event._def.extendedProps["calType"];
	                        
	                        var calAll = info.event._def.extendedProps["allDayYN"];
	                        var calColor = info.event["borderColor"];         
	                       var calRepeatUnit = info.event._def.extendedProps["calRepeatUnit"];
	                       
	             
	                       
	                        console.log("일정 제목: " + info.event.title);
	                        console.log("일정 시작 날짜: " + startDate);
	                        console.log("일정 종료 날짜: " + endDate);
	                        console.log("반복날짜: " + repeatDate);
	                        console.log("반복단위: " + calRepeatUnit);
	                        console.log("일정단위: " + calType);
	                        console.log("all: " + calAll);
	                        console.log("calColor: " + calColor);

	                        // extendedProps가 존재하고 그 안에 calendarMemo가 있는지 확인
	                        // content 입력
	                        var calContent = info.event._def.extendedProps["content"];
	                        console.log("일정 내용: " + calContent);
	                        
	                     // 캘린더 번호 값을 숨겨진 입력 필드에 설정
	                     // 폼 태그 안쪽에 prepend 해보자. 안되겠다...
	                     $("#calForm #calendarNo").remove();
	                     $("#calForm").prepend("<input id='calendarNo' type='hidden' name='calNo'  value='"+info.event.extendedProps.calendarNo+"' />");
	                        // 입력 요소를 읽기 전용으로 설정
	                        $("#calModal #calTitle").prop("readonly", true);
	                        $("#calModal #calStartDate").prop("readonly", true);
	                        $("#calModal #calEndDate").prop("readonly", true);
	                        $("#calModal #calContent").prop("readonly", true);
	                        $("#calModal #calRepeatDate").prop("readonly", true);
	                        // 버튼 텍스트 변경 및 클래스 추가
	                        $("#insertCal")
	                            .text("수정")
	                            .removeClass("btn-primary")
	                            .removeClass("btn-danger")
	                            .addClass("btn-warning");
	                     
	                        
	                        // 삭제 버튼 추가
	                        var removeBtn = "<button type='button' id='deleteCal' class='btn btn-danger'>삭제</button>";
	                        $("#calForm").append(removeBtn);  // 모달 창 열기
	                        $("#calModal #calNo").val(info.event.calendarNo);      // 번호
	                        $("#calModal #calTitle").val(info.event.title);         // 제목                     
	                        $("#calModal #calStartDate").val(startDate);         //시간날짜
	                        $("#calModal #calEndDate").val(endDate);            //끝 날짜
	                        $("#calModal #calContent").val(calContent);            //내용
	                        $("#calModal #calRepeatUnit").val(calRepeatUnit);      //반복단위
	                        $("#calModal #calRepeatDate").val(moment(repeatDate).format('YYYY-MM-DD'));   // 반복일자
	                        $("#calModal #calAll").val(calAll);                                       // allDay
	                        $("input:radio[name ='calType']:input[value='"+calType+"']").attr("checked", true); // 일정 종류 값 넣기
	                        $("#calModal").modal("show");
	                        $(".modal-header .modal-title").html("<strong style='color: green;'>일정 확인</strong>");
	                        },
	                        
	                        
	                    eventMouseEnter: function (info) {
	                       console.log("eventMouseEnter");
	                        // 툴팁 내용 생성
	                        var tooltipContent = '<span class="tooltip-title">' + info.event.title + '</span><br /><span class="tooltip-Content">' + info.event.extendedProps.content + '</span>';
	                        // 부트스트랩 툴팁 적용                                                                                             
	                        $(info.el).tooltip({
	                            title: tooltipContent,
	                            html: true,
	                            placement: 'top',
	                            trigger: 'hover focus', // 툴팁을 호버 또는 포커스할 때만 표시
	                        }).tooltip('show');
	                    },
	                    eventMouseLeave: function (info) {
	                        // 툴팁 숨기기
	                        $(info.el).tooltip('hide');
	                    }
	         });
	         calendar.render();
	         $(".fc-header-toolbar").css("display", "none");
	         calendar.render();
	         });
	         
	        
// 개인일정, 부서일정, 전사일정을 체크 이벤트로 호출할 때
$(".checkBox").change(function(){
    var arrayText = "";
    for(let i=0 ; i< $("input:checkbox[name=checkBox]:checked").length; i++){
       var val = $("input:checkbox[name=checkBox]:checked")[i].value;
       arrayText += "'"+ val + "'";
       
       if(i != $("input:checkbox[name=checkBox]:checked").length-1){
         arrayText += ",";
       }

    }

    
     $.ajax({
         type : "POST",            // HTTP method type(GET, POST) 형식이다.
         url : "/calendar/celcheckBox",      // 컨트롤러에서 대기중인 URL 주소이다.
         data : {asd : arrayText },            // Json 형식의 데이터이다.
         beforeSend:function(xhr){
            xhr.setRequestHeader(header,token);
         },
         success : function(data){ // 비동기통신의 성공일경우 success콜백으로 들어옵니다. 'res'는 응답받은 데이터이다.
             // 응답코드 > 0000
             var dataArray = [];
             for(let i = 0; i<data.result.length; i++){
                var color = "";
                var borderColor = "";
                var allDay = true;
                var allDayYN = "";
                
                if(data.result[i].calType == 0){
                    color = "green";
                      borderColor = "green";
                }else if (data.result[i].calType == 1){
                   color = "blue";
                     borderColor = "blue";
                }else if (data.result[i].calType == 2){
                   color = "red";
                     borderColor = "red";
                }
                
                if(data.result[i].calAll == "Y"){
                   allDay = true ; 
                     allDayYN = "Y";
                }else{
                   allDay = false ; 
                     allDayYN = "N";
                
                }
                
                dataArray[i] = { 
                      calendarNo: data.result[i].calNo,         //일정번호
                         title: data.result[i].calTitle,         //일정제목
                         start: data.result[i].calStartDate,      //캘린더 시작날짜
                         end: data.result[i].calEndDate,         //캘린더 끝나는날짜
                         content: data.result[i].calContent,      //캘린더 상세내용                                                
                         repeatDate: data.result[i].calRepeatDate,   // 일정반복종료
                         calRepeatUnit: data.result[i].calRepeatUnit, // 일정반복 단위
                         calType: data.result[i].calType,         // 일정 종류
                         color : color,
                         borderColor : borderColor,
                         allDay : allDay,
                         allDayYN : allDayYN
                         
                }

                



      
             
             }
             
             console.log(dataArray);
             
             
             
             var calendarEl = document.getElementById('_dm-calendar');
             var calendar = new FullCalendar.Calendar(calendarEl, {
             initialView : 'dayGridMonth',
             locale : 'ko',  
             
                  
               navLinks: false,       // day/week 클릭시 단위별 보여주는 화면으로 넘어감
               editable: true,       // 드래그 수정 가능 길게 확장가능
               dayMaxEvents: true,   // +more 표시 전 최대 이벤트 갯수 true는 셀 높이에 의해 결정
               selectable: true,      // 캘린더에서 날짜 영역을 선택할 수 있는지 여부결정
               businessHours: true,    // display business hours(영업시간표사??)
               droppable: true,      // 와부 요소나 다른 캘린더 이벤트 등을 캘린더 영억에 끌어서 떨어뜨릴 수 있는 지 여부를 결정
               
               events:   dataArray       
                   
                      ,
                      
                      dateClick: function(info) {
                         // 클릭된 날짜 정보 출력
                          console.log('Clicked on: ' + info.dateStr);
                         console.log(moment(info.date).format('YYYY-MM-DD HH:mm:ss'));
                         var date = new Date(info.date);
                         var startDate = moment(date).format('YYYY-MM-DD HH:mm:ss');
                         date.setDate(date.getDate() + 1);
                         var endDate = moment(date).format('YYYY-MM-DD HH:mm:ss')
                         var repeatDate = moment(date).format('YYYY-MM-DD')
                         
                          // 여기에 클릭된 날짜에 대한 추가 동작을 구현할 수 있습니다.
                          // 예를 들어, 모달 창 열기, 이벤트 추가 등의 동작을 수행할 수 있습니다.
                          $("#calModal #calTitle").val("");
                          $("#calModal #calStartDate").val(startDate);
                          $("#calModal #calEndDate").val(endDate);
                          $("#calModal #calContent").val("");
                          
                          // 등록 버튼의 스타일을 파란색으로 변경
                          $("#insertCal")
                              .removeClass("btn-danger font-weight-bold")
                              .addClass("btn-primary");
                          $("#calModal").modal("show");
                          $(".modal-header .modal-title").html("<strong style='color: red;'>일간</strong> 일정 등록");
                          },
                          select: function(info) {
                              // 선택된 날짜 범위 정보 출력
                              console.log('Selected from: ' + info.startStr + ' to: ' + info.endStr  );
                              // 여기에 선택된 날짜 범위에 대한 추가 동작을 구현할 수 있습니다.
                              // 예를 들어, 모달 창 열기, 이벤트 추가 등의 동작을 수행할 수 있습니다.
                            
                              
                              info.startStr = moment(info.startStr).format('YYYY-MM-DD HH:mm:ss');
                              info.endStr  = moment(info.endStr).format('YYYY-MM-DD HH:mm:ss');
                          
                          
                          
                 
                          
                       
                              // info.end를 Moment.js 객체로 변환
                           var momentEnd = moment(info.end);
                           // Moment.js 객체인 경우에만 clone 메서드 사용
                           if (momentEnd.isValid()) {
                               // 여기에서 수정된 날짜를 사용하여 추가 작업 수행
                                 $("#calModal #calTitle").val("");
                                 $("#calModal #calStartDate").val(info.startStr);
                                 $("#calModal #calEndDate").val(info.endStr);
                                 $("#calModal #calRepeatDate").val(info.repeatStr);
                                 $("#calModal #calContent").val("");
                                 $("#calModal #calRepeatUnit").val("calRepeatUnit");
                      
                               $("#calModal").modal("show");
                               $(".modal-header .modal-title").html("<strong style='color: blue;'>주간</strong> 일정 등록");
                           } else {
                               console.error('info.end is not a valid Moment.js object');
                           }
                          },
                          selectMinDistance: 4, // 기본값은 0입니다. 원하는 값으로 조정하세요.
                          
                          
                          eventDrop: function(info) {
                             
                             var calType = info.event._def.extendedProps["calType"];
                              var calColor = info.event["borderColor"];   
                             var calAll = info.event._def.extendedProps["allDayYN"];
                             var calRepeatUnit = info.event._def.extendedProps["calRepeatUnit"];
                             info.repeatStr = moment(info.repeatStr).format('YYYY-MM-DD');
                             
                             const json = JSON.stringify(info.repeatStr);
                             const Unit = calRepeatUnit;
                             const all = calAll
                             const type = calType
                             
                              // 드래그한 이벤트의 정보 출력
                              console.log('Event dropped: ' + info.event.title);
                              console.log('Calendar No: ' + info.event.extendedProps.calendarNo);
                              console.log('New start date: ' + info.event.startStr);
                              console.log('New end date: ' + info.event.endStr);
                              console.log('New repeat date: ' + json);
                              console.log('all: ' + all);                  
                              console.log('Event title: ' + info.event.title);
                              console.log('Event content: ' + info.event.extendedProps.content);
                              console.log('Event calAll: ' + all);
                              console.log('Event calColor: ' + calColor);
                              console.log('Event type: ' + type);
                           console.log(info);
                           // info.event.startStr와 info.event.endStr는 ISO 형식의 날짜 문자열입니다.
                              var startDate = new Date(info.event.startStr);
                              var endDate = new Date(info.event.endStr);
                             
                              
                              console.log("startDate : " + startDate);
                              console.log("endDate : " + endDate);
                              console.log("repeatDate : " + json);
                              if(endDate == 'Invalid Date') {
                              endDate = startDate;
                              }
                              
                              /* if(startDate != endDate){
                              // 하루 뒤로 미룸
                              startDate.setDate(startDate.getDate() + 1);
                              endDate.setDate(endDate.getDate() + 1);
                              }else {
                              endDate.setDate(endDate.getDate() + 1);
                              } */
                              // 날짜를 'YYYY-MM-DD' 형식으로 변환
                              var formattedStartDate = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
                              var formattedEndDate = moment(endDate).format('YYYY-MM-DD HH:mm:ss');
                              var formattedRepeatDate = moment(json).format('YYYY-MM-DD');
                              console.log('New start date: ' + formattedStartDate);
                              console.log('New end date: ' + formattedEndDate);
                              console.log('New Repeat date: ' + formattedRepeatDate);
                              // 여기에 드래그한 이벤트에 대한 추가 동작을 구현할 수 있습니다.
                              // 예를 들어, 이벤트의 업데이트, 모달 창 열기 등의 동작을 수행할 수 있습니다.
                              
                              $("#calForm #calendarNo").remove();
                              $("#calForm").prepend("<input id='calendarNo' name='calNo' type='hidden' value='"+info.event.extendedProps.calendarNo+"' />");
                              
                              $("#calForm #calTitle").remove();
                              $("#calForm label[for=calTitle]").prepend("<input id='calTitle' name='calTitle' type='hidden' value='"+info.event.title+"' />");
                              
                              $("#calForm #calContent").remove();
                              $("#calForm label[for=calStartDate]").prepend("<input id='calContent' name='calContent' type='hidden' value='"+info.event.extendedProps.content+"' />");
                              
                              $("#calForm #calStartDate").remove();
                              $("#calForm label[for=calStartDate]").prepend("<input id='calStartDate' name='calStartDate' type='hidden' value='"+formattedStartDate+"' />");
                            
                              $("#calForm #calEndDate").remove();
                              $("#calForm label[for=calEndDate]").prepend("<input id='calEndDate' name='calEndDate' type='hidden' value='"+formattedEndDate+"' />");
                              
                              $("#calForm #calRepeatDate").remove();
                              $("#calForm label[for=calRepeatDate]").prepend("<input id='calRepeatDate' name='calRepeatDate' type='hidden' value='"+formattedRepeatDate+"' />");
                              
                              $("#calForm #calRepeatUnit").remove();
                              $("#calForm label[for=calRepeatUnit]").prepend("<input id='calRepeatUnit' name='calRepeatUnit' type='hidden' value='"+Unit+"' />");
                                                                     
                              $("#calForm #calAll").remove();
                              $("#calForm label[for=all]").prepend("<input id='all' name='all' type='hidden' value='"+all+"' />");
                              
                              $("#calForm #calType").remove();
//                               $("#calForm label[for=calType]").prepend("<input id='calType' name='calType' type='hidden' value='"+type+"' />");
                        var calTypes = $("#calForm").find("input[name=calType]");
                        calTypes.map(function(i,v){
                           if(calType == v.value){
                              v.checked = true;                  
                           }
                        });
                              
                            
                               $("#calForm").attr("action", "/calendar/updateCal");
                               $("#calForm").submit();      
                 },
                 
                          // 이벤트 클릭
                          eventClick: function(info) {
                             console.log("eventClick");
                             console.log(info);
                          // 클릭된 이벤트의 정보 출력
                              console.log('클릭한 이벤트: ', info.event);
                              // 시작일 및 종료일이 null이 아닌지 확인
                              var startDate = moment(info.event.start).format('YYYY-MM-DD HH:mm:ss');
                              var endDate = moment(info.event.end).format('YYYY-MM-DD HH:mm:ss');
                              var repeatDate = moment(info.event.repeat).format('YYYY-MM-DD');
                              var calType = info.event._def.extendedProps["calType"];
                              
                              var calAll = info.event._def.extendedProps["allDayYN"];
                              var calColor = info.event["borderColor"];         
                             var calRepeatUnit = info.event._def.extendedProps["calRepeatUnit"];
                             
                   
                             
                              console.log("일정 제목: " + info.event.title);
                              console.log("일정 시작 날짜: " + startDate);
                              console.log("일정 종료 날짜: " + endDate);
                              console.log("반복날짜: " + repeatDate);
                              console.log("반복단위: " + calRepeatUnit);
                              console.log("일정단위: " + calType);
                              console.log("all: " + calAll);
                              console.log("calColor: " + calColor);

                              // extendedProps가 존재하고 그 안에 calendarMemo가 있는지 확인
                              // content 입력
                              var calContent = info.event._def.extendedProps["content"];
                              console.log("일정 내용: " + calContent);
                              
                           // 캘린더 번호 값을 숨겨진 입력 필드에 설정
                           // 폼 태그 안쪽에 prepend 해보자. 안되겠다...
                           $("#calForm #calendarNo").remove();
                           $("#calForm").prepend("<input id='calendarNo' type='hidden' name='calNo'  value='"+info.event.extendedProps.calendarNo+"' />");
                              // 입력 요소를 읽기 전용으로 설정
                              $("#calModal #calTitle").prop("readonly", true);
                              $("#calModal #calStartDate").prop("readonly", true);
                              $("#calModal #calEndDate").prop("readonly", true);
                              $("#calModal #calContent").prop("readonly", true);
                              $("#calModal #calRepeatDate").prop("readonly", true);
                              // 버튼 텍스트 변경 및 클래스 추가
                              $("#insertCal")
                                  .text("수정")
                                  .removeClass("btn-primary")
                                  .removeClass("btn-danger")
                                  .addClass("btn-warning");
                           
                              
                              // 삭제 버튼 추가
                              var removeBtn = "<button type='button' id='deleteCal' class='btn btn-danger'>삭제</button>";
                              $("#calForm").append(removeBtn);  // 모달 창 열기
                              $("#calModal #calNo").val(info.event.calendarNo);      // 번호
                              $("#calModal #calTitle").val(info.event.title);         // 제목                     
                              $("#calModal #calStartDate").val(startDate);         //시간날짜
                              $("#calModal #calEndDate").val(endDate);            //끝 날짜
                              $("#calModal #calContent").val(calContent);            //내용
                              $("#calModal #calRepeatUnit").val(calRepeatUnit);      //반복단위
                              $("#calModal #calRepeatDate").val(moment(repeatDate).format('YYYY-MM-DD'));   // 반복일자
                              $("#calModal #calAll").val(calAll);                                       // allDay
                              $("input:radio[name ='calType']:input[value='"+calType+"']").attr("checked", true); // 일정 종류 값 넣기
                              $("#calModal").modal("show");
                              $(".modal-header .modal-title").html("<strong style='color: green;'>일정 확인</strong>");
                              },
                              
                              
                          eventMouseEnter: function (info) {
                             console.log("eventMouseEnter");
                              // 툴팁 내용 생성
                              var tooltipContent = '<span class="tooltip-title">' + info.event.title + '</span><br /><span class="tooltip-Content">' + info.event.extendedProps.content + '</span>';
                              // 부트스트랩 툴팁 적용                                                                                             
                              $(info.el).tooltip({
                                  title: tooltipContent,
                                  html: true,
                                  placement: 'top',
                                  trigger: 'hover focus', // 툴팁을 호버 또는 포커스할 때만 표시
                              }).tooltip('show');
                          },
                          eventMouseLeave: function (info) {
                              // 툴팁 숨기기
                              $(info.el).tooltip('hide');
                          }
               });
               calendar.render();
            
               console.log('calendar 값 ', calendar);
         },
         error : function(XMLHttpRequest, textStatus, errorThrown){ // 비동기 통신이 실패할경우 error 콜백으로 들어옵니다.
             alert("통신 실패.")
         }
     });
     
     
 });
	         
</script>	


