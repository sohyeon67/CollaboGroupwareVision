<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<div class="w-md-160px w-xl-200px flex-shrink-0 mb-3">

	<!-- Composed button -->
	<div class="d-grid">
		<button type="button" id="writeMailBtn"
			class="btn btn-lg btn-secondary hstack gap-3">
			<i class=" demo-psi-mail-send fs-3"></i> <span class="vr"></span>Compose
		</button>
	</div>
	<!-- END : Composed button -->

	<!-- 메일함 종류 -->
	<h5 class="px-3 mt-5 mb-3">[메일함]</h5>
	<div class="list-group list-group-borderless gap-1">
		<a href="/email/inbox" class="list-group-item list-group-item-action <c:if test='${active eq "inbox" }'>active</c:if>">
			<i class="demo-pli-mail-unread fs-5 me-2"></i>받은메일함 ( ${noRead } )
		</a> 
		<a href="/email/sentMailBox" class="list-group-item list-group-item-action <c:if test='${active eq "sentBox" }'>active</c:if>"> <i
			class="demo-pli-mail-send fs-5 me-2"></i> 보낸메일함
		</a>
		<a href="/email/importantBox" class="list-group-item list-group-item-action <c:if test='${active eq "importantBox" }'>active</c:if>"> <i
			class="demo-pli-star fs-5 me-2"></i> 중요메일함
		</a>
		</a> <a href="/email/trashCan" class="list-group-item list-group-item-action <c:if test='${active eq "trash" }'>active</c:if>"> <i
			class="demo-pli-trash fs-5 me-2"></i> 휴지통
		</a>
	</div>

</div>
<script>
$(function(){
	var writeMailBtn = $("#writeMailBtn");	// 메일 쓰기 버튼
	
	writeMailBtn.on("click", function(){
		console.log("메일 쓰기");
		location.href = "/email/compose";
	});
});

//팝업
setTimeout(() => {
	check();
}, 30);
</script>