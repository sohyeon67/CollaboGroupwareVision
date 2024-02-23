<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Access error | CollaboGroupwareVision</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&family=Ubuntu:wght@400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/nifty.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/demo-purpose/demo-icons.min.css">
</head>
<body>
    <div id="root" class="root front-container">
        <section id="content" class="content">
            <div class="content__boxed card rounded-0 w-100 min-vh-100 d-flex flex-column align-items-stretch justify-content-center">
                <div class="content__wrap">

                    <div class="text-center">
                        <div class="mb-4">
                            <i class="demo-psi-exclamation error-code text-red"></i>
                        </div>
                        <h3 class="mb-5">
                            <div class="badge bg-dark px-3 fs-3">Access Error... !</div>
                        </h3>
                        <p class="lead fs-4">죄송합니다. 해당 페이지에 접근할 권한이 없습니다.<br>문제가 반복될 시 관리자에게 연락해주세요.</p>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-4">
                        <button type="button" onclick="window.history.back()" class="btn btn-light btn-lg">뒤로가기</button>
                        <a href="/index" class="btn btn-primary btn-lg">홈으로</a>
                    </div>
                </div>
            </div>
        </section>
    </div>
</body>
</html>