<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
table.table {
	font-size : 1rem;
	border: 1px solid navy;
	color : black;
}

table.table th {
	border-right: 1px solid navy;
    background: aliceblue;
	text-align: center;
}

table.table td {
    padding-left: 1rem !important;
}

</style>


<div class="content__header content__boxed overlapping">
    <div class="content__wrap">

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="./index.html">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page">조직도</li>
            </ol>
        </nav>
        <!-- Breadcrumb 끝 -->
        <br/>

    </div>

</div>

<div class="content__boxed">
    <div class="content__wrap">

        <div class="row">

            <!-- 조직도, 사원정보 -->

				<div class="col-md-4 mb-3">
					<div class="card h-100">
						<div class="card-body d-md-flex align-content-stretch">
			                <!-- 조직도 -->
			                <jsp:include page="./orgChart.jsp"/>
		                </div>
	                </div>
				</div>

				<!-- 사원정보 -->
				<div class="col-md-8 mb-3">
					<div class="card h-100">
		                <div class="card-body flex-fill m-5" style="height: 650px;">
				
	                        <div class="text-center position-relative">
	                            <div class="pb-3">
	                                <img id="profileImg" class="img-xl" src="${emp.profileImgPath }" style="object-fit: contain; height: 170px" alt="Profile Picture">
	                            </div>
	                        </div>
	                        
	                        <div class="table-responsive d-flex justify-content-center">
	                            <table class="table" style="max-width: 600px;">
		                            <tr>
		                                <th class="w-25">이름</th>
		                                <td id="empName">${emp.empName }</td>
		                            </tr>
		                            <tr>
		                                <th>사원번호</th>
		                                <td id="empNo">${emp.empNo }</td>
		                            </tr>
		                            <tr>
		                                <th>부서</th>
		                                <td id="deptName">${emp.deptName }</td>
		                            </tr>
		                            <tr>
		                                <th>직위</th>
		                                <td id="position">${emp.position }</td>
		                            </tr>
		                            <tr>
		                                <th>직책</th>
		                                <td id="duty">${emp.duty }</td>
		                            </tr>
		                            <tr>
		                                <th>연락처</th>
		                                <td id="empTel">${emp.empTel }</td>
		                            </tr>
		                            <tr>
		                                <th>내선번호</th>
		                                <td id="extNo">${emp.extNo }</td>
		                            </tr>
		                            <tr>
		                                <th>사내이메일</th>
		                                <td id="empEmail">${emp.empEmail }</td>
		                            </tr>
		                            <tr>
		                                <th>입사일</th>
		                                <td id="joinDay">${emp.joinDay }</td>
		                            </tr>
	                            </table>
	                        </div>
				
				        </div>
			        </div>
		        
            	</div>
            	<!-- 사원정보 끝 -->

        </div>

    </div>
</div>
<script>
$(function() {
	jsTreeObj.on('select_node.jstree', function(event, data) {
		
		// 부서 노드를 클릭한 경우 하위 노드 토글
		if(data.node.type === 'dept') {
			jsTreeObj.jstree(true).toggle_node(data.node);
		} else {	// 사원 노드를 클릭한 경우 상세 정보 가져오기
			showEmpDetails(data.node.id);
		}
		
	});
});

// 조직도 사원정보 출력
function showEmpDetails(nodeId) {
	
    $.ajax({
        type: 'get',
        url: '/org/getOrgDetails',
        data: { empNo: nodeId },
        dataType: 'json',
        success: function(emp) {
            // 가져온 상세 정보를 각각 뿌려주기
            $("#empName").text(emp.empName);	// 사원명
            $("#empNo").text(emp.empNo);		// 사번
            $("#deptName").text(emp.deptName);	// 부서명
            $("#position").text(emp.position);	// 직위명
            $("#duty").text(emp.duty);			// 직책
            $("#empTel").text(emp.empTel);		// 연락처
            $("#extNo").text(emp.extNo);		// 내선번호
            $("#empEmail").text(emp.empEmail);	// 사내이메일
            $("#joinDay").text(emp.joinDay);	// 입사일
            $("#profileImg").attr("src", emp.profileImgPath);	// 증명사진
        },
        error: function(xhr, status, error) {
            console.log('AJAX 오류:', status, error);
        }
    });
    
}
</script>