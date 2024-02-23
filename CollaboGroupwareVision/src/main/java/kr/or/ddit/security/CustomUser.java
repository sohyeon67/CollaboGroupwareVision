package kr.or.ddit.security;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import kr.or.ddit.account.vo.Employee;

public class CustomUser extends User {

	private Employee employee;
		
	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}
	
	public CustomUser(Employee employee) {
		// Java 스트림을 사용한 경우(람다표현식)
		// - 자바 버전 8부터 추가된 기능
		// map : 컬렉션(List, Map, Set 등), 배열 등의 설정되어 있는 각 타입의 값들을 하나씩 참조하여 람다식으로 반복 처리할 수 있게 해줍니다.
		// collect : Stream()을 돌려 발생되는 데이터를 가공 처리하고 원하는 형태의 자료형으로 변환을 돕는다.
		// 회원정보 안에 들어있는 역할명들을 컬렉션 형태의 스트림으로 만들어서 보내준다.
		// ** 람다표현식은 복잡한 메서드 라인을 간단한 표현식으로 출력할 수 있다는 장점이 있는 대신 디버깅을 할 수 없다는 점이 단점이다.
		super(employee.getEmpNo(), employee.getEmpPw(),
				employee.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuth())).
				collect(Collectors.toList()));
		this.employee = employee;
	}

	public Employee getEmployee() {
		return employee;
	}

	public void setEmployee(Employee employee) {
		this.employee = employee;
	}
	
	
}
