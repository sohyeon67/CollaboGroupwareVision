<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>    
<!-- 결재작성 모달 -->
<%@ include file="./draftFormModal.jsp" %>
<c:if test="${not empty message }">
<script type="text/javascript">
Swal.fire({
	icon: 'error',
	title: '에러',
	text: '${message}'
});
<c:remove var="message" scope="request"/>
<c:remove var="message" scope="session"/>
</script>
</c:if>  
<c:if test="${not empty writeFailed }">
<script type="text/javascript">
Swal.fire({
	icon: 'error',
	title: '등록 실패',
	text: '${writeFailed}'
});
<c:remove var="failedMessage" scope="request"/>
<c:remove var="successMessage" scope="session"/>
</script> 
</c:if>  
<style>
#jsTreeModal{
	position: fixed;
    width: 100%;
    height: 100%; /* fixed인 경우 작동 */
    left: 0px;
    top: 0px;
    background-color: rgb(200, 200, 200, 0.5);
    display: none; 
    z-index: 1000; /* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
}

#jsTreeModalCont{
    margin: 10% auto;   /* 수평가운데 정렬 */
	width : 640px;
	height : 500px;
	background-color: rgb(255,255,255);
	
}

#divtree{
	width: 60%;
	min-width : 350px !important;
}

#jstree{
	max-height: 300px !important;
}


#approvalTable td{
	border: 0px;
}

#approval td{
	padding: 0px;
}

#approval input{
	background-color: #ffffff;
}

#drftTable{
	width: 100%;
}

#drftTable input{
	background-color: #ffffff;
}

table tr td{
	border-width: 2px;
	color: black;
}

#fileTable tr td{
	border-width: 0px;
}

#favoriteListTable{
	height: 78%;
	display: block;
	overflow: auto;
}

#favoriteListTable tr td{
	border-width: 0px;
}

#fileTableDiv{
	max-height: 650px;
	overflow: auto;
}

#searchInput{
	width: 100% !important;
}

#favoriteAddModal, #favoriteListModal{
	position: fixed;
    width: 100%;
    height: 100%; /* fixed인 경우 작동 */
    left: 0px;
    top: 0px;
    background-color: rgb(200, 200, 200, 0.5);
    display: none;  /* 존재하지만 보이지않음 */
    z-index: 1000; /* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
    /* static(브라우저에게 외주), relative(static한 상태에서 내가 조금 조정할게)
        absolute(내가 다 할게, 기준점 브라우저 왼쪽상단 모서리), fixed(고정좌표),
        $$ 부모 relative, 자식 absolute (자식의 기준점이 부모 왼쪽상단 모서리)
    */
}

#favoriteAddModalCont{
    margin: 20% auto;   /* 수평가운데 정렬 */
	width : 350px;
}

#favoriteListModalCont{
    margin: 12% auto;   
	width : 350px;
}

#inputFile{
	display: none;
}

input{
	font-size: 14px !important;
	color: black !important;
}

</style>

<c:set value="${drftDayCount }" var="drftNo"/> <!-- 기안번호 -->
<c:set value="등록" var="title"/>	<!-- 타이틀 -->
<c:set value="${employee.empName }" var="drftWriterName"/> <!-- 기안자명 -->
<c:set value="${employee.deptName }" var="drftWriterDeptName"/> <!-- 부서명 -->
<c:set value="${employee.position }" var="drftWriterPositionName"/> <!-- 직위 -->
<c:set value="" var="drftDate"/> <!-- 기안일 -->
<c:set value="${draftingForm.drftFormContent }" var="drftContent"/> <!-- 내용 -->

<c:if test="${status eq 'u' }"> <!-- 재기안 -->
	<c:set value="${draftingMap.drafting.drftContent }" var="drftContent"/> <!-- 내용 -->
</c:if>

<div class="content__header content__boxed overlapping">
    <div class="content__wrap">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/index">Home</a></li>
                <li class="breadcrumb-item"><a href="./main">전자결재</a></li>
                <li class="breadcrumb-item active" aria-current="page">전자결재 ${title }</li>
            </ol>
        </nav>
        <!-- END : Breadcrumb -->
		<br/>	
		<br/>	
    </div>
</div>

<div class="content__boxed">
    <div class="content__wrap">
		<form action="/drafting/insert" method="post" id="draftingForm" enctype="multipart/form-data">
			<c:if test="${status ne 'u' }">
				<input type="hidden" id="drftFormNo" name="drftFormNo" value="${drftFormNo }"> <!-- 결재 양식 번호 히든 -->
			</c:if>
			<c:if test="${status eq 'u' }">
				<input type="hidden" id="drftFormNo" name="drftFormNo" value="${draftingMap.drafting.drftFormNo }"> <!-- 결재 양식 번호 히든 -->
			</c:if>
	        
	        <!-- 결재폼, 사이드바 옆으로 정렬 -->
	        <div class="d-flex gap-4">
	        	<!-- 결재폼 시작 -->
			    <div class="card">
			        <div class="d-md-flex gap-4">
			            <div class="card-body" style="max-width: 950px; text-align: center;">
				            <div style="font-size: 30px; color: black; font-weight: bold;">
					            <c:if test="${status ne 'u' }">
					                ${draftingForm.drftFormName}
					            </c:if>
					            <c:if test="${status eq 'u' }">
					                ${draftingMap.drafting.drftFormName}
					            </c:if>
				            </div>
				            <br/>
							<table border="1" id="drftTable">
								<tbody>
									<tr>
										<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">기안번호</span></strong></td>
										<td><input class="form-control" type="text" id="drftNo" name="drftNo" readonly="readonly" value="${drftNo }"></td>
									</tr>
									<tr>
										<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">기안자</span></strong></td>
										<td><input class="form-control" type="text" id="drftWriterName" name="drftWriterName" readonly="readonly" value="${drftWriterName }"></td>
									</tr>
									<tr>
										<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">부서</span></strong></td>
										<td><input class="form-control" type="text" id="drftWriterDeptName" name="drftWriterDeptName" readonly="readonly" value="${drftWriterDeptName }"></td>

									</tr>
									<tr>
										<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">직위</span></strong></td>
										<td><input class="form-control" type="text" id="drftWriterPositionName" name="drftWriterPositionName" readonly="readonly" value="${drftWriterPositionName }"></td>
									</tr>
									<tr>
										<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">기안일</span></strong></td>
										<td><input class="form-control" type="text" id="drftDate" readonly="readonly" value="${drftDate }"></td>
									</tr>
									<tr>
										<td style="background-color:#dddddd; height:40px; text-align:center; width:100px; color:#000000;"><strong><span style="font-size:14px">제목</span></strong></td>
										<c:choose>
											<c:when test="${draftingForm.drftFormName eq '출장신청서'}">
												<td><input class="form-control" type="text" id="drftTitle" name="drftTitle" placeholder="출장신청서(00000000)" value="${draftingMap.drafting.drftTitle }"></td>
											</c:when>
											<c:when test="${draftingForm.drftFormName eq '휴가신청서'}">
												<td><input class="form-control" type="text" id="drftTitle" name="drftTitle" placeholder="휴가신청서(00000000)" value="${draftingMap.drafting.drftTitle }"></td>
											</c:when>
											<c:otherwise>
												<td><input class="form-control" type="text" id="drftTitle" name="drftTitle" placeholder="제목을 입력하세요" value="${draftingMap.drafting.drftTitle }"></td>
											</c:otherwise>
										</c:choose>

									</tr>
								</tbody>
							</table>
								
							<br/>
							<div class="form-group">
								<textarea id="drftContent" name="drftContent" class="form-control" rows="14">${drftContent }</textarea>
							</div>
							<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
					   			<button type="button" id="insertBtn" class="btn btn-success fw-bold" style="font-size: 16px;" >${title }</button>
							
							<c:if test="${status ne 'u' }">
					   			<button type="button" id="listBtn" class="btn btn-danger fw-bold" style="font-size: 16px;">목록</button>
							</c:if>				   			
							<c:if test="${status eq 'u' }">
					   			<button type="button" id="cancelBtn" class="btn btn-danger fw-bold" style="font-size: 16px;">취소</button>
							</c:if>	
							
							
							<c:if test="${draftingForm.drftFormName eq '업무기안서'}">
								<button type="button" id="presentationBtnWork" class="btn btn-info fw-bold" style="font-size: 16px;">업무기안 시연</button>
							</c:if>
							<c:if test="${draftingForm.drftFormName eq '휴가신청서'}">
								<button type="button" id="presentationBtnVacation" class="btn btn-info fw-bold" style="font-size: 16px;">휴가신청 시연</button>
							</c:if>
							<c:if test="${draftingForm.drftFormName eq '프로젝트생성신청서'}">
								<button type="button" id="presentationBtnProject" class="btn btn-info fw-bold" style="font-size: 16px;">프로젝트 시연</button>
							</c:if>
							<c:if test="${draftingMap.drafting.drftFormName eq '품의서'}">
								<button type="button" id="presentationBtnExpense" class="btn btn-info fw-bold" style="font-size: 16px;">재기안 시연</button>
							</c:if>
										   			
							</div>
						</div>
					</div>					
		        </div>					
				<!-- 결재폼 끝 -->		
						
				<!-- 전자결재 사이드바  시작 -->
				<div class="card" style="min-width: 400px;">
		            <div class="d-md-flex gap-4">
						<div class="card-body d-flex justify-content-center">
		                    <div class="w-md-300px w-xl-350px flex-shrink-0 mb-3" style="min-width: 340px;">
		                        <!-- 결재자 추가 버튼 시작 -->
		                        <div class="row align-items-center">
								    <div class="col-auto">
								        <p class="h3 my-3 fw-bold" style="margin-right: 20px">결재선</p>
								    </div>
								    <div class="col-auto" style="margin-left: 22%;">
								        <button type="button" class="btn btn-lg btn-secondary hstack gap-2" onclick="jsTreeModalOpen()" style="min-width: 160px;">
								            <i class="demo-pli-add-user fs-5 me-2"></i>
								            <span class="vr"></span>
								            <div class="fw-bold">결재자 선택</div>
								        </button>
								    </div>
								</div>
	
		                        <!-- 결재자 추가 버튼 끝 -->
		                       	<div class="table-responsive">
					                <table class="table table-striped" id="approvalTable">
					                    <thead>
					                        <tr>
					                        	<th style="width:50px">순번</th>
					                            <th style="width:90px;">결재자명</th>
					                            <th style="width:90px;">직위</th>
					                            <th style="width:90px;">부서</th>
					                        </tr>
					                    </thead>
					                    <tbody id="approval">
					                    	<c:choose>
						                    	<c:when test="${status eq 'u' }">
						                    		<c:forEach items="${draftingMap.approvalList }" var="approval">
						                    			<tr>
															<td><input type="text" id="apprvOrder" name="approvalList[${approval.apprvOrder - 1 }].apprvOrder" value="${approval.apprvOrder }" readonly="readonly" style="background-color:#ffffff;" class="form-control"/></td>
															<td><input type="hidden" id="empNo" name="approvalList[${approval.apprvOrder - 1 }].empNo" value="${approval.empNo }" readonly="readonly" style="background-color:#ffffff;" class="form-control"/>
															<input type="text" id="empName" name="approvalList[${approval.apprvOrder - 1 }].apprvSignerName" value="${approval.apprvSignerName }" readonly="readonly" style="background-color:#ffffff;" class="form-control"/></td>
															<td><input type="text" id="apprvSignerPositionName" name="approvalList[${approval.apprvOrder - 1 }].apprvSignerPositionName" value="${approval.apprvSignerPositionName }" readonly="readonly" style="background-color:#ffffff;" class="form-control"/></td>
															<td><input type="text" id="apprvSignerDeptName" name="approvalList[${approval.apprvOrder - 1 }].apprvSignerDeptName" value="${approval.apprvSignerDeptName }" readonly="readonly" style="background-color:#ffffff;" class="form-control"/></td>
														</tr> 
														<input type="hidden" id="apprvFinalYn" name="approvalList[${approval.apprvOrder - 1 }].apprvFinalYn" value="${approval.apprvFinalYn }"/>
						                    		</c:forEach>
						                    	</c:when>
						                    	<c:otherwise>
				                        			<tr>
				                        				<td class="fw-bold" colspan="4" style="padding: 12px 8px 12px 8px;">결재승인자를 추가해주세요.</td>                    			
			                        				</tr>
						                    	</c:otherwise>
					                    	</c:choose>
					                    </tbody>
					                </table>
					            </div>
								<br/><br/><br/>
								
								
								<div class="row align-items-center">
								    <div class="col-auto">
								        <p class="h3 my-3 fw-bold">첨부파일</p>
								    </div>
								    <div class="col-auto" style="margin-left: 22%;">
										<label for="inputFile">
											<div class="btn btn-lg btn-info hstack gap-2 fw-bold">
												<i class="demo-pli-file-add fs-5 me-2"></i>
												<span class="vr"></span>
												 	 파일 업로드
											</div>
										</label>
								    </div>
								</div>
								
								
								<input type="file" id="inputFile" multiple="multiple"> 
		                   	 	<div class="uploadedList"></div>
		                   	 	
								<!-- 파일 출력 시작  -->
								<div class="table-responsive pb-4" id="fileTableDiv">
			                        <table class="table table-striped align-middle" id="fileTable">
			                            <thead>
			                                <tr>
			                                    <th class="w-100w">파일명</th>
			                                    <th class="text-center" style="width: 100px">크기</th>
			                                    <th class="text-center" style="width: 41px"></th>
			                                </tr>
			                            </thead>
			                            <tbody id="fileList">
											<tr id="noAttachmentMessage" style="display: none;">
		                           	 			<td class="fw-bold" colspan="3">첨부파일이 존재하지 않습니다.</td>
		                           	 		</tr>
											<c:forEach items="${draftingMap.draftingAttachList }" var="draftingAttach">
				                                <tr>
				                                	<td>
				                                		<div class="d-flex align-items-center position-relative">
					                 						<div class="flex-shrink-0 text-primary">
				                                                <i class="demo-psi-file-html fs-3"></i>
                                                            </div>
                                                            <div class="flex-grow-1 ms-2">
																<%-- <a href="${downloadURL }"> --%> 
																<a href="/downloadFile?savePath=${draftingAttach.drftFileSavepath }" class="file-original-name"> 
						                                			${draftingAttach.drftFileName }
						                                		</a>
                                                            </div>
                                                        </div>
				                                	</td>
				                                	<td class="text-center">
				                                		${draftingAttach.drftFileFancysize }
				                                	</td>
				                                	<td>
				                                		<button type="button" class="btn btn-icon btn-danger btn-xs rounded-circle attachmentFileDel">-</button>
				                                	</td>
				                                </tr>
											</c:forEach>
			                            </tbody>
									</table>
								</div>	
								<!-- 파일 출력 끝 -->
                   			</div>
						</div>		
		            </div>					
		        </div>	
                <!-- 전자결재 사이드바  끝 -->
			</div>
	        <!-- 결재폼, 사이드바 옆으로 정렬 끝 -->							
	        <sec:csrfInput/>
		</form>
    </div>
</div>


<!-- 조직도 모달  시작 -->
<div id="jsTreeModal">
	<div class="card" id="jsTreeModalCont">
		<div class="d-flex">
		<%@ include file="../org/orgChart.jsp" %>
		
		<div style="margin:60px 0px 0px 30px;">
			<p class="h3 my-3 fw-bold">결재승인자  &nbsp;
				<button id="favoriteBtn" type="button" class="btn btn-warning btn-icon btn-lg" onclick="favoriteAddModalOpen()">
                    <i class="demo-pli-add-user-star fs-5" style="margin: 0px 0px 3px 0px;"></i>
                </button> 
				<button id="bookmarkListBtn" type="button" class="btn btn-info btn-icon btn-lg" onclick="favoriteListModalOpen()">
                    <i class="demo-pli-star fs-5"></i>
                </button> 
               </p>
			<ul class="list-group border border-2" style="width:190px; height: 210px" id="signer">
            </ul>
		</div>
           
		</div>
		
		<div class="d-flex" style="margin: auto;">
		     <!-- 버튼 시작 -->
			<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
			    <button type="button" class="btn btn-success fw-bold" style="font-size: 16px; margin-right: 10px;" onclick="jsTreeModalAdd()">등록</button>
			</div>
			<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
			    <button type="button" class="btn btn-danger fw-bold" style="font-size: 16px;" onclick="jsTreeModalClose()">닫기</button>
			</div>
		</div>
        <!-- 버튼 끝 -->
	</div>
</div>
<!-- 조직도 모달 끝 -->

<!-- 즐겨찾기 저장 모달창 시작  -->
<div id="favoriteAddModal">
	<div class="col-md-6 mb-3" id="favoriteAddModalCont">
	    <div class="card">
	        <div class="card-body">
	            <h5 class="card-title fw-bold">개인결재선 저장</h5>
	            	 결재선 이름  &nbsp;&nbsp;&nbsp;<input type="text" id="favoriteAddCont" name="favoriteAddCont">
	            <!-- 버튼 시작 -->
				<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
				    <button type="button" class="btn btn-success fw-bold" style="font-size: 16px;" id="favoriteAddModalBtn">저장</button>
				    <button type="button" class="btn btn-light  fw-bold" style="font-size: 16px;" onclick="favoriteAddModalClose()">닫기</button>
				</div>
	            <!-- 버튼 끝 -->
	        </div>
	    </div>
	</div>
</div>
<!-- 즐겨찾기 저장 모달창 끝  -->

<!-- 즐겨찾기 리스트 모달창 시작  -->
<div id="favoriteListModal">
	<div class="col-md-6 mb-3" id="favoriteListModalCont">
	    <div class="card">
	        <div class="card-body" style="height: 450px;">
	            <h5 class="card-title fw-bold">개인 결재선 리스트</h5>
	            	 <table class="table table-striped align-middle" id="favoriteListTable">
	            	 	<thead>
	            	 		<tr>
	            	 			<th style="width: 85%;">
	            	 			</th>
	            	 			<th>
	            	 			</th>
	            	 		</tr>
	            	 	</thead>
	            	 	<tbody id="favoriteListTbody">
	            	 		<tr id="noBookmarkMessage" style="display: none;">
		                    	<td colspan="2">저장한 개인 결재선이 존재하지 않습니다.</td>
		                    </tr>
	            	 		<c:forEach items="${approvalBookmarkList }" var="approvalBookmark">
	            	 			<tr>
		            	 			<td>
	                                	<a href="#" id="${approvalBookmark.apprvBookmarkNo }">
	                                		${approvalBookmark.apprvBookmarkName }
	                                	</a>
		            	 			</td>
		            	 			<td>
		            	 				<button type="button" class="btn btn-icon btn-danger btn-xs rounded-circle bookmarkListDel">-</button>
		            	 			</td>
	            	 			</tr>
                       		</c:forEach>
	            	 	</tbody>
	            	 </table>
	            <!-- 버튼 시작 -->
				<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
				    <button type="button" class="btn btn-light  fw-bold" style="font-size: 16px;" onclick="favoriteListModalClose()">닫기</button>
				</div>
	            <!-- 버튼 끝 -->
	        </div>
	    </div>
	</div>
</div>
<!-- 즐겨찾기 리스트 모달창 끝  -->



<script>
// 전역변수 (모달 <-> 폼)
var selectedNodes = [];	// 모달에서 선택된 결재자들 정보 {id: '2377001', name: '강진석', position: '사원', div: '인사부'}
var signer;	// 결재승인자모달 Element (add에서 사용)
var ajaxData = [];	// 파일 정보
	
$(function (){	// $function 시작
// ck에디터
    CKEDITOR.replace("drftContent", {
        filebrowserUploadUrl: '/imageUpload?${_csrf.parameterName}=${_csrf.token}'
    });
    
    CKEDITOR.config.height = "600px"; // CKEDITOR 높이 설정
    CKEDITOR.config.width = "100%"; // CKEDITOR 너비 설정
    CKEDITOR.config.versionCheck = false;
    
	var inputFile = $("#inputFile");	// 파일선택 Element
	var insertBtn = $("#insertBtn");// 등록 버튼 Element
	var listBtn = $("#listBtn");	// 목록 버튼 Element
	var cancelBtn = $("#cancelBtn");	// 취소 버튼 Element
	var draftingForm = $("#draftingForm");	// 폼 Element
	var favoriteAddModalBtn = $("#favoriteAddModalBtn"); // 즐겨찾기 Element
	var favoriteListTbody = $("#favoriteListTbody");
	
	// 시연용
	var presentationBtnWork = $("#presentationBtnWork");
	var presentationBtnVacation = $("#presentationBtnVacation");
	var presentationBtnProject = $("#presentationBtnProject");
	var presentationBtnExpense = $("#presentationBtnExpense");
	var drftTitle = $("#drftTitle");
	var drftContent = $("#drftContent");
	
	
	
	if($("#favoriteListTable tbody tr").length == 1){
		$("#noBookmarkMessage").show();
	}
	
	// 파일 불러오기
	var status = "${status}";
	
	console.log("상태:", status);
	console.log("jsonDraftingAttachList:", jsonDraftingAttachList);

	
	if (status == 'u') {
		if('${jsonDraftingAttachList}' != null){
		
		var jsonDraftingAttachList = '${jsonDraftingAttachList}';
		// JSON 문자열을 JavaScript 객체로 변환
		var parsedDraftingAttachList = JSON.parse(jsonDraftingAttachList);
		// 이제 parsedDraftingAttachList는 배열이므로 forEach를 사용할 수 있습니다.
		parsedDraftingAttachList.forEach(function (attachment) {
		    // attachment에서 필요한 필드를 추출하여 객체로 만듭니다.
		    var attachmentData = {
		        originalName: attachment.drftFileName,
		        fileSize: attachment.drftFileSize,
		        fancySize: attachment.drftFileFancysize,
		        mime: attachment.drftFileMime,
		        dbPath: attachment.drftFileSavepath
		    };

		    // ajaxData 배열에 추가
		    ajaxData.push(attachmentData);
		});

		// ajaxData 배열을 콘솔에 출력
		console.log("ajaxData:", ajaxData);
		}
	}
	
	
	// insertBtn.on 시작
	insertBtn.on("click", function(){
		
		var drftTitle =  $("#drftTitle").val();

		if(drftTitle == null || drftTitle == ""){
			Swal.fire({
	        	icon: 'error',
	        	title: '미입력',
	        	text: '제목 혹은 내용을 입력해주세요!'
	        });
			return false;
		};			
	
				
		var approvalTable = $("#approval"); // 결재자 테이블
		var approvalRows = approvalTable.find("tr"); // 테이블 내의 행(tr) 요소들을 선택
		
		if(approvalRows.length === 1 && approvalRows.find("td").hasClass("fw-bold")){
	    	Swal.fire({
	        	icon: 'error',
	        	title: '미등록',
	        	text: '결재자는 1명 이상 등록해야합니다.'
	        });
	    	return false;
	    };
	    
	    
	    if(status == "u"){
			draftingForm.attr("action", "/drafting/resurgence");
		}
	    
		Swal.fire({
			icon: 'warning',
			title: '결재 ${title}',
			text: '결재를 ${title}하시겠습니까?',
			
		 	showCancelButton: true, // cancel버튼 보이기. 기본은 원래 없음
		   	confirmButtonColor: '#3085d6', // confrim 버튼 색깔 지정
		   	cancelButtonColor: '#d33', // cancel 버튼 색깔 지정
		   	confirmButtonText: '등록', // confirm 버튼 텍스트 지정
		   	cancelButtonText: '취소' // cancel 버튼 텍스트 지정
		   
		}).then(result => {
			   // 만약 Promise리턴을 받으면,
			   if (result.isConfirmed) { // confirm 버튼을 눌렀다면
				   draftingForm.submit();		   		
	        	}
		});
		
		
	}); // insertBtn.on 끝
	
	// 목록버튼
	listBtn.on("click", function(){
		location.href = "/drafting/main";
	})
	
	// 취소 버튼
	cancelBtn.on("click", function(){
		location.href = "/drafting/detail?drftNo=${draftingMap.drafting.drftNo}";
	});
	
	// 기안 파일을 변경했을때 이벤트 발동
    inputFile.on("change", function(event){
    	console.log("change...!");
    	
    	var files = event.target.files;
    	var fileList = $("#fileList");	// 파일 출력구간
    	
    	// 첨부 파일이 추가될 때 메시지를 숨기기
        $("#noAttachmentMessage").hide();
    	
    	for(var i=0; i<files.length; i++){
			var file = files[i];
			console.log(file);
			
			var formData = new FormData();
			formData.append("drftNo", drftNo.value); // drftNo 추가
			formData.append("file", file);
			
			
			$.ajax({
				type : "post",
				url : "/drafting/uploadAjax",
				data : formData,
				dataType : 'json',
				processData : false,
				contentType : false,
				beforeSend : function(xhr){
					xhr.setRequestHeader(header, token); // 메인 내비게이터
					//xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
				}, 
				success : function(data){
					console.log(data);	// 넘긴 데이터 그대로
					console.log(data.mime);	// 파일 확장자명
					console.log(data.drftNo);	// 기안번호
					console.log(data.originalName);	// 원본파일명
					console.log(data.fileSize);	// 파일 사이즈 byte
					console.log(data.fancySize);	// 사이즈 변환 (KB)
					console.log(data.dbPath);	// 사이즈 변환 (KB)
					
					ajaxData.push(data);
					
					var str = "";
					// 다음 라인을 수정하여 각 파일에 대한 테이블 행을 동적으로 생성
                    str = '<tr>';
					str += '<td>';
					str += '<div class="d-flex align-items-center position-relative">';
					str += '<div class="flex-shrink-0 text-primary">';
					str += '<i class="demo-psi-file-html fs-3"></i>';
					str += '</div>';
					str += '<div class="flex-grow-1 ms-2">';
					str += '<a href="/downloadFile?savePath=' + data.dbPath + '" class="file-original-name">' + data.originalName + '</a>';
					str += '</div>';
					str += '</div>';
					str += '</td>';
					str += '<td class="text-center">' + data.fancySize + '</td>'; // 여기에 파일 크기를 동적으로 추가하도록 수정
					str += '<td>';
					str += '<button type="button" class="btn btn-icon btn-danger btn-xs rounded-circle attachmentFileDel">-</button>';
					str += '</td>';
					str += '</tr>';

                    fileList.append(str);
					
                    console.log(ajaxData);
				}
			});	// $.ajax
		}
    }); // inputFile.on
    
     
    
	// 파일 삭제 버튼 누르면
	$("#fileList").on("click", ".attachmentFileDel", function(){
		var row = $(this).closest("tr"); // 클릭된 버튼이 속한 행을 가져오기
	    // var originalName = row.find(".file-original-name").text(); // 파일 원본 이름 가져오기
		var originalName = row.find(".file-original-name").text().trim(); // 파일 원본 이름 가져오기
	    
	    console.log(ajaxData);
	    // ajaxData 배열에서 originalName과 일치하는 데이터 찾기
	    var dataIndex = -1;
	    
	    for (var i = 0; i < ajaxData.length; i++) {
	        if (ajaxData[i].originalName === originalName) {
	            dataIndex = i;
	            break;
	        }
	    }
	    
	    if (dataIndex !== -1) {
	        ajaxData.splice(dataIndex, 1); // 해당 데이터를 배열에서 제거
	    }
	    
	    row.remove();
		
		// $(this).parents("tr").remove();
	    if ($(".attachmentFileDel").length == 0) {
	        $("#noAttachmentMessage").show();
	    }
	});
    
    // 첨부 파일이 하나도 남지 않았을 때 메시지를 보여주기
    if (ajaxData.length === 0) {
        $("#noAttachmentMessage").show();
    }
	
	// form
 	draftingForm.submit(function(event){
		// form 태그의 submit 이벤트를 block
		event.preventDefault();
		
		var that = $(this);	// 현재 발생한 form태그
		var str = "";
		
		// ajaxData 배열에 있는 데이터 활용
	    $.each(ajaxData, function(index, data) {
	        // data 활용
	        console.log(data);
	        
	     	// hidden input을 생성하여 form에 추가
	        str += '<input type="hidden" name="draftingAttachList[' + index + '].drftFileName" value="' + data.originalName + '" />';
	        str += '<input type="hidden" name="draftingAttachList[' + index + '].drftFileSize" value="' + data.fileSize + '" />';
	        str += '<input type="hidden" name="draftingAttachList[' + index + '].drftFileFancysize" value="' + data.fancySize + '" />';
	        str += '<input type="hidden" name="draftingAttachList[' + index + '].drftFileMime" value="' + data.mime + '" />';
	        str += '<input type="hidden" name="draftingAttachList[' + index + '].drftFileSavepath" value="' + data.dbPath + '" />';
	    });
		
		that.append(str);
		console.log("str : ", str);
		// form의 첫번째를 가져와서 submit() 처리
		// get() 함수는 여러개중에 1개를 찾을때 (form태그가 1개이긴 하지만 여러개 중에 1개를 찾을때도 활용함)
		that.get(0).submit();		
	});

	// favoriteAddModalBtn 시작
 	favoriteAddModalBtn.on("click", function(){
 		var favoriteAddContValue = $("#favoriteAddCont").val().trim();
		// var dropdownBookmark = $("#dropdownBookmark");
		var str = "";
 		var noBookmarkMessage = $("#noBookmarkMessage");
		
 		console.log("favoriteAddContValue:", favoriteAddContValue); // 디버깅을 위한 출력
 		
 		if (!favoriteAddContValue) {
	        Swal.fire({
	            icon: 'error',
	            title: '미등록',
	            text: '저장할 결재선 이름을 입력해주세요.'
	        });
	        return;
 		 };
 		  
 		if(selectedNodes.length == 0){
 	    	Swal.fire({
 	        	icon: 'error',
 	        	title: '미등록',
 	        	text: '결재자는 1명 이상 등록해야합니다.'
 	        });
 	    	return;
		};
		
		// 선택된 노드 정보를 data 객체에 추가
 		var sendData = {
			apprvBookmarkName: favoriteAddContValue,
			empNoList: selectedNodes.map(node => node.id)
		};
		
		$.ajax({
			type : "post",
			url : "/drafting/favoriteAddAjax",
			data : JSON.stringify(sendData),
			contentType : "application/json;charset=utf-8",
			beforeSend : function(xhr){
				xhr.setRequestHeader(header, token); // 메인 내비게이터
				//xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			}, 
			success : function(data){
				console.log(data);	// 넘긴 데이터 그대로
				favoriteAddModalClose();
				
				Swal.fire({
		        	icon: 'success',
		        	title: '등록',
		        	text: '개인 결재선이 저장되었습니다.'
		        });
				
				str += '<tr>';
				str += '<td>';
				str += '<a href="#" id="' + data.bookmarkNo + '" class=>';
				str += data.bookmarkName;
				str += '</a>';
				str += '</td>';
				str += '<td>';
				str += '<button type="button" class="btn btn-icon btn-danger btn-xs rounded-circle bookmarkListDel">-</button>';
				str += '</td>';
				str += '</tr>';
					
				favoriteListTbody.append(str);
				
				noBookmarkMessage.hide();
				
			}
		});	// $.ajax
 	}); // favoriteAddModalBtn 끝
 	
 	// 개인 결재선 선택 시작
 	$("#dropdownBookmark").on("click", "li", function(){
 		var bookmarkNo = $(this).attr("id");
 		var approval = $("#approval");	// 결재자 출력구간
 		var str = "";
 		
 		console.log("Clicked Bookmark ID:", bookmarkNo);
 		
 		sendData = {
 			apprvBookmarkNo : bookmarkNo
 		};
 		
 		$.ajax({
 			type : "post",
			url : "/drafting/searchBookmarkList",
			data : JSON.stringify(sendData),
			contentType : "application/json;charset=utf-8",
			beforeSend : function(xhr){
				xhr.setRequestHeader(header, token); // 메인 내비게이터
				//xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			}, 
			success : function(data){
				console.log(data);
				
				$.each(data, function(order, emp){
					str += '<tr>';
					str += '<td><input type="text" id="apprvOrder" name="approvalList[' + order + '].apprvOrder" value="' + (order+1) + '" readonly="readonly" class="form-control"/></td>';
					str += '<td><input type="hidden" id="empNo" name="approvalList[' + order + '].empNo" value="' + emp.empNo + '" readonly="readonly" class="form-control"/>';
					str += '<input type="text" id="empName" name="approvalList[' + order + '].apprvSignerName" value="' + emp.empName + '" readonly="readonly" class="form-control"/></td>';
					str += '<td><input type="text" id="apprvSignerPositionName" name="approvalList[' + order + '].apprvSignerPositionName" value="' + emp.position + '" readonly="readonly" class="form-control"/></td>';
					str += '<td><input type="text" id="apprvSignerDeptName" name="approvalList[' + order + '].apprvSignerDeptName" value="' + emp.deptName + '" readonly="readonly" class="form-control"/></td>';
					str += '</tr>'; 
					str += '<input type="hidden" id="apprvFinalYn" name="approvalList[' + order + '].apprvFinalYn" value="' + (order + 1 == data.length ? 'Y' : 'N') + '">'; //마지막 결재승인자면 Y 아니면 N (hidden)
				});
				
				
				approval.empty();
				approval.append(str);
			}
 		});
 	});
	// 결재선 선택 끝
	
	// 개인 결재선 즐겨찾기 리스트 선택 시작
	$("#favoriteListTable tbody").on("click", "a", function(){
		// 클릭한 a 태그 id
	    var bookmarkNo = $(this).attr("id");
	    signer = $("#signer");
	    var str = "";
	    
	    console.log("Clicked Bookmark ID:", bookmarkNo);
	    
	    sendData = {
	 		apprvBookmarkNo : bookmarkNo
	 	};
	    
	    $.ajax({
	    	type : "post",
			url : "/drafting/searchBookmarkList",
			data : JSON.stringify(sendData),
			contentType : "application/json;charset=utf-8",
			beforeSend : function(xhr){
				xhr.setRequestHeader(header, token); // 메인 내비게이터
				//xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success : function(data){
				console.log(data);
				
				selectedNodes = [];  // 즐겨찾기 불러올 때 빈 배열로 바꿈
				signer.empty();
				
				$.each(data, function(order, emp){
					
				// 모달에서 선택된 결재자들 정보 {id: '2377001', name: '강진석', position: '사원', div: '인사부'}
				// 선택된 노드 정보 배열에 추가
				selectedNodes.push({
					id: emp.empNo,
			        name: emp.empName,
			        position: emp.position,
			        div: emp.deptName
				});
				console.log(selectedNodes);
				
			 	var str = '<li class="list-group-item d-flex justify-content-between align-items-center" data-id="' + emp.empNo + '">' + emp.empName + ' ' + emp.position + 
			     	'<button type="button" class="btn btn-icon btn-danger btn-xs rounded-circle" onclick="removeSigner(this)">-</button></li>';

			   	signer.append(str);
				});
				
				
			    favoriteListModalClose();
			}
	    });
	});
	
	// 즐겨찾기 삭제 버튼 누르면
	$("#favoriteListTable").on("click", ".bookmarkListDel", function(){
		var row = $(this).closest("tr"); // 클릭된 버튼이 속한 행을 가져오기
		var noBookmarkMessage = $("#noBookmarkMessage");	    
	    
		// a 태그 안의 id 속성 값 가져오기
	    var aTagId = row.find("a").attr("id");
	
	    // a 태그 안의 value 값 가져오기
	    var aTagValue = row.find("a").text().trim();
	
	    // 가져온 값 확인 (콘솔에 출력)
	    console.log("ID: " + aTagId);
	    console.log("Value: " + aTagValue);
	
		var sendData = {
			apprvBookmarkNo : aTagId
		};

	    $.ajax({
	    	type : "post",
			url : "/drafting/deleteBookmark",
			data : JSON.stringify(sendData),
			contentType : "application/json;charset=utf-8",
			beforeSend : function(xhr){
				xhr.setRequestHeader(header, token);	// 메인 내비게이터
				//xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success : function(data){
				console.log(data);
				
				console.log($("#favoriteListTbody tr").length);

			 	// 행 삭제
			    row.remove();
				console.log($("#favoriteListTbody tr").length);
			 	
			 	// 남아있는 행이 없으면 noBookmarkMessage를 보여줌
			    if ($("#favoriteListTbody tr").length == 1) {
			        noBookmarkMessage.show();
			    }
			}

	    });

		
	});
	
	
	// 개인 결재선 즐겨찾기 리스트 선택 끝
 	
	// jstree select_node 커스텀(.bind는 include파일에 존재)
	jsTreeObj.on("select_node.jstree", function (event, data) {	
		// 부서 노드를 클릭한 경우 하위 노드 토글
		if(data.node.type === 'dept') {	
			jsTreeObj.jstree(true).toggle_node(data.node);
		} else if(data.node.type === 'employee') {	// 클릭한 노드가 사원일 경우
			processSelectNode(data.node);
		}
	});  //  jsTreeObj 끝
	
	
	// 업무기안 시연용 버튼
	presentationBtnWork.on("click", function(){	
		var strTitle = 'CGV 그룹웨어 고객사 대상 만족도 조사 이벤트 진행의 건';
		var strContent = `<table border="1" cellpadding="0" cellspacing="0" style="height:500px; width:800px">
							<tbody>
								<tr>
									<td style="background-color:#dddddd; height:40px; text-align:center; width:100px"><span style="font-size:14px"><strong>시행일자</strong></span></td>
									<td style="height:40px; text-align:center; width:200px">2024년 02월 19일</td>
									<td style="background-color:#dddddd; height:40px; text-align:center; width:100px"><span style="font-size:14px"><strong>협조부서</strong></span></td>
									<td style="height:40px; text-align:center; width:400px">영업부, 인사부</td>
								</tr>
								<tr>
									<td colspan="4" style="background-color:#dddddd; height:40px; text-align:center"><span style="font-size:14px"><strong>기안 내용</strong></span></td>
								</tr>
								<tr>
									<td colspan="4" style="height:400px; text-align:left; vertical-align:top; width:800px">
									<p>&#39;CGV그룹웨어&nbsp;고객사 대상 만족도 조사 이벤트 진행의 건&#39;과 관련하여 다음과 같이 진행하고자 하오니 결재하여 주시기&nbsp;바랍니다.&nbsp;</p>
						
									<p>&nbsp;</p>
						
									<p>-다 음-</p>
						
									<p><strong>&nbsp;1. 목적 :</strong>&nbsp;정기레터를 통해 CGV그룹웨어를 사용중인 고객사를 대상으로 고객만족도 조사 진행 (기능/편의성/솔루션 연동/고객지원/기술지원 등의 만족도 조사)</p>
						
									<p><strong>&nbsp;2. 기간 :&nbsp;2024년 02월 19일(월) ~ 2024년 02월 23일(금)</strong></p>
						
									<p><strong>&nbsp;3. 대상 : </strong>CGV그룹웨어 클라우드형/설치형 고객사&nbsp;</p>
						
									<p><strong>&nbsp;4. 진행 :&nbsp;</strong>고객만족도 참여한 고객사 중 100명을 선정하여 커피 모바일 쿠폰 발송&nbsp;</p>
						
									<p><strong>&nbsp;5. 첨부 :&nbsp;</strong>정기레터 시안 (설치형/클라우드형 각 1부)</p>
									</td>
								</tr>
							</tbody>
						</table>`;
				
				
		drftTitle.val(strTitle);
		CKEDITOR.instances.drftContent.setData(strContent);
		
	});
	
	
	// 휴가신청서 시연용 버튼
	presentationBtnVacation.on("click", function(){
		var strTitle = '휴가신청서(20240219)';
		var strContent = `<table border="1" cellpadding="0" cellspacing="0" style="height:500px; width:800px">
							<tbody>
								<tr>
									<td style="background-color:#dddddd; height:40px; text-align:center; width:100px"><span style="font-size:14px"><strong>기간 및 일시</strong></span></td>
									<td style="height:40px; text-align:center; width:700px">2024년 02월 19일&nbsp; ~&nbsp; 2024년 02월 19일</td>
								</tr>
								<tr>
									<td colspan="2" style="background-color:#dddddd; height:40px; text-align:center; width:800px"><span style="font-size:14px"><strong>휴가 사유</strong></span></td>
								</tr>
								<tr>
									<td colspan="2" style="height:340px; width:800px">
									<p><strong>1. 신청사유 :&nbsp;</strong>가족여행</p>
					
									<p><strong>2. 동행인원 : </strong>부모님, 동생</p>
					
									<p><strong>3. 여행장소 : </strong>제주도</p>
					
									<p><strong>4. 비상연락처 :</strong> 어머니 010-1234-5678</p>
					
									<p><strong>5. 첨부 : </strong>예약내역(1부)</p>
					
									<p>&nbsp;</p>
					
									<p>본인은 위와 같은 사유로 신청서를 제출하오니 허락하여 주시기 바랍니다.</p>
									</td>
								</tr>
							</tbody>
						</table>`;
				
		drftTitle.val(strTitle);
		CKEDITOR.instances.drftContent.setData(strContent);
	});
	
	// 프로젝트 생성신청서 시연용 버튼
	presentationBtnProject.on("click", function(){
		var strTitle = '항공예약 시스템 프로젝트 생성 신청의 건';
		var strContent = `<table border="1" cellpadding="0" cellspacing="0" style="height:500px; width:800px">
							<tbody>
								<tr>
									<td style="background-color:#dddddd; height:40px; text-align:center; width:100px"><span style="font-size:14px"><strong>프로젝트명</strong></span></td>
									<td colspan="3" rowspan="1" style="height:40px; width:700px">&nbsp;항공예약 시스템</td>
								</tr>
								<tr>
									<td style="background-color:#dddddd; height:40px; text-align:center; width:100px"><span style="font-size:14px"><strong>리더명</strong></span></td>
									<td colspan="3" rowspan="1" style="height:40px; width:700px">&nbsp;김민채 과장</td>
								</tr>
								<tr>
									<td colspan="1" rowspan="10" style="background-color:#dddddd; height:400px; text-align:center; width:100px">
									<p><span style="font-size:14px"><strong>프로젝트</strong></span></p>
					
									<p><span style="font-size:14px"><strong>구성원</strong></span></p>
									</td>
									<td style="background-color:#dddddd; height:40px; text-align:center; width:230px"><span style="font-size:14px"><strong>부서</strong></span></td>
									<td style="background-color:#dddddd; height:40px; text-align:center; width:230px"><span style="font-size:14px"><strong>직급</strong></span></td>
									<td style="background-color:#dddddd; height:40px; text-align:center; width:230px"><span style="font-size:14px"><strong>이름</strong></span></td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">개발부</td>
									<td style="height:35px; width:230px">부장</td>
									<td style="height:35px; width:230px">정소현</td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">개발부</td>
									<td style="height:35px; width:230px">과장</td>
									<td style="height:35px; width:230px">김민채</td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">개발부</td>
									<td style="height:35px; width:230px">차장</td>
									<td style="height:35px; width:230px">서강민</td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">개발부</td>
									<td style="height:35px; width:230px">사원</td>
									<td style="height:35px; width:230px">장원영</td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">개발부</td>
									<td style="height:35px; width:230px">사원</td>
									<td style="height:35px; width:230px">김민지</td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">&nbsp;</td>
									<td style="height:35px; width:230px">&nbsp;</td>
									<td style="height:35px; width:230px">&nbsp;</td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">&nbsp;</td>
									<td style="height:35px; width:230px">&nbsp;</td>
									<td style="height:35px; width:230px">&nbsp;</td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">&nbsp;</td>
									<td style="height:35px; width:230px">&nbsp;</td>
									<td style="height:35px; width:230px">&nbsp;</td>
								</tr>
								<tr>
									<td style="height:35px; width:230px">&nbsp;</td>
									<td style="height:35px; width:230px">&nbsp;</td>
									<td style="height:35px; width:230px">&nbsp;</td>
								</tr>
							</tbody>
						</table>`;
				
		drftTitle.val(strTitle);
		CKEDITOR.instances.drftContent.setData(strContent);
	});
	
	// 품의서 재기안 버튼
	presentationBtnExpense.on("click", function(){
		var strTitle = 'PC 구매 및 설치 재기안';
		var strContent = `<table border="1" cellpadding="0" cellspacing="0" style="height:500px; width:800px">
							<tbody>
								<tr>
									<td style="background-color:#dddddd; height:330px; text-align:center; width:100px">
									<p><strong><span style="font-size:14px">품의 사유</span></strong></p>
					
									<p><strong><span style="font-size:14px">및</span></strong></p>
					
									<p><strong><span style="font-size:14px">상세 내역</span></strong></p>
									</td>
									<td style="height:330px; width:700px">
									<p>업무의 효율성 제고를 위하여 PC 구매 및 설치를 아래와 같이 진행하고자 하오니 검토 후 재가하여 주시기 바랍니다.</p>
					
									<p>&nbsp;</p>
					
									<p>-다 음-&nbsp;</p>
					
									<p><strong>1. 목적 :&nbsp;</strong>현재 기록업무를 A4시트에 수작업으로 기록하고 있는 바&nbsp;기본 DATA 가공에 어려움이 있으며 기록 후 정리작업에 과다한 시간이 소요되고 있으므로 기초 DATA 입력을 전산화시킴으로서 업무시간 단축 및 후속 업무의 효율성을 제고하고자 함.</p>
					
									<p>&nbsp;</p>
					
									<p><strong>2. 첨부 :&nbsp;</strong>PC견적 (1부)</p>
									</td>
								</tr>
								<tr>
									<td style="background-color:#dddddd; height:70px; text-align:center; width:100px"><strong><span style="font-size:14px">예상 비용</span></strong></td>
									<td style="height:70px; width:700px">&nbsp;&#8361; 1,000,000&nbsp;</td>
								</tr>
								<tr>
									<td style="background-color:#dddddd; height:100px; text-align:center; width:100px"><strong><span style="font-size:14px">비&nbsp; &nbsp;고</span></strong></td>
									<td style="height:100px; width:700px">&nbsp;재기안 요청입니다.</td>
								</tr>
							</tbody>
						</table>`;
				
		drftTitle.val(strTitle);
		CKEDITOR.instances.drftContent.setData(strContent);
	});
	
	
}); // $function 끝 -------------------------------


// 작성일 등록(등록 시에만)
var currentDate = new Date();
var formattedDate = currentDate.toISOString().split('T')[0];
var drftDateElement = document.getElementById('drftDate');
if (!drftDateElement.value) {
    drftDateElement.value = formattedDate;
}

//모달창 스크립트 시작 
// 결재승인자 모달 열기
function jsTreeModalOpen(){
	jsTreeModal.style.display = "block";  // none을 block으로 모달창 출력
}

// 결재승인자 모달 닫기
function jsTreeModalClose(){
	jsTreeModal.style.display = "none";    // block을 non으로 변경해서 모달창 닫기
	jsTreeObj.jstree("close_all");
	selectedNodes = [];  // 배열 안 데이터 제거
	signer.empty();		// 모달 안 결재자 리스트 제거
}

// 결재승인자 즐겨찾기 모달 열기
function favoriteAddModalOpen(){
	favoriteAddModal.style.display = "block";
}

// 결재승인자 즐겨찾기 모달 닫기
function favoriteAddModalClose(){
	$("#favoriteAddCont").val(''); // input text 값을 비움
	favoriteAddModal.style.display = "none";
}

// 결재승인자 즐겨찾기 리스트 열기
function favoriteListModalOpen(){
	favoriteListModal.style.display = "block";
}

// 결재승인자 즐겨찾기 리스트 닫기
function favoriteListModalClose(){
	favoriteListModal.style.display = "none";
}



// 결재승인자 지우기
function removeSigner(button) {
	// 버튼 부모 (li 태그)
    var liElement = button.parentElement;
    liElement.remove();
    
 	// 지운 li와 일치하는 data-id 찾기
    var idToRemove = liElement.getAttribute('data-id');
    
    // selectedNodes 배열에서 해당 id를 가진 객체를 찾아 제거
    selectedNodes = selectedNodes.filter(function (node) {
        return node.id !== idToRemove;
    });
    
    console.log(selectedNodes);
}

// 결재자 등록
function jsTreeModalAdd(){
	var approval = $("#approval");	// 결재자 출력구간
	var str = "";
	console.log("selectedNodes", selectedNodes);
	
 	if(selectedNodes.length == 0){
    	Swal.fire({
        	icon: 'error',
        	title: '미등록',
        	text: '결재자는 1명 이상 등록해야합니다.'
        });
    	return;
    };
 
	$.each(selectedNodes, function(order, emp){
		console.log('order : ', order);
		console.log(emp.id);
		console.log(emp.name);
		console.log(emp.position);
		console.log(emp.div);
		
		
 		str += '<tr>';
		str += '<td><input type="text" id="apprvOrder" name="approvalList[' + order + '].apprvOrder" value="' + (order+1) + '" readonly="readonly" class="form-control"/></td>';
		str += '<td><input type="hidden" id="empNo" name="approvalList[' + order + '].empNo" value="' + emp.id + '" readonly="readonly" class="form-control"/>';
		str += '<input type="text" id="empName" name="approvalList[' + order + '].apprvSignerName" value="' + emp.name + '" readonly="readonly" class="form-control"/></td>';
		str += '<td><input type="text" id="apprvSignerPositionName" name="approvalList[' + order + '].apprvSignerPositionName" value="' + emp.position + '" readonly="readonly" class="form-control"/></td>';
		str += '<td><input type="text" id="apprvSignerDeptName" name="approvalList[' + order + '].apprvSignerDeptName" value="' + emp.div + '" readonly="readonly" class="form-control"/></td>';
		str += '</tr>'; 
		str += '<input type="hidden" id="apprvFinalYn" name="approvalList[' + order + '].apprvFinalYn" value="' + (order + 1 == selectedNodes.length ? 'Y' : 'N') + '">'; //마지막 결재승인자면 Y 아니면 N (hidden)
	console.log(order+1, "/", selectedNodes.length);
	});
	approval.empty();
	approval.append(str);
	
	
	
//	console.log(selectedNodes);
	
	jsTreeModalClose();	// 모달 닫기
	
	selectedNodes = [];  // 배열 안 데이터 제거
	signer.empty();		// 모달 안 결재자 리스트 제거
	
}

function processSelectNode(node){
	var text = node.text; // 사원 객체 '홍길동 사원'
    var textArray = text.split(' '); // '홍길동 사원'
	var parentNode = jsTreeObj.jstree(true).get_node(node.parent);
    var maxSignerCount = 5; // 최대 허용되는 signer li 개수
    signer = $("#signer");	// 전역변수
    var signerItems = signer.find('.list-group-item'); // 결재자 li개수 찾기
    
	console.log(node.id, node.text, parentNode.text);
    
    var id = node.id;	// 사번
    var name = textArray[0];	// '홍길동'
    var position = textArray[1];	// '사원'
	var div = parentNode.text;	// 부서()
	
	div = (typeof(div) === "undefined") ? '-' : div;
	
	// 중복 체크 및 처리
    var isDuplicate = false;
    signerItems.each(function () {
    	var trimmedText = $(this).text().trim();
    	trimmedText = trimmedText.slice(0, -1); // 버튼 글자(-) 삭제
    	console.log("Trimmed Text:", trimmedText);
        console.log("text :", text);
        if(trimmedText === text) {
            isDuplicate = true;
            return false; // 중복된 경우 반복문 종료
        }
    });
	
    if(isDuplicate) {
        Swal.fire({
        	icon: 'error',
        	title: '중복',
        	text: '이미 추가된 사원입니다.'
        });
        return; // 중복된 경우 종료
    }
    
    if(signerItems.length >= maxSignerCount){
    	Swal.fire({
        	icon: 'error',
        	title: '초과',
        	text: '결재자는 '+ maxSignerCount + '명까지만 등록할 수 있습니다.'
        });
    	return; // 5명 이상인 경우 종료
    }
		
	// 선택된 노드 정보 배열에 추가
	selectedNodes.push({
		id: id,
        name: name,
        position: position,
        div: div
	});
	console.log(selectedNodes);
	
 	var str = '<li class="list-group-item d-flex justify-content-between align-items-center" data-id="' + id + '">' + text +
     	'<button type="button" class="btn btn-icon btn-danger btn-xs rounded-circle" onclick="removeSigner(this)">-</button></li>';

   	signer.append(str);
	
}


// 모달창 스크립트 끝





</script>
  
            
            