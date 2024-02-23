<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<div class="content__boxed">
    <div class="content__wrap">
        <div class="card mb-3">
            <div class="card-body">

                <div class="mb-3">
                    <h2>Dropzone</h2>
                    <p class="m-0">Dropzone is an easy to use drag'n'drop library. It supports image previews and shows nice progress bars.</p>
                    <p class="mt-2 pb-3 fw-bold"><i class="demo-psi-coding h4 mb-0 me-2"></i><a class="btn-link text-decoration-underline" href="https://github.com/dropzone/dropzone" target="blank">github.com/dropzone/dropzone</a></p>
                </div>

                <!-- Default Style -->
                <form action="/drive/driveFileUplaod" method="post" class="dropzone bg-light text-center rounded p-5">
                    <div class="dz-message m-0">
                        <div class="p-3 text-muted text-opacity-25">
                            <i class="demo-psi-upload-to-cloud display-2"></i>
                        </div>
                        <h4>Drop files to upload</h4>
                        <p class="text-muted mb-0">or click to pick manually</p>
                    </div>
                    <div class="fallback">
                        <input name="file" type="file" multiple />
                    </div>
				<sec:csrfInput />
                </form>
                
                <!-- 페이지 돌아가기 -->
                <br/><br/>
                <div class="hstack gap-3">
                    <button class="btn btn-success ms-auto" type="button" id="driveBackPage">돌아가기 </button>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath }/resources/assets/js/demo-purpose-only.js" defer></script>
<script src="${pageContext.request.contextPath }/resources/assets/vendors/dropzone/dropzone.min.js" defer></script>
<script src="${pageContext.request.contextPath }/resources/assets/pages/file-uploads.js" defer></script>            
<script>
$(function(){
	var driveFolderNo = "${driveFolderNo}";	 // 업로드 할 폴더 번호
	var driveStatus = "${driveStatus}"; 	 // 업로드 할 문서함
	
	var driveBackPage = $("#driveBackPage");	// 돌아가기 버튼
	
	console.log("업로드 driveFolderNo: "+driveFolderNo);
	console.log("업로드 driveStatus: "+driveStatus);
	
	// 드라이브 페이지로 돌아가는 버튼이벤트
	driveBackPage.on("click", function(){
		if(driveFolderNo == null || driveFolderNo == ""){
			location.replace("/drive/fileManager?driveStatus="+driveStatus);
		}else{
			location.replace("/drive/driveParent?driveFolderNo="+driveFolderNo+"&driveStatus="+driveStatus);
		}
	});
	
});

// 팝업
setTimeout(() => {
	check();
}, 30);
</script>
            
            