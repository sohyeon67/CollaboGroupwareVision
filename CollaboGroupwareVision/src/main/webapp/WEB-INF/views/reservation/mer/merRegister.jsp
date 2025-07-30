<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>   
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<style>
#merRegister{
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

#merRegisterContent{
    margin: 10% auto;   /* 수평가운데 정렬 */
	width : 500px;
}
h5{
	text-align : center;
}
td{
	vertical-align: middle;
}
</style>

<!-- 회의실예약 모달창 시작  -->
<div id="merRegister">
	<div class="col-md-6 mb-3" id="merRegisterContent">
	    <div class="card">
	        <div class="card-body">
	
	            <h5 class="card-title fw-bold">회의실 예약하기</h5>
				
	            <!-- Bordered table -->
	            <div class="table-responsive">
	            	<form id="merRegisterForm">
		                <table class="table">
		                    <tbody>
	                  			<tr>
									<td>
										<p>회의실 선택</p>
									</td>
									<td>
										<div class="form-floating mb-3">
                                            <select class="form-select" id="merInsert" aria-label="Floating label select example">
                                                <option selected disabled>--선택--</option>
                                                <c:choose>
                                                	<c:when test="${empty merList }">
                                                		조회가능한 회의실이 없습니다
                                                	</c:when>
                                                	<c:otherwise>
                                                		<c:forEach items="${merList }" var="mer">
                                                			<c:if test="${mer.enabled eq 'Y' }">
                                                				<option value="${mer.merNo }">${mer.merName}</option>
                                                			</c:if>
                                                		</c:forEach>
                                                	</c:otherwise>
                                                </c:choose>
                                            </select>
                                            <label for="floatingSelect">회의실</label>
                                        </div>
									</td>	                        			
			                   	</tr>
			                    <tr>
									<td>
										<p>날짜</p>
									</td>
									<td>
										<div class="mb-3">
                                        	<input type="date" id="merDateInsert" class="form-control">
                                    	</div>
									</td>	                        			
	                 			</tr>	
	                 			<tr>
									<td>
										<p>시작시간</p>
									</td>
									<td>
										<div class="mb-3">
                                        	<select class="form-select" id="startTimeInsert" aria-label="Floating label select example">
                                                <option selected disabled>--선택--</option>
                                                <c:forEach var="i" begin="7" end="22">    
														<option value="${i}">${i}시</option>
												</c:forEach>
                                            </select>
                                    	</div>
									</td>	                        			
	                 			</tr>	
	                 			<tr>
									<td>
										<p>종료시간</p>
									</td>
									<td>
										<div class="mb-3">
                                        	<select class="form-select" id="endTimeInsert" aria-label="Floating label select example">
                                                <option selected disabled>--선택--</option>
                                                <c:forEach var="i" begin="7" end="22">    
														<option value="${i}">${i}시</option>
												</c:forEach>
                                            </select>
                                    	</div>
									</td>	                        			
	                 			</tr>	
	                 			<tr>
									<td>
										<p>예약제목</p>
									</td>
									<td>
										<div class="mb-3">
                                        	<input type="text" id="titleInsert" class="form-control">
                                    	</div>
									</td>	                        			
	                 			</tr>	
	                 			<tr>
									<td>
										<p>사용목적</p>
									</td>
									<td>
										<div class="form-floating">
                                            <textarea class="form-control" placeholder="Leave a comment here" id="ppusInsert" style="height: 140px"></textarea>
                                            <label for="floatingTextarea2">사용목적 작성</label>
                                        </div>
									</td>	                        			
	                 			</tr>	
		                    </tbody>
		                </table>
		            <sec:csrfInput/>
	                </form>
	            </div>
	            <!-- END : Bordered table -->
	            
	            <!-- 버튼 시작 -->
				<div class="mt-4 d-flex flex-wrap justify-content-center gap-2">		
					<button type="button" class="btn btn-info fw-bold" style="font-size: 16px;" id="merRegisterBtn">등록</button>
				    <button type="button" class="btn btn-danger fw-bold" style="font-size: 16px;" onclick="modalClose()">닫기</button>
				</div>
	            <!-- 버튼 끝 -->
	        </div>
	    </div>
	</div>
</div>
<!-- 회의실예약 모달창 끝  -->
<script>
function modalOpen(){
	// 회의실 예약하기 클릭이벤트
	$("#merRegister").css("display","block");
}

function modalClose(){
	$("#merRegister").css("display","none"); 
}
// 모달창 스크립트 끝
</script>

