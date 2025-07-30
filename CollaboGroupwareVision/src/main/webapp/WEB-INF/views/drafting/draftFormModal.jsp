<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>   


<style>
#draftingModal{
	position: fixed;
    width: 100%;
    height: 100%; /* fixed인 경우 작동 */
    left: 0px;
    top: 0px;
    background-color: rgb(200, 200, 200, 0.5);
    display: none;  /* 존재하지만 보이지않음 */
    z-index: 1000; /* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
    /* static(브라우저에게 외주), relative(static한 상태에서 내가 조금 조정할게)
        absolute(내가 다 할게, 기준점 브라우저 왼쪽상단 모서리), fixed(고정좌표),
        $$ 부모 relative, 자식 absolute (자식의 기준점이 부모 왼쪽상단 모서리)
    */
}


#modalCont{
    margin: 10% auto;   /* 수평가운데 정렬 */
	width : 500px;
	
}


</style>

<!-- 전자결재 모달창 시작  -->
<div id="draftingModal">
	<div class="col-md-6 mb-3" id="modalCont">
	    <div class="card">
	        <div class="card-body">
	
	            <h5 class="card-title fw-bold">결재 양식 선택</h5>
				
	            <!-- Bordered table -->
	            <div class="table-responsive">
	                <table class="table table-bordered">
	                    <thead>
	                        <tr>
	                            <th>결재 양식 명</th>
	                            <th>사용 가능 여부</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                    	<c:set value="${draftingFormList }" var="draftingFormList" />
	                        <c:choose>
	                        	<c:when test="${empty draftingFormList }">
	                        		<tr>
	                        			<td colspan="2">서류 양식이 존재하지 않습니다.</td>
	                        		</tr>
	                        	</c:when>
	                        	<c:otherwise>    
	                        		<c:forEach items="${draftingFormList }" var="draftingForm">
										<c:if test="${draftingForm.drftFormUseYn eq 'Y' }">
		                        			<tr>
												<td>
													<a href="/drafting/draftingForm?drftFormNo=${draftingForm.drftFormNo }" class="btn-link">${draftingForm.drftFormName }</a>
												</td>
												<td>
													<span class="badge bg-success">사용 가능</span>
												</td>	                        			
	                        				</tr>
										</c:if>
										<c:if test="${draftingForm.drftFormUseYn eq 'N' }">
		                        			<tr>
												<td>
													<a href="#" class="btn-link">${draftingForm.drftFormName }</a>
												</td>
												<td>
													<span class="badge bg-danger">사용 불가</span>
												</td>	                        			
	                        				</tr>	
										</c:if>
	                        		</c:forEach>                    		
	                        	</c:otherwise>
	                        </c:choose>	             
	                    </tbody>
	                </table>
	            </div>
	            <!-- END : Bordered table -->
	            
	            <!-- 버튼 시작 -->
				<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
				    <button type="button" class="btn btn-danger  fw-bold" style="font-size: 16px;" onclick="modalClose()">닫기</button>
				</div>

	            <!-- 버튼 끝 -->
                
	        </div>
	    </div>
	</div>
</div>
<!-- 전자결재 모달창 끝  -->


<script>
// 모달창 스크립트 시작 
function modalOpen(){
	draftingModal.style.display = "block";  // none을 block으로 모달창 출력
}

function modalClose(){
	draftingModal.style.display = "none";    // block을 none으로 변경해서 모달창 닫기
}

// 모달창 스크립트 끝

setTimeout(() => {
	check();
}, 30);
</script>

