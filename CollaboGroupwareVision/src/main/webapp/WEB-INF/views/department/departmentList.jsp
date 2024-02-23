<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script src="${pageContext.request.contextPath }/js/demo-purpose-only.js" defer></script>
<c:if test="${not empty pageContext.request.userPrincipal}">
    <c:set var="loggedInEmpNo" value="${pageContext.request.userPrincipal.name}" />
</c:if>
<%-- <p>LoggedIn User: ${loggedInEmpNo}</p> --%>

<style>
    .large-text {
        font-size: 1.2em;
    }
    .fixed-height-div, .fixed-height-card {
        height: 200px; 
        overflow: hidden; 
        margin-bottom: 20px;
    }
</style>

            <div class="content__header content__boxed overlapping">
                <div class="content__wrap">

                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="./index.html">홈</a></li>
                            <li class="breadcrumb-item"><a href="./blog-apps.html">게시판</a></li>
                            <li class="breadcrumb-item active" aria-current="page">부서게시판</li>
                        </ol>
                    </nav>
                    <!-- END : Breadcrumb -->

                    <h1 class="page-title mb-0 mt-2">부서게시판</h1>

                    <p class="lead">
                          	부서별 소식을 공유할 수 있는 게시판입니다.
                    </p>
                </div>
            </div>
            
<%-- <p>departmentList loginEmpDeptCode: ${loginEmpDeptCode}</p> --%>

<%-- alert 스크립트 실행 여부를 결정하는 조건 --%>
<c:if test="${not empty alertMessage}">
    <script>
        // 페이지 로딩 후 showAlert 함수 실행
        window.onload = function() {
            showAlert();
        };
    </script>
</c:if>

            <div class="content__boxed">
                <div class="content__wrap">

					<div class="row">
		           		<c:choose>
		           			<c:when test="${empty deptList }">
		           			
		           			</c:when>
		           			<c:otherwise>
								<c:forEach items="${deptList}" var="dept">
								    <div class="col-md-6 fixed-height-div">
								        <div class="card flex-row mb-3 department fixed-height-card" data-code="${dept.deptCode}">
								             <a href="/department/deptBoardList?code=${dept.deptCode}">
								                 <div class="w-300px flex-shrink-0">
								                     <img class="img-fluid rounded-start" src="${pageContext.request.contextPath}/resources/assets/img/department/${dept.deptName}.jpg" alt="coffee" loading="lazy">
								                 </div>
								                 <div class="card-body d-flex flex-column w-160px">
								                     <div class="d-flex align-items-center justify-content-between mb-3">
								                         <a href="/department/deptBoardList?code=${dept.deptCode}" class="h5 btn-link text-truncate m-0 pe-3"></a>
								                     </div>
								                     <p>
								                         <c:forEach items="${dept.deptMemList}" var="deptMem">
								                             <c:out value="${deptMem.empName}"></c:out>
								                         </c:forEach>
								                     </p>
								                     <div class="mt-auto pt-3 border-top d-flex align-items-center">
								                         <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
								                             <i class="text-muted demo-pli-heart-2 fs-5 me-2 text-red"></i>
								                         </a><b style="color:gray;">${dept.deptName}</b>
								                     </div>
								                 </div>
								             </a>
								        </div>
								    </div>
								</c:forEach>
		           			</c:otherwise>
		           		</c:choose>
           			 </div>
            <!-- END : Card blog with image -->
					
						<button type="button" class="btn btn-primary rounded-pill"
							id="addBtn">부서글 등록</button>
                </div>
            </div>
<script type="text/javascript">
$(function showAlert() {
    // 알림 창 띄우기
    alert("${alertMessage}");
});

	$(function() {
		var pagingArea = $("#pagingArea");
		var searchForm = $("#searchForm");
		var addBtn = $("#addBtn");

		pagingArea.on("click", "a", function(event) {
			event.preventDefault();
			var pageNo = $(this).data("page");
			searchForm.find("#page").val(pageNo);
			searchForm.submit();
		});

		addBtn.on("click", function() {
			location.href = "/department/departmentForm";
		});
		
		$(".department").on("click", function() {
		    var clickedDeptCode = $(this).data("code");
		    var userDeptCode = ${loginEmpDeptCode}; // 서버에서 전달받은 사용자 부서 코드

		    if (clickedDeptCode === userDeptCode) {
		        var url = "/department/deptBoardList?code=" + clickedDeptCode;
		        location.href = url;
		    } else {
		        alert("다른 부서는 조회할 수 없습니다.");
		    }
		});

		
	    // 각 행의 높이를 조절합니다.
	    adjustRowHeights();

	    // 창 크기가 변경될 때마다 높이를 다시 조절합니다.
	    $(window).resize(function () {
	        adjustRowHeights();
	    });
	    
/* 	    $(".department").on("click", function(){
	    	var code = $(this).data("code");
	    	location.href = "/department/deptBoardList?code="+code;
	    }); */

	    /*
	    $(".department").on("click", function(){
			event.preventDefault();   // a 태그 이동 막기
	        var deptCode = $(this).data("code");
			alert("/department/deptBoardList?code=" + deptCode);
			var url = "/department/deptBoardList?code=" + deptCode;
	        location.href = url;
	    });
	    */

	});

	$(function adjustRowHeights() {
	    // 모든 행의 최대 높이를 저장하는 변수 초기화
	    var maxRowHeight = 0;

	    // 각 행을 순회하여 최대 높이를 찾습니다.
	    $(".row").each(function () {
	        // 행의 최대 높이를 초기화합니다.
	        var rowHeight = 0;

	        // 행의 카드를 순회하여 최대 높이를 찾습니다.
	        $(this).find(".card").each(function () {
	            var cardHeight = $(this).outerHeight();
	            if (cardHeight > rowHeight) {
	                rowHeight = cardHeight;
	            }
	        });

	        // 현재 행의 최대 높이가 전체 행의 최대 높이보다 크면 업데이트합니다.
	        if (rowHeight > maxRowHeight) {
	            maxRowHeight = rowHeight;
	        }
	    });

	    // 모든 행의 각 카드 높이를 전체 행의 최대 높이로 설정합니다.
	    $(".row").each(function () {
	        $(this).find(".card").css("height", maxRowHeight);

	        // 각 카드 내부의 이미지를 행의 높이에 맞게 조절합니다.
	        var cardImage = $(this).find(".card img");
	        if (cardImage.length > 0) {
	            var cardImageHeight = maxRowHeight - 20; // 조절할 여백을 고려하여 설정
	            cardImage.css({
	                "max-height": cardImageHeight + "px",
	                "width": "100%",
	                "height": cardImageHeight + "px",
	                "object-fit": "cover" // 이미지를 카드 영역에 맞게 자동으로 조절
	            });
	        }
	    });
	    
	});
</script>

