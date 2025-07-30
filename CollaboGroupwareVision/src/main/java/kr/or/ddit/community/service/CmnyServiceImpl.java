package kr.or.ddit.community.service;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.community.mapper.CmnyMapper;
import kr.or.ddit.community.vo.Cmny;
import kr.or.ddit.community.vo.CmnyMem;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CmnyServiceImpl implements CmnyService {

	@Inject
	private CmnyMapper cmnyMapper;

	@Override
	public int selectCmnyCount(PaginationInfoVO<Cmny> pagingVO) {
		return cmnyMapper.selectCmnyCount(pagingVO);
	}

	@Override
	public List<Cmny> selectCmnyList(PaginationInfoVO<Cmny> pagingVO) {
		return cmnyMapper.selectCmnyList(pagingVO);
	}

	@Override
	public void comInsert(HttpServletRequest req, Cmny cmny) {
		// 커뮤니티 이미지 등록 시, 커뮤니티 이미지로 파일을 업로드 하는데 이때 업로드 할 서버 경로
		String uploadPath = req.getServletContext().getRealPath("/resources/cmny"); // getRealPath은 권장되지는 않지만 알고쓰면
		File file = new File(uploadPath); // 지정된 업로드 경로에 대한 File 객체를 생성합니다.
		if (!file.exists()) { // 업로드 경로에 해당하는 디렉터리가 존재하지 않으면
			file.mkdirs(); // 디렉터리를 생성합니다.
		}

		String cmnyImgPath = ""; // 커뮤니티 정보에 추가될 이미지 경로
		try {
			// 넘겨받은 이미지 정보에서 파일 데이터 가져오기
			MultipartFile cmnyImgPathFile = cmny.getImgFile(); // MultipartFile
			log.info("cmnyImgPathFile : " + cmnyImgPathFile);

			// 넘겨받은 파일 데이터가 존재할 때
			if (cmnyImgPathFile.getOriginalFilename() != null && !cmnyImgPathFile.getOriginalFilename().equals("")) {
				String fileName = UUID.randomUUID().toString(); // UUID 파일명 생성
				fileName += "_" + cmnyImgPathFile.getOriginalFilename(); // UUID_원본파일명으로 파일명 생성
				uploadPath += "/" + fileName; // /resources/profile/uuid_원본파일명

				cmnyImgPathFile.transferTo(new File(uploadPath)); // 해당 위치에 파일 복사
				cmnyImgPath = "/resources/cmny/" + fileName; // 파일 복사가 일어난 파일의 위치로 접근하기 위한 URI 설정
			} else {
				log.debug("cmnyImgPathFile : " + cmnyImgPathFile);
			}

			cmny.setCmnyImgPath(cmnyImgPath); // 커뮤니티 객체에 이미지 경로를 설정

		} catch (Exception e) {
			e.printStackTrace();
		}
		cmnyMapper.comInsert(cmny);
		int generatedCmnyNo = cmny.getCmnyNo(); // 커뮤니티 생성 후 자동 생성된 cmnyNo
		
		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("시큐리티 확인");
		Employee employee = user.getEmployee();	
		
		// 생성된 커뮤니티 번호를 사용하여 멤버 등록
	    CmnyMem cmnyMem = new CmnyMem();
	    cmnyMem.setCmnyNo(generatedCmnyNo); // 생성된 커뮤니티 번호를 멤버 객체에 설정
	    cmnyMem.setEmpNo(employee.getEmpNo());

	    cmnyMapper.comInsertMem(cmnyMem);		
	}

	@Override
	public Cmny getCommunityDetail(int cmnyNo) {		
		return cmnyMapper.getCommunityDetail(cmnyNo);
	}

	@Override
	public List<Cmny> getMyCommunityList(String empNo) {
		return cmnyMapper.getMyCommunityList(empNo);
	}

	@Override
	public List<CmnyMem> selectCmnyMemList(int cmnyNo) {
		return cmnyMapper.selectCmnyMemList(cmnyNo);
	}

	@Override
	public void comSubmitMem(CmnyMem cmnyMem) {
		cmnyMapper.comSubmitMem(cmnyMem);	
		
	}

	@Override
	public void withdrawMem(CmnyMem cmnyMem) {
		cmnyMapper.withdrawMem(cmnyMem);
		
	}

	@Override
	public int cmnycloseMemCnt(int cmnyNo) {
		return cmnyMapper.cmnycloseMemCnt(cmnyNo);
	}

	@Override
	public void updateCmnyStatus(int cmnyNo) {
		cmnyMapper.updateCmnyStatus(cmnyNo);
		
	}





}
