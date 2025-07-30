<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>데이터</title> 
</head>
<body>
	<div>
		<div id="date"></div>
		<button onclick="startDate()">시작</button>
		<button onclick="stopDate()">정지</button>
	</div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
var date; 
$(document).ready(function () { 
	startDate();   
}); 
function startDate() { 
	date = setInterval(function () { 
		var dateString = "Today's date is: "; 
		var newDate = new Date(); 
		dateString += newDate.getFullYear() + "/"; 
		dateString += ("0" + (newDate.getMonth() + 1)).slice(-2) + "/"; //월은 0부터 시작하므로 +1을 해줘야 한다.             dateString += ("0" + newDate.getDate()).slice(-2) + " ";             dateString += ("0" + newDate.getHours()).slice(-2) + ":";             dateString += ("0" + newDate.getMinutes()).slice(-2) + ":";             dateString += ("0" + newDate.getSeconds()).slice(-2);            //document.write(dateString); 문서에 바로 그릴 수 있다. 
		dateString += ("0" + newDate.getDate()).slice(-2) + " ";
		dateString += ("0" + newDate.getHours()).slice(-2) + ":";
		dateString += ("0" + newDate.getMinutes()).slice(-2) + ":";
		dateString += ("0" + newDate.getSeconds()).slice(-2);
		 //document.write(dateString); 문서에 바로 그릴 수 있다.
		$("#date").text(dateString); 
	}, 1000); 
}
function stopDate() { 
	clearInterval(date); 
}
</script>
</html>

