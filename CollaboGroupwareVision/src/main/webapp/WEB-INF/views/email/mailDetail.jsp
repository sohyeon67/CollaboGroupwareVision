<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div class="content__header content__boxed overlapping">
	<div class="content__wrap"></div>
</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card">
			<div class="card-body">

				<div class="d-md-flex gap-4">

					<!-- Mail sidebar -->
                    <%@include file="./pagingAndSearch.jsp" %>

					<div class="flex-fill min-w-0">
						<h1 class="h3" id="mailTitle">
							<!-- <span class="badge bg-info">Family</span> --> ${mail.mailTitle }
						</h1>

						<!-- Sender information -->
						<div class="d-md-flex mt-4">
							<div class="d-flex mb-3 position-relative">
								<c:if test="${not empty mail.employee.profileImgPath }">
									<div class="flex-shrink-0">
										<img class="img-sm rounded-circle"
											src="${mail.employee.profileImgPath }" alt="Profile Picture"
											loading="lazy">
									</div>
								</c:if>
								<div class="flex-grow-1 ms-3">
									<input type="hidden" id="senderEmpNo" value="${mail.empNo }"/>
									<h6>${mail.employee.empName }</h6> 
										<small class="d-block text-muted">${mail.employee.empEmail }</small>
								</div>
							</div>
							
							<div class="ms-auto d-md-flex flex-md-column align-items-md-end">
								<small class="text-muted">${mail.sendDate }</small>
							</div>
						</div>
						<!-- END : Sender information -->

						<!-- Email content -->
						<div class="lh-lg py-4 border-top border-bottom">
							${mail.mailContent }
						</div>
						<!-- END : Email content -->

						<!-- File attachments -->
						<div id="_dm-attachment" class="mt-3">
							<!-- 파일이 이미지일때 이미지로, 아닐때 고정적인 이미지를 보여줌 -->
							<span class="h6"><i class="demo-psi-paperclip me-2"></i>Attachments
									<span>(${fn:length(mail.mailAttachList)} files) </span>
							</span> 
							<div class="d-flex flex-wrap gap-2 mt-3">
								<c:forEach items="${mail.mailAttachList }" var="mailAttach">
									<c:if test="${mailAttach.fileNo ne '0' }">
										<c:choose>
											<c:when test="${fn:split(mailAttach.fileMimetype, '/')[0] eq 'image' }">
												<figure class="figure w-160px position-relative">
													<div class="figure-img ratio ratio-16x9">
														<img class="object-cover rounded"
															src="/resources/mail/${mail.mailNo }/${fn:split(mailAttach.fileSavepath,'/')[1] }">
													</div>
													<figcaption class="figure-caption">
														<a href="/email/download?fileNo=${mailAttach.fileNo }" class="h6 stretched-link btn-link">${mailAttach.fileName }</a> <small
															class="d-block">File size : ${mailAttach.fileFancysize }</small>
													</figcaption>
												</figure>
											</c:when>
											<c:otherwise>
												<figure class="figure w-160px position-relative">
													<div class="figure-img ratio ratio-16x9">
														<i
															class="ti-image fs-1 d-flex justify-content-center align-items-center bg-light rounded"></i>
													</div>
													<figcaption class="figure-caption">
														<a href="/email/download?fileNo=${mailAttach.fileNo }" class="h6 stretched-link btn-link">${mailAttach.fileName }</a>
														<small class="d-block">File size : ${mailAttach.fileFancysize }</small>
													</figcaption>
												</figure>
											</c:otherwise>									
										</c:choose>
									</c:if>
								</c:forEach>
							</div>
						</div>
						<!-- END : File attachments -->
						
						<!-- 답장보내기 -->
						<c:if test="${mail.empNo ne empNo }">
							<textarea class="form-control mt-5" rows="5" id="replyContent"
								placeholder="Reply or Forward this message..."></textarea>
							<div class="d-grid mt-3">
								<button class="btn btn-primary" id="sendReplyBtn">Send message</button>
							</div>
						</c:if>
					</div>
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
	// 답장보내기 버튼 눌렀을 때
	$("#sendReplyBtn").on("click", function(){
		var replyContent = $("#replyContent").val();
		var mailTitle = $("#mailTitle").text();
		var senderEmpNo = $("#senderEmpNo").val();
		if(replyContent == null || replyContent == ""){
			alert("내용을 입력해주세요!");
			return false;
		}
		
		var data = {
			mailTitle : mailTitle,
			replyContent : replyContent,
			senderEmpNo : senderEmpNo
		}
		
		$.ajax({
			url:"/email/sendReply",
			type:"post",
			data:JSON.stringify(data),
			contentType : "application/json;charset=utf-8",
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success:function(res){
				console.log("답장보내기 결과:"+res);
				location.href="/email/sentMailBox";
			}
		});
		webSocket.send("메일의 답장이 도착했습니다!,"+senderEmpNo);
	});
});
</script>