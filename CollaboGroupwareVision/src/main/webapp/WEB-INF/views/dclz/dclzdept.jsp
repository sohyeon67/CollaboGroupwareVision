<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- QR 인식 스크립트  -->
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/dclz/jsQR.js"></script>

<!-- QR 생성 스크립트 -->
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/dclz/qrcode.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/js/dclz/qrcode.min.js"></script>




<style type="text/css">
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
</style>



<!-- 풀캘린더 스크립트 -->
<script
	src="${pageContext.request.contextPath }/resources/js/dclz/fullcalendar-dclzdept.js"
	defer></script>
<script
	src="${pageContext.request.contextPath }/resources/assets/vendors/fullcalendar/main.min.js"
	defer></script>

<!-- 날짜 및 시간(실시간) 스크립트 -->
<script type="text/javascript">
/* 전역변수 */
var currentTime = getCurrentTime();
/* 실행되는 함수 구간 */
$(function () {
	addDeptServer(); //부서근황 출력
	selectStatus(); //당월 근태현황 호출
	//addCalendarEventServer(); //서버에 저장된 캘린더 일정 가져오기
	updateDateTime(); // 초기 호출
    setInterval(updateDateTime, 1000);
    
	var dclzNo = "${dclzTime.dclzNo}";
	var empNo = "${dclzTime.empNo}";
	var lvwkDate = "${dclzTime.lvwkDate}";
	var gowkDate = "${dclzTime.gowkDate}";
	
	console.log("dclzNo:",dclzNo);
	console.log("empNo:",empNo);
	console.log("lvwkDate:",lvwkDate);
	console.log("gowkDate:",gowkDate);

	startBtnStatus();
    
	// 퇴근시간 스크립트
    $("#leaveBtn").on("click", function() {
    	currentTime = getCurrentTime();
        if (gowkDate == null || gowkDate.trim() == "") {
        	alertWarning();
            return;
        }else{
            $('#leaveWorkTime').text(currentTime);
            console.log("퇴근버튼 클릭");
            
            $.ajax({
                url: '/dclz/dclzhomeleave',
                type: 'post',
                data: {dclzNo: dclzNo},
                dataType: 'json',
                beforeSend:function(xhr){
                    xhr.setRequestHeader(header,token);
                },
                success:function(data){
                    console.log(data);
                    addCalendarEventServer();
                },
	            error : function (jqXHR, textStatus, errorThrown){
   	         		console.log("jqXHR:",jqXHR);  //응답 메시지
   	         		console.log("textStatus:",textStatus); //"error"로 고정인듯함
   	         		console.log("errorThrown:",errorThrown);
     	        }
              
            }); //ajax 끝
        }
    });

    // 출근시간 스크립트 (QR사용) 
    $("#startBtn").on("click", function() {
    	console.log("출근 버튼 클릭됨");
    	$('#QRModal').modal('show');
    	console.log("모달창 열림");
    	$('#QRModal').on('shown.bs.modal',function(){
    	console.log("jsqr 활성화");
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
	                          outputData.innerHTML = code.data;
	                          alertSuccess();
	                          
	                          // 출근시간 설정
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
	         	                		console.log(" 출근 입력 성공!");

	         	                		setTimeout(() => {
		         	                		addCalendarEventServer();
										}, 300);

	
	         	                    },
	             	             	error : function (jqXHR, textStatus, errorThrown){
	             	         		console.log("jqXHR:",jqXHR);  //응답 메시지
	             	         		console.log("textStatus:",textStatus); //"error"로 고정인듯함
	             	         		console.log("errorThrown:",errorThrown);
	             	         		}
	          	              
	          	            }); //ajax 끝
	
	                          // return을 써서 함수를 빠져나가면 QR코드 프로그램이 종료된다.        	                                   
	                          return;
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



//캘린더에 일정 추가(서버에서 가져온 값 띄우기)
function addDeptServer() {

    $.ajax({
        url: "/dclz/selectDclzDept",
        type: "post",
        beforeSend: function (xhr) {
            xhr.setRequestHeader(header, token);
        },
        success: function (res) {
            const calendar = new FullCalendar.Calendar(document.getElementById("_dm-calendar"), {
                initialView: "listWeek",
                eventColor: 'gray', // event-dot 때문에 추가
                headerToolbar: {
                    left: "prev,next today",
                    center: "title",
                    right: "listWeek"
                },
                themeSystem: "bootstrap",
                bootstrapFontAwesome: {
                    close: " demo-psi-cross",
                    prev: " demo-psi-arrow-left",
                    next: " demo-psi-arrow-right",
                    prevYear: " demo-psi-arrow-left-2",
                    nextYear: " demo-psi-arrow-right-2"
                },
                events: res,

            });
            calendar.render();
        }
    });
}




//당월 근태 현황 가져오기
function selectStatus(){
	$.ajax({
        type: "POST",
        url: "/dclz/dclzStatusCount",
        dataType:"json",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (data) {
            // 성공 시 처리
            console.log("selectStatus() 실행", data); // 데이터 확인 (콘솔에 출력)
            
           	// 출력 형식 지정
            function formatCount(count) {
                return count < 10 ? "0" + count : count;
            }
            
         	// 출근과 퇴근을 합산하여 저장할 변수
            var workCount = 0;
            
            $.each(data, function (title, count) {
            	if(title == "출근" || title == "퇴근"){
            		// 출근 또는 퇴근인 경우 workCount에 누적
                    workCount += count;
            	}else if(title == "지각"){
	                $("#lateStatus").text(formatCount(count));            		            		
            	}else if(title == "출장"){
	                $("#tripStatus").text(formatCount(count));            		            		
            	}else if(title == "연차"){
	                $("#annualStatus").text(formatCount(count));            		            		
            	}else if(title == "반차"){
	                $("#halfStatus").text(formatCount(count));            		            		
            	}else if(title == "병가"){
	                $("#sickAndAbsentStatus").text(formatCount(count));            		            		
            	}
                $("#workStatus").text(formatCount(workCount));           		

            });
            
        },
        error: function (error) {
            console.error("Ajax 요청 실패 : ", error);
        }
    });
}


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




<!-- jsQR 모달창 -->
<div class="modal fade" id="QRModal">
	<div class="modal-dialog modal-dialog-centered modal-md">
		<div class="modal-content">

			<!-- modal-header 삭제 -->

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
			<!-- modal-footer 삭제 -->
		</div>
	</div>
</div>



<!-- jsQR 모달창 끝 -->







<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item"><a href="/dclz/dclzhome">근태</a></li>
				<li class="breadcrumb-item active" aria-current="page">부서근무현황</li>
			</ol>
		</nav>
		<!-- Breadcrumb 끝-->

		<!-- Page title and information -->

		<br />
		<!-- END : Page title and information -->

	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card d-felx justify-content-center">
			<div class="card-body ">
				<div class="d-md-flex" style="height: 740px;">


					<!-- Full calendar container -->
					<div class="flex-fill d-flex justify-content-center">
						<jsp:include page="left.jsp" />
						<div id="_dm-calendar" style="width: 55%;"></div>
					</div>
					<!-- 좌측공간 끝 -->


				</div>
				<!-- END : Full calendar container -->

			</div>


		</div>
		<!-- card-body 끝 -->
	</div>

</div>
<!-- content__boxed 끝 -->



<!-- footer 영역 -->
<!-- header 영역 -->
<!-- mainNavigator 영역 -->
<!-- setting 영역 -->