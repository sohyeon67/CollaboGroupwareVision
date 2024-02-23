<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!-- 좌측 상단 -->
<div class="content__header content__boxed overlapping">
   <div class="content__wrap">
      <nav aria-label="breadcrumb">
         <ol class="breadcrumb mb-0">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="#">예약</a></li>
            <li class="breadcrumb-item"><a href="/mer">회의실예약</a></li>
            <li class="breadcrumb-item active" aria-current="page">예약상세보기</li>
         </ol>
      </nav>
      <br/>
   </div>
</div>

<div class="content__boxed">
   <div class="content__wrap">
      <div class="card d-felx justify-content-center">
         <div class="card-body ">
			<div class="row mb-5">
				<div class="d-md-flex">
					<div class="me-auto">
						<button type="button" class="btn btn-success btn-lg rounded-pill" onclick="f_modalOpen()">회의실등록</button><br/><br/>
					</div>
					<div class="align-self-center">
					</div>
				</div><hr/>
			  <c:forEach items="${merList }" var="mer">
	             <div class="col-md-3 mb-3">
				 
	                 <div class="card border-2 border-primary parent">
	                     <h5 class="card-header hMerName">${mer.merName }</h5>
	                     <div class="card-body">
	                     	<p class="pMerNo">회의실 번호 : ${mer.merNo }</p>
	                         <p class="pEnabled">사용 가능 여부 : ${mer.enabled }</p>
	                         <a href="#" class="link-warning merUpdateForm">수정</a>&nbsp;&nbsp;&nbsp;
	                         <a href="#" class="link-danger merDelete">삭제</a>
	                     </div>
	                 </div>
	                 <!-- END : Primary card -->
	             </div>
				</c:forEach>
          	</div>
         </div>
         <!-- card-body 끝 -->
      </div>
   </div>
</div>
<!-- content__boxed 끝 -->

<!--모달 : 회의실 등록 화면 -->
<div id="merInsertModal">
	<div class="col-md-5 mb-3" id="merInsertCont">
		<div class="h-100">
			<h2 class="card-title" id="merMainTitle">회의실 등록</h2>
			<div class="card-body">
				<br />
				<form action="/mer/adminMerInsert" method="post" id="merInsertForm">
					<input type="hidden" name="merNo" id="merNo" value=""/>
					<div class="row mb-3">
						<label for="merName" class="col-sm-4 col-form-label">회의실명</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="merName" id="merName" value="">
						</div>
					</div>
                    <div class="row mb-3">
                        <label class="col-sm-4 col-form-label">사용가능여부</label>
                        <div class="col-sm-8 pt-3">
                            <div class="form-check form-check-inline">
                                <input id="enabledY" class="form-check-input" type="radio" name="enabled" value="Y">
                                <label for="enabledY" class="form-check-label">Y</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input id="enabledN" class="form-check-input" type="radio" name="enabled" value="N">
                                <label for="enabledN" class="form-check-label">N</label>
                            </div>
                        </div>
                    </div>			
					<div class="row mb-3">
						<div class="col-sm-12">
							<button type="button" id="merInsertBtn" class="btn btn-outline-info">등록</button>
							<button type="button" onclick="f_modalClose()" class="btn btn-outline-danger">Close</button>
						</div>
					</div>
				<sec:csrfInput />
				</form>
			</div>
		</div>
	</div>
</div>

<!-- 스타일 -->
<style>
#merInsertModal {
	position: fixed;
	width: 100%;
	height: 100%; /*fixed인 경우 먹음*/
	left: 0px;
	top: 0px;
	background-color: rgba(204, 204, 204, 0.5);
	display: none;
	z-index: 1000;
}
#merInsertCont {
	width: 500px;
	margin: 10% auto; /* 수평가운데 정렬 */
	padding: 50px;
	border-radius: 30px;
	background-color: white;
	text-align: center;
	border: 1px solid lightgray;
}

</style>

<script>
$(function(){
	var merInsertBtn = $("#merInsertBtn");	 // 회의실 등록 버튼
	var merInsertForm = $("#merInsertForm");	// 회으실 등록 폼
	var merUpdateForm = $(".merUpdateForm");	// 회의실 수정 클래스
	var merDelete = $(".merDelete");	// 회의실 삭제 클래스

	
	// 회의실 등록,수정 이벤트
	merInsertBtn.on("click", function(){

		var merName = $("#merName").val();
		var enabled = $("input[name='enabled']:checked").val();
		
		if(merName == null || merName == ""){
			Swal.fire("회의실 이름을 입력해주세요!");
			return false;
		}
		if(enabled == null || enabled == ""){
			Swal.fire("사용여부를 체크해주세요!");
			return false;
		}
		merInsertForm.submit();
		
	});
	
	// 회의실 수정 폼으로 가는 이벤트
	merUpdateForm.on("click",function(){
		var merNo = parseInt($(this).parent(".card-body").find(".pMerNo").text().split(":")[1]);
		var merName = $(this).parents(".parent").find(".hMerName").text();
		var enabled = $(this).parent(".card-body").find(".pEnabled").text().split(":")[1].trim();
		console.log("merNo:",merNo,",merName:",merName,",enabled:",enabled);
		
		$("#merName").val(merName);
		$("input:radio[name='enabled']:radio[value='"+enabled+"']").prop('checked', true); 
		if($("#merName").val() != null && $("#merName").val() != ""){
			$("#merNo").val(merNo);
			$("#merInsertBtn").text("수정");
			$("#merMainTitle").text("회의실 수정");
			$("#merInsertForm").attr("action","/mer/adminMerUpdate");
			$("#merInsertModal").css("display","block");
		}
	});
	
	// 회의실 삭제 이벤트
	merDelete.on("click", function(){
		var merNo = parseInt($(this).parent(".card-body").find(".pMerNo").text().split(":")[1]);
		console.log("merNo:"+merNo);
		
		if(confirm("삭제하면 복구할 수 없습니다. 정말 삭제하시겠습니까?")){
			$.ajax({
				url:"/mer/adminMerDelete",
				type:"post",
				data:{merNo:merNo},
				beforeSend:function(xhr){
					xhr.setRequestHeader(header,token);
                },
				success:function(rslt){
					console.log("삭제결과:",rslt);
					location.href = "/mer/adminMer";
				}
			});
		}
	});
});

function f_modalOpen(){
	$("#merNo").val("");
	$("#merName").val("");
	$("input[name='enabled']").prop('checked', false);
	$("#merInsertBtn").text("등록");
	$("#merMainTitle").text("회의실 등록");
	$("#merInsertForm").attr("action","/mer/adminMerInsert");
	$("#merInsertModal").css("display","block");
}

function f_modalClose(){
	$("#merInsertModal").css("display","none");
} 
</script>
