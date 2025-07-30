<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>




<!-- 상단 -->
<div class="content__boxed">

	<div class="content__header content__boxed overlapping">
		<div class="content__wrap">
			<div class="d-md-flex align-items-end">
				<div class="me-auto">
					<!-- Breadcrumb -->
					<nav aria-label="breadcrumb">
						<ol class="breadcrumb mb-0">
							<li class="breadcrumb-item"><a href="/">Home</a></li>
							<li class="breadcrumb-item"><a href="/com/comHome">커뮤니티</a></li>
							<li class="breadcrumb-item"><a href="/com/comHome">커뮤니티
									목록</a></li>
							<li class="breadcrumb-item">${cmny.cmnyName}</li>
						</ol>
					</nav>
					<!-- END : Breadcrumb -->
					<h1 class="page-title mb-0 mt-2">&nbsp;&nbsp;</h1>
				</div>
				<div
					class="flex-grow-1 d-flex flex-wrap justify-content-end align-items-center gap-3">
					<c:choose>
						<c:when test="${not empty cmnyMemList}">
							<!-- cmnyMemList가 비어 있지 않을 때 -->
							<c:set var="userIsMember" value="false" />
							<c:set var="userIsLeader" value="false" />

							<c:forEach items="${cmnyMemList}" var="cmnyMem">
								<c:if test="${cmnyMem.empNo eq employee.empNo}">
									<!-- 현재 로그인한 사용자가 해당 커뮤니티의 회원인 경우 -->
									<c:set var="userIsMember" value="true" />
								</c:if>
								<!-- 현재 로그인한 사용자가 커뮤니티장인 경우 -->
								<c:if
									test="${cmnyMem.empNo eq employee.empNo and cmnyMem.cmnyTopYn eq 'Y'}">
									<c:set var="userIsLeader" value="true" />
								</c:if>
							</c:forEach>

							<c:if test="${userIsLeader eq 'true'}">
								<!-- 가입된 회원이고 본인이 커뮤니티장인 경우 (커뮤니티 폐쇄 버튼 표시) -->
								<button type="button" class="btn btn-danger btn-lg hstack gap-2"
									onclick="closeCommunity()">
									<i class="ti-zoom-out"></i><span class="vr"></span> 커뮤니티 폐쇄
								</button>
							</c:if>
							<c:if test="${userIsMember eq 'true' and userIsLeader ne 'true'}">
								<!-- 가입된 회원이지만 본인이 커뮤니티장이 아닌 경우 (탈퇴 버튼 표시) -->
								<button type="button" class="btn btn-danger btn-lg hstack gap-2"
									onclick="withdraw()">
									<i class="ti-zoom-out"></i><span class="vr"></span> 탈퇴
								</button>
							</c:if>
							<c:if test="${userIsMember eq 'false'}">
								<!-- 가입된 회원이지만 본인이 아닌 경우 (가입신청 버튼 표시) -->
								<button type="button"
									class="btn btn-secondary btn-lg hstack gap-2"
									onclick="f_modalOpen()">
									<i class="ti-zoom-in"></i><span class="vr"></span> 가입신청
								</button>
							</c:if>
						</c:when>
						<c:otherwise>
							<!-- 가입된 회원이 없는 경우 (가입신청 버튼 표시) -->
							<button type="button"
								class="btn btn-secondary btn-lg hstack gap-2"
								onclick="f_modalOpen()">
								<i class="demo-psi-add fs-4"></i> <span class="vr"></span> 가입신청
							</button>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<!-- content-wrap 끝 -->
		<br />
	</div>

	<div class="content__boxed">
		<div class="content__wrap">
			<div class="card d-flex justify-content-center">
				<h1 class="text-center mt-4 fw-bold">${cmny.cmnyName }</h1>
				<hr />

				<div class="row">
					<!-- 커뮤니티 이미지 출력 -->
					<div class="col-md-6 d-flex justify-content-end">
						<a href="/com/comDetail?cmnyNo=${cmny.cmnyNo}"
							style="text-decoration: none;"> <img class="img-xl"
							style="width: 100%; height: 200px;"
							src="${pageContext.request.contextPath}${cmny.cmnyImgPath}"
							alt="${cmny.cmnyName}">
						</a>
					</div>
					<!-- 커뮤니티 이미지 출력 끝 -->

					<!-- 커뮤니티장, 개설일, 소개글 -->
					<div class="col-md-6 d-flex justify-content-start">

						<!-- Hover rows -->
						<div class="table-responsive" style="width: 50%;">
							<table class="table table-hover">
								<tbody>
									<tr>
										<td class="text-center"><i
											class="ti-user fs-1 text-danger"></i></td>
										<td><small class="text-muted">커뮤니티장</small><br> <span
											class="h6 fw-bold">${cmny.cmnyTop}</span></td>
									</tr>
									<tr>
										<td class="text-center"><i
											class="ti-timer fs-1 text-warning"></i></td>
										<td><small class="text-muted">개설일</small><br> <span
											class="h6 fw-bold">${cmny.openDay}</span></td>
									</tr>
									<tr>
										<td class="text-center"><i
											class="ti-comment-alt fs-1 text-success"></i></td>
										<td><small class="text-muted">소개</small><br> <span
											class="h4 fw-bold">${cmny.cmnyIntro}</span></td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- END : Hover rows -->

					</div>
					<!-- 커뮤니티장, 개설일, 소개글 끝 -->

				</div>
				<hr />

				<!-- 멤버 리스트 구역 -->
				<div class="text-center">

					<div class="card-body">

						<h4 class="card-title fw-bold">가입 회원 리스트</h4>

						<div class="table-responsive mx-auto" style="width: 70%;">
							<table class="table table-striped">
								<thead>
									<tr>
										<th style="width: 20%;">사번</th>
										<th style="width: 20%;">이름</th>
										<th style="width: 20%;">부서</th>
										<th style="width: 20%;">직위</th>
										<th style="width: 20%;">가입일</th>
									</tr>
								</thead>

								<c:set value="${cmnyMemList}" var="cmnyMemList" />

								<c:choose>
									<c:when test="${empty cmnyMemList}">
										<tr>
											<th colspan="5">가입된 회원이 없습니다.</th>
										</tr>
									</c:when>

									<c:otherwise>
										<c:forEach items="${cmnyMemList}" var="cmnyMemList">

											<!-- Striped rows -->

											<tr>
												<td class="text-center">${cmnyMemList.empNo }</td>
												<td class="text-center">${cmnyMemList.empName}</td>
												<td class="text-center">${cmnyMemList.deptName}</td>
												<td class="text-center">${cmnyMemList.positionName}</td>
												<td class="text-center">${cmnyMemList.joinDay}</td>
											</tr>

										</c:forEach>
									</c:otherwise>
								</c:choose>
							</table>
						</div>
						<!-- END : Striped rows -->
					</div>
				</div>
				<!-- 멤버 리스트 구역 끝 -->


				<hr />
			</div>
		</div>
	</div>
</div>
<!-- content__boxed 끝 -->


<!--모달 : 커뮤니티 가입 화면 -->
<div id="cmnyInsertModal">
	<div class="col-md-5 mb-1" id="cmnyInsertCont">
		<div>
			<c:set value="${cmnyMem}" var="cmnyMem" />
				<h2 class="card-title">커뮤니티 가입 신청</h2>
				<br><br>
				<form action="/com/comSubmitMem" method="post" id="cmnyInsertForm"
					enctype="multipart/form-data">
					<input type="hidden" class="hCmnyNo" name="cmnyNo"
						value="${cmnyMem.cmnyNo}" />
					<div class="row mb-3">
						<label for="empName" class="col-sm-4 col-form-label">가입자명</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="empName" readonly
								id="empName" value="${cmnyMem.empName }">
						</div>
					</div>
					<div class="row mb-3">
						<label for="empNo" class="col-sm-4 col-form-label">가입자 사번</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="empNo" readonly
								id="empNo" value="${cmnyMem.empNo }">
						</div>
					</div>
					<br><br>
					<div class="row mb-3">
						<div class="col-sm-12">
							<button type="button" id="cmnyInsertBtn"
								class="btn btn-outline-info">신청</button>
							<button type="button" onclick="f_modalClose()"
								class="btn btn-outline-danger">Close</button>
						</div>
					</div>
					<sec:csrfInput />
				</form>
		</div>
	</div>
</div>


<!-- 스타일 -->
<style>
#cmnyInsertModal {
	position: fixed;
	width: 100%;
	height: 100%; /*fixed인 경우 먹음*/
	left: 0px;
	top: 0px;
	background-color: rgba(204, 204, 204, 0.5);
	display: none;
	z-index: 1000;
}

#cmnyInsertCont {
	width: 500px;
	margin: 10% auto; /* 수평가운데 정렬 */
	padding: 50px;
	border-radius: 30px;
	background-color: white;
	text-align: center;
	box-shadow: none;
}

#cmnyInsertForm {
	border-color: white;
}
</style>

<script type="text/javascript">
	$(function() {

		var cmnyInsertBtn = $("#cmnyInsertBtn");
		var cmnyInsertForm = $("#cmnyInsertForm");

		// 커뮤니티 가입 이벤트
		cmnyInsertBtn.on("click", function() {
			cmnyInsertForm.submit();
			
			// 커뮤니티 알람
			var communityNo = "${cmny.cmnyNo}";
			var communityName = "${cmny.cmnyName }";
			webSocket.send("커뮤니티:["+communityName+"]에 새로운 멤버가 가입했습니다. ,"+communityNo)
		}); //커뮤니티 개설 이벤트 끝

	});
	
	//커뮤니티 폐쇄
	function closeCommunity() {
		
		var communityNo = "${cmny.cmnyNo}";
		
        // Ajax 요청을 통해 가입된 회원 수를 가져오는 로직
        $.ajax({
            type: 'get',
            url: '/com/cmnycloseMemCnt',
            dataType: 'text',
            contentType: 'application/json;charset=UTF-8',  // JSON 형태로 전송
            data : { cmnyNo : communityNo },
			beforeSend : function(xhr) { //시큐리티 적용
				xhr.setRequestHeader(header, token);
			},
            success: function(response) {
            	 var cmnyMemCount = parseInt(response);
                if (cmnyMemCount > 0) {
                    // 가입된 회원이 있는 경우 알림
                    Swal.fire({
                        icon: 'warning',
                        text: '모든 회원이 탈퇴 후 폐쇄가 가능합니다.',
                        confirmButtonText: 'OK',
                    }).then((result) => {
                        if (result.isConfirmed) {
                        	window.location.href = '/com/comDetail?cmnyNo=' + communityNo;
                        }
                    });
                } else {
                    // 가입된 회원이 없는 경우 알림
                    Swal.fire({
                        icon: 'warning',
                        text: '정말 폐쇄하시겠습니까?',
                        showCancelButton: true,
                        confirmButtonText: 'OK',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // 폐쇄 로직 수행
                            updateCmnyStatus();
                        }
                    });
                }
            },
            error: function(error) {
                console.error('가입된 회원 수 조회 에러:', error);
            }
        });
    }
	
    // 실제로 커뮤니티를 폐쇄하는 로직
    function updateCmnyStatus() {
    	
    	var communityNo = "${cmny.cmnyNo}";
    	
        $.ajax({
            type: 'get',
            url: '/com/updateCmnyStatus',
            dataType: 'text',
            contentType: 'application/json;charset=UTF-8',  // JSON 형태로 전송
            data : { cmnyNo : communityNo },
			beforeSend : function(xhr) { //시큐리티 적용
				xhr.setRequestHeader(header, token);
			},
            success: function(response) {
                Swal.fire({
                    icon: 'success',
                    text: '커뮤니티 폐쇄가 완료되었습니다.',
                    confirmButtonText: 'OK',
                }).then((result) => {
                    if (result.isConfirmed) {
                    	window.location.href = '/com/comHome';
                    }
                });
            	
            },
            error: function(error) {
                console.error('커뮤니티 폐쇄 에러:', error);
            }
        });
    }
	
	//탈퇴
	function withdraw() {
	    Swal.fire({
	        icon: 'warning',
	        text: '탈퇴하시겠습니까?',
	        showCancelButton: true,
	        confirmButtonText: 'OK',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            // 현재 로그인한 사용자의 사번을 동적으로 가져오는 코드
	            var loggedInUserEmpNo = "${employee.empNo}";

	            // 커뮤니티에 가입된 회원의 사번을 동적으로 가져오는 코드
	            var communityMemberEmpNo = "${cmnyMem.empNo}";
	            
	            var communityNo = "${cmny.cmnyNo}";
	
	            // 로그인한 사용자의 사번과 커뮤니티 회원의 사번이 일치하는 경우에만 탈퇴 요청 보냄
	            if (loggedInUserEmpNo === communityMemberEmpNo) {
	                // Ajax 요청을 통해 서버에 탈퇴 요청과 사용자 정보를 전송
	                $.ajax({
	                    type: 'POST',
	                    url: '/com/comWithdrawMem', 
	                    contentType: 'application/json;charset=UTF-8',  // JSON 형태로 전송
	                    data: JSON.stringify({ 
	                    	empNo: communityMemberEmpNo,
	                    	cmnyNo : communityNo
	                    	}), 
	    				beforeSend : function(xhr) {
	    					xhr.setRequestHeader(header, token);
	    				},
	                    success: function(response) {
	                        // 서버에서 탈퇴가 성공적으로 이루어지면
	                    	Swal.fire({
	                            icon: 'success',
	                            text: '탈퇴가 완료되었습니다.',
	                            confirmButtonText: '확인'
	                        }).then(function() {
	                            window.location.href = '/com/comDetail?cmnyNo=' + communityNo;
	                        });
	                        
	                        
	                    },
	                    error: function(error) {
	                        console.error('탈퇴 에러:', error);
	                        // 탈퇴에 실패한 경우에 대한 처리
	                    }
	                });
	            } else {
	                // 로그인한 사용자의 사번과 커뮤니티 회원의 사번이 일치하지 않는 경우
	                Swal.fire({
	                    icon: 'error',
	                    text: '잘못된 접근입니다.',
	                    confirmButtonText: '확인'
	                });
	            }
	        }
	    });
	}


	//가입신청
	function f_modalOpen() {
		$("#cmnyName").val();
		$("#cmnyName").val();
		$("#cmnyInsertBtn").text("신청");
		$("#cmnyInsertForm").attr("action", "/com/comSubmitMem");
		$("#cmnyInsertModal").css("display", "block");
	}

	function f_modalClose() {
		$("#cmnyInsertModal").css("display", "none");
	}
</script>
