<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<div class="content__header content__boxed overlapping">
    <div class="content__wrap">
    
    	<!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page">메일</li>
            </ol>
        </nav>
        <!-- Breadcrumb 끝-->
		<br/>
    </div>
</div>

<div class="content__boxed">
    <div class="content__wrap">
        <div class="card">
            <div class="card-body">
                <div class="d-md-flex gap-4">

                    <!-- Mail sidebar -->
                    <%@include file="./pagingAndSearch.jsp" %>
                    

                    <!-- Mail List -->
                    <div class="flex-fill min-w-0">
                        <div class="d-md-flex align-items-center border-bottom pb-3 mb-3">
                            <h2 class="page-title">${subTitle }</h2>
                            <div class="form-group ms-auto">
                            	<form class="row row-cols-md-auto g-3 align-items-center" method="post" id="searchForm">
									<input type="hidden" name="page" id="page"/>
									<div class="col-12">
										<select class="form-control" name="searchType">
											<option value="title" <c:if test="${searchType eq 'title' }">selected</c:if>>제목</option>
											<option value="content" <c:if test="${searchType eq 'content' }">selected</c:if>>내용</option>
											<option value="empName" <c:if test="${searchType eq 'empName' }">selected</c:if>>이름</option>
										</select> 
									</div>
									<div class="col-12">
										<input type="text" placeholder="Search..." name="searchWord" value="${searchWord }" class="form-control" autocomplete="off">
									</div>
									<div class="col-12">
										<button type="submit" class="btn btn-primary">
											<i class="fas fa-search"></i>검색
										</button>
									</div>
									<sec:csrfInput/>
								</form>
                               
                            </div>
                        </div>

                        <!-- Mail toolbar -->
                        <div class="d-md-flex px-3 mb-3">

                            <!-- Left toolbar -->
                            <div class="d-flex flex-wrap gap-1 align-items-center justify-content-center mb-3">
                            	<c:if test="${active ne 'importantBox' }">
	                                <div class="py-2 me-4">
	                                    <input class="form-check-input" id="checkAll" type="checkbox" id="checkboxNoLabel" value="" aria-label="...">
	                                </div>
                                </c:if>
                                <!-- 삭제하기 -->
	                                <c:if test="${active eq 'inbox' }">
		                                <div class="btn-group">
		                                    <button id="inboxDelBtn" class="btn btn-lg btn-icon btn-outline-light"><i class="demo-pli-recycling fs-5"></i></button>
		                                </div>
	                                </c:if>
	                                 <c:if test="${active eq 'sentBox' }">
		                                <div class="btn-group">
		                                    <button id="sentBoxDelBtn" class="btn btn-lg btn-icon btn-outline-light"><i class="demo-pli-recycling fs-5"></i></button>
		                                </div>
	                                </c:if>
	                                <c:if test="${active eq 'trash' }">
	                                	<div class="btn-group">
		                                    <button id="restoreBtn" class="btn btn-icon btn-lg btn-outline-light"><i class="demo-psi-back fs-5"></i></button>
		                                    <button id="trashDelBtn" class="btn btn-icon btn-lg btn-outline-light"><i class="demo-pli-recycling fs-5"></i></button>
		                                </div>
	                                </c:if>
                            </div>
                            <!-- END : Left toolbar -->

                            <!--페이징처리 -->
                            <div id="pagingArea" class="ms-auto d-flex gap-3 align-items-center justify-content-center justify-content-md-end mb-3">
                                ${pagingVO.pagingHTML }
                            </div>

                        </div>
                        
                        <!-- Mail list -->
						<c:set value="${pagingVO.dataList }" var="mailList" /> 
                        <div class="list-group list-group-borderless gap-1 mb-3">
                        	<c:forEach items="${mailList }" var="mail">
		                            <div class="list-group-item list-group-item-action 
		                            	<c:forEach items="${mail.mailReceiveList }" var="mailReceive">
		                            		<c:if test="${((active eq 'inbox') || (active eq 'sentBox'))  and (mail.mailNo eq mailReceive.mailNo) and (mailReceive.mailReadYn eq 'N') }">list-group-item-info</c:if> 
		                            	</c:forEach> d-flex align-items-center">
		
		                                <!-- Checkbox and star button -->
		                                <div class="d-flex flex-column flex-md-row flex-shrink-0 gap-3 align-items-center">
		                                	<!-- 중요메일여부 설정 -->
											<input type="hidden" class="importantYN" value="${mail.important}"/>
											<c:if test="${active ne 'importantBox' }">
		                                    	<input class="form-check-input chk" type="checkbox" value="Y" data-mail_no="${mail.mailNo }">
		                                    </c:if>
		                                    <c:if test="${active eq 'importantBox' }">
		                                    	<input class="chk" type="hidden" data-mail_no="${mail.mailNo }">
		                                    </c:if>
		                                    <c:if test="${(active ne 'trash')}">
		                                   	 	<span class="importantMail" class="text-decoration-none text-light"><i class="demo-psi-star fs-5 <c:if test="${mail.important eq 'Y' }">text-yellow</c:if>"></i></span>
		                                    </c:if>
		                                </div>
		                                <!-- END : Checkbox and star button -->
		
		                                <div class="oneMailDiv flex-fill min-w-0 ms-3">
		                                    <div class="d-flex flex-wrap flex-xl-nowrap align-items-xl-center">
		
		                                        <!-- Mail sender -->
		                                        <div class="w-md-160px flex-shrink-0">
		                                        	<c:forEach items="${mail.mailReceiveList }" var="mailReceive2">
		                                            	<a href="#" class="text-dark fw-bold m-0 text-decoration-none">${mailReceive2.employee.empName}</a>
		                                            </c:forEach>
		                                        </div>
		                                        <!-- END : Mail sender -->
		
		                                        <!-- Date and attachment icon -->
		                                        <div class="flex-shrink-0 ms-auto order-xl-3">
		                                        	<c:forEach items="${mailAttachList  }" var="mailAttach">
		                                        		<c:if test="${mailAttach.mailNo eq mail.mailNo }">
		                                        			<c:if test="${mailAttach.mailAttachList[0].fileNo ne '0' }">
	                                            				<span class="me-2"><i class="demo-psi-paperclip"></i></span>
	                                            			</c:if>
	                                           	 		</c:if>
		                                        	</c:forEach>
		                                            <small class="text-muted">${mail.sendDate }</small>
		                                        </div>
		                                        <!-- END : Date and attachment icon -->
		
		                                        <!-- Mail subject -->
		                                        <input type="hidden" class="mailNoValue" value="${mail.mailNo }"/>
		                                        <div class="flex-fill w-100 min-w-0 mt-2 mt-xl-0 mx-xl-3 order-xl-2">
		                                            <a href="#" class="d-block text-dark fw-bold m-0 text-decoration-none text-truncate">
		                                            	${mail.mailTitle }
		                                            </a>
		                                        </div>
		                                        <!-- END : Mail subject -->
		                                    </div>
		                                </div>
		                            </div>
                            </c:forEach>
                        </div>
                    </div>
                    <!-- END : Mail List -->
                </div>
            </div>
        </div>
    </div>
</div>
<style>
.card{
	min-height : 800px;
}
</style>
<script>
$(function(){
	var pagingArea = $("#pagingArea");
	var searchForm = $("#searchForm");
	
	var oneMailDiv = $(".oneMailDiv");
	
	var inboxDelBtn = $("#inboxDelBtn");	// 받은메일함 삭제버튼
	var sentBoxDelBtn = $("#sentBoxDelBtn");// 보낸메일함 삭제버튼
	var restoreBtn = $("#restoreBtn");		// 복구버튼
	var trashDelBtn = $("#trashDelBtn");	// 영구삭제버튼
	
	var importantMail = $(".importantMail");	// 중요메일함 클릭
	var importantYN = $(".importantYN");		// 중요여부
	
	var chk = $(".chk");// 체크박스
	var url = "";		// url
	
	// 페이징처리
	pagingArea.on("click", "a", function(event) {

		event.preventDefault();
		var pageNo = $(this).data("page");
		searchForm.find("#page").val(pageNo);
		searchForm.submit();

	});
	
	// 상세보기
	oneMailDiv.on("click", function(){
		var mailNoValue = parseInt($(this).find(".mailNoValue").val());
		location.href ="/email/mailDetail?mailNo="+mailNoValue+"&active=${active}";
	});
	
	// 전체선택
	$("#checkAll").click(function() {
		if($("#checkAll").is(":checked")) chk.prop("checked", true);
		else chk.prop("checked", false);
	});

	chk.click(function() {
		var total = chk.length;
		var checked = $(".chk:checked").length;

		if(total != checked) $("#checkAll").prop("checked", false);
		else $("#checkAll").prop("checked", true); 
	});
	
	//임시삭제, 메일복구, 영구삭제 통합 함수
	function mailManager(url){
		var chkYes = $(".chk:checked");
		var chkYesArr = [];	// mailNo을 담을 배열
		for(i=0; i<chkYes.length; i++){
			if(chkYes.eq(i).val() == "Y"){
				var mailNo = chkYes.eq(i).data("mail_no");
				console.log("mailNo:",mailNo);
				chkYesArr.push(mailNo);
			}
		}
		console.log("chkYesArr:",chkYesArr);
		
		var data = {
				chkYesArr : chkYesArr,
		};
		
		$.ajax({
			url: url,
			type: "post",
			data:JSON.stringify(data),
			contentType : "application/json;charset=utf-8",
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success: function(res){
				console.log("결과:",res);
				if(res === "OK"){
					location.reload();
				}
			}
		}); 
	}
	
	// 받은메일함에서 삭제버튼 눌렀을 때
	inboxDelBtn.on("click", function(){
		url = "/email/inboxTempDelMail";
		mailManager(url);
	});
	
	// 보낸메일함에서 삭제버튼 눌렀을 때
	sentBoxDelBtn.on("click", function(){
		url = "/email/sentBoxTempDelMail";
		mailManager(url);
	});
	
	// 메세지 복구
	restoreBtn.on("click", function(){
		url = "/email/restoreMail";
		mailManager(url);
	});
	
	// 메세지 영구 삭제
	trashDelBtn.on("click", function(){
		if(confirm("삭제하면 복구하실 수 없습니다. 정말 삭제하시겠습니까?")){
			url = "/email/deleteMail";
			mailManager(url);
		}
	});
	
	// 중요메일함 바꾸기
	importantMail.on("click", function(event){
		event.preventDefault();
		var nowImportantYN = $(this).parent().find(".importantYN").val();
		var mailNo = $(this).parent().find(".chk").data("mail_no");
		var afterImportantYN = "";
		
		if(nowImportantYN == "Y"){
			afterImportantYN = "N";
		}else{
			afterImportantYN = "Y";
		}
		
		var data = {
			afterImportantYN : afterImportantYN,
			mailNo : mailNo
		}
		
		$.ajax({
			url: "/email/updateImportant",
			type: "post",
			data:JSON.stringify(data),
			contentType : "application/json;charset=utf-8",
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success: function(res){
				console.log("결과:",res);
				if(res === "OK"){
					location.reload();
				}
			}
		});
	});
});


</script>