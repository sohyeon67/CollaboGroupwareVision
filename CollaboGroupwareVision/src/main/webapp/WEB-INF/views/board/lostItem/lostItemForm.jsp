<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>      
<style>
input[type=file]::file-selector-button {
  width: 150px;
  background: #fff;
  border: 1px solid rgb(230,230,230);
  border-radius: 7px;
  cursor: pointer;
  font-size: 1rem;
  height: 43px;
  color: #808080;
}
.form-control{
	font-size: 1rem;
}
.form-select{
	font-size: 1rem;
}

input[type='date']::before {
  content: attr(data-placeholder);
  width: 100%;
}

input[type='date']:focus::before,
input[type='date']:valid::before {
  display: none;
}


</style>
 
<div class="content__header content__boxed overlapping">
    <div class="content__wrap">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/index">Home</a></li>
                <li class="breadcrumb-item"><a href="./main">게시판</a></li>
                <li class="breadcrumb-item active" aria-current="page"> ${title }</li>
            </ol>
        </nav>
        <!-- END : Breadcrumb -->
		<br/>	
		<br/>	
    </div>
</div>

<div class="content__boxed">
    <div class="content__wrap">
		<form action="/board/lostItem/insert" method="post" id="lostitemForm" enctype="multipart/form-data">
	        
	        <!-- 결재폼, 사이드바 옆으로 정렬 -->
	        <div class="d-flex gap-4">
	        	<!-- 결재폼 시작 -->
			    <div class="card" style="width: 100%">
			        <div class="d-md-flex gap-4">
			            <div class="card-body">
				            <div style="font-size: 30px; color: black; font-weight: bold;">
				                	분실물 게시판 등록
				            </div>
				            <br/>
							<div class="form-group row">
							  <div class="col-sm-12" style="display: flex;">
							    <select name="boardLostitemCategory" class="form-select" id="category" name="category" style="width: 150px; flex-shrink: 0;">
							      <option value="" selected="selected" disabled="disabled" hidden="">카테고리</option>
							      <option>분실</option>
							      <option>습득</option>
							    </select>
							    <input type="text" id="boardTitle" name="boardTitle" class="form-control" value="${board.boardTitle}" placeholder="제목">
							  </div>
							</div>
							<br/>
							<div class="form-group row">
							  <div class="col-sm-12" style="display: flex;">
								<input id="boardLostitemDate" name="boardLostitemDate" type="date" data-placeholder="분실일자" class="form-control" style="width: 150px; flex-shrink: 0;" required aria-required="true">
								<input type="text" id="boardLostitemPlace" name="boardLostitemPlace" class="form-control" value="" placeholder="장소">
							  </div>
							</div>
							<br/>
								<input type="file" id="inputFile" name="boFile" multiple="multiple"> 
							<br/>




							<br/>
							
							<div class="form-group">
								<textarea id="boardContent" name="boardContent" class="form-control" rows="14">${drftContent }</textarea>
							</div>
							
							<br/>
							
							<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
					   			<button type="button" id="insertBtn" class="btn btn-success fw-bold" style="font-size: 16px;" >등록</button>
							
							
							<c:if test="${status ne 'u' }">
					   			<button type="button" id="listBtn" class="btn btn-danger fw-bold" style="font-size: 16px;">목록</button>
							</c:if>				   			
							<c:if test="${status eq 'u' }">
					   			<button type="button" id="cancelBtn" class="btn btn-danger fw-bold" style="font-size: 16px;">취소</button>
							</c:if>				   			
							</div>
						</div>
					</div>					
		        </div>					
			</div>
	        <!-- 결재폼, 사이드바 옆으로 정렬 끝 -->							
	        <sec:csrfInput/>
		</form>
    </div>
</div>

<script>

var now_utc = Date.now()
var timeOff = new Date().getTimezoneOffset()*60000;
var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
document.getElementById("boardLostitemDate").setAttribute("max", today);



$(function(){
	//ck에디터
	CKEDITOR.replace("boardContent", {
	    filebrowserUploadUrl: '/imageUpload?${_csrf.parameterName}=${_csrf.token}'
	});
	
	CKEDITOR.config.height = "300px"; // CKEDITOR 높이 설정
	CKEDITOR.config.width = "100%"; // CKEDITOR 너비 설정
	CKEDITOR.config.versionCheck = false;
	
	var insertBtn = $("#insertBtn");
	var lostitemForm = $("#lostitemForm");
	
	insertBtn.on("click", function() {
		var boardTitle = $("#boardTitle").val();
		var boardContent = CKEDITOR.instances.boardContent.getData();
	
		if (boardTitle == null || boardTitle === "") {
			alert("제목을 입력해주세요.");
			return false;
		}

		if (boardContent == null || boardContent.trim() === "") {
			alert("내용을 입력해주세요.");
			return false;
		}

		if ($(this).val() == "수정") {
			lostitemForm.attr("action", "/board/update");
		}

		lostitemForm.submit();
	});
	
	
	
	
});
</script>