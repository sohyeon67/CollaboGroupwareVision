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
				<li class="breadcrumb-item active" aria-current="page">전자결재통계</li>
			</ol>
		</nav>
		<!-- END : Breadcrumb -->

		<h1 class="page-title mb-0 mt-2">전자결재통계</h1>
		<p class="lead"></p>

	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card" id="statDraft">
			<div class="card-body" id="chartDiv">
				<div>
					<select id="dclzYear">
						<c:forEach items="${yearList }" var="year">
							<option value="${year }">${year }</option>
						</c:forEach>
					</select>
				</div>
				
				<div class="table-responsive"><br/><br/>
					<table class="table table-bordered">
						<tr>
							<th width="10%">진행</th>
							<th width="10%">승인</th>
							<th width="10%">반려</th>
							<th width="10%">총</th>
						</tr>
						<tr>
							<td id="progress"></td>
							<td id="approval"></td>
							<td id="companion"></td>
							<td id="sum"></td>
						</tr>
					</table>
				</div>
				<div style="width:1300px" id="myChartPa"><br/><br/>
					<!-- <canvas id="myChart"></canvas> -->
				</div><br/><br/>
				<button class="btn btn-info" style="font-size:15px;" id="checkEmpDraftBtn" onclick="f_checkEmpDraft()">전직원 결재현황</button>
			</div>
		</div>
	</div>
</div>
<style>
#statDraft{
	min-width : 1300px;
}
table{
	text-align : center;
}
#chartDiv{
	margin : 0 auto;
}
#checkEmpDraftBtn{
	float : right;
}
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
var date = new Date();
var dclzYear = date.getFullYear()+"";

$("select[id=dclzYear]").val(dclzYear).prop("selected", true);

selectStatus(dclzYear);
//선택한 연도 가져오기
$("#dclzYear").on("change",function(){
	dclzYear = $("#dclzYear option:selected").val();
	if(dclzYear == null || dclzYear == ""){
		return false;
	}
	selectStatus(dclzYear);
	
});

// 12개월 막대그래프로 한번에!!
 function selectStatus(dclzYear){
	console.log("selectStatus() 실행..!");
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		dclzYear : dclzYear,	
	};
	
	$.ajax({
		url: "/stat/apprvStatusCount",
        type: "post",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
        dataType:"json",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (res) {
            // 성공 시 처리
            console.log("selectStatus() 실행", res); // 데이터 확인 (콘솔에 출력)
            
         	// 총을 합산하여 저장할 변수
         	var progress = 0;
         	var approval = 0;
         	var companion = 0;
            var sumCount = 0;
            var countByMonthArr1 = [];
            var countByMonthArr2 = [];
            var countByMonthArr3 = [];
            
            $.each(res, function (key, count) {
            	var month = key.split("_")[0];
            	var status = key.split("_")[1];
            	
            	// 테이블에 값넣기
            	if(status == "01"){		// 진행
            		progress += count
            		$("#progress").text(progress); 
            		sumCount += count;
            	}else if(status == "02"){// 승인
            		approval += count
	                $("#approval").text(approval);  
	                sumCount += count;
            	}else if(status == "03"){// 반려
            		companion += count
	                $("#companion").text(companion);       
	                sumCount += count;
            	}
                $("#sum").text(sumCount);   
            	
                // 그래프
            	for(i=1; i<=12; i++){
            		if(month == i){
            			if(status == "01"){		// 진행
            				countByMonthArr1[month-1] = count ;
                    	}else if(status == "02"){// 승인
            				countByMonthArr2[month-1] = count;
                    	}else if(status == "03"){// 반려
            				countByMonthArr3[month-1] = count;
                    	}
            		}
            	}
            	
                
             }); 
            
            html = "<canvas id='myChart'></canvas>";
            $("#myChartPa").html(html);
            draftAllChart(countByMonthArr1,countByMonthArr2,countByMonthArr3);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function draftAllChart(countByMonthArr1,countByMonthArr2,countByMonthArr3){
	const ctx = document.querySelector('#myChart');
	var youChart = new Chart(ctx, {
	    type: 'bar',
	    data: {
	    labels: ["1월","2월","3월","4월","6월","7월","8월","9월","10월","11월","12월"],
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# 진행',
	            data: countByMonthArr1,
	            borderWidth: 1,
	            backgroundColor:"rgba(255,204,000,0.8)"
	        },
	        {
	        	label: '# 승인',
	        	data: countByMonthArr2,
		        borderWidth: 1,
	        	backgroundColor:"rgba(000,102,000,0.8)"
	        },
	        {
	        	label: '# 반려',
	        	data: countByMonthArr3,
		        borderWidth: 1,
	        	backgroundColor:"rgba(255,000,000,0.8)"
	        }
	    ]
	    },
	    options: {
		    scales: {
		        y: {
			        beginAtZero: true,
			        ticks: {
						stepSize: 1
					}
		        }
		    }	
	    }
	});
}

// 전직원 결재현황 확인 버튼 클릭했을 때 이벤트
function f_checkEmpDraft(){
	location.href = "/stat/selectAllEmpDraft";
};
</script>
<script src="${pageContext.request.contextPath }/resources/assets/js/demo-purpose-only.js" defer></script>