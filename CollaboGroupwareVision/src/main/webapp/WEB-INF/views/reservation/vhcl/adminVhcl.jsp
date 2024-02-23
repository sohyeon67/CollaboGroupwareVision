<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>


<div class="content__header content__boxed overlapping">
   <div class="content__wrap">
      <nav aria-label="breadcrumb">
         <ol class="breadcrumb mb-0">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="#">예약</a></li>
            <li class="breadcrumb-item"><a href="/adminVhcl">차량예약</a></li>
            <li class="breadcrumb-item active" aria-current="page">차량관리</li>
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
						<button type="button" class="btn btn-primary btn-lg rounded-pill" onclick="f_modalOpen()">차량등록</button><br/><br/>
					</div>
					<div class="align-self-center">
					</div>
				</div><hr/>
				  <br/><br/><br/>
				  <c:forEach items="${vhclList }" var="vhcl">
		             <div class="col-md-3 mb-3">
					 
		                 <div class="card border-2 border-primary parent" style="height: 100%; width: 85%; ">
		                     <h5 class="card-header hVhclName">${vhcl.vhclName }</h5>
		                     <div class="card-body">
		                     	<div style="height: 50%; width: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center;">
			                     	<img src="${pageContext.request.contextPath}${vhcl.vhclImgPath}" 
			                     		alt="" id="vhclImgPath" name="vhclImgPath" style="max-width: 100%; max-height: 100%;"/>
		                     	</div>	
		                     		<hr/>
		                     		<br/>
		                     	<p class="pVhclNo">차량 번호 : ${vhcl.vhclNo }</p>
		                         <p class="pEnabled">사용 가능 여부 : ${vhcl.enabled }</p>
		                         <a href="#" class="link-warning vhclUpdateForm">수정</a>&nbsp;&nbsp;&nbsp;
		                         <a href="#" class="link-danger vhclDelete">삭제</a>
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


<!--모달 : 차량 등록 화면 -->
<div id="vhclInsertModal">
	<div class="col-md-5 mb-3" id="vhclInsertCont">
		<div class="card h-100">
			<div class="card-body">
				<h2 class="card-title">차량 등록</h2>
				<br />
				<form action="/adminVhcl/adminVhclInsert" method="post" id="vhclInsertForm" enctype="multipart/form-data">
					<!-- 숨겨진 필드를 추가하여 기존 파일 경로를 저장 -->
	   				<input type="hidden" name="vhclImgPath" id="currentImgPath" value="${vhcl.vhclImgPath}">
					<div class="row mb-3">
						<label for="vhclNo" class="col-sm-4 col-form-label">차량번호</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="vhclNo" id="vhclNo" value="">
						</div>
					</div>
					<div class="row mb-3">
						<label for="vhclName" class="col-sm-4 col-form-label">차량명</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="vhclName" id="vhclName" value="">
						</div>
					</div>
					<div class="row mb-3">
						<label for="imgFile" class="col-sm-4 col-form-label">차량 이미지</label>
						<div class="col-sm-8">
							<input type="file" class="form-control" name="imgFile" id="imgFile" value="">
						</div>
					</div>
					<div class="row mb-3">
						<!-- 이미지 출력 -->
						<div class="col-sm-4 col-form-label">미리보기</div>
						<div class="col-sm-8">
							<img src="" alt="" id="vhclImgPathPreview" style="max-width: 100%; max-height: 100%;"/>
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
							<button type="button" id="vhclInsertBtn" class="btn btn-outline-info">등록</button>
							<button type="button" onclick="f_modalClose()" class="btn btn-outline-danger">Close</button>
							<button type="button" class="btn btn-light btn-lg" onclick="setDemoValues()">시연용</button>
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
#vhclInsertModal {
	position: fixed;
	width: 100%;
	height: 100%; /*fixed인 경우 먹음*/
	left: 0px;
	top: 0px;
	background-color: rgba(204, 204, 204, 0.5);
	display: none;
	z-index: 1000;
}
#vhclInsertCont {
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

	var vhclInsertBtn = $("#vhclInsertBtn");	 // 차량 등록 버튼
	var vhclInsertForm = $("#vhclInsertForm");	// 차량 등록 폼
	var vhclUpdateForm = $(".vhclUpdateForm");	// 차량 수정 클래스
	var vhclDelete = $(".vhclDelete");	// 차량 삭제 클래스
	var vhclImgPath = $("#vhclImgPath"); //파일 출력 
	var imgFile = $("#imgFile");  // 파일 선택 Element
	var vhclImgPathPreview = $("#vhclImgPathPreview"); // 미리보기 이미지 출력
	//var successImagePath; //성공적으로 업로드된 이미지 경로 변수 업데이트
	
	//이미지 추가
	imgFile.on("change", function(event){
		var file = event.target.files[0];
		
		if(isImagefile(file)){ //이미지 파일이 맞다면!
			var reader = new FileReader();
			reader.onload = function(e){
				vhclImgPathPreview.attr("src", e.target.result); // 이미지 출력 미리보기
				vhclImgPath.attr("src", e.target.result); // 이미지 출력 // 차량 이미지 출력란에 src를 타겟 결과로 출력	
				//successImagePath = e.target.result; //성공적으로 업로드된 이미지 경로 변수 업데이트
			}
			reader.readAsDataURL(file);
		}else{ //이미지 파일이 아니라면
			alert("이미지 파일을 선택해주세요!");
		}
	});

	
	// 차량 등록,수정 이벤트
	vhclInsertBtn.on("click", function(){

		var vhclNo = $("#vhclNo").val();
		var vhclName = $("#vhclName").val();
		var enabled = $("input[name='enabled']:checked").val();
		
		if(vhclNo == null || vhclNo == ""){
			Swal.fire({
				icon : 'warning',
				text : `차량 번호 입력해주세요!`,
			})
			return false;
		}
		if(vhclName == null || vhclName == ""){
			Swal.fire({
				icon : 'warning',
				text : `차량 이름을 입력해주세요!`,
			})
			return false;
		}
		if(enabled == null || enabled == ""){
			Swal.fire({
				icon : 'warning',
				text : `사용여부를 체크해주세요!`,
			})
			return false;
		}
			
		vhclInsertForm.submit(); 
		
		
	}); //차량 등록, 수정 이벤트 끝
	

	
	

	// 이미지 파일인지 체크 
	function isImagefile(file){
		var ext = file.name.split(".").pop().toLowerCase(); // 파일명에서 확장자를 가져온다.
		return ($.inArray(ext, ["jpg", "jpeg", "gif", "png"]) === -1) ? false : true;
	}
	
	

	// 차량 수정 폼으로 가는 이벤트
	vhclUpdateForm.on("click",function(){
		var vhclNoText = $(this).parent(".card-body").find(".pVhclNo").text();
		var vhclNo = vhclNoText.includes(":") ? vhclNoText.split(":")[1].trim() : null;		
		var vhclName = $(this).parents(".parent").find(".hVhclName").text();
		var enabled = $(this).parent(".card-body").find(".pEnabled").text().split(":")[1].trim();
		
 		// 이미지 경로를 가져온다.
	    var imgPath = $(this).parents(".parent").find("#vhclImgPath").attr("src");
		
	    // 모달에서 이미지 경로 설정
        $("#vhclImgPath").attr("src", imgPath); 
	    
        // 기존 파일 경로를 숨겨진 필드에 설정
        $("#currentImgPath").val(imgPath);
		
		console.log("vhclNo:",vhclNo,",vhclName:",vhclName,",enabled:",enabled);
				
		$("#vhclNo").val(vhclNo).prop('readonly', true);
	    $("#vhclName").val(vhclName).prop('readonly', true);
	    $("#vhclImgPath").attr("src", imgPath); // 이미지 경로를 설정
		$("input:radio[name='enabled']:radio[value='"+enabled+"']").prop('checked', true); 
		if($("#vhclName").val() != null && $("#vhclName").val() != ""){
			$("#vhclNo").val(vhclNo);	
			$("#vhclInsertBtn").text("수정");
			$("#vhclInsertForm").attr("action","/adminVhcl/adminVhclUpdate");
			$("#vhclInsertModal").css("display","block");
		}
	});
	
	
	
		
	// 차량 삭제 이벤트
	vhclDelete.on("click", function(){
		var vhclNoText = $(this).parent(".card-body").find(".pVhclNo").text();
		var vhclNo = vhclNoText.includes(":") ? vhclNoText.split(":")[1].trim() : null;
		console.log("vhclNo:"+vhclNo);
		
		if(confirm("삭제하면 복구할 수 없습니다. 정말 삭제하시겠습니까?")){
			$.ajax({
				url:"/adminVhcl/adminVhclDelete",
				type:"post",
				data:{vhclNo:vhclNo},
				beforeSend:function(xhr){
					xhr.setRequestHeader(header,token);
                },
				success:function(rslt){
					console.log("삭제결과:",rslt);
					location.href = "/adminVhcl/adminVhcl";
				},	
			});
		}
	});

});

function f_modalOpen(){
	$("#vhclNo").val("");
	$("#vhclName").val("");
	$("input[name='enabled']").prop('checked', false);
	$("#vhclInsertBtn").text("등록");
	$("#vhclInsertForm").attr("action","/adminVhcl/adminVhclInsert");
	$("#vhclInsertModal").css("display","block");
}

function f_modalClose(){
	$("#vhclInsertModal").css("display","none");
} 

// 발표 시연용 데이터 세팅
function setDemoValues() {
	$('#vhclNo').val('38차3611');
	$('#vhclName').val('SUV 베뉴');
	$('#enabledY').prop('checked', true);
}

</script>
