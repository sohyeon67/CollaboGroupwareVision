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
				<li class="breadcrumb-item"><a href="/stat/statDclz">근태통계</a></li>
				<li class="breadcrumb-item"><a href="/stat/selectAllEmpDclz">전직원 근태현황</a></li>
				<li class="breadcrumb-item active" aria-current="page">부서근태비교</li>
			</ol>
		</nav>
		<!-- END : Breadcrumb -->

		<h1 class="page-title mb-0 mt-2">부서근태비교</h1>
		<p class="lead"></p>
	</div>
</div>

<div class="content__boxed">
	<div class="content__wrap">
		<div class="card">
			<div class="card-body" id="chartDiv">
				<div>
					<select id="dclzYear" onchange="dclzYearChange(this)">
						<c:forEach items="${yearList }" var="year">
							<option value="${year }">${year }</option>
						</c:forEach>
					</select>
					<select id="dclzMonth" onchange="dclzMonthChange(this)">
						<c:forEach begin="1" end="12" step="1" var="i">
							<option value="${i }">${i }</option>
						</c:forEach>
					</select>
				</div><br/><br/>
				<div class="row">
					<div class="col-md-6 chart" style="width: 730px;" id="normal"><br/><br/>
					</div><br/><br/>
					
					<div class="col-md-6 chart" style="width: 730px;" id="late"><br/><br/>
					</div><br/><br/>
				</div>
				
				<div class="row">
					<div class="col-md-6 chart" style="width: 730px;" id="businessTrip"><br/><br/>
					</div><br/><br/>
					
					<div class="col-md-6 chart" style="width: 730px;" id="annual"><br/><br/>
					</div><br/><br/>
				</div>
				
				<div class="row">
					<!-- <div class="col-md-6 chart" style="width: 800px;" id="halfDay"><br/><br/>
					</div><br/><br/> -->
					<div class="col-md-6" style="width: 730px;" id="etc"><br/><br/>
					</div><br/><br/>
					
					<div class="col-md-6 chart" style="width: 730px;" id="sick"><br/><br/>
					</div><br/><br/>
					
					
				</div>
			</div>
		</div>
	</div>
</div>
<style>
.col-md-6{
	margin : 30px auto;

}
/* .chart{
	margin : 30px auto;
	padding : 10px auto;
	width : 80%;
} */
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
//수를 담을 변수
var normal = $("#normal");			// 정상출근
var late = $("#late");		// 지각
var businessTrip = $("#businessTrip");	// 출장
var annual = $("#annual");		// 연차
var halfDay = $("#halfDay");		// 반차
var sick = $("#sick");		// 병가
var etc = $("#etc");			// 기타

var calTitle = "퇴근";
var date = new Date();
var dclzYear = date.getFullYear()+"";
var dclzMonth = date.getMonth() + 1+"";

$("select[id=dclzYear]").val(dclzYear).prop("selected", true);
$("select[id=dclzMonth]").val(dclzMonth).prop("selected", true);
console.log("dclzYear:",dclzYear,"dclzMonth:",dclzMonth);

// 들어오자마자 호출
normalStatus("퇴근",dclzYear,dclzMonth);
lateStatus("지각", dclzYear, dclzMonth);
businessStatus("출장", dclzYear, dclzMonth);
annualStatus("연차", dclzYear, dclzMonth);
//halfDayStatus("반차", dclzYear, dclzMonth);
sickStatus("병가", dclzYear, dclzMonth);
etcStatus("출근", dclzYear, dclzMonth);

// 선택한 연도 체인지 이벤트
function dclzYearChange(obj){
	dclzYear = $(obj).val();
	dclzMonth = $("#dclzMonth option:selected").val();
	
	if(dclzYear == null || dclzYear == "" || dclzMonth == null || dclzMonth == ""){
		return false;
	}
	normalStatus("퇴근",dclzYear,dclzMonth);
	lateStatus("지각", dclzYear, dclzMonth);
	businessStatus("출장", dclzYear, dclzMonth);
	annualStatus("연차", dclzYear, dclzMonth);
	//halfDayStatus("반차", dclzYear, dclzMonth);
	sickStatus("병가", dclzYear, dclzMonth);
	etcStatus("출근", dclzYear, dclzMonth);
}

// 선택한 월 체인지 이벤트
function dclzMonthChange(obj){
	dclzYear = $("#dclzYear option:selected").val();
	dclzMonth = $(obj).val();
	
	if(dclzYear == null || dclzYear == "" || dclzMonth == null || dclzMonth == ""){
		return false;
	}
	normalStatus("퇴근",dclzYear,dclzMonth);
	lateStatus("지각", dclzYear, dclzMonth);
	businessStatus("출장", dclzYear, dclzMonth);
	annualStatus("연차", dclzYear, dclzMonth);
	//halfDayStatus("반차", dclzYear, dclzMonth);
	sickStatus("병가", dclzYear, dclzMonth);
	etcStatus("출근", dclzYear, dclzMonth);
}

// 정상출근
function normalStatus(calTitle, dclzYear, dclzMonth){
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		calTitle : calTitle,
		dclzYear : dclzYear,
		dclzMonth : dclzMonth
	};
	$.ajax({
		url: "/stat/statDeptCompare",
        type: "post",
        dataType:"json",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (res) {
        	// 부서 이름과 비율을 담을 배열
    		var deptNameArr = [];
    		var dclzPercentArr = [];
    		
    		// res를 순회하며 부서 이름과 비율을 추출
            Object.keys(res).forEach(function (key) {
                var deptName = key.split(",")[1].split("=")[1];
                var percent = res[key];
				
                deptNameArr.push(deptName);
                dclzPercentArr.push(percent);
            });

            
            html = "<canvas id='normalChart'></canvas>";
            $("#normal").html(html);
            dclzNormalChart(deptNameArr,dclzPercentArr);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function dclzNormalChart(deptNameArr,dclzPercentArr){
	const ctx = document.querySelector('#normalChart');
	var youChart = new Chart(ctx, {
	    type: 'bar',    /*bar, line, pie, doughnut, radar*/
	    data: {
	    labels: deptNameArr,
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# '+dclzYear+'년'+dclzMonth+'월  부서별 정상출근율 비교',
	            data: dclzPercentArr.map(Number),
	            borderWidth: 1,
	            backgroundColor:'rgba(102,051,204,0.8)'
	        }
	    ]
	    },
	    options: {
	        //indexAxis:'y',
		    scales: {
		        y: {
			        beginAtZero: true,
			        ticks: {
			        	min : 0,
			        	max : 1
			        },
			        afterDataLimits: (scale) => {
			            scale.max = scale.max * 1.2;
			        }
		        }
		    }	
	    }
	});
}

//지각
function lateStatus(calTitle, dclzYear, dclzMonth){
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		calTitle : calTitle,
		dclzYear : dclzYear,
		dclzMonth : dclzMonth
	};
	$.ajax({
		url: "/stat/statDeptCompare",
        type: "post",
        dataType:"json",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (res) {
        	// 부서 이름과 비율을 담을 배열
    		var deptNameArr = [];
    		var dclzPercentArr = [];
    		
    		// res를 순회하며 부서 이름과 비율을 추출
            Object.keys(res).forEach(function (key) {
                var deptName = key.split(",")[1].split("=")[1];
                var percent = res[key];
				
                deptNameArr.push(deptName);
                dclzPercentArr.push(percent);
            });

            
            html = "<canvas id='lateChart'></canvas>";
            $("#late").html(html);
            dclzLateChart(deptNameArr,dclzPercentArr);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function dclzLateChart(deptNameArr,dclzPercentArr){
	const ctx = document.querySelector('#lateChart');
	var youChart = new Chart(ctx, {
	    type: 'bar',    /*bar, line, pie, doughnut, radar*/
	    data: {
	    labels: deptNameArr,
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# '+dclzYear+'년'+dclzMonth+'월 부서별 지각율 비교',
	            data: dclzPercentArr.map(Number),
	            borderWidth: 1,
	            backgroundColor:'rgba(100,255,255,0.8)'
	        }
	    ]
	    },
	    options: {
	        //indexAxis:'y',
		    scales: {
		        y: {
			        beginAtZero: true,
			        ticks: {
			        	min : 0,
			        	max : 1
			        },
			        afterDataLimits: (scale) => {
			            scale.max = scale.max * 1.2;
			        }
		        }
		    }	
	    }
	});
}

//출장
function businessStatus(calTitle, dclzYear, dclzMonth){
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		calTitle : calTitle,
		dclzYear : dclzYear,
		dclzMonth : dclzMonth
	};
	$.ajax({
		url: "/stat/statDeptCompare",
        type: "post",
        dataType:"json",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (res) {
        	// 부서 이름과 비율을 담을 배열
    		var deptNameArr = [];
    		var dclzPercentArr = [];
    		
    		// res를 순회하며 부서 이름과 비율을 추출
            Object.keys(res).forEach(function (key) {
                var deptName = key.split(",")[1].split("=")[1];
                var percent = res[key];
				
                deptNameArr.push(deptName);
                dclzPercentArr.push(percent);
            });

            
            html = "<canvas id='businessChart'></canvas>";
            $("#businessTrip").html(html);
            dclzBusinessChart(deptNameArr,dclzPercentArr);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function dclzBusinessChart(deptNameArr,dclzPercentArr){
	const ctx = document.querySelector('#businessChart');
	var youChart = new Chart(ctx, {
	    type: 'bar',    /*bar, line, pie, doughnut, radar*/
	    data: {
	    labels: deptNameArr,
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# '+dclzYear+'년'+dclzMonth+'월 부서별 출장율 비교',
	            data: dclzPercentArr.map(Number),
	            borderWidth: 1,
	            backgroundColor:'rgba(000,204,051,0.8)'
	        }
	    ]
	    },
	    options: {
	        //indexAxis:'y',
		    scales: {
		        y: {
			        beginAtZero: true,
			        ticks: {
			        	min : 0,
			        	max : 1
			        },
			        afterDataLimits: (scale) => {
			            scale.max = scale.max * 1.2;
			        }
		        }
		    }	
	    }
	});
}

// 연차
function annualStatus(calTitle, dclzYear, dclzMonth){
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		calTitle : calTitle,
		dclzYear : dclzYear,
		dclzMonth : dclzMonth
	};
	$.ajax({
		url: "/stat/statDeptCompare",
        type: "post",
        dataType:"json",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (res) {
        	// 부서 이름과 비율을 담을 배열
    		var deptNameArr = [];
    		var dclzPercentArr = [];
    		
    		// res를 순회하며 부서 이름과 비율을 추출
            Object.keys(res).forEach(function (key) {
                var deptName = key.split(",")[1].split("=")[1];
                var percent = res[key];
				
                deptNameArr.push(deptName);
                dclzPercentArr.push(percent);
            });

            
            html = "<canvas id='annualChart'></canvas>";
            $("#annual").html(html);
            dclzAnnualChart(deptNameArr,dclzPercentArr);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function dclzAnnualChart(deptNameArr,dclzPercentArr){
	const ctx = document.querySelector('#annualChart');
	var youChart = new Chart(ctx, {
	    type: 'bar',    /*bar, line, pie, doughnut, radar*/
	    data: {
	    labels: deptNameArr,
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# '+dclzYear+'년'+dclzMonth+'월 부서별 연차율 비교',
	            data: dclzPercentArr.map(Number),
	            borderWidth: 1,
	            backgroundColor:'rgba(255,153,000,0.8)'
	        }
	    ]
	    },
	    options: {
	        //indexAxis:'y',
		    scales: {
		        y: {
			        beginAtZero: true,
			        ticks: {
			        	min : 0,
			        	max : 1
			        },
			        afterDataLimits: (scale) => {
			            scale.max = scale.max * 1.2;
			        }
		        }
		    }	
	    }
	});
}

// 반차
/*function halfDayStatus(calTitle, dclzYear, dclzMonth){
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		calTitle : calTitle,
		dclzYear : dclzYear,
		dclzMonth : dclzMonth
	};
	$.ajax({
		url: "/stat/statDeptCompare",
        type: "post",
        dataType:"json",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (res) {
        	// 부서 이름과 비율을 담을 배열
    		var deptNameArr = [];
    		var dclzPercentArr = [];
    		
    		// res를 순회하며 부서 이름과 비율을 추출
            Object.keys(res).forEach(function (key) {
                var deptName = key.split(",")[1].split("=")[1];
                var percent = res[key];
				
                deptNameArr.push(deptName);
                dclzPercentArr.push(percent);
            });

            
            html = "<canvas id='halfDayChart'></canvas>";
            $("#halfDay").html(html);
            dclzHalfDayChart(deptNameArr,dclzPercentArr);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function dclzHalfDayChart(deptNameArr,dclzPercentArr){
	const ctx = document.querySelector('#halfDayChart');
	var youChart = new Chart(ctx, {
	    type: 'bar',    
	    data: {
	    labels: deptNameArr,
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# '+dclzYear+'년'+dclzMonth+'월 부서별 반차율 비교',
	            data: dclzPercentArr.map(Number),
	            borderWidth: 1,
	            backgroundColor:'rgba(255,051,153,0.8)'
	        }
	    ]
	    },
	    options: {
	        //indexAxis:'y',
		    scales: {
		        y: {
			        beginAtZero: true,
		        }
		    }	
	    }
	});
}*/

//병가
function sickStatus(calTitle, dclzYear, dclzMonth){
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		calTitle : calTitle,
		dclzYear : dclzYear,
		dclzMonth : dclzMonth
	};
	$.ajax({
		url: "/stat/statDeptCompare",
        type: "post",
        dataType:"json",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (res) {
        	// 부서 이름과 비율을 담을 배열
    		var deptNameArr = [];
    		var dclzPercentArr = [];
    		
    		// res를 순회하며 부서 이름과 비율을 추출
            Object.keys(res).forEach(function (key) {
                var deptName = key.split(",")[1].split("=")[1];
                var percent = res[key];
				
                deptNameArr.push(deptName);
                dclzPercentArr.push(percent);
            });

            
            html = "<canvas id='sickChart'></canvas>";
            $("#sick").html(html);
            dclzSickChart(deptNameArr,dclzPercentArr);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function dclzSickChart(deptNameArr,dclzPercentArr){
	const ctx = document.querySelector('#sickChart');
	var youChart = new Chart(ctx, {
	    type: 'bar',    /*bar, line, pie, doughnut, radar*/
	    data: {
	    labels: deptNameArr,
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# '+dclzYear+'년'+dclzMonth+'월 부서별 병가율 비교',
	            data: dclzPercentArr.map(Number),
	            borderWidth: 1,
	            backgroundColor:'rgba(000,102,153,0.8)'
	        }
	    ]
	    },
	    options: {
	        //indexAxis:'y',
		    scales: {
		        y: {
			        beginAtZero: true,
			        ticks: {
			        	min : 0,
			        	max : 1
			        },
			        afterDataLimits: (scale) => {
			            scale.max = scale.max * 1.2;
			        }
		        }
		    }	
	    }
	});
}

// 퇴근미체크
function etcStatus(calTitle, dclzYear, dclzMonth){
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var data = {
		calTitle : calTitle,
		dclzYear : dclzYear,
		dclzMonth : dclzMonth
	};
	$.ajax({
		url: "/stat/statDeptCompare",
        type: "post",
        dataType:"json",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
        success: function (res) {
        	// 부서 이름과 비율을 담을 배열
    		var deptNameArr = [];
    		var dclzPercentArr = [];
    		
    		// res를 순회하며 부서 이름과 비율을 추출
            Object.keys(res).forEach(function (key) {
                var deptName = key.split(",")[1].split("=")[1];
                var percent = res[key];
				
                deptNameArr.push(deptName);
                dclzPercentArr.push(percent);
            });

            
            html = "<canvas id='etcChart'></canvas>";
            $("#etc").html(html);
            dclzEtcChart(deptNameArr,dclzPercentArr);	// 그래프 호출
        },
        error: function (error) {
            console.log("Ajax 요청 실패 : ", error);
        }
    });
}

function dclzEtcChart(deptNameArr,dclzPercentArr){
	const ctx = document.querySelector('#etcChart');
	var youChart = new Chart(ctx, {
	    type: 'bar',    /*bar, line, pie, doughnut, radar*/
	    data: {
	    labels: deptNameArr,
	    // mix는 line과 bar만 가능
	    datasets: [
	        {
	            label: '# '+dclzYear+'년'+dclzMonth+'월 부서별 퇴근미체크 비교',
	            data: dclzPercentArr.map(Number),
	            borderWidth: 1,
	            backgroundColor:'rgba(204,000,051,0.8)'
	        }
	    ]
	    },
	    options: {
	        //indexAxis:'y',
		    scales: {
		        y: {
			        beginAtZero: true,
			        ticks: {
			        	min : 0,
			        	max : 1
			        },
			        afterDataLimits: (scale) => {
			            scale.max = scale.max * 1.2;
			        }
		        }
		    }	
	    }
	});
}

</script>