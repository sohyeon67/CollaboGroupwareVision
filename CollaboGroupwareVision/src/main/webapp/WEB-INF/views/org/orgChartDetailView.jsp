<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

        <div class="card">

            <!-- 조직도, 사원정보 -->
            <div class="d-md-flex align-content-stretch">

                <!-- 조직도 -->
                <jsp:include page="./orgChart.jsp"/>

				<!-- 사원정보 -->
                <div class="card-body flex-fill m-5" style="height: 650px;">
		
                        <!-- Profile picture and short information -->
                        <div class="text-center position-relative">
                            <div class="pb-5">
                                <img id="profileImg" class="img-xl" src="${emp.profileImgPath }" style="object-fit: contain;" alt="Profile Picture">
                            </div>
                        </div>
                        <!-- END : Profile picture and short information -->
                        
                        <!-- Bordered table -->
                        <div class="table-responsive d-flex justify-content-center">
                            <table class="table table-bordered" style="max-width: 600px;">
	                            <tr>
	                                <td class="w-25">이름</td>
	                                <td id="empName">${emp.empName }</td>
	                            </tr>
	                            <tr>
	                                <td>사원번호</td>
	                                <td id="empNo">${emp.empNo }</td>
	                            </tr>
	                            <tr>
	                                <td>부서</td>
	                                <td id="deptName">${emp.deptName }</td>
	                            </tr>
	                            <tr>
	                                <td>직위</td>
	                                <td id="position">${emp.position }</td>
	                            </tr>
	                            <tr>
	                                <td>직책</td>
	                                <td id="duty">${emp.duty }</td>
	                            </tr>
	                            <tr>
	                                <td>연락처</td>
	                                <td id="empTel">${emp.empTel }</td>
	                            </tr>
	                            <tr>
	                                <td>내선번호</td>
	                                <td id="extNo">${emp.extNo }</td>
	                            </tr>
	                            <tr>
	                                <td>사내이메일</td>
	                                <td id="empEmail">${emp.empEmail }</td>
	                            </tr>
                            </table>
                        </div>
                        <!-- END : Bordered table -->
		
		        </div>
            </div>
            <!-- 조직도, 사원정보 끝 -->

        </div>

    </div>
</div>
<script>
$(function() {
	jsTreeObj.on('select_node.jstree', function(event, data) {
		// 노드 선택 이벤트
		//console.log("Selected Node:", data.node);
		
		// 부서 노드를 클릭한 경우 하위 노드 토글
		if(data.node.type === 'dept') {
			jsTreeObj.jstree(true).toggle_node(data.node);
		} else {	// 사원 노드를 클릭한 경우 상세 정보 가져오기
			showEmpDetails(data.node.id);
		}
		
	});
});

function showEmpDetails(nodeId) {
    //var node = jsTreeObj.jstree(true).get_node(nodeId);
    console.log("선택한 노드 사번:", nodeId);
    
    var profileImg = $("#profileImg");	// 증명사진
    var empNo = $("#empNo");			// 사번
    var deptName = $("#deptName");		// 부서명
    var empName = $("#empName");		// 사원명
    var empTel = $("#empTel");			// 연락처
    var extNo = $("#extNo");			// 내선번호
    var empEmail = $("#empEmail");		// 사내이메일
    var position = $("#position");		// 직위명
    var duty = $("#duty");				// 직책
    
    // 해당 직원의 상세 정보를 가져오는 AJAX 요청
    $.ajax({
        type: 'get',
        url: '/org/getOrgDetails',
        data: { empNo: nodeId },
        dataType: 'json',
        success: function(emp) {
            // 가져온 상세 정보를 각각 뿌려주기
            empName.html(emp.empName);		// 사원명
            empNo.html(emp.empNo);			// 사번
            deptName.html(emp.deptName);	// 부서명
            position.html(emp.position);	// 직위명
            duty.html(emp.duty);			// 직책
            empTel.html(emp.empTel);		// 연락처
            extNo.html(emp.extNo);			// 내선번호
            empEmail.html(emp.empEmail);	// 사내이메일
            profileImg.attr("src", emp.profileImgPath);	// 증명사진
        },
        error: function(xhr, status, error) {
            console.log('AJAX 오류:', status, error);
        }
    });
    
}
</script>