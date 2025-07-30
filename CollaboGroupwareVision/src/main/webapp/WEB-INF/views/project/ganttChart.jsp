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
					<c:forEach var="entry" items="${issueStatusMap}">
					    <span class="me-2">
					        <span class="d-inline-block rounded-circle p-1 me-1"
					              style="background-color: 
					                <c:choose>
					                    <c:when test="${entry.key == '01'}">#3498db</c:when>
					                    <c:when test="${entry.key == '02'}">#2ecc71</c:when>
					                    <c:when test="${entry.key == '03'}">#8e44ad</c:when>
					                    <c:when test="${entry.key == '04'}">#f39c12</c:when>
					                    <c:when test="${entry.key == '05'}">#e74c3c</c:when>
					                    <c:when test="${entry.key == '06'}">#7f8c8d</c:when>
					                    <c:otherwise>#ccc</c:otherwise>
					                </c:choose>;">
					        </span>${entry.value}</span>
					</c:forEach>
				</div>
				
				<!-- 간트차트 -->
				<div id="gantt_here" style="width:100%; height:550px;"></div>
			</div>
		</div>
		
		
	</div>
</div>


<script>
// 작업(Task)의 이전 상태를 저장하는 히스토리 객체 - 스택 구조로 관리
const taskHistory = {};

// 특정 Task의 현재 상태를 스택에 저장하는 함수
function saveTaskState(id) {
    const task = gantt.getTask(id);
    if (!taskHistory[id]) {
        taskHistory[id] = [];
    }
    taskHistory[id].push({
        start_date: new Date(task.start_date),
        end_date: new Date(task.end_date),
        duration: task.duration
    });
    console.log("상태 저장:", taskHistory);
}

// 되돌리기 버튼 클릭 시, 직전 상태로 복원하는 함수
function revertLastChange(id) {
    const history = taskHistory[id];
    if (!history || history.length === 0) {
    	gantt.message.hideAll();
        gantt.message({ text: "되돌릴 변경이 없습니다.", type: "warning" });
        return;
    }

    const last = history.pop();
    const task = gantt.getTask(id);
    task.start_date = last.start_date;
    task.end_date = last.end_date;
    task.duration = last.duration;
    gantt.updateTask(id);

    gantt.message.hideAll();
    gantt.message({ text: "변경이 되돌려졌습니다.", type: "info" });
}

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
    gantt.config.drag_move = true;		// 작업 이동 가능
    gantt.config.drag_links = false;	// 작업 간의 연결 비활성화
    gantt.config.drag_progress = false; // 진행률 드래그 비활성화
    gantt.config.drag_resize = true; 	// 작업 기간 조절 허용
    
	// Lightbox 비활성화
    gantt.showLightbox = function(id) {
        return false;
    };
    
    // Gantt 컬럼 구성
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
    
    // quickinfo에 버튼 만들기
	gantt.config.quickinfo_buttons=["issueDetails"];
	gantt.locale.labels["issueDetails"] = "상세보기";
	
	// quickinfo 내용 설정
	gantt.templates.quick_info_title = function(start, end, task) {
        return "<strong>" + task.text + "</strong>";
    };
	gantt.templates.quick_info_date = function(start, end, task) {
		var dateFormat = gantt.date.date_to_str("%Y-%m-%d");
		var startDate = dateFormat(start);
        var endDate = dateFormat(gantt.date.add(end, -1, 'day'));	// 실제 종료일은 차트종료일-1
        
		return "<br>시작일: " + startDate + "<br>종료일: " + endDate;
	};
	
	// Gantt 차트 초기화 및 데이터 바인딩
	gantt.init("gantt_here");
	gantt.parse(ganttData);
	
	// 작업 드래그 전 상태 저장
	gantt.attachEvent("onBeforeTaskDrag", function(id) {
	    saveTaskState(id);
	    return true;
	});

	// 작업 리사이즈 전 상태 저장
	gantt.attachEvent("onBeforeTaskResize", function(id) {
	    saveTaskState(id);
	    return true;
	});
	

	// 작업 수정 후 서버에 변경사항 반영
	gantt.attachEvent("onAfterTaskUpdate", function(id, task) {
	    $.ajax({
	        url: "/project/issue/updateDate",
	        type: "POST",
	        contentType: "application/json",
	        data: JSON.stringify({
	            issueNo: id,
	            issueStartDay: gantt.date.date_to_str("%Y%m%d")(task.start_date),
	            issueEndDay: gantt.date.date_to_str("%Y%m%d")(gantt.date.add(task.start_date, task.duration - 1, 'day'))
	        }),
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader(header, token);
	        },
	        success: function(response) {
	        	gantt.message.hideAll();
	            gantt.message({
	                text: `날짜 수정 완료 <button id="undo-btn" onclick="revertLastChange('\${id}')">되돌리기</button>`,
	                expire: 5000,
	                type: "success"
	            });
	            gantt.sort((a, b) => a.start_date - b.start_date);
	        },
	        error: function(xhr) {
	            gantt.message({
	                text: "날짜 수정 실패",
	                type: "error"
	            });
	        }
	    });
	});

	
	// 상세보기 버튼 클릭 시
    gantt.$click.buttons.issueDetails = function(id){
        console.log("일감번호", id);
        location.href="/project/"+projectId+"/issue/"+id;
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


// yyyyMMdd 형식의 문자열을 Date 객체로 변환
function convertDateFromFormat(input) {
    var year = parseInt(input.substring(0, 4), 10);
    var month = parseInt(input.substring(4, 6), 10) - 1; // 월이 0부터 시작
    var day = parseInt(input.substring(6, 8), 10);

    return new Date(year, month, day);
}


// 시작일과 종료일 간의 일수 차이 계산
function calculateDuration(startDate, endDate) {
	const start = convertDateFromFormat(startDate);
	const end = convertDateFromFormat(endDate);
    const timeDiff = end - start;

	// 밀리초를 일로 변환하여 반환
    return Math.ceil(timeDiff / (1000 * 60 * 60 * 24));
}
</script>

