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
				<li class="breadcrumb-item active" aria-current="page">전직원 결재현황</li>
			</ol>
		</nav>
		<!-- END : Breadcrumb -->

		<h1 class="page-title mb-0 mt-2">전직원 결재현황</h1>
		<p class="lead"></p>
	</div>
</div>

<div class="content__boxed">
    <div class="content__wrap">
        <div class="card" id="statDclz">
            <div class="card-body" id="chartDiv">
                <div class="card h-100">
                    <div class="card-body">
                    	<!-- 날짜 선택 -->
                    	시작날짜: <input type="date" id="startDate"/> ~ 끝날짜: <input type="date" id="endDate"/>&nbsp;&nbsp;&nbsp;&nbsp;
                    	
                    	<!-- 부서 선택 -->
						부서: <select id="deptDclzList">
                        	<option selected value="">전체</option>
                        	<c:forEach items="${deptList }" var="dept">
                        		<option value="${dept.deptCode }">${dept.deptName }</option>
                        	</c:forEach>
                        </select>&nbsp;&nbsp;&nbsp;&nbsp;
                        
                        <!-- 검색버튼 -->
                        <button class="btn btn-xs btn-primary" id="statEmpDraftBtn">검색</button><br/><br/>
                        
                        

                        <!-- 직원 결재 테이블 -->
                        <div class="table-responsive">
                            <table class="table table-sm table-bordered">
                                <thead>
                                    <tr>
										<th width="10%">사번</th>
                                        <th width="10%">이름</th>
                                        <th width="10%">부서</th>
                                        <th width="10%">직위</th>
                                        <th width="10%">진행</th>
                                        <th width="10%">승인</th>
                                        <th width="10%">반려</th>
										<th width="10%">총</th>
                                    </tr>
                                </thead>
                                <tbody id="empDraft">
									<!--여기서 td추가-->
                                </tbody>
                            </table>
                        </div>
						
						<!-- 반력사유분석으로 이동하는 버튼 -->
                        <!-- <div>
                            <button class="btn btn-danger" id="rejectAnalyze" onclick="fRejectAnalyze()">반려사유 분석</button>
                        </div> -->

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<style>
#rejectAnalyze{
	float : right;
}
table{
	text-align : center;
}
</style>
<script>
var statEmpDraftBtn = document.querySelector("#statEmpDraftBtn");	// 검색버튼

function fempDraftList(){
	var startDate = document.querySelector("#startDate").value;
	var endDate = document.querySelector("#endDate").value;
	var deptDclzList = document.getElementById('deptDclzList');
	var deptSelected = deptDclzList.options[deptDclzList.selectedIndex].value;

	var data = {
		startDate : startDate,
		endDate : endDate,
		deptCode : deptSelected
	};

	$.ajax({
		url:"/stat/selectEmpDraftList",
		type: "post",
		data: JSON.stringify(data),
		contentType: "application/json;charset=utf-8",
		dataType:"json",
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
		},
		success:function(res){
			const empList = [];
			for(var i=0; i<res.length;i++){
				var approval = res[i];
				var employee = approval.employee;
				var dept = approval.dept;

				// 중복 체크 로직이나 거의 똑같아서 나중에 함수로 리팩토링하면 좋음, 일단 기능 완성..... 나중에 하는 걸로
				var isIn = false;
				for(var j=0; j<empList.length; j++){
					// 있으면 객체의 속성값만 ++
					if(empList[j].empNo == employee.empNo){
						if(approval.apprvStatus == "01"){
							empList[j].progress +=1;
						}

						if(approval.apprvStatus == "02"){
							empList[j].approval +=1;
						}

						if(approval.apprvStatus == "03"){
							empList[j].companion +=1;
						}

						isIn=true;
						break;
					}
				}
	
				// 없을 때 맨처음 하나 들어가기
				if(!isIn){
					var emp = {
						empNo:employee.empNo,
						empName:employee.empName,
						deptName:dept.deptName,
						position:employee.position,
						progress:approval.apprvStatus=="01"?1:0,
						approval:approval.apprvStatus=="02"?1:0,
						companion:approval.apprvStatus=="03"?1:0,
					}
					empList.push(emp);
				}
			}

			var html = "";
			for(var k=0; k<empList.length;k++){
				var sum = empList[k].progress + empList[k].approval + empList[k].companion;

				html += "<tr>"
				html += "<td>"+empList[k].empNo+"</td>";
				html += "<td>"+empList[k].empName+"</td>";
				html += "<td>"+empList[k].deptName+"</td>";
				html += "<td>"+empList[k].position+"</td>";
				html += "<td>"+empList[k].progress+"</td>";
				html += "<td>"+empList[k].approval+"</td>";
				html += "<td>"+empList[k].companion+"</td>";
				html += "<td>"+sum+"</td>";
				html += "</tr>"
			}
			$("#empDraft").html(html);
			
		}
	});
}
// 처음 들어왔을 때
setTimeout(() => {
	fempDraftList();
}, 100);

// 검색버튼 눌렀을 때
statEmpDraftBtn.addEventListener("click", function(){
	setTimeout(() => {
		fempDraftList();
	}, 100);
});

/* function fRejectAnalyze(){
	location.href = "/stat/rejectAnalyze";
} */
</script>