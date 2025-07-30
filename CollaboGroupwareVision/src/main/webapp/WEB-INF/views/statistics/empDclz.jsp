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
				<li class="breadcrumb-item active" aria-current="page">전직원 근태현황</li>
			</ol>
		</nav>
		<!-- END : Breadcrumb -->

		<h1 class="page-title mb-0 mt-2">근태통계</h1>
		<p class="lead"></p>
	</div>
</div>

<div class="content__boxed">
    <div class="content__wrap">
        <div class="card" id="statDclz">
            <div class="card-body" id="chartDiv">
                <div class="card h-100">
                    <div class="card-body">
                    
                    	<!-- 부서 선택 -->
						<select id="deptDclzList" onchange="deptChange(this)">
                        	<option selected value="all">전체</option>
                        	<c:forEach items="${deptList }" var="dept">
                        		<option value="${dept.deptCode }">${dept.deptName }</option>
                        	</c:forEach>
                        </select>
                        
                        <h5 class="card-title">근태현황</h5><br/>

                        <!-- 직원 근태 테이블 -->
                        <div class="table-responsive">
                            <!-- 테이블을 나타낼 테이블 요소 -->
                            <table class="table table-sm table-bordered" id="weekTable">
                                <thead>
                                    <tr id="week">
                                        <!-- 여기에 동적으로 생성될 날짜 헤더를 추가 -->
                                    </tr>
                                </thead>
                                <tbody id="empDclz">
                                	<tr empDclzTR style="display:none;">
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                    <!-- 여기에 동적으로 생성될 테이블 내용을 추가 -->
                                </tbody>
                            </table>
                        </div>

                        <!-- 이전 주, 다음 주로 이동할 화살표 -->
                        <div>
                            <button class="btn btn-light" onclick="fPre()">이전</button>
                            <button class="btn btn-light" onclick="fNext()">다음</button>
                            <button class="btn btn-warning" id="deptCompare" onclick="fDeptCompare()">부서별 근태비교</button>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<style>
    .current-date {
        background-color: #ffff99; 
    }
    
    #deptDclzList, #deptCompare{
    	float: right;
    }
</style>
<script>
//현재 날짜 기준
var now = new Date();

//월요일로 만들어주기
function schMonday(pNow){
    pNow.setDate(pNow.getDate()-pNow.getDay()+1);
}

if(now.getDay() != 0){          // 0(일)~6(토) 
    schMonday(now);
}
//특정 날짜가 오늘인지 확인하는 함수
function isToday(date) {
    const today = new Date();
    return (
        date.getFullYear() === today.getFullYear() &&
        date.getMonth() === today.getMonth() &&
        date.getDate() === today.getDate()
    );
}
//일주일 날짜 구하기
function getCurrentWeek(day, deptCode) {
	var result = [];	// 날짜 담을 배열
	// 이번주 일요일부터 일주일 세팅
	const sunday = day.getTime() - 86400000 * day.getDay();
	day.setTime(sunday);
	day.toISOString().slice(0, 10)
	result.push(day.toISOString().slice(0, 10));
	
	for (let i = 1; i < 7; i++) {
	    day.setTime(day.getTime() + 86400000);
	    result.push(day.toISOString().slice(0, 10));
	}
	
	// 화면에 띄우기
	var html = "<th>사번</th><th>이름</th><th>부서</th>";
	for(j=1; j<result.length; j++){
		if (isToday(new Date(result[j]))) {
            html += "<th><span class='current-date'>" + result[j] + "</span></th>";
        } else {
            html += "<th>" + result[j] + "</th>";
        }
	}
	
	// 다음주 일요일 세팅
	const nextSunday = day.getTime() - 86400000 * (day.getDay()-7);
	day.setTime(nextSunday);
	html += "<th>"+day.toISOString().slice(0, 10)+"</th>";
	result.push(day.toISOString().slice(0, 10));
	
	$("#week").html(html);
	setTimeout(() => {
		empDclz(result, deptCode);	// 직원리스트 호출
	}, 300);
	
	day.setTime(sunday);	// 초기화
	
}

var empDclzTR = document.querySelector("[empDclzTR]");

//직원리스트 뽑아오는 함수
function empDclz(day, deptCode) {
 var data = {
     dayArray: day
 }; 
 console.log("empDclz");
 
 $.ajax({
     url: "/stat/empDclz",
     type: "post",
     data: JSON.stringify(data),
     contentType: "application/json;charset=utf-8",
     beforeSend: function(xhr) {
         xhr.setRequestHeader(header, token);
     },
     dataType: "json",
     success: function(res){
         var empDclzContainer = document.getElementById("empDclz");
         empDclzContainer.innerHTML = ""; // 기존 내용 초기화

         // 사번을 기준으로 데이터를 그룹화
         var groupedData = {};
         res.forEach(function(v) {
             if (!groupedData[v.empNo]) {
                 groupedData[v.empNo] = {
                     empNo: v.empNo,
                     empName: v.employee.empName,
                     departmentCode : v.employee.deptCode,
                     department: v.dept.deptName,
                     calTitles: {} // 날짜별 calTitle을 담을 객체
                 };
             }
             // 각 날짜에 대한 calTitle 추가
             var date = v.dclzNo.substring(0, 6);
             groupedData[v.empNo].calTitles[date] = v.calTitle;
         });

         // 그룹화된 데이터를 기반으로 테이블 생성
         Object.values(groupedData).forEach(function(group) {
        	 if(deptCode == null){	// 전체리스트
	             var newEmpDclzTR = empDclzTR.cloneNode(true);
	             newEmpDclzTR.style.display = "table-row";
	
	             newEmpDclzTR.cells[0].innerHTML = group.empNo;
	             newEmpDclzTR.cells[1].innerHTML = group.empName;
	             newEmpDclzTR.cells[2].innerHTML = group.department;
	
	             for (var j = 1; j < 8; j++) {
	                 var date = day[j].split("-")[0].substring(2, 4) + day[j].split("-")[1] + day[j].split("-")[2];
	                 newEmpDclzTR.cells[j + 2].innerHTML = group.calTitles[date] || "";
	             }
	
	             empDclzContainer.appendChild(newEmpDclzTR);
        	 }else{	// 부서별 리스트
	        	 if(deptCode == group.departmentCode){
	        		 var newEmpDclzTR = empDclzTR.cloneNode(true);
		             newEmpDclzTR.style.display = "table-row";
		
		             newEmpDclzTR.cells[0].innerHTML = group.empNo;
		             newEmpDclzTR.cells[1].innerHTML = group.empName;
		             newEmpDclzTR.cells[2].innerHTML = group.department;
		
		             for (var j = 1; j < 8; j++) {
		                 var date = day[j].split("-")[0].substring(2, 4) + day[j].split("-")[1] + day[j].split("-")[2];
		                 newEmpDclzTR.cells[j + 2].innerHTML = group.calTitles[date] || "";
		             }
		             
		             let sel = document.querySelector("select[id=deptDclzList]").options;
		             for (let i=0; i<sel.length; i++) {
		                 if (sel[i].value == group.department) sel[i].selected = true;
		             }
		             empDclzContainer.appendChild(newEmpDclzTR);
	        	 }
        	 }
         });
     }
 });
}
// 부서 선택했을 때 getCurrentWeek 호출
function deptSelected(dept){
	if(dept == "all"){
		getCurrentWeek(now);
	}else{
		getCurrentWeek(now,dept);
	}
}

//이전주
function fPre(){
	now.setDate(now.getDate()-7);
	let sel = document.querySelector("select[id=deptDclzList]");
	let dept = sel.options[sel.selectedIndex].value;
	deptSelected(dept);
}

//다음주
function fNext(){
	now.setDate(now.getDate()+7);
	let sel = document.querySelector("select[id=deptDclzList]");
	let dept = sel.options[sel.selectedIndex].value;
	deptSelected(dept);
}

// 데이터 포맷 : 현재는 사용하지 않음
function dayFormat(pNow,pSep){
    var swYear = pNow.getFullYear();
    var swMonth = pNow.getMonth()+1;
    if(swMonth < 10){
        swMonth = "0" + swMonth;
    }
    var swDate = pNow.getDate();
    if(swDate < 10 ){
        swDate = "0" + swDate;
    }

    return swYear + pSep + swMonth + pSep + swDate; 
}

//현재 날짜 기준으로 호출
getCurrentWeek(now);

// 부서별 리스트 불러오기
function deptChange(obj){
	var dept = $(obj).val();
	deptSelected(dept);
}

function fDeptCompare(){
	location.href = "/stat/deptCompare";
}
</script>