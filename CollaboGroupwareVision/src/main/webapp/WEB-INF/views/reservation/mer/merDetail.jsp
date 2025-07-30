<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 좌측 상단 -->
<div class="content__header content__boxed overlapping">
   <div class="content__wrap">
      <nav aria-label="breadcrumb">
         <ol class="breadcrumb mb-0">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item"><a href="#">예약</a></li>
            <li class="breadcrumb-item"><a href="/mer">회의실예약</a></li>
            <li class="breadcrumb-item active" aria-current="page">예약상세보기</li>
         </ol>
      </nav>
      <br/>
   </div>
</div>

<div class="content__boxed">
   <div class="content__wrap d-flex justify-content-center">
      <div class="card d-felx justify-content-center" style="width:80%;">
         <div class="card-body">
            <div class="table-responsive">
               <table class="table table-striped">
                   <thead>
                       <tr>
                           <th width="20%">구분</th>
                           <th width="80%">내용</th>
                       </tr>
                   </thead>
                   <tbody>
                       <tr>
                           <td>예약번호</td>
                           <td>${merRsvt.getMRsvtNo() }</td>
                       </tr>
                       <tr>
                           <td>회의실</td>
                           <td>${merRsvt.getMer().getMerName() }</td>
                       </tr>
                       <tr>
                           <td>예약자 사번</td>
                           <td>${merRsvt.getEmpNo() }</td>
                       </tr>
                       <tr>
                           <td>예약제목</td>
                           <td>${merRsvt.getMRsvtTitle() }</td>
                       </tr>
                       <tr>
                           <td>예약등록일시</td>
                           <td>${merRsvt.getRsvtDate() }</td>
                       </tr>
                       <tr>
                           <td>시작일시</td>
                           <td>${merRsvt.getStrtRsvtDate() }</td>
                       </tr>
                       <tr>
                           <td>종료일시</td>
                           <td>${merRsvt.getEndRsvtDate() }</td>
                       </tr>
                        <tr>
                           <td>사용목적</td>
                           <td>${merRsvt.getPpus() }</td>
                       </tr>
                   </tbody>
               </table><br/><br/>
               <div class="d-md-flex">
					<div class="me-auto">
					</div>
					<div class="align-self-center">
						<c:if test="${empNo eq merRsvt.getEmpNo() }">
							<button type="button" class="btn btn-secondary btn-lg rounded-pill" onclick="f_merCancel()" id="cancelButtonDiv">취소하기</button>
						</c:if>
						<button type="button" class="btn btn-warning btn-lg rounded-pill" onclick="f_merRsvtList()">예약목록</button>
					</div>
				</div>
           </div>
         </div>
         <!-- card-body 끝 -->
      </div>
   </div>
</div>
<!-- content__boxed 끝 -->
<script>
// 예약목록버튼
function f_merRsvtList(){
	location.href = "/mer";
}

//현재시간에 따른 예약취소버튼 출력 유무
var startDate = "${merRsvt.getStrtRsvtDate() }";	// 시작시간
var endDate = "${merRsvt.getEndRsvtDate() }";	// 종료시간
// 현재날짜
var date = new Date();     
var year = date.getFullYear(); //년도    
var month = date.getMonth()+1; //월    
var day = date.getDate(); //일
var hour = date.getHours(); // 시간

//예약 시작 시간이 현재 시간 이후인 경우에만 취소 버튼 표시
var startDateArr = startDate.split(' ')[0].split('-'); // 시작 날짜 
var startTime = startDate.split(' ')[1].split(':')[0]; // 시작 시간
var startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1]) - 1, startDateArr[2], startTime);

var endDateArr = endDate.split(' ')[0].split('-');	// 종료 날짜 
var endTime = endDate.split(' ')[1].split(':')[0];	// 종료 시간
         
var endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2], endTime);
var toDayCompare = new Date(year, month-1, day, hour);

if (toDayCompare.getTime() >= endDateCompare.getTime()) {
	$("#cancelButtonDiv").attr("style", "background-color: white; border-color: white; color: white;");
    $("#cancelButtonDiv").hide(); 
}


// 예약취소버튼
function f_merCancel(){
	
	var endDate = "${merRsvt.getEndRsvtDate() }";	// 종료시간
	// 현재날짜
	var date = new Date();     
	var year = date.getFullYear(); //년도    
	var month = date.getMonth()+1; //월    
	var day = date.getDate(); //일
	var hour = date.getHours(); // 시간
	
    var endDateArr = endDate.split(' ')[0].split('-');	// 종료 날짜 
    var endTime = endDate.split(' ')[1].split(':')[0];	// 종료 시간
             
    var endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2], endTime);
    var toDayCompare = new Date(year, month-1, day, hour);
    
    if(toDayCompare.getTime() > endDateCompare.getTime()) {
    	Swal.fire("지난 날짜는 취소할 수 없습니다");
        return false;
    }
    
	if(confirm("정말 예약을 취소하시겠습니까?")){
		location.href = `/mer/merCancel?mRsvtNo=${merRsvt.getMRsvtNo() }`;
	}
}
</script>