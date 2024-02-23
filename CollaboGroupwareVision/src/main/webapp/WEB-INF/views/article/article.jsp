<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<div class="content__header content__boxed overlapping">
	<div class="content__wrap">
		<div class="d-md-flex">
			<div class="me-auto">
				<!-- Breadcrumb -->
				<nav aria-label="breadcrumb">
					<ol class="breadcrumb mb-0">
						<li class="breadcrumb-item"><a href="/">Home</a></li>
						<li class="breadcrumb-item"><a href="/artic">실시간뉴스</a></li>
					</ol>
				</nav>
				<!-- END : Breadcrumb -->
				<h1 class="page-title mb-0 mt-2">최신뉴스</h1>
				<p class="lead"></p>
			</div>
		</div>
	</div>
</div>
v
<div class="content__boxed">
	<div class="content__wrap" >
		<div class="card">
			<div class="card-body" sswWrap>
			<div class="col-md-6 mb-3" ssw style="display: none; margin: 10px auto;">
				<div class="card border-1 border-success parent">
					<div class="card-header toolbar">
						<div class="toolbar-start">
							<h5 class="m-0">
								<a href="#" class="link-dark" id="articleTitle" target="_blank" 
								onmouseover="this.style.color='red'" onmouseout="this.style.color='black';"></a>
							</h5>
						</div>
						<div class="toolbar-end">
							<button type="button"
								class="btn btn-icon btn-light btn-xs collapsed"
								data-bs-toggle="collapse" data-bs-target=""
								aria-expanded="false" aria-controls="_dm-expandedByDefault">
								<i class="demo-psi-min"></i>
							</button>
						</div>
					</div>
					<div id="" class="collapse" style="">
						<div class="card-body">
							<p id="articleRegDate">등록일:</p>
							<p id="articleContent"></p>
						</div>
					</div>
				</div>
			</div>
		</div>
		</div>
	</div>
</div>
<script>
// 뉴스
var newsCard = document.querySelector("[ssw]");
var newsWrap = document.querySelector("[sswWrap]");

f_newArticle();	// 기사 호출
function f_newArticle() {
	$.ajax({
        url: "/artic/newArticle",
        type: "get",
        dataType: "json",
        success: function (rslt) {
            console.log("결과:", rslt);
            var newsArr = rslt.items;

            for (var i = 0; i < newsArr.length; i += 2) {
                var newRowDiv = document.createElement("div");
                newRowDiv.className = "row";

                for (var j = i; j < i + 2 && j < newsArr.length; j++) {
                    var newNewsCard = newsCard.cloneNode(true);
                    newNewsCard.style.display = "block";
                    newNewsCard.querySelector("#articleTitle").innerHTML = newsArr[j].title;
                    newNewsCard.querySelector("#articleTitle").setAttribute("href", newsArr[j].link);
                    newNewsCard.querySelector("#articleRegDate").innerHTML += newsArr[j].pubDate;
                    newNewsCard.querySelector("#articleContent").innerHTML = newsArr[j].description;
                    newNewsCard.querySelector("button").dataset.bsTarget = "#_articleNo" + (j + 1);
                    newNewsCard.querySelector(".collapse").id = "_articleNo" + (j + 1);

                    newRowDiv.appendChild(newNewsCard);
                }

                newsWrap.appendChild(newRowDiv);
            }
        }
    });
}
</script>