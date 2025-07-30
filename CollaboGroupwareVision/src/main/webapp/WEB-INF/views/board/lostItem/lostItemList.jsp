<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
#searchWrap input{
	width: 287px;
}
input[type='date']{
	width: 130px !important;
}

#leftSearch{
	margin-right: 20px;
	width: 360px;
}

#rightSearch{
	width: 360px;
}

#leftSearchLabel{
	width: 60px;
}

#rightSearchLabel{
	width: 60px;
}

</style>

<div class="content__header content__boxed overlapping">
    <div class="content__wrap" id="searchWrap">

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="./index.html">Home</a></li>
                <li class="breadcrumb-item"><a href="./blog-apps.html">게시판</a></li>
                <li class="breadcrumb-item active" aria-current="page">분실물 게시판</li>
            </ol>
        </nav>
        <!-- END : Breadcrumb -->
			



        <!-- Title and information -->
        <h1 class="page-title d-flex flex-wrap just justify-content-center mb-2 mt-4">분실물 게시판</h1>
        <!-- END : Title and information -->

		<select class="form-select" style="width: 200px;">
			<option value="date-created" selected="selected">분실</option>
		    <option value="date-modified">습득</option>
		</select>

		<div class="float-end" style="margin-top: -57px;"> <!-- margin-top 조정 -->
			<form class="input-group input-group-sm" method="post" id="searchForm">
				<input type="hidden" name="page" id="page"/>
			    <div class="btn-group m-3" style="height: 40px;">
			        <select id="" name="searchType" class="form-select bg-white text-black" style="width: 130px;">
			            <option value="" <c:if test="${searchType eq 'title' }">selected</c:if>>제목</option>
			            <option value="" <c:if test="${searchType eq 'place' }">selected</c:if>>장소</option>
			        </select>
			        <input type="text" name="searchWord" value="${searchWord }" class="form-control float-right" placeholder="Search">
			        <div class="input-group-append">
			            <button type="submit" class="btn btn-info fw-bold" style="width: 60px; height: 40px;">검색</button>
			        </div>
			    </div>
			    <sec:csrfInput/>
			</form>
		</div>    
		<br/>
		

		
		
    </div>

</div>

<!-- Card blog with image -->
<div class="content__boxed">
	<div class="content__wrap">
             
             
		<div class="card flex-row mb-3">
		    <div class="w-300px flex-shrink-0">
		        <img class="img-fluid rounded-start" src="${pageContext.request.contextPath }/resources/assets/img/sample-img/img-1.jpg" alt="my car" loading="lazy">
		    </div>
		    <div class="card-body d-flex flex-column w-160px">
		        <div class="mb-3">
		            <a href="#" class="h5 btn-link text-truncate">Let's do Adventure</a>
		        </div>
		        <p>Doing business like this takes much more effort than doing your own business at home</p>
		        <div class="mt-auto pt-3 border-top d-flex align-items-center">
		            <small class="text-muted">3 weeks ago</small>
		            <div class="d-flex gap-2 ms-auto">
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-heart-2 fs-5 me-2"></i>2.89K
		                </a>
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-speech-bubble-4 fs-5 me-2"></i>798
		                </a>
		            </div>
		        </div>
		    </div>
		</div>
             
             
        <div class="card flex-row mb-3">
		    <div class="w-300px flex-shrink-0">
		        <img class="img-fluid rounded-start" src="${pageContext.request.contextPath }/resources/assets/img/sample-img/img-1.jpg" alt="my car" loading="lazy">
		    </div>
		    <div class="card-body d-flex flex-column w-160px">
		        <div class="mb-3">
		            <a href="#" class="h5 btn-link text-truncate">Let's do Adventure</a>
		        </div>
		        <p>Doing business like this takes much more effort than doing your own business at home</p>
		        <div class="mt-auto pt-3 border-top d-flex align-items-center">
		            <small class="text-muted">3 weeks ago</small>
		            <div class="d-flex gap-2 ms-auto">
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-heart-2 fs-5 me-2"></i>2.89K
		                </a>
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-speech-bubble-4 fs-5 me-2"></i>798
		                </a>
		            </div>
		        </div>
		    </div>
		</div>
		
		<div class="card flex-row mb-3">
		    <div class="w-300px flex-shrink-0">
		        <img class="img-fluid rounded-start" src="${pageContext.request.contextPath }/resources/assets/img/sample-img/img-1.jpg" alt="my car" loading="lazy">
		    </div>
		    <div class="card-body d-flex flex-column w-160px">
		        <div class="mb-3">
		            <a href="#" class="h5 btn-link text-truncate">Let's do Adventure</a>
		        </div>
		        <p>Doing business like this takes much more effort than doing your own business at home</p>
		        <div class="mt-auto pt-3 border-top d-flex align-items-center">
		            <small class="text-muted">3 weeks ago</small>
		            <div class="d-flex gap-2 ms-auto">
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-heart-2 fs-5 me-2"></i>2.89K
		                </a>
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-speech-bubble-4 fs-5 me-2"></i>798
		                </a>
		            </div>
		        </div>
		    </div>
		</div>
		
		<div class="card flex-row mb-3">
		    <div class="w-300px flex-shrink-0">
		        <img class="img-fluid rounded-start" src="${pageContext.request.contextPath }/resources/assets/img/sample-img/img-1.jpg" alt="my car" loading="lazy">
		    </div>
		    <div class="card-body d-flex flex-column w-160px">
		        <div class="mb-3">
		            <a href="#" class="h5 btn-link text-truncate">Let's do Adventure</a>
		        </div>
		        <p>Doing business like this takes much more effort than doing your own business at home</p>
		        <div class="mt-auto pt-3 border-top d-flex align-items-center">
		            <small class="text-muted">3 weeks ago</small>
		            <div class="d-flex gap-2 ms-auto">
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-heart-2 fs-5 me-2"></i>2.89K
		                </a>
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-speech-bubble-4 fs-5 me-2"></i>798
		                </a>
		            </div>
		        </div>
		    </div>
		</div>
		
		<div class="card flex-row mb-3">
		    <div class="w-300px flex-shrink-0">
		        <img class="img-fluid rounded-start" src="${pageContext.request.contextPath }/resources/assets/img/sample-img/img-1.jpg" alt="my car" loading="lazy">
		    </div>
		    <div class="card-body d-flex flex-column w-160px">
		        <div class="mb-3">
		            <a href="#" class="h5 btn-link text-truncate">Let's do Adventure</a>
		        </div>
		        <p>Doing business like this takes much more effort than doing your own business at home</p>
		        <div class="mt-auto pt-3 border-top d-flex align-items-center">
		            <small class="text-muted">3 weeks ago</small>
		            <div class="d-flex gap-2 ms-auto">
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-heart-2 fs-5 me-2"></i>2.89K
		                </a>
		                <a href="#" class="btn btn-icon btn-sm btn-link text-head px-2 py-0">
		                    <i class="text-muted demo-pli-speech-bubble-4 fs-5 me-2"></i>798
		                </a>
		            </div>
		        </div>
		    </div>
		</div>         
                 
                 
                 
	</div>
</div>
<!-- END : Card blog with image -->




                <!-- END : Blog post lists -->
					
                <div align="right" style="margin-right: 3%;"> <!-- margin-top 조정 -->
					<button type="button" class="btn btn-primary rounded-pill" id="addBtn" style="width: 100px; font-size: 1.0rem;">등록</button>
                </div>

                <div class="mt-4 d-flex justify-content-center">

                    <!-- Pagination - Disabled and active states -->
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Previous</a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">1</a></li>
                            <li class="page-item active" aria-current="page">
                                <a class="page-link" href="#">2</a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item"><a class="page-link" href="#">4</a></li>
                            <li class="page-item"><a class="page-link" href="#">5</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#">Next</a>
                            </li>
                        </ul>
                    </nav>
                    <!-- END : Pagination - Disabled and active states -->
                </div>
                

 

<script>

var now_utc = Date.now()
var timeOff = new Date().getTimezoneOffset()*60000;
var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
document.getElementById("startSearchDate").setAttribute("max", today);
document.getElementById("endSearchDate").setAttribute("max", today);



$(function(){	// $function 시작
	var addBtn = $("#addBtn");
	
	addBtn.on("click", function(){
		location.href = "/board/lostItem/form";	
	});
	
});	// $function 끝
</script>    
    