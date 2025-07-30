<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- csrf meta 정보를 등록 -->
<meta id="_csrf" name="_csrf" content="${_csrf.token }"/>
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName }"/>
<title>${title }</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&family=Ubuntu:wght@400;500;700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/nifty.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/demo-purpose/demo-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/demo-purpose/demo-settings.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath }/resources/assets/vendors/popperjs/popper.min.js" defer></script>
<script src="${pageContext.request.contextPath }/resources/assets/vendors/bootstrap/bootstrap.min.js" defer></script>
<script src="${pageContext.request.contextPath }/resources/assets/js/nifty.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>

<script type="text/javascript">
var token = "";
var header = "";
$(function() {
	token = $("meta[name='_csrf']").attr("content");
	header = $("meta[name='_csrf_header']").attr("content");
});
</script>
<style>
body, .form-control, .form-select {
	font-size : 0.9rem;
	font-family: 'NanumBarunGothic';
}
</style>
</head>
<c:if test="${not empty message }">
<script type="text/javascript">
alert("${message}");
<c:remove var="message" scope="request"/>
<c:remove var="message" scope="session"/>
</script>
</c:if>
<body>
	<!-- content 영역 -->
	<div id="root" class="root front-container hd--expanded">
		<section id="content" class="content">
			<tiles:insertAttribute name="content"/>
		</section>
	</div>

</body>
</html>