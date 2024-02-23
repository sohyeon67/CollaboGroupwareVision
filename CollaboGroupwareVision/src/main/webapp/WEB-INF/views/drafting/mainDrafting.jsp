<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 모달 style, script, body -->
<%@include file="./draftFormModal.jsp" %>
<style>
#recentToSignInfo {
    display: none;
    position: absolute;
    background-color: #fff;
    border: 1px solid #ccc;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    padding: 10px;
    z-index: 1000;
}

#draftingInfo {
    display: none;
    position: absolute;
    background-color: #fff;
    border: 1px solid #ccc;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    padding: 10px;
    z-index: 1000;
}
</style>

<c:if test="${not empty message }">
<script type="text/javascript">
Swal.fire({
	icon: 'error',
	title: '에러',
	text: '${message}'
});
<c:remove var="message" scope="request"/>
<c:remove var="message" scope="session"/>
</script>
</c:if>


<div class="content__header content__boxed overlapping">
    <div class="content__wrap">
         <!-- 경로 표시 -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/index">Home</a></li>
                <li class="breadcrumb-item"><a href="/drafting/main">전자결재</a></li>
                <li class="breadcrumb-item active" aria-current="page">${title }</li>
            </ol>
        </nav>

        <br/>
	    <br/>
    </div>
</div>

<div class="content__boxed">
    <div class="content__wrap">
        <!-- 카드 시작 -->
        <div class="card">
        	<!-- 카드 바디 -->
            <div class="card-body">

                <div class="d-md-flex gap-4">

                    <!-- 전자결재 사이드바  시작 -->
                    <div class="w-md-175px w-xl-200px flex-shrink-0 mb-3">

                        <!-- 새 결재 진행 버튼 시작 -->
                        <div class="d-grid">
                            <button type="button" class="btn btn-lg btn-secondary hstack gap-2" onclick="modalOpen()">
                                <i class="demo-pli-pen-5 fs-5 me-2"></i>
                                <span class="vr"></span>
                                	<div class="fw-bold">새 결재 진행</div>
                            </button>
                        </div>
                        <!-- 새 결재 진행 버튼 끝 -->

                        <!-- 전자결재 내비게이터 시작 -->
                        <h4 class="px-3 mt-5 mb-1 fw-bold">전자결재</h4>
                        <div class="list-group list-group-borderless gap-1">
                            <a href="/drafting/main" class="list-group-item list-group-item-action active">
                                <i class="demo-pli-home fs-5 me-2"></i> 전자결재 홈
                            </a>
                            <a href="/drafting/waitingApprovalList" class="list-group-item list-group-item-action">
                                <i class="demo-pli-mail-unread fs-5 me-2"></i> 결재 대기 문서함
                            </a>
                            <a href="/drafting/draftingList" class="list-group-item list-group-item-action">
                                <i class="demo-pli-mail-send fs-5 me-2"></i> 기안 문서함
                            </a>
                            <a href="/drafting/approvalList" class="list-group-item list-group-item-action">
                                <i class="demo-psi-mail fs-5 me-2"></i> 결재 문서함
                            </a>
                        </div>
                        <!-- 전자결재 내비게이터 끝 -->
                    </div>
                     <!-- 전자결재 사이드바  끝 -->

                    <div class="flex-fill min-w-0">
                        <div class="card-body">

                            <!-- Blog post lists -->
                            <div class="table-responsive">
	                            <h5 class="mb-1 fw-bold" style="font-size: 20px;"><a href="/drafting/waitingApprovalList" style="cursor: pointer; text-decoration: none; color: inherit;">결재 대기 문서</a>
	                            	<span class="fs-6 ms-2 text-primary cursor-pointer" onclick="showRecentToSignInfo()" style="cursor: pointer;">
								        <i class="ti-info-alt" style="font-size: 18px;"></i>
								    </span>
	                            </h5>
	                            <div id="recentToSignInfo" class="recent-info" style="display: none;">
								    현재 결재해야할 문서 5개를 최근 등록 순서대로 표시합니다.
								</div>
                                <table class="table table-striped align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width: 13%;">문서번호</th>
                                            <th style="width: 30%;">제목</th>
                                            <th class="text-nowrap" style="width: 13%;">기안일</th>
                                            <th style="width: 13%;">결재양식</th>
                                            <th style="width: 11%;">기안자</th>
                                            <th style="width: 8%;">부서</th>
                                            <th class="text-center" style="width: 10%;">결재 상태</th>
                                        </tr>
                                    </thead> 
                                    <tbody>
                                        <c:choose>
                                        	<c:when test="${empty toSignList }">
                                        		<tr>
                                        			<td colspan="5">결재해야 할 문서가 존재하지 않습니다.</td>
                                        		</tr>
                                        	</c:when>
                                        	<c:otherwise>
                                        		<c:forEach items="${toSignList }" var="toSign">
                                        			<tr>
                                        				<td>${toSign.drftNo }</td>
                                        				<td>
                                        					<a class="h6 btn-link text-decoration-underline text-truncate mb-0" href="/drafting/detail?drftNo=${toSign.drftNo }">
                                        						${toSign.drftTitle }
                                        					</a>
                                        				</td>
                                        				<td>
                                        					<span class="text-nowrap text-muted">${toSign.drftDate }</span>
                                        				</td>
                                        				<td>${toSign.drftFormName }</td>
                                        				<td>${toSign.drftWriterName } ${toSign.drftWriterPositionName }</td>
                                        				<td>${toSign.drftWriterDeptName }</td>
			                                            <td class="h5" style="width: 10%;">
	                                        				<c:if test="${toSign.drftStatus eq '진행중'}">
				                                               	<div class="d-block badge bg-success">${toSign.drftStatus }</div>
	                                        				</c:if>
	                                        				<c:if test="${toSign.drftStatus eq '승인'}">
				                                                <div class="d-block badge bg-light text-dark">${toSign.drftStatus }</div>
	                                        				</c:if>
	                                        				<c:if test="${toSign.drftStatus eq '반려'}">
				                                                <div class="d-block badge bg-danger">${toSign.drftStatus }</div>
	                                        				</c:if>
                                        				</td>
                                        			</tr>
                                        		</c:forEach>
                                        	</c:otherwise>
                                        </c:choose>                            
                                    </tbody>
                                </table>
                            </div>
                            <!-- END : Blog post lists -->
                            
                            <br/>
                            <br/>
                            <br/>
                            <!-- Blog post lists -->
                            <div class="table-responsive">
                            	<h5 class="mb-1 fw-bold" style="font-size: 20px;"> <a href="/drafting/draftingList" style="cursor: pointer; text-decoration: none; color: inherit;" >기안 문서</a>&nbsp;
                            		<span class="fs-6 me-2 text-primary drafting-cursor-pointer" onclick="showDraftingInfo()" style="cursor: pointer;">
								        <i class="ti-info-alt" style="font-size: 18px;"></i>
								    </span>
								</h5>
								<div id="draftingInfo" class="recent-info" style="display: none;">
								    작성한 기안문서 5개를 최근 등록 순서대로 표시합니다.
								</div>
                                <table class="table table-striped align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width: 13%;">문서번호</th>
                                            <th style="width: 30%;">제목</th>
                                            <th class="text-nowrap" style="width: 13%;">기안일</th>
                                            <th style="width: 13%;">결재양식</th>
                                            <th style="width: 11%;">기안자</th>
                                            <th style="width: 8%;">부서</th>
                                            <th class="text-center" style="width: 10%;">결재 상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                        	<c:when test="${empty writeDraftingList }">
                                        		<tr>
                                        			<td colspan="7">기안한 문서가 존재하지 않습니다.</td>
                                        		</tr>
                                        	</c:when>
                                        	
                                        	<c:otherwise>
                                        		<c:forEach items="${writeDraftingList }" var="writeDrafting">
                                        			<tr>
                                        				<td>${writeDrafting.drftNo }</td>
                                        				<td>
                                        					<a class="h6 btn-link text-decoration-underline text-truncate mb-0" href="/drafting/detail?drftNo=${writeDrafting.drftNo }">
                                        						${writeDrafting.drftTitle }
                                        					</a>
                                        				</td>
                                        				<td>
                                        					<span class="text-nowrap text-muted">${writeDrafting.drftDate }</span>
                                        				</td>
                                        				<td>${writeDrafting.drftFormName }</td>
                                        				<td>${writeDrafting.drftWriterName } ${writeDrafting.drftWriterPositionName }</td>
                                        				<td>${writeDrafting.drftWriterDeptName }</td>
			                                            <td class="h5" style="width: 10%;">
	                                        				<c:if test="${writeDrafting.drftStatus eq '진행중'}">
				                                               	<div class="d-block badge bg-success">${writeDrafting.drftStatus }</div>
	                                        				</c:if>
	                                        				<c:if test="${writeDrafting.drftStatus eq '승인'}">
				                                                <div class="d-block badge bg-light text-dark">${writeDrafting.drftStatus }</div>
	                                        				</c:if>
	                                        				<c:if test="${writeDrafting.drftStatus eq '반려'}">
				                                                <div class="d-block badge bg-danger">${writeDrafting.drftStatus }</div>
	                                        				</c:if>
                                        				</td>
                                        			</tr>
                                        		</c:forEach>
                                        	</c:otherwise>
                                        </c:choose>                            
                                    </tbody>
                                </table>
                            </div>
                            <!-- END : Blog post lists -->
                        </div>
                    </div>
                </div>
			<!-- 카드 바디 끝 -->
            </div>
		<!-- 카드 끝 -->
        </div>
    </div>
</div>
<script type="text/javascript">

// 최근 결재문서 5개 표시
function showRecentToSignInfo() {
    const icon = document.querySelector('.cursor-pointer');
    const infoDiv = document.getElementById('recentToSignInfo');

    // 내용을 표시할 위치 설정
    infoDiv.style.left = icon.offsetLeft + 'px';
    infoDiv.style.top = icon.offsetTop + icon.offsetHeight + 'px';

    // 내용을 표시
    infoDiv.style.display = 'block';

    // 아이콘 외의 영역을 클릭하면 숨김
    document.addEventListener('click', function hideInfo(event) {
        if (!infoDiv.contains(event.target) && !icon.contains(event.target)) {
            infoDiv.style.display = 'none';
            document.removeEventListener('click', hideInfo);
        }
    });
}


//기안 문서 정보 표시
function showDraftingInfo() {
    const draftingIcon = document.querySelector('.drafting-cursor-pointer');
    const draftingInfoDiv = document.getElementById('draftingInfo');

    // 내용을 표시할 위치 설정
    draftingInfoDiv.style.left = draftingIcon.offsetLeft + 'px';
    draftingInfoDiv.style.top = draftingIcon.offsetTop + draftingIcon.offsetHeight + 'px';

    // 내용을 표시
    draftingInfoDiv.style.display = 'block';

    // 아이콘 외의 영역을 클릭하면 숨김
    document.addEventListener('click', function hideDraftingInfo(event) {
        if (!draftingInfoDiv.contains(event.target) && !draftingIcon.contains(event.target)) {
            draftingInfoDiv.style.display = 'none';
            document.removeEventListener('click', hideDraftingInfo);
        }
    });
}

</script>
