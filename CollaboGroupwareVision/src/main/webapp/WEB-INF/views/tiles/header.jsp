<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<header class="header" id="IdHeader">
    <div class="header__inner">
        <div class="header__brand">
            <div class="brand-wrap">
                <a href="/" class="brand-img stretched-link">
                    <img src="${pageContext.request.contextPath }/resources/assets/img/logo.svg" alt="Nifty Logo" class="Nifty logo" width="40" height="40">
                </a>
                <div class="brand-title">Groupware</div>
            </div>
        </div>
        <div class="header__content">
            <div class="header__content-start">
                <button type="button" class="nav-toggler header__btn btn btn-icon btn-sm" aria-label="Nav Toggler">
                    <i class="demo-psi-view-list"></i>
                </button>
                <div class="header-searchbox">
                    <label for="header-search-input" class="header__btn d-md-none btn btn-icon rounded-pill shadow-none border-0 btn-sm" type="button">
                        <i class="demo-psi-magnifi-glass"></i>
                    </label>
                    <form class="searchbox searchbox--auto-expand searchbox--hide-btn input-group">
                        <input id="header-search-input" class="searchbox__input form-control bg-transparent" type="search" placeholder="Type for search . . ." aria-label="Search">
                        <div class="searchbox__backdrop">
                            <button class="searchbox__btn header__btn btn btn-icon rounded shadow-none border-0 btn-sm" type="button" id="button-addon2">
                                <i class="demo-pli-magnifi-glass"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="header__content-end">
            	<!-- 결재팝업 -->
                <div >
                    <a target="_blank" class="header__btn btn btn-icon btn-sm" rel="noopener" type="button" id="draftPopUp">
                        <i class="ti-stamp"></i>
                    </a>
                </div>
				<!-- 결재팝업 끝 -->
            	<!-- 드라이브팝업 -->
                <div >
                    <a target="_blank" class="header__btn btn btn-icon btn-sm" rel="noopener" type="button" id="drivePopUp">
                        <i class="ti-cloud"></i>
                    </a>
                </div>
				<!-- 드라이브팝업 끝 -->
				<!-- 이메일팝업 -->
                <div >
                    <button class="header__btn btn btn-icon btn-sm" type="button" id="emailPopUp">
                        <i class="ti-email"></i>
                    </button>
                </div>
				<!-- 이메일팝업 끝 -->
            	<!-- 채팅팝업 -->
                <div >
                    <button class="header__btn btn btn-icon btn-sm" type="button" id="chatPopUp">
                        <i class="ti-comments"></i>
                    </button>
                </div>
				<!-- 채팅팝업 끝 -->
				<!-- 알람 -->
				<!-- 알람수 고정 -->

                <div class="dropdown" >
					<!-- 알림 영역 -->
                    <button class="header__btn btn btn-icon btn-sm" type="button" data-bs-toggle="dropdown" aria-label="Notification dropdown" aria-expanded="false" id="notiMainBtn">
                        <span class="d-block position-relative">
                            <i class="demo-psi-bell"></i>
                            <span class="badge badge-super rounded bg-danger p-1" id="notiCount">
                                <span class="visually-hidden">unread messages</span>
                            </span>
                        </span>
                    </button>

                    <div class="dropdown-menu dropdown-menu-end w-md-300px"  >
                        <div class="border-bottom px-3 py-2 mb-3">
                            <h5>Notifications</h5>
                        </div>

                        <div class="list-group list-group-borderless" id="notiContainer">

                        </div>
                    </div>
                </div>
                <!-- 알람 끝 -->

				<!-- 마이페이지 -->
                <div class="dropdown">

                    <a href="/account/checkPassword" class="header__btn btn btn-icon btn-sm">
                        <i class="demo-psi-male"></i>
                    </a>
                </div>
                <!-- 마이페이지 끝 -->

                <button class="sidebar-toggler header__btn btn btn-icon btn-sm" type="button" aria-label="Sidebar button">
                    <i class="demo-psi-dot-vertical"></i>
                </button>

            </div>
        </div>
    </div>
</header>
<!-- 스타일 -->
<style>
#notiContainer{
	height : 400px;
	overflow: auto;
}
</style>
<!-- 알림기능 구현을 위한 스크립트 -->
<script type="text/javascript">
	
	const notiContainer = document.querySelector("#notiContainer"); // 알람의 내용을 감싸는 영역
	const notiMainBtn = document.querySelector("#notiMainBtn");	// 알람아이콘 버튼
	const notiCount = document.querySelector("#notiCount");		// 알람수 적히는 span
	
	// 알람수 설정하기
	function f_notiCount(){
		$.ajax({
			url:"/headerNotiCount",
			type:"get",
			dataType:"text",
			success:function(rslt){
				notiCount.innerText = rslt;
			}
		});
	}
	f_notiCount();
	
	//연결
	var webSocket;
	connect();
	
	function connect(){
		webSocket = new WebSocket("ws://localhost/ws-noti");
		webSocket.onopen = fOpen;
		webSocket.onmessage = fMessage;
	}

	function fOpen() {
		console.log("웹소켓(알람) 연결");
	} 
	function fMessage() {
		let data = event.data;
		console.log("받은 메세지: " + data);
	}
	
	// 알람버튼을 클릭 시, 알람읽음여부가 N인것이 보이고 읽으면 읽음여부가 Y로 업데이트된다.(보이지 않게 됨)
	notiMainBtn.addEventListener("click", function () {
		
		$.ajax({
			url:"/notify/notiList",
			type:"get",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader(header,token);
			},
			success:function(rslt){
				var html = "";
				$.each(rslt, function(i,v){
					
					var iconType = "";
					var aHref = "";
					
					if(v.notiKind == "01"){			// 공지사항
						iconType = "demo-pli-information text-red";
						aHref = "/notice/noticeList";
					}else if(v.notiKind == "02"){	// 메일
						iconType = "demo-pli-mail-unread text-green";
						aHref = "/email/inbox";
					}else if(v.notiKind == "03"){	// 프로젝트
						iconType = "demo-pli-share";
					}else if(v.notiKind == "04"){	// 커뮤니티
						iconType = "demo-psi-happy text-yellow";
						aHref = "/com/comHome";
					}else if(v.notiKind == "05"){	// 드라이브
						iconType = "demo-pli-file-add";
					}else if(v.notiKind == "06"){	// 채팅
						iconType = "demo-pli-love-user text-blue";
						aHref = "/chat";
					}else if(v.notiKind == "07"){	// 관리자
						iconType = "demo-pli-pencil";
					}else{							// 기타
						iconType = "demo-psi-data-settings";
					}
					
					html += "<div class='list-group-item list-group-item-action d-flex align-items-start mb-3'>";
					html += "    <div class='flex-shrink-0 me-3'>";
					html += "        <i class='"+iconType+" text-muted fs-2'></i>";
					html += "    </div>";
					html +=	"	<div class='flex-grow-1'>";
					html += "    	<a href='"+aHref+"' class='h6 d-block mb-0 stretched-link text-decoration-none updateNoticeRead' data-noti-kind='"+v.notiKind+"'>"+v.notiTitle+"</a>";
					html += "        	<small class='text-muted'>"+v.notiContent+"</small>";
					html += " 	</div>";
					html += "</div>";
			                
				});
				
				notiContainer.innerHTML = html;
			}
		});
		
	});
	
	// 내가 읽은 알람의 알람종류만 읽음여부 N->Y로 업데이트 하기
	$(function(){
		// 알람을 클릭했을 때
		$("#notiContainer").on("click",".updateNoticeRead",function(e){
			e.preventDefault();
			var notiKind = $(this).data("noti-kind");
			var href = $(this).attr("href");
			
			$.ajax({
				url:"/notify/updateNotiRead",
				type:"post",
				data:{notiKind:notiKind},
				beforeSend:function(xhr){
					xhr.setRequestHeader(header,token);
				},
				success:function(rslt){
					console.log("결과:"+rslt);
					location.replace(href);
				}
			});
		});
	});
	
	// [채팅]:완료
	// 채팅을 받으면 해당 채팅방에 있는 멤버들에게 알람이 간다.
	
	// [게시판]:완료
	// 공지사항 등록 시 전체 직원들에게 알람이 간다.
	
	// [메일]:완료
	// 메일을 받았을 시 알람이 간다.
	
	// [결재]
	// 결재 대기 서류가 생성될 시 알람이 간다.
	
	// 결재 서류가 승인/반려되었을 때 알람이 간다.
	
	// [프로젝트]
	// 프로젝트 시작/종료 시 알람이 간다.
	
	// 프로젝트 일감 등록 시 알람이 간다.
	
	// [커뮤니티]
	// 커뮤니티 승인/반려 시 알람이 간다.
			
	//---------------------------------팝업---------------------------------
	//팝업
	var popUrl = ""; // 팝업 경로
	var popOption = "";	// 팝업옵션
	
	var draftPopUp = document.querySelector("#draftPopUp");	// 결재 팝업버튼
	var chatPopUp = document.querySelector("#chatPopUp");	// 채팅팝업버튼
	var emailPopUp = document.querySelector("#emailPopUp");	// 메일팝업버튼
	var drivePopUp = document.querySelector("#drivePopUp");	// 드라이브 팝업버튼
	
	var draft_win = null;
	var chat_win = null;
	var mail_win = null;
	var drive_win = null;
	
	// 결재팝업 클릭 이벤트
	draftPopUp.addEventListener("click", function(){
		console.log("결재버튼");
		popUrl = "/drafting/main";        
		popOption = "width=1600, height=800, left=1200, top=0, menubar=no";        
		draft_win = window.open(popUrl, "draft-popup", popOption);
	});
	
	// 채팅팝업 클릭 이벤트
	chatPopUp.addEventListener("click", function(){
		console.log("채팅버튼");
		popUrl = "/chat";        
		popOption = "width=1600, height=800, left=1200, top=0, menubar=no";        
		chat_win = window.open(popUrl, "chat-popup", popOption);
	});
	
	// 메일팝업 클릭 이벤트
	emailPopUp.addEventListener("click", function(){
		console.log("메일버튼");
		popUrl = "/email/inbox";        
		popOption = "width=1600, height=800, left=1200, top=0, menubar=no";        
		mail_win = window.open(popUrl, "email-popup", popOption);
	});
	
	//드라이브 팝업버튼 클릭 이벤트
	drivePopUp.addEventListener("click", function(){
		console.log("드라이브버튼");
		popUrl = "/drive/fileManager";        
		popOption = "width=1600, height=800, left=1200, top=0, menubar=no";        
		drive_win = window.open(popUrl, "drive-popup", popOption);
	});
	
	
		
</script>