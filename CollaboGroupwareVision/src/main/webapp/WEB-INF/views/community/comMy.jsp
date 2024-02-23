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
					<c:when test="${empty myCmnyList}">
						<div class="card text-center text-muted p-5">
							<h4 class="fw-bold fs-3">가입한 커뮤니티가 없습니다.</h4>
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach items="${myCmnyList }" var="cmny">

							<div class="col-sm-6 col-md-4 col-xl-3 mb-3">
								<div class="card">
									<div class="card-body pt-2">
										<br />
										<!-- 커뮤니티 이미지 출력 -->
										<div class="text-center">
											<a href="/com/comDetail?cmnyNo=${cmny.cmnyNo}"
												style="text-decoration: none;"> <img class="img-xl"
												style="width: 90%;"
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
			<hr />
			<div class="clearfix d-flex justify-content-center" id="pagingArea">${page.pagingHTML }</div>
		</div>
	</div>
</div>
<!-- content__boxed 끝 -->

<script type="text/javascript">
	$(function() {
		var pagingArea = $("#pagingArea");

		pagingArea.on("click", "a", function(event) {

			event.preventDefault(); //a태그의 이벤트를 block

		}); //pagingArea 클릭이벤트 끝

	});
</script>
