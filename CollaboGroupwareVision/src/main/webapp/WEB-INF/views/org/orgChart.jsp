<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 조직도 부분 -->
<div id="divtree" class="col-md-4 border-2 d-flex flex-column justify-content-center px-5 rounded" style="min-width:500px; max-width:500px;">
	<h3 class="my-3 fw-bold">조직도</h3>
	<input type="text" id="searchInput" class="form-control mb-2 w-50" placeholder="검색" style="margin-left: auto;">
    <div id="jstree" class="border border-2 p-3 mainnav__top-content scrollable-content" style="max-height: 500px;"></div>
</div>
<!-- 조직도 부분 끝 -->

<script>
var jsTreeObj;	// 전역변수

$(function() {
	jsTreeObj = $("#jstree");
	var searchInput = $("#searchInput");
	
	// jstree 불러오기
	treelist();
	
	// 검색어 입력란에 입력이 있을 때마다 트리를 검색하도록 이벤트 리스너 등록
    searchInput.on("input", function() {
        var searchWord = $(this).val();
        // 검색어로 트리를 검색하는 함수 호출
        searchTree(searchWord);
    });
});

function searchTree(searchWord) {
	// jstree에서 제공하는 검색 함수
	jsTreeObj.jstree(true).search(searchWord);
}

//트리 리스트 출력
function treelist() {
	//트리 데이터 가져오기
	$.ajax({
		type : 'get',
		url : '/org/getOrgTree',
		dataType : 'json',
		success : function(data) {
			var treeData = data.map(function(node) {
				return { 
					'id': node.ID, 
					'parent': node.PARENT, 
					'text': node.TEXT, 
					'type': node.TYPE 
				}
			})
			
			jsTreeObj.jstree({
				'core' : {
					'data' : treeData
				},
				'state' : {
					'opened' : false
				},
				'types' : {
					'employee' : {
						'icon' : '${pageContext.request.contextPath }/resources/assets/vendors/ionicons/svg/person.svg',
					},
					'dept' : {
						'icon' : '${pageContext.request.contextPath }/resources/assets/vendors/ionicons/svg/home.svg',
					}
				},
				'plugins' : [ 'types', 'search' ]
			});
		}, // success 끝
		error : function(xhr, status, error) {
			console.log('AJAX 오류:', status, error);
		}
	}); //ajax 끝
} //treelist 끝
</script>