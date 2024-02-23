<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item"><a href="/email/inbox">메일</a></li>
				<li class="breadcrumb-item active" aria-current="page">메일쓰기</li>
			</ol>
		</nav><br/>
		<!-- Breadcrumb 끝--><br/>
	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card">
			<div class="card-body">

				<div class="d-md-flex gap-4">
					<!-- Mail sidebar -->
                    <%@include file="./pagingAndSearch.jsp" %>
					
					<!-- Mail Form -->
					<div class="flex-fill min-w-0">
						<form action="/email/mailSend" method="post" id="mailForm" enctype="multipart/form-data">
							<div class="p-md-4">
								<!-- 보내는 사람 -->
								<div class="row mb-3" id="toEmp" onclick="f_modalOpen()">
									<label for="empToArr" class="col-sm-4 col-xl-2 col-form-label">To</label>
									<div class="col-sm-8">
										<input id="empToArr" name="empToArr" type="text" class="form-control">
									</div>
								</div>
								<!-- 제목 -->								
								<div class="row mb-3">
									<label for="mailTitle" class="col-sm-4 col-xl-2 col-form-label">Subject</label>
									<div class="col-sm-8 col-xl-10">
										<input id="mailTitle" name="mailTitle" type="text" class="form-control">
									</div>
								</div>
								<!-- 파일첨부 -->
								<div class="row mb-3">
									<label for="mailFile" class="col-sm-4 col-xl-2 col-form-label">Attachment</label>
									<div class="col-sm-8 col-xl-10">
										<input type="file" class="form-control" id="mailFile" name="mailFile" multiple="multiple"> 
									</div>
								</div>
							</div>
	
							<!-- 메일내용 -->
							<textarea id="mailContent" name="mailContent"></textarea>
	
							<!-- Action buttons -->
							<div class="mt-4 d-flex flex-wrap justify-content-md-end gap-2">
								<!-- <button type="button" class="btn btn-light">
									<i class="demo-pli-mail-unread fs-5 me-2"></i>(임시저장)
								</button> -->
								<button type="button" class="btn btn-light">
									<i class="demo-pli-cross fs-5 me-2"></i> Cancel
								</button>
								<button type="button" class="btn btn-primary" id="sendBtn">
									<i class=" demo-pli-mail-send fs-5 me-2"></i> Send message
								</button>
								<button type="button" class="btn btn-light" id="testingBtn">
									<i class="demo-pli-data-settings fs-5 me-2"></i> 시연용
								</button>
							</div>
							<!-- END : Action buttons -->
						<sec:csrfInput/>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--모달 : 보내는 사람 선택 화면 -->
<div id="mailModal">
	<div class="card" id="mailModalCont">
		<p class="h3 my-3" id=""><br/>수신자 선택</p><br/>
		<div class="d-flex">
			<%@include file="../org/orgChart.jsp"%>

			<div style="margin: 60px 0px 0px 30px;">

				<form style="width:90%;">

					<div class="row mb-3">
						<div class="col-sm-12">
							<textarea rows="10" cols="30" class="form-control"
								name="mailReceiver" id="mailReceiver" placeholder="선택한 멤버가 여기에 뜸" ></textarea>
						</div>
					</div>
					<div class="d-flex" style="margin: auto; ">
						<div class="row mb-3">
							<div class="col-sm-12">
								<button type="button" id="chooseOK" class="btn btn-outline-warning">선택완료</button>
							</div>&nbsp;&nbsp;
						</div>

						<div class="row mb-3">
							<div class="col-sm-12">
								<button type="button" onclick="f_modalClose()" class="btn btn-outline-danger">Close</button>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<style>
/*채팅방생성 모달 메인창*/
#mailModal {
	position: fixed;
    width: 100%;
    height: 100%; /* fixed인 경우 작동 */
    left: 0px;
    top: 0px;
    background-color: rgb(200, 200, 200, 0.5);
    display: none;  /* 존재하지만 보이지않음 */
    z-index: 1000; /* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
}
/*채팅방 생성 모달 속 내용창*/
#mailModalCont {
	margin: 10% auto;   /* 수평가운데 정렬 */
    width :	800px;
    height : 650px;
    background-color: rgb(255,255,255);
	text-align: center;
	border: 1px solid lightgray;
}

#jstree {
	max-height: 250px !important;
}
</style>
<script>
$(function(){
	CKEDITOR.replace("mailContent",{height: 360});
	var toEmp = $("#toEmp");	// 받는 사람 div

	var chooseOK = $("#chooseOK");	// 선택완료 버튼
	var mailForm = $("#mailForm");	// 메일 폼
	var sendBtn = $("#sendBtn");	// 보내기 버튼
	
	chooseOK.on("click", function(){
		$("#empToArr").val($("#mailReceiver").val());
		$("#mailModal").css("display","none");
	});
	
	sendBtn.on("click", function(){
		console.log("send")
		var empToArr = $("#empToArr").val();
		var mailTitle = $("#mailTitle").val();
		var mailContent = CKEDITOR.instances.mailContent.getData();
		
		if(empToArr == null || empToArr == ""){
			Swal.fire({
	        	icon: 'error',
	        	text: '수신자를 선택해주세요!'
	        });
			return false;
		}
		
		if(mailTitle == null || mailTitle == ""){
			$("#mailTitle").val("[제목 없음]");
		}
		
		if(mailContent == null || mailContent == ""){
			Swal.fire({
	        	icon: 'error',
	        	text: '내용을 입력해주세요!'
	        });
			return false;
		}
		mailForm.submit();
		webSocket.send("새로운 메일이 도착했습니다!,"+empToArr);
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
	
	// 시연
	$("#testingBtn").on("click", function(){
		$("#mailTitle").val("[검토] 외근관련 검토부탁드립니다.");
		CKEDITOR.instances.mailContent.setData("<p>부장님 안녕하세요. 개발부 김영진 과장입니다</p><br/><p>내일 외근을 하는데 혹시 필요한 것들이 있다면 말씀해주시면 제가 준비하도록 하겠습니다.</p><br/><p>감사합니다</p>");
	});
	
});


function f_modalOpen(){
	$("#mailModal").css("display","block");
}

function f_modalClose(){
	$("#mailModal").css("display","none");
}

//조직도 -----------------------------------
//선택된 id만 담을 배열
const swMembers =[];

//nodeId 중복체크 함수
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
 	console.log("오는가?"+loginEmpNo);
     swMembers.push(nodeId);
 } 
 
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

         $("#mailReceiver").val(swMembers.toString());
     },
     error: function(xhr, status, error) {
         console.log('AJAX 오류:', status, error);
     }
 });
 
}

</script>