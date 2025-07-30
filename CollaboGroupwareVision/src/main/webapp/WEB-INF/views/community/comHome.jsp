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
							<li class="breadcrumb-item active" aria-current="page">커뮤니티
								목록</li>
						</ol>
					</nav>
					<!-- END : Breadcrumb -->
					<h1 class="page-title mb-0 mt-2">&nbsp;&nbsp;</h1>
				</div>
				<div
					class="flex-grow-1 d-flex flex-wrap justify-content-end align-items-center gap-3">

					<button type="button" class="btn btn-secondary btn-lg hstack gap-2"
						onclick="f_modalOpen()">
						<i class="demo-psi-add fs-4"></i> <span class="vr"></span> 커뮤니티 개설
					</button>

					<div class="w-auto text-nowrap">
						<form
							class="input-group input-group-sm bg-primary text-white float-end"
							method="post" action="/com/comHome" id="searchForm"
							style="width: 440px;">
							<input type="hidden" name="page" id="page" /> <select
								class="form-control text-black" name="searchType">
								<option value="cmnyName"
									<c:if test="${searchType eq 'cmnyName' }">selected</c:if>>커뮤니티명</option>
								<option value="cmnyTop"
									<c:if test="${searchType eq 'cmnyTop' }">selected</c:if>>커뮤니티장</option>
							</select> <input type="text" name="searchWord" value="${searchWord}"
								class="form-control float-right text-black" placeholder="Search">
							<div class="input-group-append">
								<button type="submit"
									class="btn btn-default bg-success text-white">
									<i class="fas fa-search"></i>검색
								</button>
							</div>
							<sec:csrfInput />
						</form>
					</div>
				</div>
			</div>
		</div>
		<!-- content-wrap 끝 -->
		<br />
	</div>

	<div class="content__boxed">
		<div class="content__wrap">
			<div class="row mt-3">

				<!-- 커뮤니티 리스트 1개  -->

				<c:set value="${pagingVO.dataList }" var="cmnyList" />

				<c:choose>
					<c:when test="${empty cmnyList}">
						<div class="card text-center text-muted p-5">
							<h4 class="fw-bold fs-3">개설된 커뮤니티가 없습니다.</h4>
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach items="${cmnyList }" var="cmny">

							<div class="col-sm-6 col-md-4 col-xl-3 mb-3">
								<div class="card">
									<div class="card-body pt-2">
										<br />
										<!-- 커뮤니티 이미지 출력 -->
										<div class="text-center">
											<a href="/com/comDetail?cmnyNo=${cmny.cmnyNo}" style="text-decoration: none;">
												<img class="img-xl" style="width: 90%;"
													src="${pageContext.request.contextPath}${cmny.cmnyImgPath}"
													alt="${cmny.cmnyName}">
											</a>		
										</div>
										<!-- 커뮤니티 이미지 출력 끝 -->

										<!-- 하단 커뮤니티 정보 -->
										<div class="mt-4 pt-3 text-center border-top text-muted">
											<a href="/com/comDetail?cmnyNo=${cmny.cmnyNo}" style="text-decoration: none;">
												<h4 class="fw-bold fs-3">${cmny.cmnyName}</h4>
											</a>	
											<i class="ti-user"></i> 커뮤니티장 : ${cmny.cmnyTop}
											&nbsp;&nbsp;&nbsp;&nbsp;<i class="ti-timer"></i> 개설일 :
											${cmny.openDay}
										</div>
										<!-- 하단 커뮤니티 정보 끝 -->
									</div>
									<!-- 커뮤니티 리스트 1개 끝 -->
								</div>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
			<hr/>
			<div class="clearfix d-flex justify-content-center"
				id="pagingArea">${pagingVO.pagingHTML }</div>
		</div>
	</div>
</div>
<!-- content__boxed 끝 -->


<!--모달 : 커뮤니티 등록 화면 -->
<div id="cmnyInsertModal">
	<div class="col-md-5" id="cmnyInsertCont">
		<c:set value="${cmny }" var="cmny" />
				<h2 class="card-title">커뮤니티 개설</h2>
				<br />
				<form action="/com/comInsert" method="post" id="cmnyInsertForm"
					enctype="multipart/form-data">
					<div class="row mb-3">
						<label for="cmnyName" class="col-sm-4 col-form-label">커뮤니티명</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="cmnyName"
								id="cmnyName" value="">
						</div>
					</div>
					<div class="row mb-3">
						<label for="cmnyIntro" class="col-sm-4 col-form-label">커뮤니티
							소개글</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="cmnyIntro"
								id="cmnyIntro" value="">
						</div>
					</div>
					<div class="row mb-3">
						<label for="imgFile" class="col-sm-4 col-form-label">커뮤니티
							이미지</label>
						<div class="col-sm-8">
							<input type="file" class="form-control" name="imgFile"
								id="imgFile" value="">
						</div>
					</div>
					<div class="row mb-3">
						<!-- 이미지 출력 -->
						<div class="col-sm-4 col-form-label">미리보기</div>
						<div class="col-sm-8">
							<img src="" alt="" id="cmnyImgPathPreview"
								style="max-width: 100%; max-height: 100%;" />
						</div>
					</div>
					<div class="row mb-3">
						<div class="col-sm-12">
							<button type="button" id="cmnyInsertBtn" class="btn btn-outline-info">등록</button>
							<button type="button" onclick="f_modalClose()" class="btn btn-outline-danger">Close</button>
							<button type="button" class="btn btn-light btn-lg" onclick="setDemoValues()">시연용</button>
						</div>
					</div>
					<sec:csrfInput />
				</form>
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
	border: 1px solid lightgray;
}
</style>

<script type="text/javascript">
	$(function() {

		var cmnyInsertBtn = $("#cmnyInsertBtn");
		var cmnyInsertForm = $("#cmnyInsertForm");
		var cmnyImgPath = $("#cmnyImgPath"); //파일 출력 
		var imgFile = $("#imgFile"); // 파일 선택 Element
		var cmnyImgPathPreview = $("#cmnyImgPathPreview"); // 미리보기 이미지 출력

		//이미지 추가
		imgFile.on("change", function(event) {
			var file = event.target.files[0];

			if (isImagefile(file)) { //이미지 파일이 맞다면!
				var reader = new FileReader();
				reader.onload = function(e) {
					cmnyImgPathPreview.attr("src", e.target.result); // 이미지 출력 미리보기
					cmnyImgPath.attr("src", e.target.result); // 이미지 출력 // 차량 이미지 출력란에 src를 타겟 결과로 출력	
				}
				reader.readAsDataURL(file);
			} else { //이미지 파일이 아니라면
				alert("이미지 파일을 선택해주세요!");
			}
		});

		// 커뮤니티 개설 이벤트
		cmnyInsertBtn.on("click", function() {

			var cmnyName = $("#cmnyName").val();
			var cmnyIntro = $("#cmnyIntro").val();

			if (cmnyName == null || cmnyName == "") {
				Swal.fire({
					icon : 'warning',
					text : `커뮤니티 이름을 입력해주세요!`,
				})
				return false;
			}
			if (cmnyIntro == null || cmnyIntro == "") {
				Swal.fire({
					icon : 'warning',
					text : `커뮤니티 소개글을 입력해주세요!`,
				})
				return false;
			}

			cmnyInsertForm.submit();

		}); //커뮤니티 개설 이벤트 끝

		// 이미지 파일인지 체크 
		function isImagefile(file) {
			var ext = file.name.split(".").pop().toLowerCase(); // 파일명에서 확장자를 가져온다.
			return ($.inArray(ext, [ "jpg", "jpeg", "gif", "png" ]) === -1) ? false
					: true;
		}
		
		//페이징을 처리할 때 사용할 Element
		//pagingArea div안에 ul과 li로 구성된 페이징 정보가 존재
		//그 안에는 a태그로 구성된 페이지 정보가 들어있음
		//a태그 안에 들어있는 page번호를 가져와서 페이징처리를 진행
		var pagingArea = $("#pagingArea");
		var searchForm = $("#searchForm");
		
		pagingArea.on("click", "a", function(event) {

			event.preventDefault(); //a태그의 이벤트를 block
			var pageNo = $(this).data("page");
			searchForm.find("#page").val(pageNo);
			searchForm.submit();

		}); //pagingArea 클릭이벤트 끝
		
		
	});

	function f_modalOpen() {
		$("#cmnyName").val("");
		$("#cmnyInsertBtn").text("등록");
		$("#cmnyInsertForm").attr("action", "/com/comInsert");
		$("#cmnyInsertModal").css("display", "block");
	}

	function f_modalClose() {
		$("#cmnyInsertModal").css("display", "none");
	}
	
	
	// 발표 시연용 데이터 세팅
	function setDemoValues() {
		$('#cmnyName').val('댄스 커뮤니티');
		$('#cmnyIntro').val('신나게 춤추고 스트레스 풀어요!');
	}
	
	
	
</script>
