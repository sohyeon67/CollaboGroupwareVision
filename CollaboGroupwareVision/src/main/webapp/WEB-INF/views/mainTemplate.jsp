<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta name="generator" content="${generator }" />
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
	<meta id="_csrf" name="_csrf" content="${_csrf.token }"/>
	<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName }"/>
    <meta name="description" content="${description }">
    <title>${title }</title>
	
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&family=Ubuntu:wght@400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/nifty.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/demo-purpose/demo-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/demo-purpose/demo-settings.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/vendors/fullcalendar/fullcalendar.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/vendors/dropzone/dropzone.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/vendors/tabulator/tabulator.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/vendors/themify-icons/themify-icons.min.css">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath }/resources/assets/vendors/popperjs/popper.min.js" defer></script>
	<script src="${pageContext.request.contextPath }/resources/assets/vendors/bootstrap/bootstrap.min.js" defer></script>
	<script src="${pageContext.request.contextPath }/resources/assets/js/nifty.js" defer></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
	<script src="${pageContext.request.contextPath }/resources/ckeditor/ckeditor.js"></script>
	
	<script type="text/javascript">
		var token = "";
		var header = "";
		$(function() {
			token = $("meta[name='_csrf']").attr("content");
			header = $("meta[name='_csrf_header']").attr("content");
		});
		
		// 팝업창에서 navigator와 header 부분을 없애준다
		function check(){
			if(window.name == "drive-popup" || window.name == "chat-popup" || window.name == "email-popup" || window.name == "draft-popup"){
				console.log(window.name);	
				
				$("#mainnav-container").css("display","none");
			    $("#IdHeader").css("display","none");
			}
		}
	</script>
	<style>
	body, .form-control, .form-select {
		font-size : 0.9rem;
		font-family: 'NanumBarunGothic';
	}
	</style>
</head>
<%-- 
	<c:if test="${not empty message }">
	<script type="text/javascript">
	alert("${message}");
	<c:remove var="message" scope="request"/>
	<c:remove var="message" scope="session"/>
	</script>
	</c:if> 
--%>
<body class="jumping">
	<div id="root" class="root mn--max hd--expanded">
		<section id="content" class="content">
			<!-- content 영역 -->
			<tiles:insertAttribute name="content"/>
			
			<!-- footer 영역 -->
			<tiles:insertAttribute name="footer"/>
			
		</section>
		
		<!-- header 영역 -->
		<tiles:insertAttribute name="header"/>
		
		<!-- 좌측메뉴 -->
		<c:choose>
			<c:when test="${not empty adminMenu }">
				<tiles:insertAttribute name="adminNavigator"/>
			</c:when>
			<c:otherwise>
				<tiles:insertAttribute name="mainNavigator"/>
			</c:otherwise>
		</c:choose>
	</div>
		
	<!-- 설정 -->
	<tiles:insertAttribute name="setting"/>

</body>
</html>