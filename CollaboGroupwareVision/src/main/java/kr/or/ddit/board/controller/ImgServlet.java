package kr.or.ddit.board.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/generateDynamicFolderName")
public class ImgServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dynamicFolderName = generateDynamicFolderName(); // 폴더명을 동적으로 생성하는 함수
        request.setAttribute("dynamicFolderName", dynamicFolderName); // JSP로 전달
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/free/list.jsp");
        dispatcher.forward(request, response);
    }

	private String generateDynamicFolderName() {
		// TODO Auto-generated method stub
		return null;
	}

}
