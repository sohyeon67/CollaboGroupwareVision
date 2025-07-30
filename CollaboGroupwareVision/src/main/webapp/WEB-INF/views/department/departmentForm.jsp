<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/resources/ckeditor/ckeditor.js"></script>
<style>
h1, h5 {
	color: white;
}
</style>

<div class="content__header content__boxed overlapping">
	<div class="content__wrap">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="./index.html">게시판</a></li>
				<li class="breadcrumb-item"><a href="./forms.html">부서게시판</a></li>
				<li class="breadcrumb-item active" aria-current="page">부서게시글 등록하기</li>
			</ol>
		</nav>
	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">
		<c:set value="등록" var="name" />
		<c:if test="${status eq 'u' }">
			<c:set value="수정" var="name" />
		</c:if>
		<hr />
		<h1>${name }</h1>
		<hr />
		<form action="/department/departmentInsert" method="post" id="insertForm"
			enctype="multipart/form-data">
			<input type="hidden" value="${board.boardCode } == 4">
			<c:if test="${status eq 'u' }">
				<input type="hidden" name="boardNo" value="${board.boardNo }" />
			</c:if>

<p></p>

<div class="row">
    <div class="col-md-1">
        <h5 class="card-title">부서명</h5>
    </div>
    <div class="col-md-8">
    	${deptName }
   	</div>
</div>
<div class="row">
    <div class="col-md-1">
        <h5 class="card-title">작성자</h5>
    </div>
    <div class="col-md-8">
    	${empName }
   	</div>
</div>
    
<p></p>
			<div class="row">
				<div class="col-md-1">
					<h5 class="card-title">제목</h5>
				</div>
				<div class="col-md-8">
					<input type="text" class="form-control" name="boardTitle"
						id="boardTitle" value="${board.boardTitle}" />
				</div>
			</div>	
			<div class="row">
				<div class="col-md-1"><br/>
					<h5 class="card-title">파일</h5>
				</div>
				<div class="col-md-11"><br/>
					<input type="file" id="inputFile" name="boFile" multiple="multiple">
						<div class="uploadedList"></div>
				</div>
			</div>
			<div class="row">
				<c:forEach items="${boardAttachList }" var="boardAttach">
	               	<div id="parentDiv" class="col-md-2 bg-light p-3 rounded bg-opacity-50 mt-5">
                         <p class="mb-3">첨부파일 : ${boardAttach.fileName }</p>
                         <p class="mb-0 text-xs font-weight-bolder text-info text-uppercase">
							<button type="button" class="btn btn-primary btn-sm fileDelete" id="file_${boardAttach.fileNo }" 
									data-file-no="${boardAttach.fileNo }">
									delete 
							</button>
					 	</p>
    	            </div>
				</c:forEach>
			</div>
			
			<div class="col-md-12"><br/></div>
<c:if test="${status eq 'u' }">
    <c:set value="${board.boardAttachList }" var="boardAttachList"/>
    <c:if test="${not empty boardAttachList }">
        <div class="col-md-12">
            <div class="row">
                <c:forEach items="${boardAttachList }" var="boardAttach">
                    <div class="col-md-2">
                        <div class="card shadow-lg">
                            <div class="card-header mt-n4 mx-3 p-0 bg-transparent position-relative z-index-2">
                                <a class="d-block blur-shadow-image text-center"> 
                                    <c:choose>
                                        <c:when test="${fn:split(boardAttach.fileMime, '/')[0] eq 'image' }">
                                            <img src="/resources/board/${board.boardNo}/${fn:split(boardAttach.fileSavepath, '/')[1]}" 
                                                style="width:50%;" alt="img-blur-shadow">												
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/resources/assets/img/icons/img.jpg" alt="img-blur-shadow" class="img-fluid shadow border-radius-lg">
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="colored-shadow" style="background-image: url(&quot;https://images.unsplash.com/photo-1536321115970-5dfa13356211?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&amp;ixlib=rb-1.2.1&amp;auto=format&amp;fit=crop&amp;w=934&amp;q=80&quot;);"></div>
                            </div>
                            <div class="card-body text-center bg-white border-radius-lg p-3 pt-0">
                                <h6 class="mt-3 mb-1 d-md-block d-none">
                                    ${boardAttach.fileName }(${boardAttach.fileFancysize })
                                </h6>
                                <p class="mb-0 text-xs font-weight-bolder text-info text-uppercase">
                                    <button type="button" id="btn_${boardAttach.fileNo }" 
                                        class="btn btn-primary fileDelete" data-file-no="${boardAttach.fileNo }">delete</button>
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</c:if>

			<hr />
			<textarea name="boardContent" id="editor">${board.boardContent}</textarea>
			<hr/>
						<p>
							<input type="button" class="btn btn-primary rounded-pill"
								id="insertBtn" value="${name }" />
							<c:if test="${status ne 'u' }">
								<input type="button" class="btn btn-primary rounded-pill"
									id="listBtn" value="목록" />
							</c:if>
							<c:if test="${status eq 'u' }">
								<input type="button" class="btn btn-primary rounded-pill"
									id="cancelBtn" value="취소" />
							</c:if>
						</p>
			<sec:csrfInput />
		</form>
	</div>
</div>

<script>
$(function() {
	CKEDITOR.replace("editor");
	var insertForm = $("#insertForm");
	var insertBtn = $("#insertBtn");
	var listBtn = $("#listBtn");
	var cancelBtn = $("#cancelBtn");
	var inputFile = $("#inputFile");
	
/* 	$(".fileDelete").on("click", function(){
		var id = $(this).prop("id");
		var idx = id.indexOf("_");
		var fileNo = id.substring(idx + 1);	// fileNo 가져오기
		var ptrn = "<input type='hidden' name='delBoardNo' value='%V'/>";
		insertForm.append(ptrn.replace("%V", fileNo));
		$(this).parents("#parentDiv").hide();
	}); */

		insertBtn.on("click", function() {
			var boardTitle = $("#boardTitle").val();
			var editor = CKEDITOR.instances.editor.getData();
 			var departmentSelect = $("#departmentSelect").val();
 			var url = "/department/defaultList";
			
			if (boardTitle == null || boardTitle === "") {
				alert("제목을 입력해주세요.");
				return false;
			}
	
			if (editor == null || editor.trim() === "") {
				alert("내용을 입력해주세요.");
				return false;
			}
	
			if ($(this).val() == "수정") {
				insertForm.attr("action", "/department/departmentUpdate");
			}
			
			$("#insertForm").submit();
		});
	
		listBtn.on("click", function() {
			location.href = "/department/departmentList";
		});
	
		cancelBtn.on("click", function() {
			location.href = "/department/departmentList";
		});

/* 		// Open 파일을 변경했을때 이벤트 발동
		inputFile.on("change", function(event) {
		    console.log("change...!");
		    var files = event.target.files;
		    var file = files[0];
		
		    console.log(file);
		    var formData = new FormData();
		    formData.append("file", file);
		    // boardNo 변수를 추가하고 해당 변수에 게시글 번호를 할당합니다.
		    formData.append("boardNo", $("#boardNo").val());
		
 		    $.ajax({
		        type: "post",
		        url: "/department/departmentUploadAjax",
		        data: formData,
		        processData: false,
		        contentType: false,
		        success: function(data) {
		            console.log(data);
		            console.log("inputFile ajax");
		
		            var str = "";
		
		            if (checkImageType(data)) {
		                str += "<div>";
		                str += "  <a href='/department/departmentDisplayFile?fileName=" + data + "'>";
		                str += "    <img src='/department/departmentDisplayFile?fileName=" + getThumbnailName(data) + "'/>";
		                str += "  </a>";
		                str += "  <span>X</span>";
		                str += "</div>";
		            } else {
		                str += "<div>";
		                str += "  <a href='/department/departmentDisplayFile?fileName=" + data + "'>" + getOriginalName(data) + "</a>";
		                str += "  <span>X</span>";
		                str += "</div>";
		            }
		
		            $(".uploadedList").append(str);
	      		  }
    		}); 
});


		$(".uploadedList").on("click", "span", function() {
			$(this).parent("div").remove();
		});

     item.submit(function(event){
		 event.preventDefault();
		
		 var that = $(this);
		 var str = "";
		 $(".uploadedList a").each(function(index){
		 var value = $(this).attr("href");
		 value = value.substr(28);
		
		 str += "<input type='hidden' name='files["+index+"]' value='"+value+"'>";
		 });
		
		 console.log("str : " + str);
		 that.append(str);
		 that.get(0).submit();
	 }); 

		function getThumbnailName(fileName) {
			var front = fileName.substr(0, 12);
			var end = fileName.substr(12);

			console.log("front : " + front);
			console.log("end : " + end);

			return front + "s_" + end;
		}

		function getOriginalName(fileName) {
			if (checkImageType(fileName)) {
				return;
			}

			var idx = fileName.indexOf("_") + 1;
			return fileName.substr(idx);
		}

		function checkImageType(fileName) {
			var pattern = /jpg|gif|png|jpeg/i;
			return fileName.match(pattern);
		} */
	});
</script>