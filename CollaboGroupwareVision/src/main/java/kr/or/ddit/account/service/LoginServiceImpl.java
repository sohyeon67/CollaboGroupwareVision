package kr.or.ddit.account.service;

import java.util.Properties;

import javax.inject.Inject;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.mapper.LoginMapper;
import kr.or.ddit.account.vo.Employee;

@Service
public class LoginServiceImpl implements LoginService {

	@Inject
	private BCryptPasswordEncoder bpe;

	@Inject
	private LoginMapper loginMapper;

	@Override
	public ServiceResult findPassword(Employee employee) {

		// 사번과 이메일이 DB에 존재하는지 확인
		int status = loginMapper.findByEmpNoAndPsnEmail(employee);
		System.out.println("디비에 있음? " + status);
		if (status > 0) {
			// 임시 비밀번호 생성
			String temporaryPassword = generateTemporaryPassword();

			// 비밀번호 업데이트
			String empNo = employee.getEmpNo();
			loginMapper.updatePassword(empNo, bpe.encode(temporaryPassword));

			// 이메일로 임시 비밀번호 발송
			String email = employee.getEmpPsnEmail();
			sendTemporaryPassword(email, temporaryPassword);

			return ServiceResult.OK;
		}

		return ServiceResult.FAILED;

	}

	// 임시 비밀번호를 무작위로 생성하는 함수
	private String generateTemporaryPassword() {
		String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_";
		int passwordLength = 8; // 임시 비밀번호의 길이

		StringBuilder newPassword = new StringBuilder();

		for (int i = 0; i < passwordLength; i++) {
			int index = (int) (Math.random() * characters.length());
			newPassword.append(characters.charAt(index));
		}

		return newPassword.toString();
	}

	// 임시 비밀번호 발송하는 함수
	private void sendTemporaryPassword(String userEmail, String temporaryPassword) {

		String senderEmail = "thgusznzn@naver.com";
		String senderPw = "GCVYRZZ9711V";

		// SMTP 서버 및 인증 정보 설정
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.naver.com");
		props.put("mail.smtp.port", "587"); // TLS:587, SSL:465
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.debug", "true");

		// 세션 객체 생성
		Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(senderEmail, senderPw);
			}
		});

		try {
			// 메일 내용 설정
			MimeMessage message = new MimeMessage(mailSession);
			// 발송자 이메일, 이름
			message.setFrom(new InternetAddress(senderEmail, "CollaboGroupwareVision"));

			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
			message.setSubject("임시 비밀번호를 알려드립니다.");

			String htmlContent = "<h2 style='color: #4CAF50;'>임시 비밀번호 안내</h2>"
					+ "<p style='font-size: 16px;'>안녕하세요, 임시 비밀번호는 <strong style='color: #4CAF50;'>" + temporaryPassword
					+ "</strong>입니다.</p>" + "<p style='font-size: 14px; color: #777;'>로그인 후 비밀번호를 변경해주세요.</p>";

			message.setContent(htmlContent, "text/html;charset=UTF-8");
			message.setSentDate(new java.util.Date());

			// 메일 전송
			Transport.send(message);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
