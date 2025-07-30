<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<!-- MAIN NAVIGATION -->
<nav id="mainnav-container" class="mainnav">
	<div class="mainnav__inner">

		<!-- Navigation menu -->
		<div class="mainnav__top-content scrollable-content pb-5">

			<!-- Profile Widget -->
			<div class="mainnav__profile mt-3 d-flex3">

				<div class="mt-2 d-mn-max"></div>

				<!-- Profile picture  -->
				<sec:authorize access="isAuthenticated()">
				    <sec:authentication var="myInfo" property="principal.employee" />
				</sec:authorize>
				<c:choose>
				    <c:when test="${not empty myInfo.profileImgPath}">
				        <c:set var="profileImgSrc" value="${myInfo.profileImgPath}" />
				    </c:when>
				    <c:otherwise>
				        <c:set var="profileImgSrc" value="${pageContext.request.contextPath}/resources/assets/img/profile-photos/1.png" />
				    </c:otherwise>
				</c:choose>
				
				<div class="mininav-toggle text-center py-2">
					<img class="mainnav__avatar img-lg border"
						src="${profileImgSrc }" id="myProfile" alt="Profile Picture" style="object-fit: contain; height: fit-content;">
				</div>

				<div class="mininav-content collapse d-mn-max">
					<div class="d-grid">

						<!-- User name -->
						<h5 class="mt-1 mb-0 fw-bold d-flex justify-content-center" id="myName">${myInfo.empName }</h5>

					</div>
				</div>
			</div>
			<!-- End - Profile widget -->

			<!-- 좌측메뉴 -->
			<div class="mainnav__categoriy py-3">
				<!-- 통계 -->
				<ul class="mainnav__menu nav flex-column">
					<li class="nav-item has-sub"><a href="#"
						class="mininav-toggle nav-link collapsed <c:if test='${activeMain eq "stat" }'>active</c:if>"><i
							class="ti-stats-up fs-5 me-2"></i> <span
							class="nav-label ms-1">통계</span> </a>
						<ul class="mininav-content nav collapse">
							<li class="nav-item"><a href="/stat/statDclz" 
								class="nav-link <c:if test='${active eq "st_dclz" }'>active</c:if>">근태 통계</a></li>
							<li class="nav-item"><a href="/stat/statDraft" 
								class="nav-link <c:if test='${active eq "st_draft" }'>active</c:if>">전자결재 통계</a></li>
						</ul></li>
				</ul>
				<!-- 프로젝트 -->
				<ul class="mainnav__menu nav flex-column">
					<li class="nav-item has-sub"><a href="/adminProject/home"
						class="nav-link collapsed <c:if test='${activeMain eq "project" }'>active</c:if>"><i
							class="ti-pencil-alt fs-5 me-2"></i> <span
							class="nav-label ms-1">프로젝트 관리</span> </a></li>
				</ul>
				<!-- 자원관리 -->
				<ul class="mainnav__menu nav flex-column">
					<li class="nav-item has-sub"><a href="#"
						class="mininav-toggle nav-link collapsed <c:if test='${activeMain eq "mng_reserve" }'>active</c:if>"><i
							class="ti-check fs-5 me-2"></i> <span
							class="nav-label ms-1">예약 관리</span> </a>
						<ul class="mininav-content nav collapse">
							<li class="nav-item"><a href="/mer/adminMer"
								class="nav-link <c:if test='${active eq "mng_meet" }'>active</c:if>">회의실관리</a></li>
							<li class="nav-item"><a href="/adminVhcl/adminVhcl" 
								class="nav-link <c:if test='${active eq "mng_vhcl" }'>active</c:if>">차량관리</a></li>

						</ul></li>
				</ul>
				<!-- 조직관리 -->
				<ul class="mainnav__menu nav flex-column">
					<li class="nav-item has-sub"><a href="#"
						class="mininav-toggle nav-link collapsed <c:if test='${activeMain eq "adminOrg" }'>active</c:if>"><i
							class="ti-id-badge fs-5 me-2"></i> <span
							class="nav-label ms-1">조직 관리</span> </a>
						<ul class="mininav-content nav collapse">
							<li class="nav-item"><a href="/adminOrg/orgDesign"
								class="nav-link <c:if test='${active eq "orgDesign" }'>active</c:if>">조직설계</a></li>
							<li class="nav-item"><a href="/account/empManage"
								class="nav-link <c:if test='${active eq "empManage" }'>active</c:if>">사원통합관리</a></li>
							<li class="nav-item"><a href="/adminOrg/deptDelList"
								class="nav-link <c:if test='${active eq "orgDelList" }'>active</c:if>">조직 삭제목록</a></li>

						</ul></li>
				</ul>
				
				<!-- 게시판 -->
				<ul class="mainnav__menu nav flex-column">
					<li class="nav-item has-sub"><a href="#"
						class="mininav-toggle nav-link collapsed <c:if test='${activeMain eq "board" }'>active</c:if>">
							<i class="ti-announcement fs-5 me-2"></i> <span
							class="nav-label ms-1">게시판</span>
					</a>
						<ul class="mininav-content nav collapse">
							<li class="nav-item"><a href="/suggestion/adsuggestionlist"
								class="nav-link <c:if test='${active eq "suggestion" }'>active</c:if>">건의게시판관리</a></li>		
						</ul>
					</li>
				</ul>
				<!-- 일반 홈 -->
				<ul class="mainnav__menu nav flex-column">
					<li class="nav-item has-sub"><a href="/"
						class="nav-link collapsed"><i
							class="ti-shift-left fs-5 me-2"></i> <span
							class="nav-label ms-1">직원 페이지</span> </a></li>
				</ul>
			</div>
			<!-- 좌측메뉴 끝 -->
		</div>
		<!-- End Navigation menu -->

		<!-- Bottom 로그아웃 -->
		<div class="mainnav__bottom-content border-top pb-2">
			<ul id="mainnav" class="mainnav__menu nav flex-column">
				<li class="nav-item has-sub"><div class="nav-link collapsed"
						aria-expanded="false">
						<i class="demo-pli-unlock fs-5 me-2"></i>
						<form action="/logout" method="post">
							<input type="submit" value="Logout"
								style="color: #75868f; border: none; background-color: transparent;" />
							<sec:csrfInput />
						</form>
					</div></li>
			</ul>
		</div>

		<!-- Bottom 로그아웃 -->

	</div>
</nav>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- END - MAIN NAVIGATION -->

<!-- SIDEBAR -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<aside class="sidebar">
	<div class="sidebar__inner scrollable-content">

		<!-- This element is only visible when sidebar Stick mode is active. -->
		<div class="sidebar__stuck align-item-center mb-3 px-4">
			<p class="m-0 text-danger">Close the sidebar =></p>
			<button type="button"
				class="sidebar-toggler btn-close btn-lg rounded-circle ms-auto"
				aria-label="Close"></button>
		</div>

		<!-- Sidebar tabs nav -->
		<div class="sidebar__wrap">
			<nav class="px-3">
				<div class="nav nav-callout nav-fill flex-nowrap" id="nav-tab"
					role="tablist">
					<button class="nav-link active" data-bs-toggle="tab"
						data-bs-target="#nav-chat" type="button" role="tab"
						aria-controls="nav-chat" aria-selected="true">
						<i class="d-block demo-pli-speech-bubble-5 fs-3 mb-2"></i> <span>Chat</span>
					</button>

					<button class="nav-link" data-bs-toggle="tab"
						data-bs-target="#nav-reports" type="button" role="tab"
						aria-controls="nav-reports" aria-selected="false">
						<i class="d-block demo-pli-information fs-3 mb-2"></i> <span>Reports</span>
					</button>

					<button class="nav-link" data-bs-toggle="tab"
						data-bs-target="#nav-settings" type="button" role="tab"
						aria-controls="nav-settings" aria-selected="false">
						<i class="d-block demo-pli-wrench fs-3 mb-2"></i> <span>Settings</span>
					</button>
				</div>
			</nav>
		</div>
		<!-- End - Sidebar tabs nav -->

		<!-- Sideabar tabs content -->
		<div class="tab-content sidebar__wrap" id="nav-tabContent">

			<!-- Chat tab Content -->
			<div id="nav-chat" class="tab-pane fade py-4 show active"
				role="tabpanel" aria-labelledby="nav-chat-tab">

				<!-- Family list group -->
				<h5 class="px-3">Family</h5>
				<div class="list-group list-group-borderless">

					<div
						class="list-group-item list-group-item-action d-flex align-items-start mb-2">
						<div class="flex-shrink-0 me-3">
							<img class="img-xs rounded-circle"
								src="./assets/img/profile-photos/2.png" alt="Profile Picture"
								loading="lazy">
						</div>
						<div class="flex-grow-1 ">
							<a href="#"
								class="h6 d-block mb-0 stretched-link text-decoration-none">Stephen
								Tran</a> <small class="text-muted">Available</small>
						</div>
					</div>

					<div
						class="list-group-item list-group-item-action d-flex align-items-start mb-2">
						<div class="flex-shrink-0 me-3">
							<img class="img-xs rounded-circle"
								src="./assets/img/profile-photos/8.png" alt="Profile Picture"
								loading="lazy">
						</div>
						<div class="flex-grow-1 ">
							<a href="#"
								class="h6 d-block mb-0 stretched-link text-decoration-none">Betty
								Murphy</a> <small class="text-muted">Iddle</small>
						</div>
					</div>

					<div
						class="list-group-item list-group-item-action d-flex align-items-start mb-2">
						<div class="flex-shrink-0 me-3">
							<img class="img-xs rounded-circle"
								src="./assets/img/profile-photos/7.png" alt="Profile Picture"
								loading="lazy">
						</div>
						<div class="flex-grow-1 ">
							<a href="#"
								class="h6 d-block mb-0 stretched-link text-decoration-none">Brittany
								Meyer</a> <small class="text-muted">I think so!</small>
						</div>
					</div>

					<div
						class="list-group-item list-group-item-action d-flex align-items-start mb-2">
						<div class="flex-shrink-0 me-3">
							<img class="img-xs rounded-circle"
								src="./assets/img/profile-photos/4.png" alt="Profile Picture"
								loading="lazy">
						</div>
						<div class="flex-grow-1 ">
							<a href="#"
								class="h6 d-block mb-0 stretched-link text-decoration-none">Jack
								George</a> <small class="text-muted">Last seen 2 hours ago</small>
						</div>
					</div>

				</div>
				<!-- End - Family list group -->

				<!-- Friends Group -->
				<h5 class="d-flex mt-5 px-3">
					Friends <span class="badge bg-success ms-auto">587 +</span>
				</h5>
				<div class="list-group list-group-borderless">
					<a href="#" class="list-group-item list-group-item-action"> <span
						class="d-inline-block bg-success rounded-circle p-1"></span> Joey
						K. Greyson
					</a> <a href="#" class="list-group-item list-group-item-action"> <span
						class="d-inline-block bg-info rounded-circle p-1"></span> Andrea
						Branden
					</a> <a href="#" class="list-group-item list-group-item-action"> <span
						class="d-inline-block bg-warning rounded-circle p-1"></span> Johny
						Juan
					</a> <a href="#" class="list-group-item list-group-item-action"> <span
						class="d-inline-block bg-secondary rounded-circle p-1"></span>
						Susan Sun
					</a>
				</div>
				<!-- End - Friends Group -->

				<!-- Simple news widget -->
				<div class="px-3">
					<h5 class="mt-5">News</h5>
					<p>Lorem ipsum, dolor sit amet consectetur adipisicing elit.
						Qui consequatur ipsum porro a repellat eaque exercitationem
						necessitatibus esse voluptate corporis.</p>
					<small class="fst-italic">Last Update : Today 13:54</small>
				</div>
				<!-- End - Simple news widget -->

			</div>
			<!-- End - Chat tab content -->

			<!-- Reports tab content -->
			<div id="nav-reports" class="tab-pane fade py-4" role="tabpanel"
				aria-labelledby="nav-reports-tab">

				<!-- Billing and Resports -->
				<div class="px-3">
					<h5 class="mb-3">Billing &amp Reports</h5>
					<p>
						Get <span class="badge bg-danger">$15.00 off</span> your next bill
						by making sure your full payment reaches us before August 5th.
					</p>

					<h5 class="mt-5 mb-0">Amount Due On</h5>
					<p>August 17, 2028</p>
					<p class="h1">$83.09</p>

					<div class="d-grid">
						<button class="btn btn-success" type="button">Pay now</button>
					</div>
				</div>
				<!-- End - Billing and Resports -->

				<!-- Additional actions nav -->
				<h5 class="mt-5 px-3">Additional Actions</h5>
				<div class="list-group list-group-borderless">
					<a href="#" class="list-group-item list-group-item-action"> <i
						class="demo-pli-information me-2 fs-5"></i> Services Information
					</a> <a href="#" class="list-group-item list-group-item-action"> <i
						class="demo-pli-mine me-2 fs-5"></i> Usage
					</a> <a href="#" class="list-group-item list-group-item-action"> <i
						class="demo-pli-credit-card-2 me-2 fs-5"></i> Payment Options
					</a> <a href="#" class="list-group-item list-group-item-action"> <i
						class="demo-pli-support me-2 fs-5"></i> Messages Center
					</a>
				</div>
				<!-- End - Additional actions nav -->

				<!-- Contact widget -->
				<div class="px-3 mt-5 text-center">
					<div class="mb-3">
						<i class="demo-pli-old-telephone display-4 text-primary"></i>
					</div>
					<p>Have a question ?</p>
					<p class="h5 mb-0">(415) 234-53454</p>
					<small><em>We are here 24/7</em></small>
				</div>
				<!-- End - Contact widget -->

			</div>
			<!-- End - Reports tab content -->

			<!-- Settings content -->
			<div id="nav-settings" class="tab-pane fade py-4" role="tabpanel"
				aria-labelledby="nav-settings-tab">

				<!-- Account settings -->
				<h5 class="px-3">Account Settings</h5>
				<div class="list-group list-group-borderless">

					<div class="list-group-item mb-1">
						<div class="d-flex justify-content-between mb-1">
							<label class="form-check-label" for="_dm-sbPersonalStatus">Show
								my personal status</label>
							<div class="form-check form-switch">
								<input id="_dm-sbPersonalStatus" class="form-check-input"
									type="checkbox" checked>
							</div>
						</div>
						<small class="text-muted">Lorem ipsum dolor sit amet,
							consectetuer adipiscing elit.</small>
					</div>

					<div class="list-group-item mb-1">
						<div class="d-flex justify-content-between mb-1">
							<label class="form-check-label" for="_dm-sbOfflineContact">Show
								offline contact</label>
							<div class="form-check form-switch">
								<input id="_dm-sbOfflineContact" class="form-check-input"
									type="checkbox">
							</div>
						</div>
						<small class="text-muted">Aenean commodo ligula eget
							dolor. Aenean massa.</small>
					</div>

					<div class="list-group-item mb-1">
						<div class="d-flex justify-content-between mb-1">
							<label class="form-check-label" for="_dm-sbInvisibleMode">Invisible
								Mode</label>
							<div class="form-check form-switch">
								<input id="_dm-sbInvisibleMode" class="form-check-input"
									type="checkbox">
							</div>
						</div>
						<small class="text-muted">Cum sociis natoque penatibus et
							magnis dis parturient montes, nascetur ridiculus mus.</small>
					</div>

				</div>
				<!-- End - Account settings -->

				<!-- Public Settings -->
				<h5 class="mt-5 px-3">Public Settings</h5>
				<div class="list-group list-group-borderless">

					<div class="list-group-item d-flex justify-content-between mb-1">
						<label class="form-check-label" for="_dm-sbOnlineStatus">Online
							Status</label>
						<div class="form-check form-switch">
							<input id="_dm-sbOnlineStatus" class="form-check-input"
								type="checkbox" checked>
						</div>
					</div>

					<div class="list-group-item d-flex justify-content-between mb-1">
						<label class="form-check-label" for="_dm-sbMuteNotifications">Mute
							Notifications</label>
						<div class="form-check form-switch">
							<input id="_dm-sbMuteNotifications" class="form-check-input"
								type="checkbox" checked>
						</div>
					</div>

					<div class="list-group-item d-flex justify-content-between mb-1">
						<label class="form-check-label" for="_dm-sbMyDevicesName">Show
							my device name</label>
						<div class="form-check form-switch">
							<input id="_dm-sbMyDevicesName" class="form-check-input"
								type="checkbox" checked>
						</div>
					</div>

				</div>
				<!-- End - Public Settings -->

			</div>
			<!-- End - Settings content -->

		</div>
		<!-- End - Sidebar tabs content -->

	</div>
</aside>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- END - SIDEBAR -->

