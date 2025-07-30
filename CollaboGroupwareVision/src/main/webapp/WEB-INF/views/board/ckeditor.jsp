<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
  <head>
  <meta charset="utf-8">
    <title>CKEditor</title>
  </head>
  <body>
    <h1>CKEditor</h1>
    <form action="" method="POST">
      <textarea name="text" id="editor"></textarea>
    <p><input type="submit" value="전송"></p>
    </form>
    <script src="https://cdn.ckeditor.com/ckeditor5/40.2.0/classic/ckeditor.js"></script>
    <script>
      ClassicEditor.create( document.querySelector( '#editor' ) );
    </script>
  </body>
</html>