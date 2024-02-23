<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Error 500 | CollaboGroupwareVision</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&family=Ubuntu:wght@400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/nifty.min.css">
</head>
<body>
    <div id="root" class="root front-container">
        <section id="content" class="content">
            <div class="content__boxed card rounded-0 w-100 min-vh-100 d-flex flex-column align-items-stretch justify-content-center">
                <div class="content__wrap">

                    <div class="text-center">
                        <div class="error-code page-title mb-3">500</div>
                        <h3 class="mb-4">
                            <div class="badge bg-danger px-3 fs-3">Internal Server Error !</div>
                        </h3>
                        <p class="lead fs-4">죄송합니다. 현재 서버오류가 발생하여 요청을 처리하지 못하고 있습니다.</p>
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