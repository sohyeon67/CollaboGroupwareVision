<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<link rel="stylesheet" href="https://cdn.dhtmlx.com/gantt/edge/dhtmlxgantt.css">
<script src="https://cdn.dhtmlx.com/gantt/edge/dhtmlxgantt.js"></script>

<style>
.gantt_grid_head_cell, .gantt_scale_cell {
	font-size: 1.0rem;
}

.gantt_tree_content, .gantt_task_content, .gantt_marker .gantt_marker_content {
	font-size: 0.9rem;
}

.start_day {
	background-color: rgba(12, 163, 10, 0.5);
}
.end_day {
	background-color: rgba(127, 140, 141, 0.5);
}
.start_day .gantt_marker_content, .today .gantt_marker_content, .end_day .gantt_marker_content {
	color: black;
}
</style>

<div class="content__header content__boxed overlapping">
	<div class="content__wrap">

		<!-- Breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0">
				<li class="breadcrumb-item"><a href="/index">Home</a></li>
				<li class="breadcrumb-item"><a href="/project">프로젝트</a></li>
				<li class="breadcrumb-item active" aria-current="page">${project.projectName }</li>
			</ol>
		</nav>
		<!-- Breadcrumb 끝-->
		<br />

	</div>

</div>


<div class="content__boxed">
	<div class="content__wrap order-2 flex-fill min-w-0">
		
		<div class="tab-base">
			<ul class="nav nav-tabs" role="tablist">
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/overview" class="fs-5 nav-link">개요</a></li>
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/issue"
					class="fs-5 nav-link">일감</a></li>
				<li class="nav-item" role="presentation"><a
					href="/project/${project.projectId }/ganttChart"
					class="fs-5 nav-link active">간트차트</a></li>
			</ul>
			
			<div class="tab-content">
				<h3 class="fw-bold mt-2 mb-4"><i class="ti-bar-chart me-2"></i>간트차트</h3>
				<div class="mb-2">
					<c:forEach var="map" items="${commonCodes}">
					    <c:if test="${map['COMMON_CODE_GROUP_ID'] == '902'}">
					        <span class="me-2">
					            <span class="d-inline-block rounded-circle p-1 me-1"
					                  style="background-color: 
					                         <c:choose>
					                             <c:when test="${map['COMMON_CODE'] == '01'}">#3498db</c:when>
					                             <c:when test="${map['COMMON_CODE'] == '02'}">#2ecc71</c:when>
					                             <c:when test="${map['COMMON_CODE'] == '03'}">#8e44ad</c:when>
					                             <c:when test="${map['COMMON_CODE'] == '04'}">#f39c12</c:when>
					                             <c:when test="${map['COMMON_CODE'] == '05'}">#e74c3c</c:when>
					                             <c:when test="${map['COMMON_CODE'] == '06'}">#7f8c8d</c:when>
					                         </c:choose>
					                         ">
					            </span>${map['COMMON_CODE_NAME']}</span>
					    </c:if>
					</c:forEach>
				</div>
				
				<!-- 간트차트 -->
				<div id="gantt_here" style="width:100%; height:550px;"></div>
			</div>
		</div>
		
		
	</div>
</div>


<script>
$(function() {
	var projectId = "${project.projectId}";
	
	var ganttData = {
	    data: [
	        <c:forEach var="issue" items="${issueList}" varStatus="loop">
	            {
	                id: "${issue.issueNo}",
	                text: "${issue.issueTitle}",
	                start_date: convertDateFromFormat("${issue.issueStartDay}"),
	                // 시작일과 종료일이 같은 경우 1칸, 하루 차이일 때 2칸...
	                duration: calculateDuration("${issue.issueStartDay}", "${issue.issueEndDay}") + 1,
	                progress: "${issue.issueProgress}"/100,
	                color: 
	                	<c:choose>
			               <c:when test="${issue.issueStatus == '01'}">'#3498db'</c:when>
			               <c:when test="${issue.issueStatus == '02'}">'#2ecc71'</c:when>
			               <c:when test="${issue.issueStatus == '03'}">'#8e44ad'</c:when>
			               <c:when test="${issue.issueStatus == '04'}">'#f39c12'</c:when>
			               <c:when test="${issue.issueStatus == '05'}">'#e74c3c'</c:when>
			               <c:when test="${issue.issueStatus == '06'}">'#7f8c8d'</c:when>
			           </c:choose>,
					details: "담당자 : ${issue.issueChargerName}<br>"+
								"진척도 : ${issue.issueProgress}%"
	            }<c:if test="${!loop.last}">,</c:if>
	        </c:forEach>
	    ]
	};
	
	// 추가한 기능
	gantt.plugins({
		marker: true,
	    quick_info: true,
	});
	
	// Task 추가 및 편집 기능 숨기기
    gantt.config.drag_move = false;		// 날짜 바꾸기 x
    gantt.config.drag_links = false;	// task 간의 dependency 드래그 비활성화
    gantt.config.drag_progress = false; // 진행 상황 드래그 비활성화
    gantt.config.drag_resize = false; // task 크기 조절 드래그 비활성화
    
	// Lightbox 감추기
    gantt.showLightbox = function(id) {
        return false;
    };
    // task 추가 기능 없애기
	gantt.config.columns = [
		{name: "text", tree: true, width: '*', resize: true},
		{name: "start_date", align: "center", resize: true},
		{name: "duration", align: "center"}
	];
    
	// 날짜부분 설정
	gantt.config.scales = [
		{unit: "month", step: 1, format: "%F, %Y"},
	    {unit: "day", step: 1, format: "%j %D"}
	];
	gantt.config.scale_height = 80;
    
    // 클릭했을 때 나오는 quickinfo에 버튼만들기
	gantt.config.quickinfo_buttons=["issueDetails"];
	gantt.locale.labels["issueDetails"] = "상세보기";
	
	// quickinfo 정보 바꾸기
	gantt.templates.quick_info_title = function(start, end, task) {
        return "<strong>" + task.text + "</strong>";
    };
	gantt.templates.quick_info_date = function(start, end, task) {
		var dateFormat = gantt.date.date_to_str("%Y-%m-%d");
		var startDate = dateFormat(start);
        var endDate = dateFormat(gantt.date.add(end, -1, 'day'));	// 실제 종료일은 차트종료일-1
        
		return "<br>시작일: " + startDate + "<br>종료일: " + endDate;
	};
	
	gantt.init("gantt_here");
	gantt.parse(ganttData);		// 데이터 리스트 넣기
	
    gantt.$click.buttons.issueDetails = function(id){
        console.log("일감번호", id);
        location.href="/project/issue/"+id;
        //return false; // lightbox 막기
    };
    
    // 오늘날짜 마커 추가
	var today = new Date();
	today.setHours(0, 0, 0, 0);	// 현재 시간을 00:00:00으로 설정
    gantt.addMarker({
        start_date: today,
        css: "today",
        text: "오늘",
        title: "Today: " + gantt.date.date_to_str("%Y-%m-%d")(today),
        id: "today"
    });
    
    // 프로젝트 시작일 마커
    var startDay = convertDateFromFormat("${project.projectStartDay}");
    gantt.addMarker({
        start_date: startDay,
        css: "start_day",
        text: "시작",
        title: gantt.date.date_to_str("%Y-%m-%d")(startDay),
        id: "startDay"
    });
    
    // 프로젝트 종료일 마커
    var endDay = convertDateFromFormat("${project.projectEndDay}");
    endDay.setDate(endDay.getDate() + 1);	// 종료일의 끝 부분에 표시하기 위해 종료일에 하루 더함
    gantt.addMarker({
        start_date: endDay,
        css: "end_day",
        text: "종료",
        title: gantt.date.date_to_str("%Y-%m-%d")(today),
        id: "endDay"
    });
    
	// Gantt Chart에서 오늘 날짜로 스크롤 이동
    gantt.showDate(today);
    
});


// DB에 저장된 날짜(yyyyMMdd)를 데이터 객체로 바꿔주는 함수
function convertDateFromFormat(input) {
    var year = parseInt(input.substring(0, 4), 10);
    var month = parseInt(input.substring(4, 6), 10) - 1; // 월이 0부터 시작
    var day = parseInt(input.substring(6, 8), 10);

    return new Date(year, month, day);
}


//날짜 차이를 일수로 계산하는 함수
function calculateDuration(startDate, endDate) {
	const start = convertDateFromFormat(startDate);
	const end = convertDateFromFormat(endDate);
    
    const timeDiff = end - start;

	// 밀리초를 일로 변환하여 반환
    return Math.ceil(timeDiff / (1000 * 60 * 60 * 24));
}
</script>

