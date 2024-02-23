

/* 전역변수 */
var currentTime = getCurrentTime();
/* 실행되는 함수 구간 */
$(function () {
	selectStatus(); //당월 근태현황 호출
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
