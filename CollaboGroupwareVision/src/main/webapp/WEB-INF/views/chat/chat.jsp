<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<div class="content__header content__boxed mb-3 overlapping">
	<div class="content__wrap">
		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item"><a href="/chat">Chat</a></li>
				<!-- <li class="breadcrumb-item active" aria-current="page">Contact Us</li> -->
			</ol>
		</nav>
	</div>
</div>

<div class="content__boxed single-content-md">
	<div class="content__wrap">
		<div class="card h-100">
			<div class="card-body h-100">
				<div class="d-md-flex h-100 gap-4">
					<!-- Chat sidebar -->
					<div
						class="w-md-250px flex-shrink-0 d-flex flex-column mb-3 mb-md-0">

						<!-- 전체 채팅방 -->
						<div
							class="list-group list-group-borderless flex-fill min-h-0 mt-3 overflow-scroll scrollable-content"
							id="chatRoom">

							<c:choose>
								<c:when test="${empty chatRoomList }">
									<p>생성된 채팅방이 없습니다</p>
								</c:when>
								<c:otherwise>
									<c:forEach items="${chatRoomList }" var="chatRoom">
										<!-- 하나의 채팅방, 클릭시 active 클래스 추가 -->
										<figure
											class="list-group-item list-group-item-action d-flex align-items-start mb-1 py-3 <c:if test='${activeChatroom eq chatRoom.chatroomNo }'>active</c:if>">
											<div class="flex-shrink-0 me-3">
												<c:set var="ran">${chatRoom.chatroomNo%8+1 }</c:set>
												<img class="img-xs rounded-circle"
													src="${pageContext.request.contextPath }/resources/assets/img/profile-photos/${ran }.png"
													alt="Profile Picture" loading="lazy">
											</div>
											<div class="flex-fill overflow-hidden">
												<div class="d-flex justify-content-between">
													<!-- 채팅방 입장 a태그 -->
													<a
														href="/chat/entryChatRoom?chatroomNo=${chatRoom.chatroomNo }"
														class="h6 d-block mb-1 stretched-link text-nowrap text-truncate text-decoration-none pe-2">${chatRoom.chatroomName}</a>
													<small class="text-muted text-nowrap"></small>
												</div>
												<!-- 마지막 채팅 내용 -->
												<div class="d-flex justify-content-between">
													<small class="fw-bold text-truncate pe-2"></small> <span
														class="badge bg-success rounded-circle"></span>
												</div>
											</div>
										</figure>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</div>
						<!-- 그룹채팅방 생성하기 버튼 -->
						<button type="button" class="btn btn-icon btn-secondary"
							title="그룹채팅방 생성하기" id="newChatRoom">
							<i class="demo-psi-speech-bubble-3 fs-5"></i>
						</button>
					</div>
					<div class="d-flex flex-column flex-fill"
						style="min-width: 1000px;">

						<!-- 채팅방 헤더 -->
						<div class="d-flex">
						
							<!-- 멤버 수 -->
							<div class="flex-shrink-0 me-3">
								<i class="demo-pli-add-user-star text-muted fs-2" id="chatMemCount">${chatroomMemCount }</i>
							</div>
							
							<figure class="d-flex align-items-center position-relative">
								<div class="flex-fill overflow-hidden">
									<a href="#"
										class="h6 d-block mb-1 stretched-link text-nowrap text-truncate text-decoration-none pe-2"></a>
								</div>
							</figure>

							<div class="d-flex gap-2 ms-auto">
								<button type="button"
									class="btn btn-icon btn-sm btn-hover btn-light"
									data-bs-toggle="button" data-view="fullcontent"
									data-view-target=".card" aria-pressed="false"
									autocomplete="off">
									<i class="icon-active demo-psi-minimize-3"></i> <i
										class="icon-inactive demo-psi-maximize-3"></i>
								</button>

								<!-- 채팅 토글 다운 -->
								<div class="dropdown">
									<button class="btn btn-icon btn-sm btn-hover btn-light"
										data-bs-toggle="dropdown" aria-expanded="false">
										<i class="demo-pli-dot-horizontal fs-5"></i> <span
											class="visually-hidden">Toggle Dropdown</span>
									</button>
									<ul class="dropdown-menu dropdown-menu-end">
										<li><a href="#" class="dropdown-item" id="chatroomInfo"> <i
												class="demo-pli-information fs-5 me-2"></i>채팅방정보
										</a></li>
										<li>
											<!-- 채팅방 삭제 폼 -->
											<form action="/chat/exitChatRoom" method="post"
												id="exitChatRoomForm">
												<input type="hidden" name="chatroomNo" id="chatroomNo"
													value="${chatroomNo }">
												<sec:csrfInput />
											</form> <a href="#" class="dropdown-item text-danger"
											id="exitChatRoom"> <i
												class="demo-pli-recycling fs-5 me-2"></i> 채팅방나가기
										</a>
										</li>
									</ul>
								</div>
							</div>

						</div>
						<!-- END : Chat header -->

						<!-- 채팅내용 -->
						<div
							class="bg-gray-600 d-flex flex-column-reverse flex-fill min-h-0 overflow-auto scrollable-content p-4 rounded-3">
							<div class="justify-content-end" id="chat">
								<!-- 채팅 삭제 폼 -->
								<form action="/chat/deleteChat" method="post"
									class="delChatForm">
									<input type="hidden" name="chatNo" id="chatNo" value="">
									<input type="hidden" name="chatroomNo" class="chatroomNo"
										value="${chatroomNo }">
									<sec:csrfInput />
								</form>
								<!-- 본격 채팅 내용 -->
								<c:forEach items="${chatMessageList }" var="chatMessage">
									<c:choose>
										<c:when test="${chatMessage.empNo eq loginEmpNo}">
											<!-- Primary bubble speech -->
											<div class="d-flex justify-content-end mb-2 chatClick">
												<div class="bubble bubble-primary"
													data-chat-no="${chatMessage.chatNo }"
													data-emp-no="${chatMessage.empNo }">
													<c:forEach var="chatAttach"
														items="${chatMessage.chatAttachList}">
														<c:set value="${chatAttach.chatFileName}"
															var="chatFileName" />
														<c:if test="${not empty chatFileName }">
															<img class="img-fluid rounded my-2"
																src="/chatfile/${chatFileName }" width="200px"
																display="block">
															<br />
															<a href="/chatfile/${chatFileName }">${chatFileName }</a>
															<br />
														</c:if>
													</c:forEach>
													<p class="mb-1">${chatMessage.chatContent }</p>
													<small class="text-muted">${chatMessage.chatDate }</small>
												</div>
											</div>
											<!-- END : Primary bubble speech -->
										</c:when>
										<c:otherwise>
											<!-- Bubble speech -->
											<div class="d-flex mb-2 chatClick">
												<div class="bubble" data-chat-no="${chatMessage.chatNo }"
													data-emp-no="${chatMessage.empNo }">
													<c:forEach var="chatAttach"
														items="${chatMessage.chatAttachList}">
														<c:set value="${chatAttach.chatFileName}"
															var="chatFileName" />
														<c:if test="${not empty chatFileName }">
															<img class="img-fluid rounded my-2"
																src="/chatfile/${chatFileName }" width="200px"
																display="block">
															<br />
															<a href="/chatfile/${chatFileName }">${chatFileName }</a>
															<br />
														</c:if>
													</c:forEach>
													<p class="mb-1">${chatMessage.employee.empName }<br />${chatMessage.chatContent }</p>
													<small class="text-muted">${chatMessage.chatDate }</small>
												</div>
											</div>
											<!-- END : Bubble speech -->
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</div>
						</div>

						<!-- 채팅 입력창 -->
						<form class="d-flex align-items-center gap-1 pt-3" id="chatForm">
							<textarea class="form-control" id="chatContent"
								placeholder="Type a message" rows="1" style="resize: none"></textarea>
							<!-- 파일 버튼 -->
							<button type="button" id="chatFileBtn"
								class="btn btn-icon bg-transparent">
								<i class="demo-pli-paperclip fs-5"></i>
							</button>
							<!-- 이모티콘 버튼 -->
							<button type="button" class="btn btn-icon bg-transparent">
								<i class="demo-pli-smile fs-5"></i>
							</button>
							<!-- 보내기 버튼 -->
							<button type="submit" id="sendBtn"
								class="btn btn-icon btn-primary">
								<i class="demo-pli-paper-plane fs-5"></i>
							</button>
							<sec:csrfInput />
						</form>

					</div>
				</div>

			</div>
		</div>
	</div>
</div>
<!--모달 : 그룹채팅방 생성하기 화면 -->
<div id="newChatroomModal">
	<div class="card" id="newChatroomCont">
		<div class="d-flex">
			<%@ include file="../org/orgChart.jsp" %>
			
			<div style="margin: 60px 10px 10px 30px; width:90%;">
				<form action="/chat/newChatRoom" method="post"
					id="insertChatRoomForm">
					<input type="hidden" name="chatroomNo" value="${chatroomNo }">

					<div class="row mb-3">
						<label for="chatroomName" class="col-sm-5 col-form-label">채팅방
							이름</label>
						<div class="col-sm-7">
							<input type="text" class="form-control" name="chatroomName"
								id="chatroomName" value="">
						</div>
					</div>

					<div class="row mb-3">
						<div class="col-sm-12">
							<textarea rows="10" cols="30" class="form-control"
								name="chatMember" id="chatMember" placeholder="선택한 멤버가 여기에 뜸" ></textarea>
						</div>
					</div>
					<sec:csrfInput />
				</form>
			</div>
		</div>
		<div class="d-flex" style="margin: auto; ">
			<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">	
				<button type="button" id="insertChatRoom"
					class="btn btn-lg btn-outline-warning">생성하기</button>
			</div>

			<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">	
				<button type="button" onclick="f_modalClose()"
					class="btn btn-lg btn-outline-danger">Close</button>
			</div>
		</div>
			
	</div>
</div>
<!--모달 : 채팅에서 파일 보내기 화면 -->
<div id="chatFileModal">
	<div class="col-md-5 mb-3" id="chatFileCont">
		<div class="card h-100">
			<div class="card-body">
				<h2 class="card-title">파일보내기</h2>
				<br />
				<br />
				<form id="insertChatFileForm">
					<div class="row mb-3">
						<div class="col-sm-12">
							<input type="file" class="form-control" name="chatFile"
								id="chatFile" value="" multiple>
						</div>
					</div>
					<div class="row mb-3">
						<div class="col-sm-12">
							<button type="button" id="insertChatFile"
								class="btn btn-outline-warning">파일보내기</button>
						</div>
					</div>
					<div class="row mb-3">
						<div class="col-sm-12">
							<button type="button" onclick="f_modalClose2()"
								class="btn btn-outline-danger">Close</button>
						</div>
					</div>
					<sec:csrfInput />
				</form>
			</div>
		</div>
	</div>
</div>

<!--모달 : 채팅방 정보 화면 -->
<div id="chatInfoModal">
	<div class="col-md-5 mb-3" id="chatInfoCont">
		<div class="card h-100">
			<div class="card-body">
				<h2 class="card-title">채팅방정보</h2>
				<br />
				<br />
				<form>
					<div class="row mb-3">
						<label for="chatroomName" class="col-sm-4 col-form-label">채팅방
							이름</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="chatroomName"
								id="chatroomName2" value="" disabled>
						</div>
					</div>

					<div class="row mb-3">
						<div class="col-sm-12" id="chatMember2">
							<!-- 여기에 프로필과 사원이름 추가  -->
						</div>
					</div>

					<div class="row mb-3">
						<div class="col-sm-12">
							<button type="button" onclick="f_modalClose3()"
								class="btn btn-outline-danger">Close</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

<!-- 스타일 -->
<style>
#newChatroomModal{
	position: fixed;
    width: 100%;
    height: 100%; /* fixed인 경우 작동 */
    left: 0px;
    top: 0px;
    background-color: rgb(200, 200, 200, 0.5);
    display: none; 
    z-index: 1000; /* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
}

#newChatroomCont{
    margin: 10% auto;   /* 수평가운데 정렬 */
	width : 700px;
	height : 500px;
	background-color: rgb(255,255,255);
	
}
h3{
	text-align: center;
}
/*채팅파일보내기 모달 메인창*/
#chatFileModal {
	position: fixed;
	width: 100%;
	height: 100%; /*fixed인 경우 먹음*/
	left: 0px;
	top: 0px;
	background-color: rgba(204, 204, 204, 0.5);
	display: none;
	z-index: 1000;
}
/*채팅파일보내기 모달 속 내용창*/
#chatFileCont {
	width: 500px;
	margin: 10% auto; /* 수평가운데 정렬 */
	padding: 50px;
	border-radius: 30px;
	background-color: white;
	text-align: center;
	border: 1px solid lightgray;
}
/*채팅방정보 모달 메인창*/
#chatInfoModal {
	position: fixed;
	width: 100%;
	height: 100%; /*fixed인 경우 먹음*/
	left: 0px;
	top: 0px;
	background-color: rgba(204, 204, 204, 0.5);
	display: none;
	z-index: 1000;
}
#chatInfoCont {
	width: 500px;
	margin: 10% auto; /* 수평가운데 정렬 */
	padding: 50px;
	border-radius: 30px;
	background-color: white;
	text-align: center;
	border: 1px solid lightgray;
	overflow:auto;
	max-height : 700px;
}
/*채팅 bubble 최대 크기 정하기*/
.bubble {
	max-width: 80%; /* 최대 너비를 설정 (예시로 80%로 설정) */
}

#jstree {
	max-height: 250px !important;
}

#divtree{
	min-width: 350px !important; 
}
</style>

<!-- 스크립트 -->
<script
	src="${pageContext.request.contextPath }/resources/assets/js/demo-purpose-only.js"
	defer></script>
<script type="text/javascript">
$(function(){
	// 채팅방 CRUD
	var newChatRoom = $("#newChatRoom");		// 그룹채팅방 생성하기 버튼
	var insertChatRoomForm = $("#insertChatRoomForm");	// 채팅방 생성하기 폼
	var insertChatRoom = $("#insertChatRoom");	// 채팅방 생성하기 모달창 안에 생성하기 버튼
	var chatModalName = $("#chatModalName");	// 채팅방 모달 이름
	var exitChatRoom = $("#exitChatRoom");		// 채팅방 나가기 버튼
	var exitChatRoomForm = $("#exitChatRoomForm");	// 채팅방 나가기 폼
	var chatroomInfo = $("#chatroomInfo");		// 채팅방정보버튼		

	const newChatroomModal = document.querySelector("#newChatroomModal");
	
	// 채팅방 생성하기 누르면 모달창이 뜸
	newChatRoom.on("click", function(){
		console.log("그룹채팅방 생성하기 버튼");
		newChatroomModal.style.display="block";  // 보이게!
	});
	
	// 채팅방정보버튼 눌렀을 때 이벤트
	chatroomInfo.on("click", function(){
		console.log("채팅방정보 버튼");
		console.log("chatroomNo:",chatroomNo);
		$.ajax({
			url:"/chat/selectChatRoom?chatroomNo="+chatroomNo,
			type:"get",
			dataType : "json",
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success:function(rslt){
				$("#chatroomName2").val(rslt[0].chatroomName);
				
				var html = "<table class='table table-bordered'>";
				html += "<tr><th colspan='2'>채팅방 멤버</th></tr>";
				html += "<tr><th>프로필</th><th>이름</th></tr>";
				$.each(rslt, function(i,v){
					$.each(v.chatMemList, function(a,b){
						if(b.employee.profileImgPath == null || b.employee.profileImgPath == ""){
							html += "<tr><td width='40%'><img class='me-3' width='50' src='${pageContext.request.contextPath }/resources/img/chat/기본사진.jpg' alt='Profile Picture' style='object-fit:contain; border-radius:50%;'/></td>";
						}else{
							html += "<tr><td width='40%'><img class='me-3' width='50' src='"+b.employee.profileImgPath+"' alt='Profile Picture' style='object-fit:contain; border-radius:50%;'/></td>";
						}
						html += "<td width='60%' style='vertical-align:middle;'>"+b.employee.empName+"</td></tr>";
					});
				});
				html += "</table>";
				$("#chatMember2").html(html);
			}
		});
		$("#chatInfoModal").css("display","block");
	});
	
	// 팅방 생성하기 모달창 안에 생성하기 버튼 클릭이벤트
	insertChatRoom.on("click", function(){
		var chatroomName = $("#chatroomName").val();	// 채팅방 이름
		var chatMember = $("#chatMember").val();		// 멤버리스트
		
		console.log(chatroomName);
		console.log(chatMember);
		
		
		if(chatroomName == null || chatroomName == "") {
			Swal.fire({
	        	icon: 'error',
	        	text: '채팅방 이름을 입력해주세요!'
	        });
			return false;
		}
		
		if(chatMember == null || chatMember == "") {
			Swal.fire({
	        	icon: 'error',
	        	text: '멤버를 선택해주세요!!'
	        });
			return false;
		}
		
		insertChatRoomForm.submit();
		
		// 초기화하기
		chatroomName.val("");
		chatMember.val("");
	});
	
	// 채팅방 나가기 이벤트
	exitChatRoom.on("click", function(){
		if(confirm("정말 나가시겠습니까?")){
			exitChatRoomForm.submit();
		}
	});
	
	//-----------------------------------------------------------
	// 채팅 CRUD
	//var sender = "${sender}";	// 보낸 사람
	var chatroomNo = $("#chatroomNo").val();	// 방번호
	console.log("웹소켓 테스트 방번호:",chatroomNo);
	var chatFileBtn = $("#chatFileBtn"); 	// 채팅 파일 보내기 버튼
	var chatFileModal = $("#chatFileModal");	// 채팅파일모달창
	var loginEmpNo = "${loginEmpNo}";
	console.log("loginEmpNo:",loginEmpNo);
	
	// 채팅 시간 재기
	var dateString = ""; 
	var newDate = new Date(); 
	dateString += newDate.getFullYear() + "-"; 
	dateString += ("0" + (newDate.getMonth() + 1)).slice(-2) + "-"; //월은 0부터 시작하므로 +1을 해줘야 한다.             dateString += ("0" + newDate.getDate()).slice(-2) + " ";             dateString += ("0" + newDate.getHours()).slice(-2) + ":";             dateString += ("0" + newDate.getMinutes()).slice(-2) + ":";             dateString += ("0" + newDate.getSeconds()).slice(-2);            //document.write(dateString); 문서에 바로 그릴 수 있다. 
	dateString += ("0" + newDate.getDate()).slice(-2) + " ";
	dateString += ("0" + newDate.getHours()).slice(-2) + ":";
	dateString += ("0" + newDate.getMinutes()).slice(-2);

	
	//  보내기 버튼 눌렀을 때 이벤트
	$("#chatForm").submit(function(event){
		event.preventDefault();
		
		var chatContent = $("#chatContent").val();
		
		if(chatContent == null || chatContent == "" ){
			return;
		}
		
		var data = {
			chatContent : chatContent,
		}
		// 메세지 보내기
		sock.send(JSON.stringify(data));
		
		// 메세지 칸 초기화
		$("#chatContent").val('').focus();
		
	});
	
	// 소켓 불러오기
	var host = location.href.split("/")[2];
	var sock = new WebSocket("ws://"+host+"/echo");
	//var sock = new WebSocket("ws://192.168.36.94/echo");
	
	// 입장했을 때 이벤트
	sock.onopen = function(e){
		//$("#chat").append(sender + "님이 입장하였습니다<br/>");
	}
	
	// 메세지 받았을 때 이벤트
	sock.onmessage = function(e){
		var data = e.data; // 전달 받은 데이터
		msgData = JSON.parse(data);

		var html = "";
		if(msgData.chatFiles != null && msgData.empNo == loginEmpNo.trim()){
			html += "<div class='d-flex justify-content-end mb-2 chatClick'>";
			html += "	<div class='bubble bubble-primary' data-chat-no='"+msgData.chatNo+"' data-emp-no='"+msgData.empNo+"'>";
			for(i=0; i<msgData.chatFiles.split(",").length; i++){
				html += "<img class='img-fluid rounded my-2' src='"+msgData.chatFiles.split(",")[i]+"' width='200px' display='block'><br/>"
				html += "<a href='"+msgData.chatFiles.split(",")[i]+"'>"+msgData.chatFiles.split(",")[i].split("/")[2]+"</a><br/>"
			}
			html += "		<small class='text-muted' id='date'>"+dateString+"</small>";
			html += "	</div>";
			html += "</div>";
		}else if(msgData.chatFiles != null && msgData.empNo != loginEmpNo.trim()){
			html += "<div class='d-flex mb-2 chatClick'>"                                                         
			html += "	<div class='bubble' data-chat-no='"+msgData.chatNo+"' data-emp-no='"+msgData.empNo+"'>"                                                                    
			html += "		<p class='mb-1'>"+msgData.employee.empName+"<br/>"+"</p>"
			for(i=0; i<msgData.chatFiles.split(",").length; i++){
				html += "<img class='img-fluid rounded my-2' src='"+msgData.chatFiles.split(",")[i]+"'  width='200px' display='block'><br/>"
				html += "<a href='"+msgData.chatFiles.split(",")[i]+"'>"+msgData.chatFiles.split(",")[i].split("/")[2]+"</a><br/>"
			}
			html += "		<small class='text-muted'>"+dateString+"</small> "                         
			html += "	</div>"                                                                                  
			html += "</div>" 
		}else if(msgData.chatFiles == null && msgData.empNo == loginEmpNo.trim()){
			html += "<div class='d-flex justify-content-end mb-2 chatClick'>";
			html += "	<div class='bubble bubble-primary' data-chat-no='"+msgData.chatNo+"' data-emp-no='"+msgData.empNo+"'>";
			html += "		<p class='mb-1'>"+msgData.chatContent+"</p>";
			html += "		<small class='text-muted' id='date'>"+dateString+"</small>";
			html += "	</div>";
			html += "</div>";
		}else{
			html += "<div class='d-flex mb-2 chatClick'>"                                                         
			html += "	<div class='bubble' data-chat-no='"+msgData.chatNo+"' data-emp-no='"+msgData.empNo+"'>"                                                                    
			html += "		<p class='mb-1'>"+msgData.employee.empName+"<br/>"+msgData.chatContent+"</p>"
			html += "		<small class='text-muted'>"+dateString+"</small> "                         
			html += "	</div>"                                                                                  
			html += "</div>"                                                                                      
		}
		$("#chat").append(html);
		webSocket.send("새로운 채팅이 도착했습니다.");
	}
	
	// 채팅 종료됐을 때 이벤트
	sock.onclose = function(){
		//$("#chat").append("연결 종료");
	}
	
	// 채팅파일 선택 모달창
	chatFileBtn.on("click", function(){
		chatFileModal.css("display","block");  // 보이게!
	});
	
	
	// 채팅 파일 보내기 클릭이벤트
	var insertChatFileForm = $("#insertChatFileForm");	// 채팅파일폼
	var insertChatFile = $("#insertChatFile");	// 채팅파일 보내기 버튼
	var chatContent = $("#chatContent");		// 채팅입력창
	
	insertChatFile.on("click", function(){
		
		if($("#chatFile").val() == null || $("#chatFile").val() == ""){
			Swal.fire({
	        	icon: 'error',
	        	text: '파일을 선택해주세요!'
	        });
			return false;
		}
		
		// 아작스로 파일 보낼 때는 FormData가 필요!
		let formData = new FormData();	// 전송방식이 무조건 multipart/form-data
		for(i=0; i<$("#chatFile")[0].files.length; i++){
			formData.append("chatFile", $("#chatFile")[0].files[i]);
		}
		formData.append("chatroomNo",chatroomNo);
		formData.append("empNo",loginEmpNo);
		
		// jQuery는 default로 contentType을 application/x-www-form-urlencoded 로 지정
		// default 값을 process(후처리)
		$.ajax({
			type:"post",
			url:"/chat/insertChatFile",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			contentType:false,	// 파일 전송시 필수
			processData:false,	// 파일 전송시 필수
			cache:false,		// 요건 옵션, 전송 캐쉬하지망
			data:formData,		
			dataType:"text",
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success:function(rslt){
				console.log("체킁:",rslt);
				rslt.split(",")
				var html = "";
				var data = {
					chatFiles : rslt	
				}
				sock.send(JSON.stringify(data)); 
				f_modalClose2();
				$("#chatFile").val("");
				webSocket.send("새로운 채팅이 도착했습니다.");
			}
		})
	});
	// 삭제----------------------------------------------------------
	var chat = $("#chat");				// 채팅 틀 
	var chatClick = $(".chatClick");	// 채팅 클릭
	
	// 마우스를 올렸을 때 삭제버튼이 추가됨
	chat.on("mouseenter", ".chatClick", function(){
		console.log("chatClick 클릭");
		var empNo = $(this).find(".bubble").data("emp-no");
		if(loginEmpNo == empNo){
			$(this).find(".bubble").append("<div class='chat_upd_del chatDeleteBtn'><a class='badge rounded-pill bg-light text-dark'>삭제</a></div>");
		}
	});
	
	// 요소에서 나갔을 때 삭제버튼이 삭제됨
	chat.on("mouseleave", ".chatClick", function(){
		$(this).find(".chat_upd_del").remove();
	});
	
	// 삭제버튼을 누르면 해당 채팅이 삭제 됨
	chat.on("click",".chatDeleteBtn",function(){
		console.log("chat 삭제버튼");
		var empNo = $(this).parents(".bubble").data("emp-no");
		if(loginEmpNo == empNo){
			if(confirm("해당 채팅을 삭제하시겠습니까?")){
				//console.log("ok");
				var chatNo = $(this).parents(".bubble").data("chat-no");
				chat.find(".delChatForm").find("#chatNo").val(chatNo);
				chat.find(".delChatForm").submit();
			}
		}
	});
	
	// 조직도----------------------------------------
	jsTreeObj.on('select_node.jstree', function(event, data) {
		// 노드 선택 이벤트
		//console.log("Selected Node:", data.node);
		
		// 부서 노드를 클릭한 경우 하위 노드 토글
		if(data.node.type === 'dept') {
			jsTreeObj.jstree(true).toggle_node(data.node);
		} else {	// 사원 노드를 클릭한 경우 상세 정보 가져오기
			showEmpDetails(data.node.id);
		}
		
	});
	
});
//-----------------------------------------------------------
function f_modalClose(){
	$("#newChatroomModal").css("display","none");
}
function f_modalClose2(){
	$("#chatFileModal").css("display","none");  // 감춰!
}
function f_modalClose3(){
	$("#chatInfoModal").css("display","none");  // 감춰!
	$("#chatroomName2").val("");
	$("#chatMember2").val("");
}
// 조직도 -----------------------------------
// 선택된 id만 담을 배열
const swMembers =[];

// nodeId 중복체크 함수
function isRepeat(nodeId){
    for(let swNodeId of swMembers){
        if(swNodeId == nodeId){
            return true;
        }
    }
    return false;
}
function showEmpDetails(nodeId) {
	var loginEmpNo = "${loginEmpNo}";
    // 넣을지 안 넣을찌 중복 체킁!

    if(!isRepeat(nodeId) && !(nodeId == loginEmpNo)){
        swMembers.push(nodeId);
    }
    
    //var node = jsTreeObj.jstree(true).get_node(nodeId);
    console.log("선택한 노드 사번:", nodeId);
    
    var empNo = $("#empNo");		// 사번
    var deptCode = $("#deptCode");
    var deptName = $("#deptName");	// 부서명
    var empName = $("#empName");	// 사원명
    var empTel = $("#empTel");		// 연락처
    var extNo = $("#extNo");		// 내선번호
    var empEmail = $("#empEmail");	// 사내이메일
    var empPsnEmail = $("#empPsnEmail");
    var empBirth = $("#empBirth");
    var empZip = $("#empZip");
    var empAddr1 = $("#empAddr1");
    var empAddr2 = $("#empAddr2");
    
    var accountNo = $("#accountNo");
    var joinDay = $("#joinDay");
    var leaveDay = $("#leaveDay");
    var yrycCount = $("#yrycCount");
    
    var gender = $("#gender");
    var gen = $("#gen");
    var positionCode = $("#positionCode");
    var position = $("#position");	// 직위명
    var dutyCode = $("#dutyCode");
    var duty = $("#duty");			// 직책
    var bankCode = $("#bankCode");
    var bank = $("#bank");
    var hffcStatus = $("#hffcStatus");
    var hffc = $("#hffc");
    var enabled = $("#enabled");
    var adminYn = $("#adminYn");
    
    
    // 해당 직원의 상세 정보를 가져오는 AJAX 요청
    $.ajax({
        type: 'get',
        url: '/org/getOrgDetails',
        data: { empNo: nodeId },
        dataType: 'json',
        success: function(empDetails) {
            // 가져온 상세 정보를 각각 뿌려주기
            empName.html(empDetails.empName);	// 사원명
            empNo.html(empDetails.empNo);		// 사번

            $("#chatMember").val(swMembers.toString());
        },
        error: function(xhr, status, error) {
            console.log('AJAX 오류:', status, error);
        }
    });
    
}

// 자식 popup이 open 되었을때, popup의 이름이 있는지 없는지를 판단해 header를 처리한다.
// 부모 popup과 자식 popup을 name으로 구분하여 처리함
setTimeout(() => {
	check();
}, 30);
</script>
