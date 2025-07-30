package kr.or.ddit.account.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.mapper.AccountMapper;
import kr.or.ddit.account.mapper.LoginMapper;
import kr.or.ddit.account.vo.Auth;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.FormatUtils;

@Service
public class AccountServiceImpl implements AccountService {
	
	@Inject
	private AccountMapper accountMapper;
	
	@Inject
	private LoginMapper loginMapper;
	
	// 스프링 시큐리티를 활용한 비밀번호 암호화를 처리할 PasswordEncoder 의존성 주입
	@Inject
	private PasswordEncoder pe;
	
	@Inject
	private UserDetailsService userDetailService;

	// 파일 업로드를 위해 HttpServletRequest req 매개변수 추가
	@Override
	public ServiceResult register(HttpServletRequest req, Employee employee) {
		ServiceResult result = null;

		// 사원 등록 시, 증명사진 업로드 할 서버 경로
		String uploadPath = req.getServletContext().getRealPath("/resources/upload/profile");

		// 폴더가 없을 시 폴더 생성
		File file = new File(uploadPath);
		if (!file.exists()) {
			file.mkdirs();
		}
		
		String profileImgPath = "";	// 사원정보 DB에 추가될 프로필 이미지 경로
		try {
			// 넘겨받은 사원정보에서 파일 데이터 가져오기
			MultipartFile profileImgFile = employee.getProfileImgFile();
			
			// 넘겨받은 파일 데이터가 존재할 때
			if (profileImgFile.getOriginalFilename() != null && !profileImgFile.getOriginalFilename().equals("")) {
				String fileName = UUID.randomUUID().toString();
				fileName += "_" + profileImgFile.getOriginalFilename(); // UUID_원본파일명
				uploadPath += "/" + fileName; // /resources/profile/uuid_원본파일명
				
				profileImgFile.transferTo(new File(uploadPath));			// 해당 위치에 파일 복사
				profileImgPath = "/resources/upload/profile/" + fileName;	// 파일 복사가 일어난 파일의 위치로 접근하기 위한 URI 설정 
				employee.setProfileImgPath(profileImgPath);	// 프로필 사진 경로 지정
			}
			
			MultipartFile signImgFile = employee.getSignImgFile();
			if(signImgFile.getOriginalFilename() != null && !signImgFile.getOriginalFilename().equals("")) {
				employee.setSignImg(signImgFile.getBytes());
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// 비밀번호 암호화(스프링 시큐리티)
		employee.setEmpPw(pe.encode(employee.getEmpPw()));
		employee.setEmpBirth(StringUtils.replace(employee.getEmpBirth(), "-", ""));
		employee.setJoinDay(StringUtils.replace(employee.getJoinDay(), "-", ""));
		
		int status = accountMapper.register(employee);
		if(status > 0) {
			// 권한 등록(시큐리티), 관리자 여부
			Auth userRole = new Auth();
			userRole.setEmpNo(employee.getEmpNo());
			userRole.setAuth("ROLE_USER");
			accountMapper.insertAuth(userRole);
			
			if(employee.getAdminYn().equals("Y")) {
				Auth adminRole = new Auth();
				adminRole.setEmpNo(employee.getEmpNo());
				adminRole.setAuth("ROLE_ADMIN");
				accountMapper.insertAuth(adminRole);
			}
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public List<Employee> getEmpList() {
		List<Employee> employees = accountMapper.getEmpList();
	    
	    // 전화번호 포맷 변환
	    for (Employee emp : employees) {
	        String rawPhone = emp.getEmpTel();
	        String formattedPhone = FormatUtils.formatPhone(rawPhone);
	        emp.setEmpTel(formattedPhone);
	    }
	    
	    return employees;
	}

	@Override
	public ServiceResult empDisable(List<String> empNoList) {
		ServiceResult result = null;
		
		int status = accountMapper.empDisable(empNoList);
		if(status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public Employee getEmpDetails(String empNo) {
		return loginMapper.readByUserId(empNo);
	}

	@Override
	public ServiceResult update(HttpServletRequest req, Employee employee) {
		ServiceResult result = null;

		// 사원 등록 시, 증명사진 업로드 할 서버 경로
		String uploadPath = req.getServletContext().getRealPath("/resources/upload/profile");

		// 폴더가 없을 시 폴더 생성
		File file = new File(uploadPath);
		if (!file.exists()) {
			file.mkdirs();
		}
		
		String profileImgPath = "";	// 사원정보 DB에 추가될 프로필 이미지 경로
		try {
			// 넘겨받은 사원정보에서 파일 데이터 가져오기
			MultipartFile profileImgFile = employee.getProfileImgFile();
			
			// 넘겨받은 파일 데이터가 존재할 때
			if (profileImgFile.getOriginalFilename() != null && !profileImgFile.getOriginalFilename().equals("")) {
				String fileName = UUID.randomUUID().toString();
				fileName += "_" + profileImgFile.getOriginalFilename(); // UUID_원본파일명
				uploadPath += "/" + fileName; // /resources/profile/uuid_원본파일명
				
				profileImgFile.transferTo(new File(uploadPath));			// 해당 위치에 파일 복사
				profileImgPath = "/resources/upload/profile/" + fileName;	// 파일 복사가 일어난 파일의 위치로 접근하기 위한 URI 설정 
				employee.setProfileImgPath(profileImgPath);	// 프로필 사진 경로 지정
			}
			
			MultipartFile signImgFile = employee.getSignImgFile();
			// 새 서명 이미지를 등록했을 때 set
			if(signImgFile.getOriginalFilename() != null && !signImgFile.getOriginalFilename().equals("")) {
				employee.setSignImg(signImgFile.getBytes());
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// 비밀번호 암호화(스프링 시큐리티)
		employee.setEmpPw(pe.encode(employee.getEmpPw()));
		employee.setEmpBirth(StringUtils.replace(employee.getEmpBirth(), "-", ""));
		employee.setJoinDay(StringUtils.replace(employee.getJoinDay(), "-", ""));
		employee.setLeaveDay(StringUtils.replace(employee.getLeaveDay(), "-", ""));
		
		int status = accountMapper.update(employee);
		if(status > 0) {
			// 권한을 모두 지운다
			accountMapper.deleteAuth(employee.getEmpNo());
			
			// 권한 등록(시큐리티), 관리자 여부
			Auth userRole = new Auth();
			userRole.setEmpNo(employee.getEmpNo());
			userRole.setAuth("ROLE_USER");
			accountMapper.insertAuth(userRole);
			
			if(employee.getAdminYn().equals("Y")) {
				Auth adminRole = new Auth();
				adminRole.setEmpNo(employee.getEmpNo());
				adminRole.setAuth("ROLE_ADMIN");
				accountMapper.insertAuth(adminRole);
			}
			
		    // 현재 Authentication 정보 호출
		    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			CustomUser user = (CustomUser) authentication.getPrincipal();
		    
		    // 현재 Authentication로 사용자 인증 후 새 Authentication 정보를 SecurityContextHolder에 세팅
		    SecurityContextHolder.getContext().setAuthentication(createNewAuthentication(authentication, user.getUsername()));
			
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}
	
	// 새로운 인증 객체 생성
	private Authentication createNewAuthentication(Authentication currentAuth, String username) {
	    UserDetails newPrincipal = userDetailService.loadUserByUsername(username);
	    UsernamePasswordAuthenticationToken newAuth = new UsernamePasswordAuthenticationToken(newPrincipal, currentAuth.getCredentials(), newPrincipal.getAuthorities());
	    newAuth.setDetails(currentAuth.getDetails());
	    return newAuth;
	}

	@Override
	public Employee getMyProfile(String myEmpNo) {
		return accountMapper.getMyProfile(myEmpNo);
	}
	
}
