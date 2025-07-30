package kr.or.ddit.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	private static final Logger log = LoggerFactory.getLogger(CustomLoginSuccessHandler.class);
	private RequestCache requestCache = new HttpSessionRequestCache();
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		//log.info("onAuthenticationSuccess() 실행...!");
		User user = (User) authentication.getPrincipal();
		//log.info("username : " + user.getUsername());
		//log.info("password : " + user.getPassword());
		
		clearAuthenticationAttribute(request);
		
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		String targetUrl = "";
		if(savedRequest != null) {
			targetUrl = savedRequest.getRedirectUrl();
		} else {
			targetUrl = "/index";
		}
		
		//log.info("Login Success targetUrl : " + targetUrl);
		response.sendRedirect(targetUrl);
	}

	private void clearAuthenticationAttribute(HttpServletRequest request) {
		// false : session 정보가 존재한다면 현재 session을 반환하고 그렇지 않으면 null을 반환한다.
		HttpSession session = request.getSession(false);
		if(session == null) {
			return;
		}
		
		// SPRING_SECURITY_LAST_EXCEPTION 값을 세션에서 지움
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
		
	}

	
}
