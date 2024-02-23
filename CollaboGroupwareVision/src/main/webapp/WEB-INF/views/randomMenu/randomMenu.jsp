<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<style>
#randomMenu {
	position: fixed;
	width: 100%;
	height: 100%;
	/* fixed인 경우 작동 */
	left: 0px;
	top: 0px;
	background-color: rgb(200, 200, 200, 0.5);
	display: none;
	/* 존재하지만 보이지않음 */
	z-index: 1000;
	/* 상황에 맞추어 사용, 큰 숫자가 앞으로 나옴 */
}
#randomMenuContent {
	margin: 10% auto;
	/* 수평가운데 정렬 */
	width: 500px;
	height: 500px;
}
#randomMenuArea {
	background-image: url("/resources/img/home/randomMenu4.png");
	background-size: 350px;
	margin: 0 auto;
	width: 100%;
	height: 60px;
}
#randomMenuCard {
	background-image: url("/resources/img/home/randomMenuModal.png");
	background-size: 500px;
	width: 500px;
	height: 500px;
}
#closeBtn {
	float: right;
}
#randomMenuDiv {
	text-align: center;
	margin: 0 auto;
}
#keyword {
	/* height : 50px; */
	width: 30%;
	text-align: center;
	font-size: 1.6em;
	font-weight: bold;
	color: black;
}
</style>

<!-- 랜덤메뉴 모달창 시작  -->
<div id="randomMenu">
	<div class="col-md-6 mb-3" id="randomMenuContent">
		<div class="card" id="randomMenuCard">
			<div class="card-body">
				<!-- 닫기 버튼 -->
				<button type="button" id="closeBtn"
					class="btn btn-danger btn-xs fw-bold" style="font-size: 16px;">X</button>
				<div id="randomMenuDiv">
					<br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br />
					<br /> <br /> <br /> <br /> 
					<!-- 키워드  -->
					<span id="keyword" class="fw-bold"></span><br />
					<br />
					<br />
					<!-- 지도 가기 버튼 -->
					<button type="button" class="btn btn-dark fw-bold"
						style="font-size: 16px;" id="randomMenuMap">지도에서 확인하기</button>
					<br />
					<br />
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 랜덤메뉴 모달창 끝  -->
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=ceae5a5d47234be7c91a37dea96a65b6&libraries=services"></script>
<script>
$(function () {
	var randomMenuArea = $("#randomMenuArea");	// 랜덤메뉴 div
	var randomMenuMap = $("#randomMenuMap");	// 지도에서 확인하기 버튼
	var closeBtn = $("#closeBtn");				// 랜덤메뉴 닫기 버튼

	var foodList = [
			"피자", "파스타", "샌드위치", "버거", "중화요리", "라멘", "타코", "샐러드", "스테이크",
			"씨푸드", "필라프", "라면", "파니니", "스프", "떡볶이", "갈비", "라자냐", "부리또", "떡국",
			"비빔밥", "삼겹살", "만두", "훠궈", "삼계탕", "토스트", "불고기", "카레", "오므라이스", "연어",
			"팟타이", "초밥", "라쯔냐", "족발", "양꼬치", "국밥", "김밥", "소바", "닭갈비", "튀김", "볶음밥",
			"닭볶음탕", "덮밥", "칼국수", "오징어 볶음", "생선구이", "치킨", "해물찜", "로스트비프", "리조또",
			"새우", "소고기", "스키야키", "찌개", "쌀국수", "잔치국수", "아구찜", "마라탕", "마라샹궈",
			"쭈꾸미", "짜장면", "짬뽕", "탕수육", "우동", "오리", "돈가스", "곱창", "낙지"
	];
	
	var keyword = "";
	
	// KaKaoMap API 사용 자원들
	var mapContainer = null;
	var map = null;

	// 랜덤메뉴
	randomMenuArea.on("click", function() {
			$("#randomMenu").css("display", "block");

			var repeatCount = 20;

			function showRandomKeywords(count) {
				if (count <= 0) {
					return;
				}

				var rnd = Math.floor(Math.random() * foodList.length);
				keyword = foodList[rnd];

				$("#keyword").text(keyword);

				setTimeout(function() {
					showRandomKeywords(count - 1);
				}, 100);
			}

			// 초기 호출
			showRandomKeywords(repeatCount);

		});

	// 지도확인
	randomMenuMap.on("click",function() {
		// 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
		var infowindow = new kakao.maps.InfoWindow({
			zIndex : 1
		});

		mapContainer = document.getElementById('randomMenuDiv'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(36.3250154,127.4088838), // 지도의 중심좌표
			level : 3
		};
		mapContainer.style.display = "block";
		// 지도를 생성합니다    
		map = new kakao.maps.Map(mapContainer, mapOption);

		// 장소 검색 객체를 생성합니다
		var ps = new kakao.maps.services.Places();

		// 키워드로 장소를 검색합니다
		ps.keywordSearch('대전 오류동' + keyword,
						placesSearchCB);

		//키워드 검색 완료 시 호출되는 콜백함수 입니다
		function placesSearchCB(data, status, pagination) {
			if (status === kakao.maps.services.Status.OK) {

				// 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
				// LatLngBounds 객체에 좌표를 추가합니다
				var bounds = new kakao.maps.LatLngBounds();

				for (var i = 0; i < data.length; i++) {
					displayMarker(data[i]);
					bounds.extend(new kakao.maps.LatLng(
							data[i].y, data[i].x));
				}

				// 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
				map.setBounds(bounds);
			}
		}

		// 지도에 마커를 표시하는 함수입니다
		function displayMarker(place) {

			// 마커를 생성하고 지도에 표시합니다
			var marker = new kakao.maps.Marker({
				map : map,
				position : new kakao.maps.LatLng(place.y,
						place.x)
			});

			// 마커에 클릭이벤트를 등록합니다
			kakao.maps.event.addListener(marker,'click',function() {
				// 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
				infowindow.setContent('<div style="padding:5px;font-size:12px;">'+ place.place_name+ '</div>');
				infowindow.open(map, marker);
			});
		}

	});

	// 닫기 버튼
	closeBtn.on("click", function() {
		$("#randomMenu").css("display", "none");
		location.reload();
	});
});
// 모달창 스크립트 끝
</script>