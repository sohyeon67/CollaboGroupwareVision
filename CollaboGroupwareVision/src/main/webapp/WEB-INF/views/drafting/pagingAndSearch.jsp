<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
 
    
<div class="float-end" style="margin-top: -70px;"> <!-- margin-top 조정 -->
	<form class="input-group input-group-sm" method="post" id="searchForm">
		<input type="hidden" name="page" id="page"/>
	    <div class="btn-group m-3" style="height: 40px;">
	        <select id="" name="searchType" class="form-select bg-white text-black" style="width: 170px;">
	            <option value="title" <c:if test="${searchType eq 'title' }">selected</c:if>>제목</option>
	            <option value="writer" <c:if test="${searchType eq 'writer' }">selected</c:if>>기안자</option>
	            <option value="no" <c:if test="${searchType eq 'no' }">selected</c:if>>문서번호</option>
	            <option value="form" <c:if test="${searchType eq 'form' }">selected</c:if>>결재양식</option>
	            <option value="dept" <c:if test="${searchType eq 'dept' }">selected</c:if>>부서</option>
	            <option value="status" <c:if test="${searchType eq 'status' }">selected</c:if>>결재상태</option>
	        </select>
	        <input type="text" name="searchWord" value="${searchWord }" class="form-control float-right" placeholder="Search">
	        <div class="input-group-append">
	            <button type="submit" class="btn btn-info fw-bold" style="width: 60px; height: 40px;">검색</button>
	        </div>
	    </div>
	    <sec:csrfInput/>
	</form>
</div>    
    
<script type="text/javascript">
$(function(){
	var pagingArea = $("#pagingArea");	
	var searchForm = $("#searchForm");	
	
	pagingArea.on("click", "a", function(event){
		event.preventDefault();	// a태그의 이벤트를 block
		var pageNo = $(this).data("page");
		searchForm.find("#page").val(pageNo);
		searchForm.submit();
	});
});

setTimeout(() => {
	check();
}, 30);
</script>