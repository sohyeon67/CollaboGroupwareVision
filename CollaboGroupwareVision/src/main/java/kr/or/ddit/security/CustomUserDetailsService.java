package kr.or.ddit.security;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import kr.or.ddit.account.mapper.LoginMapper;
import kr.or.ddit.account.vo.Employee;

public class CustomUserDetailsService implements UserDetailsService {

	private static final Logger log = LoggerFactory.getLogger(CustomUserDetailsService.class);
	
	@Inject
	private LoginMapper loginMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
	    log.info("loadUserByUsername called for: {}", username);

	    // UserDetailsService를 등록하는 과정에서 우리가 할 목표는 User 객체의 정보와
	    // 인증되어 실제로 사용될 내 id에 해당하는 회원정보를 Employee에 담고 그 녀석을 UserDetails정보 안에서
	    // 가용할 수 있도록 만든다.
	    Employee employee = loginMapper.readByUserId(username);
	    if (employee == null) {
	        throw new UsernameNotFoundException("User '" + username + "' not found");
	    }
	    return new CustomUser(employee);
	}

}
