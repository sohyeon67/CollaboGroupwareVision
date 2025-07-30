<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style>
.fc-day div a{ /* 요일색깔  */
color: black;
}
.fc-day-sat div a{ /* 토요일 */
color: black;
}
.fc-day-sun div a{ /* 일요일  */
color: black;
}

.fc .fc-non-business { /* 캘린더 바탕색  */
   background: white;
}
</style>
<style type="text/css">

 #calModal label {
    width: 100%!important; 
    margin-bottom: 10px!important;
    }
    
  .tooltip-title {
  color: white;
    }
    .tooltip-calContent {
    color: black;
    background-color: white;
    }
    
    .tooltip-title {
  color: white;
    }
    .tooltip-calContent {
    color: black;
    background-color: white;
    }
    
  </style>



<div class="content__header content__boxed overlapping">
   <div class="content__wrap">

      <!-- Breadcrumb -->
      <nav aria-label="breadcrumb">
         <ol class="breadcrumb mb-0">
            <li class="breadcrumb-item"><a href="./index.html">Home</a></li>
            <li class="breadcrumb-item"><a href="./app-views.html">일정</a></li>
            <li class="breadcrumb-item active" aria-current="page">캘린더</li>
         </ol>
      </nav>
      <!-- END : Breadcrumb -->

      <h1 class="page-title mb-0 mt-2">캘린더</h1>

      <!-- <p class="lead">A full-sized drag &amp; drop JavaScript event
         calendar.</p> -->

   </div>

</div>

<div class="content__boxed">
   <div class="content__wrap">
      <div class="card">
         <div class="card-body">

            <div class="d-md-flex gap-4">

               <!-- Calendar sidebar -->
               <div class="w-md-160px w-xl-200px flex-shrink-0 mb-3">
                <!--   <div class="d-grid">
                     <button class="btn btn-primary" type="button" onclick="insertCal"  >일정 등록</button>
                  </div> -->

                  <!-- Calendar - Checkboxes -->
                  <h5 class="mt-5 mb-3">내 일정</h5>
                  <a href="/calendar/calendarhome" class="nav-link"> 전체일정 보기 </a>
                  <hr/>
                  <form id="calChange" name="calChange" action="/calendar/calendarhome" method="post">
                     <div class="form-check mb-3">
                        <input id="_dm-checkbox1" class="form-check-input checkBox"
                           type="checkbox" value="0" name="checkBox" checked="checked"> <label for="_dm-checkbox1"
                           class="form-check-label"> 개인일정 </label>
                     </div>
                     <div class="form-check mb-3">
                        <input id="_dm-checkbox2" class="form-check-input checkBox"
                           type="checkbox" value="1" name="checkBox" checked="checked"> <label
                           for="_dm-checkbox2" class="form-check-label"> 부서일정
                        </label>
                     </div>
                     <div class="form-check mb-3">
                        <input id="_dm-checkbox3" class="form-check-input checkBox"
                           type="checkbox" value="2" name="checkBox" checked="checked"> <label
                           for="_dm-checkbox3" class="form-check-label"> 전사일정 </label>       
                     </div>
                     <div class="form-check mb-3">            
                        
                     </div>
                     <input type="hidden" id ="arrayChange" name="arrayChange">
                  <sec:csrfInput/>
                  </form>
                  <!-- END : Calendar - Checkboxes -->

                  <!-- Calendar - Upcoming event -->
                 <!--  <h5 class="mt-5 mb-3">일단보류</h5>
                  <div class="list-group list-group-borderless">

                     List item
                     <a class="bg-info list-group-item list-group-item-action mb-2"
                        href="#">
                        <h6 class="mb-2 text-white">Betty Murphy's Birthday</h6>
                        <div class="d-flex justify-content-between text-white">
                           <small>09:30 - 11:59</small> <small>Mar 12</small>
                        </div>
                     </a>

                     List item
                     <a class="bg-warning list-group-item list-group-item-action mb-2"
                        href="#">
                        <h6 class="mb-2 text-white">Company Meeting</h6>
                        <div class="d-flex justify-content-between text-white-50">
                           <small>02:00 - 03:30</small> <small>Mar 07</small>
                        </div>
                     </a>

                     List item
                     <a class="bg-danger list-group-item list-group-item-action mb-2"
                        href="#">
                        <h6 class="mb-2 text-white">Presentation</h6>
                        <div class="d-flex justify-content-between text-white-50">
                           <small>09:55 - 10:55</small> <small>Mar 05</small>
                        </div>
                     </a>

                  </div> -->
                  <!-- END : Calendar - Upcoming event -->

               </div>
               <!-- END : Calendar sidebar -->

               <!-- Full calendar container -->
               <div class="flex-fill">
                  <div id="_dm-calendar"></div>
               </div>
               <!-- END : Full calendar container -->

            </div>

         </div>
      </div>

   </div>
</div>
            <%--  <c:if test="${not empty message }">
             <script type="text/javascript">
             alert("${message}");
             <c:remove var="message" scope="request"/>
              <c:remove var="message" scope="session"/>
             </script>
             </c:if> --%>
 <div id="calender"></div>
 
 <!-- The Modal -->
 <div class="modal fade" id="calModal">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">일정 등록</h4>
                <button type="button" class="btn-close initBtn" data-bs-dismiss="modal"></button>
                
            </div>
            
            <!-- Modal body -->
            <div class="modal-body">
            
                <form id="calForm" name="calForm" action="/calendar/updateCal" method="post">    
                
                   <input type="hidden" name="calNo" id="calNo"/>   
                       
                   <label for="calType" id="carType"> 
                      <input type="radio" name="calType" checked="checked" value="0"/>개인일정            
                      <input type="radio" name="calType" value="1"/>부서일정
                      <input type="radio" name="calType" value="2"/>전사일정
                    </label>
                    
                  <select name="calAll" id="calAll">
                     <option value="N">allDay N</option>
                     <option value="Y">allDay Y</option>
                  </select>
                   
                   <label for="calTitle">
                         일정명
                   <input class="form-control" type="text" id="calTitle" name="calTitle" value="${calendarVO.calTitle }" />                         
                   </label>
                                                     
                   <label for="calContent">           
                       일정 내용
                   <textarea class="form-control" id="calContent" name="calContent" style="height: 300px;" wrap="soft">"${calendarVO.calContent }"</textarea>
                   </label>
                   
                   <label for="calStartDate">
                      시작일
                   <input id="calStartDate" name="calStartDate" class="form-control" type="datetime-local" value="${calendarVO.calStartDate }" />
                   </label>
                   
                   <label for="calEndDate">
                      종료일
                   <input id="calEndDate" name="calEndDate" class="form-control" type="datetime-local" value="${calendarVO.calEndDate }" />
                   </label>
                    <sec:csrfInput/> <!--< 이거 없으면 큰일남  -->                            
                   <button type="button" id="insertCal" class="btn btn-primary">일정 등록</button>
                   <button type="button" id="testingBtn" class="btn btn-primary" >시연용</button>
                </form>
            </div>
            
            <!-- Modal footer -->
            <div class="modal-footer">
                <button type="button" class="btn btn-danger initBtn" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
 </div>
         
<script type="text/javascript">
 var currentTooltip;
 

 
 document.addEventListener('DOMContentLoaded', function() {
  /*      console.log('==============');
       var A =[];
       <c:forEach var="vo" items="${calendarList}" varStatus ="status">
        console.log("${status.index}")
        A[${status.index}] = "vo";
        </c:forEach> */
       var calendarEl = document.getElementById('_dm-calendar');
       var calendar = new FullCalendar.Calendar(calendarEl, {
       initialView : 'dayGridMonth',
       locale : 'ko',  
       
 headerToolbar: {
           left: 'prevYear,prev,next,nextYear today',
           center: 'title',
           right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
               },
            
         navLinks: true,       // day/week 클릭시 단위별 보여주는 화면으로 넘어감
         editable: true,       // 드래그 수정 가능 길게 확장가능
         dayMaxEvents: true,   // +more 표시 전 최대 이벤트 갯수 true는 셀 높이에 의해 결정
         selectable: true,      // 캘린더에서 날짜 영역을 선택할 수 있는지 여부결정
         businessHours: true,    // display business hours(영업시간표사??)
         droppable: true,      // 와부 요소나 다른 캘린더 이벤트 등을 캘린더 영억에 끌어서 떨어뜨릴 수 있는 지 여부를 결정
         
         buttonText: {
             today:    '오늘',
             month:    '월간',
             week:     '주간',
             day:      '일간'
         },
         
         events: [          
                  <c:forEach var="vo" items="${calendarList}">
                     

                {
                   calendarNo: '<c:out value="${vo.calNo}"/>',         //일정번호
                    title: '<c:out value="${vo.calTitle}"/>',         //일정제목
                    start: '<c:out value="${vo.calStartDate}"/>',      //캘린더 시작날짜
                    end: '<c:out value="${vo.calEndDate}"/>',         //캘린더 끝나는날짜
                    content: '<c:out value="${vo.calContent}"/>',      //캘린더 상세내용                                                
                    repeatDate: '<c:out value="${vo.calRepeatDate}"/>',   // 일정반복종료
                    calRepeatUnit: '<c:out value="${vo.calRepeatUnit}"/>', // 일정반복 단위
                    calType: '<c:out value="${vo.calType}"/>',         // 일정 종류
                    
             <c:choose>       
                  <c:when test="${vo.calType eq '0'}"> 
                     color: "green",
                     borderColor : "green",
                     </c:when> 
                  <c:when test="${vo.calType eq '1'}"> 
                     color: "blue",
                     borderColor : "blue",
                     </c:when>      
                  <c:when test="${vo.calType eq '2'}"> 
                     color: "red",
                 borderColor : "red",
                 </c:when>   
            </c:choose>
            
                    <c:choose>      
                    <c:when test="${vo.calAll eq 'Y'}"> 
                       allDay: true,
                       allDayYN : "Y"
                    </c:when> 
                    <c:when test="${vo.calAll eq 'N'}"> 
                       allDay: false,
                       allDayYN : "N"
                    </c:when>

                    
                </c:choose>
                    
                    
                },
                </c:forEach>
                ],
                
                dateClick: function(info) {
                   // 클릭된 날짜 정보 출력
                    console.log('Clicked on: ' + info.dateStr);
                   console.log(moment(info.date).format('YYYY-MM-DD HH:mm:ss'));
                   var date = new Date(info.date);
                   var startDate = moment(date).format('YYYY-MM-DD HH:mm:ss');
                   date.setDate(date.getDate() + 1);
                   var endDate = moment(date).format('YYYY-MM-DD HH:mm:ss')
                   var repeatDate = moment(date).format('YYYY-MM-DD')
                   
                    // 여기에 클릭된 날짜에 대한 추가 동작을 구현할 수 있습니다.
                    // 예를 들어, 모달 창 열기, 이벤트 추가 등의 동작을 수행할 수 있습니다.
                    $("#calModal #calTitle").val("");
                    $("#calModal #calStartDate").val(startDate);
                    $("#calModal #calEndDate").val(endDate);
                    $("#calModal #calContent").val("");
                    
                    // 등록 버튼의 스타일을 파란색으로 변경
                    $("#insertCal")
                        .removeClass("btn-danger font-weight-bold")
                        .addClass("btn-primary");
                    $("#calModal").modal("show");
                    $(".modal-header .modal-title").html("<strong style='color: red;'>일간</strong> 일정 등록");
                    },
                    select: function(info) {
                        // 선택된 날짜 범위 정보 출력
                        console.log('Selected from: ' + info.startStr + ' to: ' + info.endStr  );
                        // 여기에 선택된 날짜 범위에 대한 추가 동작을 구현할 수 있습니다.
                        // 예를 들어, 모달 창 열기, 이벤트 추가 등의 동작을 수행할 수 있습니다.
                      
                        
                        info.startStr = moment(info.startStr).format('YYYY-MM-DD HH:mm:ss');
                        info.endStr  = moment(info.endStr).format('YYYY-MM-DD HH:mm:ss');
                    
                    
                    
           
                    
                 
                        // info.end를 Moment.js 객체로 변환
                     var momentEnd = moment(info.end);
                     // Moment.js 객체인 경우에만 clone 메서드 사용
                     if (momentEnd.isValid()) {
                         // 여기에서 수정된 날짜를 사용하여 추가 작업 수행
                           $("#calModal #calTitle").val("");
                           $("#calModal #calStartDate").val(info.startStr);
                           $("#calModal #calEndDate").val(info.endStr);
                           $("#calModal #calRepeatDate").val(info.repeatStr);
                           $("#calModal #calContent").val("");
                           $("#calModal #calRepeatUnit").val("calRepeatUnit");
                
                         $("#calModal").modal("show");
                         $(".modal-header .modal-title").html("<strong style='color: blue;'>주간</strong> 일정 등록");
                     } else {
                         console.error('info.end is not a valid Moment.js object');
                     }
                    },
                    selectMinDistance: 4, // 기본값은 0입니다. 원하는 값으로 조정하세요.
                    
                    
                    eventDrop: function(info) {
                       
                       var calType = info.event._def.extendedProps["calType"];
                        var calColor = info.event["borderColor"];   
                       var calAll = info.event._def.extendedProps["allDayYN"];
                       var calRepeatUnit = info.event._def.extendedProps["calRepeatUnit"];
                       info.repeatStr = moment(info.repeatStr).format('YYYY-MM-DD');
                       
                       const json = JSON.stringify(info.repeatStr);
                       const Unit = calRepeatUnit;
                       const all = calAll
                       const type = calType
                       
                        // 드래그한 이벤트의 정보 출력
                        console.log('Event dropped: ' + info.event.title);
                        console.log('Calendar No: ' + info.event.extendedProps.calendarNo);
                        console.log('New start date: ' + info.event.startStr);
                        console.log('New end date: ' + info.event.endStr);
                        console.log('New repeat date: ' + json);
                        console.log('all: ' + all);                  
                        console.log('Event title: ' + info.event.title);
                        console.log('Event content: ' + info.event.extendedProps.content);
                        console.log('Event calAll: ' + all);
                        console.log('Event calColor: ' + calColor);
                        console.log('Event type: ' + type);
                     console.log(info);
                     // info.event.startStr와 info.event.endStr는 ISO 형식의 날짜 문자열입니다.
                        var startDate = new Date(info.event.startStr);
                        var endDate = new Date(info.event.endStr);
                       
                        
                        console.log("startDate : " + startDate);
                        console.log("endDate : " + endDate);
                        console.log("repeatDate : " + json);
                        if(endDate == 'Invalid Date') {
                        endDate = startDate;
                        }
                        
                        /* if(startDate != endDate){
                        // 하루 뒤로 미룸
                        startDate.setDate(startDate.getDate() + 1);
                        endDate.setDate(endDate.getDate() + 1);
                        }else {
                        endDate.setDate(endDate.getDate() + 1);
                        } */
                        // 날짜를 'YYYY-MM-DD' 형식으로 변환
                        var formattedStartDate = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
                        var formattedEndDate = moment(endDate).format('YYYY-MM-DD HH:mm:ss');
                        var formattedRepeatDate = moment(json).format('YYYY-MM-DD');
                        console.log('New start date: ' + formattedStartDate);
                        console.log('New end date: ' + formattedEndDate);
                        console.log('New Repeat date: ' + formattedRepeatDate);
                        // 여기에 드래그한 이벤트에 대한 추가 동작을 구현할 수 있습니다.
                        // 예를 들어, 이벤트의 업데이트, 모달 창 열기 등의 동작을 수행할 수 있습니다.
                        
                        $("#calForm #calendarNo").remove();
                        $("#calForm").prepend("<input id='calendarNo' name='calNo' type='hidden' value='"+info.event.extendedProps.calendarNo+"' />");
                        
                        $("#calForm #calTitle").remove();
                        $("#calForm label[for=calTitle]").prepend("<input id='calTitle' name='calTitle' type='hidden' value='"+info.event.title+"' />");
                        
                        $("#calForm #calContent").remove();
                        $("#calForm label[for=calStartDate]").prepend("<input id='calContent' name='calContent' type='hidden' value='"+info.event.extendedProps.content+"' />");
                        
                        $("#calForm #calStartDate").remove();
                        $("#calForm label[for=calStartDate]").prepend("<input id='calStartDate' name='calStartDate' type='hidden' value='"+formattedStartDate+"' />");
                      
                        $("#calForm #calEndDate").remove();
                        $("#calForm label[for=calEndDate]").prepend("<input id='calEndDate' name='calEndDate' type='hidden' value='"+formattedEndDate+"' />");
                        
                        $("#calForm #calRepeatDate").remove();
                        $("#calForm label[for=calRepeatDate]").prepend("<input id='calRepeatDate' name='calRepeatDate' type='hidden' value='"+formattedRepeatDate+"' />");
                        
                        $("#calForm #calRepeatUnit").remove();
                        $("#calForm label[for=calRepeatUnit]").prepend("<input id='calRepeatUnit' name='calRepeatUnit' type='hidden' value='"+Unit+"' />");
                                                               
                        $("#calForm #calAll").remove();
                        $("#calForm label[for=all]").prepend("<input id='all' name='all' type='hidden' value='"+all+"' />");
                        
                        $("#calForm #calType").remove();
//                         $("#calForm label[for=calType]").prepend("<input id='calType' name='calType' type='hidden' value='"+type+"' />");
                  var calTypes = $("#calForm").find("input[name=calType]");
                  calTypes.map(function(i,v){
                     if(calType == v.value){
                        v.checked = true;                  
                     }
                  });
                        
                      
                         $("#calForm").attr("action", "/calendar/updateCal");
                         $("#calForm").submit();      
           },
           

           
                    // 이벤트 클릭
                    eventClick: function(info) {
                       console.log("eventClick");
                       console.log(info);
                    // 클릭된 이벤트의 정보 출력
                        console.log('클릭한 이벤트: ', info.event);
                        // 시작일 및 종료일이 null이 아닌지 확인
                        var startDate = moment(info.event.start).format('YYYY-MM-DD HH:mm:ss');
                        var endDate = moment(info.event.end).format('YYYY-MM-DD HH:mm:ss');
                        var repeatDate = moment(info.event.repeat).format('YYYY-MM-DD');
                        var calType = info.event._def.extendedProps["calType"];
                        
                        var calAll = info.event._def.extendedProps["allDayYN"];
                        var calColor = info.event["borderColor"];         
                       var calRepeatUnit = info.event._def.extendedProps["calRepeatUnit"];
                       
             
                       
                        console.log("일정 제목: " + info.event.title);
                        console.log("일정 시작 날짜: " + startDate);
                        console.log("일정 종료 날짜: " + endDate);
                        console.log("반복날짜: " + repeatDate);
                        console.log("반복단위: " + calRepeatUnit);
                        console.log("일정단위: " + calType);
                        console.log("all: " + calAll);
                        console.log("calColor: " + calColor);

                        // extendedProps가 존재하고 그 안에 calendarMemo가 있는지 확인
                        // content 입력
                        var calContent = info.event._def.extendedProps["content"];
                        console.log("일정 내용: " + calContent);
                        
                     // 캘린더 번호 값을 숨겨진 입력 필드에 설정
                     // 폼 태그 안쪽에 prepend 해보자. 안되겠다...
                      $("#calForm #calendarNo").remove();
                      $("#calForm").prepend("<input id='calendarNo' type='hidden' name='calNo'  value='"+info.event.extendedProps.calendarNo+"' />"); 
                      
                     
                        // 입력 요소를 읽기 전용으로 설정
                       /*  $("#calModal #calTitle").prop("readonly", true);
                        $("#calModal #calStartDate").prop("readonly", true);
                        $("#calModal #calEndDate").prop("readonly", true);
                        $("#calModal #calContent").prop("readonly", true);
                        $("#calModal #calRepeatDate").prop("readonly", true); */
                        // 버튼 텍스트 변경 및 클래스 추가
                        $("#insertCal")
                            .text("수정")
                            .removeClass("btn-primary")
                            .removeClass("btn-danger")
                            .addClass("btn-warning");
                     
                        
                        // 삭제 버튼 추가
                        var removeBtn = "<button type='button' id='deleteCal' class='btn btn-danger'>삭제</button>";
                        $("#calForm").append(removeBtn);  // 모달 창 열기
                        $("#calModal #calNo").val(info.event.calendarNo);      // 번호
                        $("#calModal #calTitle").val(info.event.title);         // 제목                     
                        $("#calModal #calStartDate").val(startDate);         //시간날짜
                        $("#calModal #calEndDate").val(endDate);            //끝 날짜
                        $("#calModal #calContent").val(calContent);            //내용
                        $("#calModal #calRepeatUnit").val(calRepeatUnit);      //반복단위
                        $("#calModal #calRepeatDate").val(moment(repeatDate).format('YYYY-MM-DD'));   // 반복일자
                        $("#calModal #calAll").val(calAll);                                       // allDay
                        $("input:radio[name ='calType']:input[value='"+calType+"']").attr("checked", true); // 일정 종류 값 넣기
                        $("#calModal").modal("show");
                        $(".modal-header .modal-title").html("<strong style='color: green;'>일정 확인</strong>");
                        },
                        
                        
                    eventMouseEnter: function (info) {
                       console.log("eventMouseEnter");
                        // 툴팁 내용 생성
                        var tooltipContent = '<span class="tooltip-title">' + info.event.title + '</span><br /><span class="tooltip-Content">' + info.event.extendedProps.content + '</span>';
                        // 부트스트랩 툴팁 적용                                                                                             
                        $(info.el).tooltip({
                            title: tooltipContent,
                            html: true,
                            placement: 'top',
                            trigger: 'hover focus', // 툴팁을 호버 또는 포커스할 때만 표시
                        }).tooltip('show');
                    },
                    eventMouseLeave: function (info) {
                        // 툴팁 숨기기
                        $(info.el).tooltip('hide');
                    }
         });
         calendar.render();
         });
 
 // 시연
	$("#testingBtn").on("click", function(){
		$("#calTitle").val(" 외근");
		$("#calContent").val("출장및 외근이 예정되어있고 부서와 함께 갈지는 아직 정해지지않음.");
	});
	

 $(function() {
       var calForm = $("#calForm"); // 등록/수정 폼 엘리먼트
       var insertCal = $("#insertCal"); // 등록/수정 버튼 엘리먼트
       var initBtn = $(".initBtn"); // 초기화 버튼 엘리먼트
       var testingBtn = $("testingBtn"); // 시연
       
       var calTitleEl = $("#calTitle");
       var calContentEl = $("#calContent");
       var calStartDateEl = $("#calStartDate");
       var calEndDateEl = $("#calEndDate");
       
       initBtn.on("click", function(){
       
                  $("#calModal #calendarTitle").prop("readonly", false);
                   $("#calModal #calStartDate").prop("readonly", false);
                   $("#calModal #calEndDate").prop("readonly", false);
                   $("#calModal #calContent").prop("readonly", false);
                   
                   $("#calModal #calTitle").val("calTitle");
                   $("#calModal #calStartDate").val("calStartDate");
                   $("#calModal #calEndDate").val("calEndDate");
                   $("#calModal #calContent").val("calContent");
                   
                   $("#calForm #calendarNo").remove();
                   $("#calForm #deleteCal").remove();
                   
                   calForm.attr("action", "/calendar/insertCal");
                   
                // 버튼 텍스트 변경 및 클래스 추가
                   $("#insertCal")
                       .text("일정 등록")
                       .removeClass("btn-warning")
                       .removeClass("btn-secondary")
                       .addClass("btn-primary");
                
       });
       
       //삭제
          $(document).on("click", "#deleteCal", function() {
            calForm.attr("action", "/calendar/deleteCal");
          calForm.submit();
       });
       
       
       //등록
       insertCal.on("click", function() {
           var calTitle = calTitleEl.val();
           var calContent = calContentEl.val();
           var calStartDate = calStartDateEl.val();
           var calEndDate = calEndDateEl.val();
           
           if ($(this).text() == "일정 등록") {
           
               $("#calForm #calendarNo").remove();
                
              if (calTitle == "") {
                   alert("제목을 입력해 주세요");
                   console.log(calTitle)
                   calTitleEl.focus();
                   return false;
               }
               if (calContent == "") {
                   alert("내용을 입력해 주세요");
                   calContentEl.focus();
                   return false;
               }
               if (calStartDate == "") {
                   alert("시작일을 입력해 주세요");
                   calStartDateEl.focus();
                   return false;
               }
               if (calEndDate == "") {
                   alert("종료일을 입력해 주세요");
                   calEndDateEl.focus();
                   return false;
               }
               
               
               // 종료일에 하루 추가
               var momentStart = moment(calStartDate);
               var momentEnd = moment(calEndDate);
               if (momentStart.isValid() && momentEnd.isValid()) {
                   // 시작일과 종료일이 같은 경우 예외 처리
                   if (momentStart.isSame(momentEnd, 'day')) {
                       // 여기에 시작일과 종료일이 같은 경우의 예외 처리를 추가할 수 있습니다.
                       calForm.submit();
                   }

                   $("#calForm").prepend("<input id='calendarNo' name='calNo' type='hidden' value='"+"8"+"' />");
                   calForm.attr("action", "/calendar/insertCal");
                   calForm.submit();
               } else {
                   console.error('calendarStart 또는 calendarEnd가 유효한 Moment.js 객체가 아닙니다');
                   // 유효하지 않은 경우에 대한 처리를 추가할 수 있습니다.
                   // 예: alert("시작일 또는 종료일이 유효하지 않습니다");
                   return false;
               }
               
           } else if ($(this).text() == "수정") {

      
              $(".modal-header .modal-title").html("<strong style='color: red; font-weight: bold;'>일정 수정</strong>");
               
               // readonly 속성 해제
               $("#calModal input, #calModal textarea").prop("readonly", false);
               
               // 삭제 버튼 제거
               $("#calForm #deleteCal").remove();
               
               // 버튼 텍스트 및 스타일 변경
                    insertCal.text("저장")
                   .removeClass("btn-primary")
                   .removeClass("btn-warning")
                   .addClass("btn-secondary font-weight-bold"); // 빨간색, 두꺼운 글씨체
                   
               return false;
           }

		

                 // 저장 버튼 클릭 시 폼 제출
                     if ($(this).text() == "저장") {
                   // 수정 버튼이 클릭된 경우의 동작
                  var calendarNo = $("calendarNo").val();
                  var calTitle = $("#calTitle").val();
                  var calContent = $("#calContent").val();
                  var calStartDate = $("#calStartDate").val();
                  var calEndDate = $("#calEndDate").val();
                  var calType = $("#calType").val();
                  var calRepeatDate = $("#calRepeatDate").val();
                  var calRepeatUnit = $("#calRepeatUnit").val();
                  var calAll = $("#calAll").val();
                  var calColor = $("#calColor").val();
                  var calRepeatYn =$("#calRepeatYn").val();
                      
                 if (calTitle == "") {
                      alert("제목을 입력해 주세요");
                      console.log(calTitle)
                      calTitleEl.focus();
                      return false;
                  }
                  if (calContent == "") {
                      alert("내용을 입력해 주세요");
                      calContentEl.focus();
                      return false;
                  }
                  if (calStartDate == "") {
                      alert("시작일을 입력해 주세요");
                      calStartDateEl.focus();
                      return false;
                  }
                  if (calEndDate == "") {
                      alert("종료일을 입력해 주세요");
                      calEndDateEl.focus();
                      return false;
                  }
                   

            
                  var momentStart = moment(calStartDate).format('YYYY-MM-DD HH:mm:ss');
                  var momentEnd = moment(calEndDate).format('YYYY-MM-DD HH:mm:ss');
                  
   
                  if (moment(momentStart).isValid() && moment(momentEnd).isValid()) {
                   // 시작일과 종료일이 같은 경우 예외 처리
                      if (moment(momentStart).isSame(momentEnd, 'day')) {
                       // 여기에 시작일과 종료일이 같은 경우의 예외 처리를 추가할 수 있습니다.
                          calForm.attr("action", "/calendar/updateCal");
                          calForm.submit();
                      }
              
                   // 유효성 검사 통과 시 폼 제출 진행      
                      calForm.attr("action", "/calendar/updateCal");
                       alert("저장 완료");
                      calForm.submit();
               } else {
                   console.error('calendarStart 또는 calendarEnd가 유효한 Moment.js 객체가 아닙니다');
                   // 유효하지 않은 경우에 대한 처리를 추가할 수 있습니다.
                   // 예: alert("시작일 또는 종료일이 유효하지 않습니다");
                   return false;
               }
                   // 유효성 검사 통과 시 폼 제출 진행
     

                   
                   /* document.getElementById('calForm').submit(); */
        

            }
       });
       
       calStartDateEl.on("change", function(event){
       
       var calStartDate = calStartDateEl.val();
       console.log("calStartDate : " + calStartDate);
       var calEndDate = calEndDateEl.val();
       console.log("calEndDate : " + calEndDate);
       var currentValue = event.target.value;
       console.log("currentValue : " + currentValue);
       
       if($(".modal-header .modal-title strong").text().trim() == "일정 수정") {
       if(calStartDate > calEndDate && calEndDate != "") {
       alert("시작일이 종료일보다 빠른 일자여야 합니다.")
       event.target.value = calEndDate;
       return false;
       }
       return false;
       }
       
       if(calStartDate == calEndDate){
       $(".modal-header .modal-title").html("<strong style='color: red;'>일간</strong> 일정 등록");
       }else {
       if(calStartDate > calEndDate && calEndDate != "") {
       alert("시작일이 종료일보다 빠른 일자여야 합니다.")
       event.target.value = calEndDate;
       $(".modal-header .modal-title").html("<strong style='color: red;'>일간</strong> 일정 등록");
       return false;
       }
       $(".modal-header .modal-title").html("<strong style='color: blue;'>주간</strong> 일정 등록");
       }
       
       });
       
       calEndDateEl.on("change", function(event){
       
       var calStartDate = calStartDateEl.val();
      console.log("calStartDate : " + calStartDate);
      var calEndDate = calEndDateEl.val();
       console.log("calEndDate : " + calEndDate);
      var currentValue = event.target.value;
      console.log("currentValue : " + currentValue);
       if($(".modal-header .modal-title strong").text().trim() == "일정 수정") {
       if(calStartDate > calEndDate) {
       alert("종료일이 시작일보다 늦은 일자여야 합니다.")
       event.target.value = calStartDate;
       return false;
       }
       return false;
       }
       
       if(calStartDate == calEndDate){
       $(".modal-header .modal-title").html("<strong style='color: red;'>일간</strong> 일정 등록");
       }else {
       if(calStartDate > calEndDate) {
       alert("종료일이 시작일보다 늦은 일자여야 합니다.")
       event.target.value = calStartDate;
       $(".modal-header .modal-title").html("<strong style='color: red;'>일간</strong> 일정 등록");
       return false;
       }
       $(".modal-header .modal-title").html("<strong style='color: blue;'>주간</strong> 일정 등록");
       }
       
       });
       
   });
 

          /*  $.ajax({
               url:"celcheckBox",
               data:{},
               type:"post",
               success:function(data){
                   console.log(data);
                   if(data == "0"){
                       
                   if(data == "1"){
                         
                   if(data == "2"){
                           
                   }
               },
               error:function(jqxhr, textStatus, errorThrown){
                   console.log("ajax 처리 실패");
                   
                   // 에러 로그
                   console.log(jqxhr);
                   console.log(textStatus);
                   console.log(errorThrown);
               }
           });
       }); */
  
   // url : Controller의 @RequestMapping 서블릿 주소,
   // data : JSON객체 형태로 key : value 꼴. 
   // key = Controller로 전달할 변수, value = 전달할 진짜 값
   // type : GET / POST 설정 가능
   // success : 연결 성공시 실행할 내용
   // error : 연결 실패시 실행할 내용   
 $(".checkBox").change(function(){
       var arrayText = "";
       for(let i=0 ; i< $("input:checkbox[name=checkBox]:checked").length; i++){
          var val = $("input:checkbox[name=checkBox]:checked")[i].value;
          arrayText += "'"+ val + "'";
          
          if(i != $("input:checkbox[name=checkBox]:checked").length-1){
            arrayText += ",";
          }

       }

       
        $.ajax({
            type : "POST",            // HTTP method type(GET, POST) 형식이다.
            url : "/calendar/celcheckBox",      // 컨트롤러에서 대기중인 URL 주소이다.
            data : {asd : arrayText },            // Json 형식의 데이터이다.
            beforeSend:function(xhr){
               xhr.setRequestHeader(header,token);
            },
            success : function(data){ // 비동기통신의 성공일경우 success콜백으로 들어옵니다. 'res'는 응답받은 데이터이다.
                // 응답코드 > 0000
                var dataArray = [];
                for(let i = 0; i<data.result.length; i++){
                   var color = "";
                   var borderColor = "";
                   var allDay = true;
                   var allDayYN = "";
                   
                   if(data.result[i].calType == 0){
                       color = "green";
                         borderColor = "green";
                   }else if (data.result[i].calType == 1){
                      color = "blue";
                        borderColor = "blue";
                   }else if (data.result[i].calType == 2){
                      color = "red";
                        borderColor = "red";
                   }
                   
                   if(data.result[i].calAll == "Y"){
                      allDay = true ; 
                        allDayYN = "Y";
                   }else{
                      allDay = false ; 
                        allDayYN = "N";
                   
                   }
                   
                   dataArray[i] = { 
                         calendarNo: data.result[i].calNo,         //일정번호
                            title: data.result[i].calTitle,         //일정제목
                            start: data.result[i].calStartDate,      //캘린더 시작날짜
                            end: data.result[i].calEndDate,         //캘린더 끝나는날짜
                            content: data.result[i].calContent,      //캘린더 상세내용                                                
                            repeatDate: data.result[i].calRepeatDate,   // 일정반복종료
                            calRepeatUnit: data.result[i].calRepeatUnit, // 일정반복 단위
                            calType: data.result[i].calType,         // 일정 종류
                            color : color,
                            borderColor : borderColor,
                            allDay : allDay,
                            allDayYN : allDayYN
                            
                   }

                   
   


         
                
                }
                
                console.log(dataArray);
                
                
                
                var calendarEl = document.getElementById('_dm-calendar');
                var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView : 'dayGridMonth',
                locale : 'ko',  
                
          headerToolbar: {
                    left: 'prevYear,prev,next,nextYear today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
                        },
                     
                  navLinks: true,       // day/week 클릭시 단위별 보여주는 화면으로 넘어감
                  editable: true,       // 드래그 수정 가능 길게 확장가능
                  dayMaxEvents: true,   // +more 표시 전 최대 이벤트 갯수 true는 셀 높이에 의해 결정
                  selectable: true,      // 캘린더에서 날짜 영역을 선택할 수 있는지 여부결정
                  businessHours: true,    // display business hours(영업시간표사??)
                  droppable: true,      // 와부 요소나 다른 캘린더 이벤트 등을 캘린더 영억에 끌어서 떨어뜨릴 수 있는 지 여부를 결정
                  
                  buttonText: {
                      today:    '오늘',
                      month:    '월간',
                      week:     '주간',
                      day:      '일간'
                  },
                  
                  events:   dataArray       
                      
                         ,
                         
                         dateClick: function(info) {
                            // 클릭된 날짜 정보 출력
                             console.log('Clicked on: ' + info.dateStr);
                            console.log(moment(info.date).format('YYYY-MM-DD HH:mm:ss'));
                            var date = new Date(info.date);
                            var startDate = moment(date).format('YYYY-MM-DD HH:mm:ss');
                            date.setDate(date.getDate() + 1);
                            var endDate = moment(date).format('YYYY-MM-DD HH:mm:ss')
                            var repeatDate = moment(date).format('YYYY-MM-DD')
                            
                             // 여기에 클릭된 날짜에 대한 추가 동작을 구현할 수 있습니다.
                             // 예를 들어, 모달 창 열기, 이벤트 추가 등의 동작을 수행할 수 있습니다.
                             $("#calModal #calTitle").val("");
                             $("#calModal #calStartDate").val(startDate);
                             $("#calModal #calEndDate").val(endDate);
                             $("#calModal #calContent").val("");
                             
                             // 등록 버튼의 스타일을 파란색으로 변경
                             $("#insertCal")
                                 .removeClass("btn-danger font-weight-bold")
                                 .addClass("btn-primary");
                             $("#calModal").modal("show");
                             $(".modal-header .modal-title").html("<strong style='color: red;'>일간</strong> 일정 등록");
                             },
                             select: function(info) {
                                 // 선택된 날짜 범위 정보 출력
                                 console.log('Selected from: ' + info.startStr + ' to: ' + info.endStr  );
                                 // 여기에 선택된 날짜 범위에 대한 추가 동작을 구현할 수 있습니다.
                                 // 예를 들어, 모달 창 열기, 이벤트 추가 등의 동작을 수행할 수 있습니다.
                               
                                 
                                 info.startStr = moment(info.startStr).format('YYYY-MM-DD HH:mm:ss');
                                 info.endStr  = moment(info.endStr).format('YYYY-MM-DD HH:mm:ss');
                             
                             
                             
                    
                             
                          
                                 // info.end를 Moment.js 객체로 변환
                              var momentEnd = moment(info.end);
                              // Moment.js 객체인 경우에만 clone 메서드 사용
                              if (momentEnd.isValid()) {
                                  // 여기에서 수정된 날짜를 사용하여 추가 작업 수행
                                    $("#calModal #calTitle").val("");
                                    $("#calModal #calStartDate").val(info.startStr);
                                    $("#calModal #calEndDate").val(info.endStr);
                                    $("#calModal #calRepeatDate").val(info.repeatStr);
                                    $("#calModal #calContent").val("");
                                    $("#calModal #calRepeatUnit").val("calRepeatUnit");
                         
                                  $("#calModal").modal("show");
                                  $(".modal-header .modal-title").html("<strong style='color: blue;'>주간</strong> 일정 등록");
                              } else {
                                  console.error('info.end is not a valid Moment.js object');
                              }
                             },
                             selectMinDistance: 4, // 기본값은 0입니다. 원하는 값으로 조정하세요.
                             
                             
                             eventDrop: function(info) {
                                
                                var calType = info.event._def.extendedProps["calType"];
                                 var calColor = info.event["borderColor"];   
                                var calAll = info.event._def.extendedProps["allDayYN"];
                                var calRepeatUnit = info.event._def.extendedProps["calRepeatUnit"];
                                info.repeatStr = moment(info.repeatStr).format('YYYY-MM-DD');
                                
                                const json = JSON.stringify(info.repeatStr);
                                const Unit = calRepeatUnit;
                                const all = calAll
                                const type = calType
                                
                                 // 드래그한 이벤트의 정보 출력
                                 console.log('Event dropped: ' + info.event.title);
                                 console.log('Calendar No: ' + info.event.extendedProps.calendarNo);
                                 console.log('New start date: ' + info.event.startStr);
                                 console.log('New end date: ' + info.event.endStr);
                                 console.log('New repeat date: ' + json);
                                 console.log('all: ' + all);                  
                                 console.log('Event title: ' + info.event.title);
                                 console.log('Event content: ' + info.event.extendedProps.content);
                                 console.log('Event calAll: ' + all);
                                 console.log('Event calColor: ' + calColor);
                                 console.log('Event type: ' + type);
                              console.log(info);
                              // info.event.startStr와 info.event.endStr는 ISO 형식의 날짜 문자열입니다.
                                 var startDate = new Date(info.event.startStr);
                                 var endDate = new Date(info.event.endStr);
                                
                                 
                                 console.log("startDate : " + startDate);
                                 console.log("endDate : " + endDate);
                                 console.log("repeatDate : " + json);
                                 if(endDate == 'Invalid Date') {
                                 endDate = startDate;
                                 }
                                 
                                 /* if(startDate != endDate){
                                 // 하루 뒤로 미룸
                                 startDate.setDate(startDate.getDate() + 1);
                                 endDate.setDate(endDate.getDate() + 1);
                                 }else {
                                 endDate.setDate(endDate.getDate() + 1);
                                 } */
                                 // 날짜를 'YYYY-MM-DD' 형식으로 변환
                                 var formattedStartDate = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
                                 var formattedEndDate = moment(endDate).format('YYYY-MM-DD HH:mm:ss');
                                 var formattedRepeatDate = moment(json).format('YYYY-MM-DD');
                                 console.log('New start date: ' + formattedStartDate);
                                 console.log('New end date: ' + formattedEndDate);
                                 console.log('New Repeat date: ' + formattedRepeatDate);
                                 // 여기에 드래그한 이벤트에 대한 추가 동작을 구현할 수 있습니다.
                                 // 예를 들어, 이벤트의 업데이트, 모달 창 열기 등의 동작을 수행할 수 있습니다.
                                 
                                 $("#calForm #calendarNo").remove();
                                 $("#calForm").prepend("<input id='calendarNo' name='calNo' type='hidden' value='"+info.event.extendedProps.calendarNo+"' />");
                                 
                                 $("#calForm #calTitle").remove();
                                 $("#calForm label[for=calTitle]").prepend("<input id='calTitle' name='calTitle' type='hidden' value='"+info.event.title+"' />");
                                 
                                 $("#calForm #calContent").remove();
                                 $("#calForm label[for=calStartDate]").prepend("<input id='calContent' name='calContent' type='hidden' value='"+info.event.extendedProps.content+"' />");
                                 
                                 $("#calForm #calStartDate").remove();
                                 $("#calForm label[for=calStartDate]").prepend("<input id='calStartDate' name='calStartDate' type='hidden' value='"+formattedStartDate+"' />");
                               
                                 $("#calForm #calEndDate").remove();
                                 $("#calForm label[for=calEndDate]").prepend("<input id='calEndDate' name='calEndDate' type='hidden' value='"+formattedEndDate+"' />");
                                 
                                 $("#calForm #calRepeatDate").remove();
                                 $("#calForm label[for=calRepeatDate]").prepend("<input id='calRepeatDate' name='calRepeatDate' type='hidden' value='"+formattedRepeatDate+"' />");
                                 
                                 $("#calForm #calRepeatUnit").remove();
                                 $("#calForm label[for=calRepeatUnit]").prepend("<input id='calRepeatUnit' name='calRepeatUnit' type='hidden' value='"+Unit+"' />");
                                                                        
                                 $("#calForm #calAll").remove();
                                 $("#calForm label[for=all]").prepend("<input id='all' name='all' type='hidden' value='"+all+"' />");
                                 
                                 $("#calForm #calType").remove();
//                                  $("#calForm label[for=calType]").prepend("<input id='calType' name='calType' type='hidden' value='"+type+"' />");
                           var calTypes = $("#calForm").find("input[name=calType]");
                           calTypes.map(function(i,v){
                              if(calType == v.value){
                                 v.checked = true;                  
                              }
                           });
                                 
                               
                                  $("#calForm").attr("action", "/calendar/updateCal");
                                  $("#calForm").submit();      
                    },
                    
                             // 이벤트 클릭
                             eventClick: function(info) {
                                console.log("eventClick");
                                console.log(info);
                             // 클릭된 이벤트의 정보 출력
                                 console.log('클릭한 이벤트: ', info.event);
                                 // 시작일 및 종료일이 null이 아닌지 확인
                                 var startDate = moment(info.event.start).format('YYYY-MM-DD HH:mm:ss');
                                 var endDate = moment(info.event.end).format('YYYY-MM-DD HH:mm:ss');
                                 var repeatDate = moment(info.event.repeat).format('YYYY-MM-DD');
                                 var calType = info.event._def.extendedProps["calType"];
                                 
                                 var calAll = info.event._def.extendedProps["allDayYN"];
                                 var calColor = info.event["borderColor"];         
                                var calRepeatUnit = info.event._def.extendedProps["calRepeatUnit"];
                                
                      
                                
                                 console.log("일정 제목: " + info.event.title);
                                 console.log("일정 시작 날짜: " + startDate);
                                 console.log("일정 종료 날짜: " + endDate);
                                 console.log("반복날짜: " + repeatDate);
                                 console.log("반복단위: " + calRepeatUnit);
                                 console.log("일정단위: " + calType);
                                 console.log("all: " + calAll);
                                 console.log("calColor: " + calColor);

                                 // extendedProps가 존재하고 그 안에 calendarMemo가 있는지 확인
                                 // content 입력
                                 var calContent = info.event._def.extendedProps["content"];
                                 console.log("일정 내용: " + calContent);
                                 
                              // 캘린더 번호 값을 숨겨진 입력 필드에 설정
                              // 폼 태그 안쪽에 prepend 해보자. 안되겠다...
                              $("#calForm #calendarNo").remove();
                              $("#calForm").prepend("<input id='calendarNo' type='hidden' name='calNo'  value='"+info.event.extendedProps.calendarNo+"' />");
                                 // 입력 요소를 읽기 전용으로 설정
                                 $("#calModal #calTitle").prop("readonly", true);
                                 $("#calModal #calStartDate").prop("readonly", true);
                                 $("#calModal #calEndDate").prop("readonly", true);
                                 $("#calModal #calContent").prop("readonly", true);
                                 $("#calModal #calRepeatDate").prop("readonly", true);
                                 // 버튼 텍스트 변경 및 클래스 추가
                                 $("#insertCal")
                                     .text("수정")
                                     .removeClass("btn-primary")
                                     .removeClass("btn-danger")
                                     .addClass("btn-warning");
                              
                                 
                                 // 삭제 버튼 추가
                                 var removeBtn = "<button type='button' id='deleteCal' class='btn btn-danger'>삭제</button>";
                                 $("#calForm").append(removeBtn);  // 모달 창 열기
                                 $("#calModal #calNo").val(info.event.calendarNo);      // 번호
                                 $("#calModal #calTitle").val(info.event.title);         // 제목                     
                                 $("#calModal #calStartDate").val(startDate);         //시간날짜
                                 $("#calModal #calEndDate").val(endDate);            //끝 날짜
                                 $("#calModal #calContent").val(calContent);            //내용
                                 $("#calModal #calRepeatUnit").val(calRepeatUnit);      //반복단위
                                 $("#calModal #calRepeatDate").val(moment(repeatDate).format('YYYY-MM-DD'));   // 반복일자
                                 $("#calModal #calAll").val(calAll);                                       // allDay
                                 $("input:radio[name ='calType']:input[value='"+calType+"']").attr("checked", true); // 일정 종류 값 넣기
                                 $("#calModal").modal("show");
                                 $(".modal-header .modal-title").html("<strong style='color: green;'>일정 확인</strong>");
                                 },
                                 
                                 
                             eventMouseEnter: function (info) {
                                console.log("eventMouseEnter");
                                 // 툴팁 내용 생성
                                 var tooltipContent = '<span class="tooltip-title">' + info.event.title + '</span><br /><span class="tooltip-Content">' + info.event.extendedProps.content + '</span>';
                                 // 부트스트랩 툴팁 적용                                                                                             
                                 $(info.el).tooltip({
                                     title: tooltipContent,
                                     html: true,
                                     placement: 'top',
                                     trigger: 'hover focus', // 툴팁을 호버 또는 포커스할 때만 표시
                                 }).tooltip('show');
                             },
                             eventMouseLeave: function (info) {
                                 // 툴팁 숨기기
                                 $(info.el).tooltip('hide');
                             }
                  });
                  calendar.render();
               
            },
            error : function(XMLHttpRequest, textStatus, errorThrown){ // 비동기 통신이 실패할경우 error 콜백으로 들어옵니다.
                alert("통신 실패.")
            }
        });

    });
 
     

 
 
 
 
 </script>

          <script
            src="${pageContext.request.contextPath }/resources/assets/js/demo-purpose-only.js"
            defer></script> 
          <script
            src="${pageContext.request.contextPath }/resources/assets/vendors/fullcalendar/main.min.js"
            defer></script> 
         <%-- <script src="${pageContext.request.contextPath }/resources/assets/pages/fullcalendar.js" defer></script> --%>