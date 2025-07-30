<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/">Home</a></li>
				<li class="breadcrumb-item">통계</li>
				<li class="breadcrumb-item"><a href="/stat/statDraft">전자결재통계</a></li>
				<li class="breadcrumb-item"><a href="/stat/selectAllEmpDraft">전직원 결재현황</a></li>
				<li class="breadcrumb-item active" aria-current="page">반려사유분석</li>
			</ol>
		</nav>
		<!-- END : Breadcrumb -->

		<h1 class="page-title mb-0 mt-2">반려사유분석</h1>
		<p class="lead"></p>
	</div>
</div>

<div class="content__boxed">
    <div class="content__wrap">
        <div class="card" id="statDclz">
            <div class="card-body" id="">
                <div class="card h-100">
                    <div class="card-body">
						<button class="sendURL">입력</button><br/>
						<div class="inside-text"></div>
						
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
$(function(){
	
	$(".sendURL").click(function() {
		var contents = "";
		$.ajax({
			url : '/stat/getURL',
			type : 'get',
			beforeSend: function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(data) {
				console.log("data:",data);
				/* var words = new Array();
				$('.inside-text').empty();
				words = data;
				for (var i = 0; i < data.length; i++) {
					contents += "<span class='a"+[i]+"'>"+words[i]+"</span>";
				}
				$(".inside-text").html(contents + "&nbsp" + "&nbsp");
				for (var i = 0; i < data.length; i++) {
					for (var j = i + 1; j < data.length; j++) {
						if (data[i] == words[j]) {
							var size = $(".a" + [i]).css('font-size',"+=10");
						}
					}
				} */
			}
		});
	});
});
</script>