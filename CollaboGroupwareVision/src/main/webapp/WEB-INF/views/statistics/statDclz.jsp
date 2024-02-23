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
				<li class="breadcrumb-item active" aria-current="page">근태통계</li>
			</ol>
		</nav>
		<!-- END : Breadcrumb -->

		<h1 class="page-title mb-0 mt-2">근태 통계</h1>
		<p class="lead"></p>
	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card" id="statDclz">
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
							<th width="10%">정상출근</th>
							<th width="10%">지각</th>
							<th width="10%">출장</th>
							<th width="10%">연차</th>
							<!-- <th width="10%">반차</th> -->
							<th width="10%">병가</th>
							<th width="10%">기타</th>
							<th width="10%">총</th>
						</tr>
						<tr>
							<td id="normal"></td>
							<td id="late"></td>
							<td id="businessTrip"></td>
							<td id="Annual"></td>
							<!-- <td id="halfDay"></td> -->
							<td id="sick"></td>
							<td id="etc"></td>
							<td id="sum"></td>
						</tr>
					</table>
				</div>
				<!-- 차트의 크기는 부모 사이즈에 의해 결정됨 -->
				<div style="width: 800px;" id="myChartPa"><br/><br/>
					<!-- <canvas id="myChart"></canvas> -->
				</div><br/><br/>
				<button class="btn btn-info" style="font-size:15px;" id="checkEmpDclzBtn" onclick="f_checkEmpDclz()">전직원 근태현황</button>
			</div>
		</div>
	</div>
</div>
<style>
#statDclz{
	width: 80%;
	min-width : 1000px;
}
table{
	text-align : center;
}
#chartDiv{
	margin : 0 auto;
}
#checkEmpDclzBtn{
	float : right;
}
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
var date = new Date();
var dclzYear = date.getFullYear()+"";

$("select[id=dclzYear]").val(dclzYear).prop("selected", true);

selectStatus(dclzYear); //당월 근태현황 호출

// 선택한 연도 가져오기
$("#dclzYear").on("change",function(){
	dclzYear = $("#dclzYear option:selected").val();
	if(dclzYear == null || dclzYear == ""){
		return false;
	}
	selectStatus(dclzYear);
});

function selectStatus(dclzYear){
	console.log("selectStatus() 실행..!");
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		dclzYear : dclzYear
	};
		
	$.ajax({
		url: "/stat/someDclzStatusCount",
        type: "post",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
        dataType:"json",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (data) {
            // 수를 담을 변수
			var normal = 0;			// 정상출근
			var late = 0;			// 지각
			var businessTrip = 0;	// 출장
			var Annual = 0;			// 연차
			/* var halfDay = 0;		// 반차 */
			var sick = 0;			// 병가
			var etc = 0;			// 기타
            var sumCount = 0;		// 총
            // 1~12월
            var cntArr1 = [];		
            var cntArr2 = [];		
            var cntArr3 = [];	
            var cntArr4 = [];
            var cntArr5 = [];
            var cntArr6 = [];
            var cntArr7 = [];
            var cntArr8 = [];
            var cntArr9 = [];
            var cntArr10 = [];
            var cntArr11 = [];
            var cntArr12 = [];
            var cntArrAll = [
           		cntArr1,cntArr2,cntArr3,cntArr4,
           		cntArr5,cntArr6,cntArr7,cntArr8,
           		cntArr9,cntArr10,cntArr11,cntArr12
            ];
            
            $.each(data, function (key, count) {
            	var month = key.split("_")[0];
            	var title = key.split("_")[1].trim();
            	
            	if(title == "퇴근"){
            		normal += count; 
            		sumCount += count;
            	}else if(title == "지각"){
            		late += count;
	                sumCount += count;
            	}else if(title == "출장"){
            		businessTrip += count;      
	                sumCount += count;
            	}else if(title == "연차"){
            		Annual += count;   
	                sumCount += count;
            	}else if(title == "병가"){
            		sick += count; 
	                sumCount += count;
            	}else if(title == "출근"){
            		etc += count;   
            		sumCount += count;
            		
            	}
            	$("#normal").text(normal);
            	$("#late").text(late);
            	$("#businessTrip").text(businessTrip);
            	$("#Annual").text(Annual);
            	/* $("#halfDay").text(halfDay); */
            	$("#sick").text(sick);
            	$("#etc").text(etc);
                $("#sum").text(sumCount);   
                
             	// 그래프
            	for(i=1; i<=12; i++){
            		if(month == i){
            			if(title == "지각"){// 지각
                    		cntArrAll[i-1][0] = count;
                    	}else if(title == "출장"){// 출장
                    		cntArrAll[i-1][1] = count;
                    	}else if(title == "연차"){// 연차
                    		cntArrAll[i-1][2] = count;
                    	}else if(title == "병가"){// 병가
                    		cntArrAll[i-1][3] = count;
                    	}else if(title == "출근"){					// 기타
                    		cntArrAll[i-1][4] = count;
                    	}
            		}
            	}
             }); 
            
            html = "<canvas id='myChart'></canvas>";
            $("#myChartPa").html(html);
            dclzAllChart(cntArr1,cntArr2,cntArr3,cntArr4,cntArr5,cntArr6,cntArr7,cntArr8,cntArr9,cntArr10,cntArr11,cntArr12);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function dclzAllChart(cntArr1,cntArr2,cntArr3,cntArr4,cntArr5,cntArr6,cntArr7,cntArr8,cntArr9,cntArr10,cntArr11,cntArr12){
	const ctx = document.querySelector('#myChart');
	var youChart = new Chart(ctx, {
	    type: 'line',    /*bar, line, pie, doughnut, radar*/
	    data: {
	    labels: ['지각', '출장', '연차', '병가', '기타'],
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# 1월',
	            data: cntArr1,
	            borderWidth: 1,
	            borderColor : 'rgba(255,0,0,0.8)',
	            backgroundColor:'rgba(255,0,0,0.8)'
	        },
	        {
	            label: '# 2월',
	            data: cntArr2,
	            borderWidth: 1,
	            borderColor : 'rgba(255,165,0,0.8)',
	            backgroundColor:'rgba(255,165,0,0.8)'
	        },
	        {
	            label: '# 3월',
	            data: cntArr3,
	            borderWidth: 1,
	            borderColor : 'rgba(255,255,0,0.8)',
	            backgroundColor:'rgba(255,255,0,0.8)'
	        },
	        {
	            label: '# 4월',
	            data: cntArr4,
	            borderWidth: 1,
	            borderColor : 'rgba(0,128,0,0.8)',
	            backgroundColor:'rgba(0,128,0,0.8)'
	        },
	        {
	            label: '# 5월',
	            data: cntArr5,
	            borderWidth: 1,
	            borderColor : 'rgba(0,191,255,0.8)',
	            backgroundColor:'rgba(0,191,255,0.8)'
	        },
	        {
	            label: '# 6월',
	            data: cntArr6,
	            borderWidth: 1,
	            borderColor : 'rgba(0,0,255,0.8)',
	            backgroundColor:'rgba(0,0,255,0.8)'
	        },
	        {
	            label: '# 7월',
	            data: cntArr7,
	            borderWidth: 1,
	            borderColor : 'rgba(128,0,128,0.8)',
	            backgroundColor:'rgba(128,0,128,0.8)'
	        },
	        {
	            label: '# 8월',
	            data: cntArr8,
	            borderWidth: 1,
	            borderColor : 'rgba(255,192,203,0.8)',
	            backgroundColor:'rgba(255,192,203,0.8)'
	        },
	        {
	            label: '# 9월',
	            data: cntArr9,
	            borderWidth: 1,
	            borderColor : 'rgba(255,215,0,0.8)',
	            backgroundColor:'rgba(255,215,0,0.8)'
	        },
	        {
	            label: '# 10월',
	            data: cntArr10,
	            borderWidth: 1,
	            borderColor : 'rgba(128,128,128,0.8)',
	            backgroundColor:'rgba(128,128,128,0.8)'
	        },
	        {
	            label: '# 11월',
	            data: cntArr11,
	            borderWidth: 1,
	            borderColor : 'rgba(0,128,128,0.8)',
	            backgroundColor:'rgba(0,128,128,0.8)'
	        },
	        {
	            label: '# 12월',
	            data: cntArr12,
	            borderWidth: 1,
	            borderColor : 'rgba(128,0,0,0.8)',
	            backgroundColor:'rgba(128,0,0,0.8)'
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

// 전직원 근태현황 확인 버튼 클릭했을 때 이벤트
function f_checkEmpDclz(){
	location.href = "/stat/selectAllEmpDclz";
};
</script>
<script src="${pageContext.request.contextPath }/resources/assets/js/demo-purpose-only.js" defer></script>
