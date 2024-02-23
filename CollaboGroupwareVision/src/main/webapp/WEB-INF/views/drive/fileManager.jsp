<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div class="content__header content__boxed mb-2 overlapping">
	<div class="content__wrap">
		<div class="d-md-flex">
			<div class="me-auto">
				<!-- Breadcrumb -->
				<nav aria-label="breadcrumb">
					<ol class="breadcrumb mb-0">
						<li class="breadcrumb-item"><a href="./index.html">Home</a></li>
						<li class="breadcrumb-item"><a href="./app-views.html">App
								Views</a></li>
						<li class="breadcrumb-item active" aria-current="page">File
							Manager</li>
					</ol>
				</nav>
				<!-- END : Breadcrumb -->
				<h1 class="page-title mb-0 mt-2">File Manager</h1>

			</div>
			<!-- <div class="align-self-center">
				<button type="button" class="btn btn-warning btn-lg hstack gap-2">
					<i class="demo-pli-folder-with-document fs-4"></i> <span class="vr"></span>
					Add Share Document Box
				</button>
			</div>&nbsp; -->
			<div class="align-self-center">
				<button type="button" class="btn btn-success btn-lg hstack gap-2" onclick="f_fileUploadForm()">
					<i class="demo-psi-upload-to-cloud fs-4"></i> <span class="vr"></span>
					Upload files
				</button>
			</div>
		</div>
	</div>

</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card" style="min-height:700px;">
			<div class="card-body">

				<div class="d-md-flex gap-4">

					<!-- 문서함 리스트 및 타입 리스트 -->
					<div class="w-md-160px w-xl-200px flex-shrink-0">
						<h5 class="px-3 mb-3">Folders</h5>
						<div class="list-group list-group-borderless gap-1">
							<a href="#" class="documentBox list-group-item list-group-item-action <c:if test='${activeDriveStatus eq "01" }'>active</c:if>" data-drive_status="01"> 
								<i class="demo-pli-folder fs-5 me-2"></i> 개인문서함
							</a> 
							<a href="#" class="documentBox list-group-item list-group-item-action <c:if test='${activeDriveStatus eq "03" }'>active</c:if>" data-drive_status="03">
								<i class="demo-pli-folder fs-5 me-2"></i> 부서문서함
							</a> 
							<a href="#" class="documentBox list-group-item list-group-item-action <c:if test='${activeDriveStatus eq "04" }'>active</c:if>" data-drive_status="04"> 
								<i class="demo-pli-folder fs-5 me-2"></i> 휴지통
							</a>
						</div>

						<h5 class="px-3 mt-5 mb-3">Type</h5>
						<div class="list-group list-group-borderless gap-1">
							<a href="/drive/drivePhotos" class="list-group-item list-group-item-action <c:if test='${activeDriveStatus eq "photo" }'>active</c:if>">
								<i class="demo-pli-camera-2 fs-5 me-2"></i> Photos
							</a> 
							<a href="/drive/driveVideos" class="list-group-item list-group-item-action <c:if test='${activeDriveStatus eq "video" }'>active</c:if>">
								<i class="demo-pli-video fs-5 me-2"></i> Videos
							</a>
						</div>

					</div>
					<!-- END : File manager sidebar -->

					<div class="vr"></div>

					<!-- File manager content -->
					<div class="flex-fill">

						<!-- Folder name and path -->
						<h2 class="d-flex align-items-center gap-3">
							<i class="demo-pli-folder-with-document fs-4"></i> Documents
						</h2>
						<ol class="breadcrumb">
							<li class="breadcrumb-item"><a href="#">Public</a></li>
							<li class="breadcrumb-item"><a href="#">Data</a></li>
							<li class="breadcrumb-item active" aria-current="page">Documents</li>
						</ol>
						<!-- END : Folder name and path -->

						<div class="row py-3">

							<!-- 파일생성/복구/삭제-->
							<c:if test="${activeDriveStatus eq '01' || activeDriveStatus eq '03' || activeDriveStatus eq '04' }">
								<div class="col-md-6 d-flex gap-1 align-items-center mb-3">
									<div class="btn-group">
										<c:if test="${activeDriveStatus eq '01' || activeDriveStatus eq '03'}"><!-- 파일생성 -->
											<button class="btn btn-lg btn-icon btn-outline-light" id="addFileBtn">
												<i class="demo-pli-file-add fs-5"></i>
											</button>
										</c:if>
										<c:if test="${activeDriveStatus eq '04' }"><!-- 파일 복구 -->
											<button class="btn btn-lg btn-icon btn-outline-light" id="driveFileMove">
												<i class="demo-psi-back fs-5"></i>
											</button>
										</c:if>
										<!-- 파일삭제 -->
										<button class="btn btn-lg btn-icon btn-outline-light" id="driveDelBtn">
											<i class="demo-pli-recycling fs-5"></i>
										</button>
									</div>
								</div>
							</c:if>
							<!-- END : 파일생성/복구/삭제 -->

							<!--검색 -->
							<div
								class="col-md-6 d-flex gap-1 align-items-center <c:if test='${activeDriveStatus eq "01" || activeDriveStatus eq "03" || activeDriveStatus eq "04" }'>justify-content-md-end</c:if> mb-3">
								<form action="/drive/search" method="post" class="row row-cols-md-auto g-3 align-items-center">
									<input type="hidden" name="driveStatus" value="${activeDriveStatus }"/>
									<div class="form-group">
										<input type="text" placeholder="Search files or folders..."
											class="form-control" autocomplete="off" name="searchName">
									</div>
									<button type="submit" class="btn btn-primary rounded-pill"><i class="demo-pli-folder-search fs-5"></i></button>
								<sec:csrfInput />
								</form>
							</div>
							<!-- END : 검색 -->

						</div>

						<!-- Folder view -->
						<div class="table-responsive pb-4">
							<table class="table table-striped align-middle">
								<thead>
									<tr>
										<th style="width: 40px"><input class="form-check-input" type="checkbox" id="checkAll"/></th>
										<th class="w-100w">Name</th>
										<th class="text-center">Type</th>
										<th class="text-center" style="width: 100px">Size</th>
										<th class="text-center" style="width: 150px">Date Modified</th>
										<th class="text-center" style="width: 40px">Options</th>
									</tr>
								</thead>
								<tbody>
									<!-- 상위폴더 UI 예시 -->
									<c:if test="${driveFolderParent > 0}">
										<tr>
											<td></td>
											<td>
												<div class="d-flex align-items-center position-relative">
													<div class="flex-shrink-0">
														<i class="demo-psi-folder fs-3 text-orange-400"></i>
													</div>
													<div class="flex-grow-1 ms-2">
														<a href="/drive/goParentFolder?driveFolderNo=${driveFolderParent}&driveStatus=${activeDriveStatus}" class="stretched-link text-reset btn-link">. . .</a>
													</div>
												</div>
											</td>
											<td class="text-center"></td>
											<td class="text-center"></td>
											<td class="text-center"></td>
											<td class="text-center"></td>
										</tr>
									</c:if>
									<!-- 상위폴더 UI 예시 끝-->
									<!-- 폴더리스트 -->
									<c:forEach items="${driveFolderList }" var="driveFolder">
										<c:set value="true" var="status"/>
										<c:forEach items="${driveFolderList }" var="folderItem" varStatus="vs">
											<c:if test="${driveFolderList[vs.index].driveFolderNo eq driveFolder.driveFolderParent }">
												<c:set value="false" var="status"/>
											</c:if>
										</c:forEach>
										<c:if test="${status }">
											<tr class="updateFolderIncru delCheckTr">
												<td>
													<input class="form-check-input driveDelCk chk" type="checkbox" value="Y">
												</td>
												<td>
													<div class="d-flex align-items-center position-relative">
														<div class="flex-shrink-0">
															<i class="demo-psi-folder fs-3 text-orange-400"></i>
														</div>
														<div class="flex-grow-1 ms-2">
															<a href="/drive/driveParent?driveFolderNo=${driveFolder.driveFolderNo}&driveStatus=${activeDriveStatus}" 
															class="stretched-link text-reset btn-link atag_driveFolder updateFolderChild delCheckaTag"  data-folder-no="${driveFolder.driveFolderNo }">${driveFolder.driveFolderName }</a>
														</div>
													</div>
												</td>
												<td class="text-center">Folder</td>
												<td class="text-center"></td>
												<td class="text-center">${driveFolder.driveFolderDate }</td>
												<td class="text-center">
													<c:if test="${activeDriveStatus eq '01' || activeDriveStatus eq '03'}">
														<div class="dropdown">
															<button class="btn btn-icon btn-xs btn-light"
																data-bs-toggle="dropdown" aria-expanded="false">
																<i class="demo-pli-dot-horizontal"></i> <span
																	class="visually-hidden">Toggle Dropdown</span>
															</button>
															<ul class="dropdown-menu dropdown-menu-end">
																<li><a class="dropdown-item text-green updateFolderName" href="#">폴더 이름 수정</a></li>
															</ul>
														</div>
													</c:if>
												</td>
											</tr>
										</c:if>
									</c:forEach>
									<!-- 폴더리스트 끝-->
									<!-- 파일리스트 -->
									<c:forEach items="${driveList }" var="drive">
										<c:set value="true" var="status"/>
										<c:forEach items="${driveFolderList }" var="folderItem" varStatus="vs">
											<c:if test="${driveFolderList[vs.index].driveFolderNo eq drive.driveFolderNo }">
												<c:set value="false" var="status"/>
											</c:if>
										</c:forEach>
										<c:if test="${status }">
											<tr class="updateFileIncru delCheckTr">
												<td>
													<input class="form-check-input driveDelCk chk" type="checkbox" value="Y">
												</td>
												<td>
													<div class="d-flex align-items-center position-relative">
														<div class="flex-shrink-0">
															<i class="demo-pli-file fs-3 text-blue"></i>
														</div>
														<div class="flex-grow-1 ms-2">
															<c:url value="/drive/driveDownload" var="downloadURL">
																<c:param name="driveFileNo" value="${drive.driveFileNo }"/>
															</c:url>
															<a href="${downloadURL }" class="stretched-link text-reset btn-link updateFileChild delCheckaTag"
															data-file-no="${drive.driveFileNo }">${drive.driveFileName }</a>
														</div>
													</div>
												</td>
												<td class="text-center">File</td>
												<td class="text-center">${drive.driveFileFancysize }</td>
												<td class="text-center">${drive.driveFileDate }</td>
												<td class="text-center">
													<c:if test="${activeDriveStatus eq '01' || activeDriveStatus eq '03'}">
														<div class="dropdown">
															<button class="btn btn-icon btn-xs btn-light"
																data-bs-toggle="dropdown" aria-expanded="false">
																<i class="demo-pli-dot-horizontal"></i> <span
																	class="visually-hidden">Toggle Dropdown</span>
															</button>
															<ul class="dropdown-menu dropdown-menu-end">
																<li><a class="dropdown-item text-blue updateFileName" href="#">파일 이름 수정</a></li>
															</ul>
														</div>
													</c:if>
												</td>
											</tr>
										</c:if>
									</c:forEach>
									<!-- 파일리스트 끝-->
								</tbody>
							</table>
						</div>
						<!-- END : Folder view -->
					</div>
					<!-- END : File manager content -->
				</div>
			</div>
		</div>
	</div>
</div>
<!--모달 : 폴더, 파일 수정 화면 -->
<div id="driveNameModal">
	<div class="col-md-5 mb-3" id="driveNameCont">
		<div class="card h-100">
			<div class="card-body">
				<br/>
				<br/>
				<form action="/drive/updateDriveName" method="post" id="updateDriveNameForm">
					<input type="hidden" name="driveStatus" value="${activeDriveStatus}"/>
					<input type="hidden" name="driveFolderParent" value="${driveFolderParent}"/>
					<div class="row mb-3">
						<label for="chatroomName" class="col-sm-4 col-form-label">이름</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" id="driveFolderName" value=""/>
						</div>
					</div>

					<div class="row mb-3">
						<div class="col-sm-12">
							<button type="button" onclick="f_updateDriveName()" class="btn btn-outline-info">수정하기</button>
						</div>
					</div>

					<div class="row mb-3">
						<div class="col-sm-12">
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
/*폴더, 파일 수정  모달 메인창*/
#driveNameModal {
	position: fixed;
	width: 100%;
	height: 100%; /*fixed인 경우 먹음*/
	left: 0px;
	top: 0px;
	background-color: rgba(204, 204, 204, 0.5);
	display: none;
	z-index: 1000;
}
#driveNameCont {
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
	var documentBox = $(".documentBox");	// 문서함 클래스
	var driveStatus = "";			// 문서함 코드
	
	var addFileBtn = $("#addFileBtn"); 	// 문서함 추가 버튼
	
	var updateFolderName = $(".updateFolderName");	// 폴더이름 수정버튼
	var updateFileName = $(".updateFileName");		// 파일이름 수정버튼
	var updateDriveNameForm = $("#updateDriveNameForm"); // 파일이름 수정 폼
	
	var driveDelBtn = $("#driveDelBtn");	// 삭제버튼
	
	var driveFileMove = $("#driveFileMove");	// 휴지통에서 파일 복구버튼
	
	// 문서함 클릭하면 넘어감
	documentBox.on("click", function(){
		driveStatus = $(this).data("drive_status");
		location.href = "/drive/fileManager?driveStatus="+driveStatus;
	});
	
	// 폴더 추가 버튼을 클릭하면 현재 있는 위치에 폴더가 생성된다. 디폴트 폴더 이름은 새폴더이다.
	addFileBtn.on("click", function(){
		var driveFolderParent = "${driveFolderParent}";
		driveStatus = "${activeDriveStatus}";
		
		var data = {
			driveStatus : driveStatus,
			driveFolderParent : driveFolderParent
		}
		console.log("driveStatus:"+driveStatus);
		console.log("driveFolderParent:"+driveFolderParent);
		
		 $.ajax({
			url:"/drive/insertFolder",
			type:"post",
			data:data,
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success:function(rslt){
				console.log("새폴더 생성 성공");
				if(driveFolderParent == null || driveFolderParent == ""){
					location.replace("/drive/fileManager?driveStatus="+driveStatus);
				}else{
					location.replace("/drive/driveParent?driveFolderNo="+driveFolderParent+"&driveStatus="+driveStatus);
				}
			}
		});  
	});
	
	// 폴더 이름 수정하기 눌렀을 때 이름을 입력하는 모달창 뜨는 이벤트
	updateFolderName.on("click",function(){
		$("#driveFolderName").attr("name","driveFolderName");
		
		// 폴더 번호 가져오기
		upd_driveFolderNo = $(this).parents(".updateFolderIncru").find(".updateFolderChild").data("folder-no");
		
		// input 태그 생성하기
		html = "<input type='hidden' name='driveFolderNo' id='upd_driveFolderNo' value='"+upd_driveFolderNo+"'/>";
		updateDriveNameForm.append(html);
		
		$("#driveNameModal").css("display","block");
	});
	
	// 파일 이름 수정하기 눌렀을 때 이름을 입력하는 모달창 뜨는 이벤트
	updateFileName.on("click", function(){
		$("#driveFolderName").attr("name","driveFileName");
		$("#driveNameModal").css("display","block");
		
		// 파일 번호 가져오기
		upd_driveFileNo = $(this).parents(".updateFileIncru").find(".updateFileChild").data("file-no");

		// input 태그 생성하기
		html = "<input type='hidden' name='driveFileNo' id='upd_driveFileNo' value='"+upd_driveFileNo+"'/>";
		updateDriveNameForm.append(html);
	});
	
	// 삭제 버튼 눌렀을 때 체크된 폴더 및 파일이 삭제됨
	driveDelBtn.on("click", function(){
		console.log("길이:"+$(".driveDelCk:checked").length);
		var driveDelCk = $(".driveDelCk:checked");
		var driveFolderParent = "${driveFolderParent}";
		var driveStatus = "${activeDriveStatus}";
		var folderDatas = [];	// 삭제할 폴더 묶음들
		var fileDatas = [];		// 삭제할 파일 묶음들
		
		if(driveDelCk.val() == null || driveDelCk.val() == ""){
			Swal.fire({
	        	icon: 'error',
	        	text: '삭제할 폴더와 파일을 선택해주세요!'
	        });
			return false;
		}
		
		if(driveStatus == "04"){
			if(confirm("휴지통에서 삭제되면 복구할 수 없습니다. 삭제하시겠습니까?")){
				// 휴지통에서 삭제했을 때 이벤트(영구삭제)
				for(i=0; i<driveDelCk.length; i++){
					if(driveDelCk.eq(i).val() == "Y"){
						
						var folderNo = driveDelCk.eq(i).parents(".delCheckTr").find(".delCheckaTag").data("folder-no");
						var fileNo = driveDelCk.eq(i).parents(".delCheckTr").find(".delCheckaTag").data("file-no");
						
						if(folderNo != null && folderNo != ""){	// 폴더일경우
							folderDatas.push(folderNo);
						}
						
						if(fileNo != null && fileNo != ""){		// 파일일경우
							fileDatas.push(fileNo);
						}
					}
				}
				
				// 폴더,파일 비동기로 보내주기
				console.log(folderDatas);
				var data = {
					folderNos:folderDatas,
					fileNos:fileDatas
				};
				$.ajax({
					url:"/drive/delete",
					type:"post",
					data:JSON.stringify(data),
					contentType : "application/json;charset=utf-8",
					beforeSend:function(xhr){
						xhr.setRequestHeader(header,token);
					},
					success:function(rslt){
						console.log("결과:"+rslt);
						folderDatas = [];
						fileDatas = [];	
						location.reload();
					}
				});
			}
			return false;
		}
		
		// 개인,부서 문서함의 경우 삭제시 휴지통으로 이동함
		for(i=0; i<driveDelCk.length; i++){
			if(driveDelCk.eq(i).val() == "Y"){
				
				var folderNo = driveDelCk.eq(i).parents(".delCheckTr").find(".delCheckaTag").data("folder-no");
				var fileNo = driveDelCk.eq(i).parents(".delCheckTr").find(".delCheckaTag").data("file-no");
				
				if(folderNo != null && folderNo != ""){	// 폴더일경우
					folderDatas.push(folderNo);
				}
				
				if(fileNo != null && fileNo != ""){		// 파일일경우
					fileDatas.push(fileNo);
				}
				
			}
		}
		
		console.log(folderDatas);
		var data = {
				folderNos:folderDatas,
				fileNos:fileDatas
		};
		$.ajax({
			url:"/drive/tempDelete",
			type:"post",
			data:JSON.stringify(data),
			contentType : "application/json;charset=utf-8",
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success:function(rslt){
				console.log("결과:"+rslt);
				folderDatas = [];
				fileDatas = [];	
				location.reload();
			}
		});
	
	});
	
	// 파일복구
	driveFileMove.on("click", function(){
		var folderDatas = [];	// 삭제할 폴더 묶음들
		var fileDatas = [];		// 삭제할 파일 묶음들
		console.log("파일복구버튼");
		var driveDelCk = $(".driveDelCk:checked");
		
		if(driveDelCk.val() == null || driveDelCk.val() == ""){
			Swal.fire({
	        	icon: 'error',
	        	text: '복구할 폴더와 파일을 선택해주세요!'
	        });
			return false;
		}
		
		for(i=0; i<driveDelCk.length; i++){
			if(driveDelCk.eq(i).val() == "Y"){
				
				var folderNo = driveDelCk.eq(i).parents(".delCheckTr").find(".delCheckaTag").data("folder-no");
				var fileNo = driveDelCk.eq(i).parents(".delCheckTr").find(".delCheckaTag").data("file-no");

				if(folderNo != null && folderNo != ""){	// 폴더일경우
					folderDatas.push(folderNo);
				}else{
					fileDatas.push(fileNo);
				}
			}
		}
		
		var data = {
			driveFolderNo : folderDatas,
			driveFileNo : fileDatas 
		};
		$.ajax({
			url:"/drive/restore",
			type:"post",
			contentType: "application/json;charset=utf-8",
			data:JSON.stringify(data),
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success:function(rslt){
				console.log("휴지통에서 복구[결과] : " + rslt);
				location.reload();
			}
		});
	});
	
	// 전체선택
	$("#checkAll").click(function() {
		if($("#checkAll").is(":checked")) $(".chk").prop("checked", true);
		else $(".chk").prop("checked", false);
	});

	$(".chk").click(function() {
		var total = $(".chk").length;
		var checked = $(".chk:checked").length;

		if(total != checked) $("#checkAll").prop("checked", false);
		else $("#checkAll").prop("checked", true); 
	});

});

// 드라이브 폴더 및 파일 이름 수정
function f_updateDriveName(){
	var driveFolderName = $("#driveFolderName").val();
	
	if(driveFolderName == null || driveFolderName == ""){
		Swal.fire({
        	icon: 'error',
        	text: '수정할 이름을 입력해주세요!'
        });
		return false;
	}
	
	updateDriveNameForm.submit();
}

// 이름수정 모달창 닫기
function f_modalClose(){
	$("#upd_driveFolderNo").remove();	// 추가했던 태그 삭제
	$("#upd_driveFileNo").remove();		// 추가했던 태그 삭제
	$("#driveNameModal").css("display","none");
}

// 파일업로드 페이지로 이동하며 해당 폴더에 파일이 업로드 된다.
function f_fileUploadForm(){
	var load_driveFolderNo = "${driveFolderParent}";
	var load_driveStatus = "${activeDriveStatus}";
	
	location.href = "/drive/uploadForm?driveFolderNo="+load_driveFolderNo+"&driveStatus="+load_driveStatus;
}


// 팝업
setTimeout(() => {
	check();
}, 30);
</script>