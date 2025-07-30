package kr.or.ddit.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

public class CustomAccessDeniedHandler implements AccessDeniedHandler {

	private static final Logger log = LoggerFactory.getLogger(CustomAccessDeniedHandler.class);

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		log.debug("why? " + accessDeniedException.getMessage()); // 에러 이유

		String uri = request.getRequestURI();

		if (uri.startsWith(request.getContextPath() + "/project")) {
			// 프로젝트 관련 페이지 권한 없으면 여기로
			request.getSession().setAttribute("accessError", "해당 프로젝트 멤버만 접근할 수 있습니다!");

			// 프로젝트 홈으로 리다이렉트
			response.sendRedirect(request.getContextPath() + "/project");
		} else {
			// CommonController에서 만들어둔 컨트롤러 메소드를 실행한다.
			response.sendRedirect("/accessError");
		}
	}

}
