package kr.or.ddit.reservation.service;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.reservation.mapper.VhclMapper;
import kr.or.ddit.reservation.vo.Vhcl;
import kr.or.ddit.reservation.vo.VhclRsvt;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class VhclServiceImpl implements VhclService {
	
	@Inject
	private VhclMapper vhclMapper;

	@Override
	public List<Vhcl> selectVhclList() {
		return vhclMapper.selectVhclList();
	}

	@Override
	public List<VhclRsvt> selectVhclRsvtListByDay(String vhclDate) {
		List<VhclRsvt> vhclRsvtList = vhclMapper.selectVhclRsvtListByDay(vhclDate);
		
		LocalDateTime now = LocalDateTime.now(); 
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		for (VhclRsvt vhclRsvt : vhclRsvtList) {
		    // 예약 종료 날짜를 String에서 LocalDate로 변환
			LocalDateTime endRsvtDate = LocalDateTime.parse(vhclRsvt.getEndRsvtDate(), formatter);
		   log.info("endRsvtDate:"+endRsvtDate);
		   // 현재시간이 예약종료시간보다 이후인경우 차량 예약 상태를 '02'로 바꿈
		   if (now.isAfter(endRsvtDate)) {
			   vhclMapper.updateRsvtStatus(vhclRsvt.getVRsvtNo());
			   log.info("endRsvtDate:"+endRsvtDate);
		   }
		}
		return vhclMapper.selectVhclRsvtListByDay(vhclDate);
	}


	@Override
	public int insertVhclRsvt(Map<String, Object> paramMap) {
		String vhclNo = (String) paramMap.get("vhclNo");	// 차량 번호
		String vhclDate = (String) paramMap.get("vhclDate");	// 선택한 날짜
		int startTime = (int) paramMap.get("startTime");	// 시작시간
		int endTime = (int) paramMap.get("endTime");		// 종료시간
		//String title = (String) paramMap.get("title");		// 예약제목
		String ppus = (String) paramMap.get("ppus");		// 사용목적
		String empNo = (String) paramMap.get("empNo");		// 사원번호
		
		VhclRsvt vhclRsvt = new VhclRsvt();
	
		vhclRsvt.setVhclNo(vhclNo);
		String startDate = vhclDate + " " + startTime;
		String endDate = vhclDate + " " + endTime;
		vhclRsvt.setStrtRsvtDate(startDate);
		vhclRsvt.setEndRsvtDate(endDate);
		//vhclRsvt.setMRsvtTitle(title);
		vhclRsvt.setPpus(ppus);
		vhclRsvt.setEmpNo(empNo);
		
		return vhclMapper.insertVhclRsvt(vhclRsvt);
	}

	@Override
	public List<VhclRsvt> checkReserve(VhclRsvt vhclRsvt) {
		return vhclMapper.checkReserve(vhclRsvt);
	}

	@Override
	public List<VhclRsvt> selectVhclRsvtList() {
		return vhclMapper.selectVhclRsvtList();
	}

	@Override
	public VhclRsvt selectDetailVhclRsvt(int vRsvtNo) {
		return vhclMapper.selectDetailVhclRsvt(vRsvtNo); 
	}

	@Override
	public void vhclCancel(int vRsvtNo) {
		vhclMapper.vhclCancel(vRsvtNo);
		
	}

	//파일업로드 과정 추가하기
	@Override
	public void adminVhclInsert(HttpServletRequest req, Vhcl vhcl) {
		//mapper에서는 없던 HttpServletRequest req이 serviceImpl에서 추가됨
		//주로 파일 업로드와 관련
		//파일 업로드를 하기 위해서는 클라이언트에서 전송된 요청(request)에 대한 정보가 필요합니다. 
		//이때 HttpServletRequest를 사용하여 클라이언트의 요청 정보에 접근할 수 있습니다.
		//클라이언트가 업로드한 파일의 정보나 요청에 대한 다양한 속성들을 HttpServletRequest를 통해 얻어와서 
		//파일 업로드와 관련된 작업을 수행하는 것입니다.
		
		//차량등록 시, 차량 이미지로 파일을 업로드 하는데 이때 업로드 할 서버 경로
		String uploadPath = req.getServletContext().getRealPath("/resources/vhcl");
		File file = new File(uploadPath); //지정된 업로드 경로에 대한 File 객체를 생성합니다.
		if(!file.exists()) { //업로드 경로에 해당하는 디렉터리가 존재하지 않으면 
			file.mkdirs();   //디렉터리를 생성합니다.
		}
		
		String vhclImgPath = ""; //차량정보에 추가될 차량 이미지 경로
		try {
			//넘겨받은 차량 정보에서 파일 데이터 가져오기
			MultipartFile vhclImgPathFile = vhcl.getImgFile(); //MultipartFile
			log.info("vhclImgPathFile : " + vhclImgPathFile);
			
			//넘겨받은 파일 데이터가 존재할 때 
			if(vhclImgPathFile.getOriginalFilename() != null && !vhclImgPathFile.getOriginalFilename().equals("")) {
				String fileName = UUID.randomUUID().toString(); // UUID 파일명 생성
				fileName += "_" + vhclImgPathFile.getOriginalFilename(); // UUID_원본파일명으로 파일명 생성
				uploadPath += "/" + fileName;	// /resources/profile/uuid_원본파일명
				
				vhclImgPathFile.transferTo(new File(uploadPath)); // 해당 위치에 파일 복사
				vhclImgPath = "/resources/vhcl/" + fileName;		// 파일 복사가 일어난 파일의 위치로 접근하기 위한 URI 설정
			}else {
				log.debug("vhclImgPathFile : " + vhclImgPathFile);
			}
			
			vhcl.setVhclImgPath(vhclImgPath); //차량 객체에 차량 이미지 경로를 설정
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		vhclMapper.adminVhclInsert(vhcl); 
		
	}

	@Override   // 새 파일이 포함되어 있을 때
	public void adminVhclUpdate(HttpServletRequest req, Vhcl vhcl) {
		
		//차량등록 시, 차량 이미지로 파일을 업로드 하는데 이때 업로드 할 서버 경로
		String uploadPath = req.getServletContext().getRealPath("/resources/vhcl");  // getRealPath은 권장되지는 않지만 알고쓰면
		File file = new File(uploadPath); //지정된 업로드 경로에 대한 File 객체를 생성합니다.
		if(!file.exists()) { //업로드 경로에 해당하는 디렉터리가 존재하지 않으면 
			file.mkdirs();   //디렉터리를 생성합니다.
		}
		
		String vhclImgPath = ""; //차량정보에 추가될 차량 이미지 경로
		try {
			//넘겨받은 차량 정보에서 파일 데이터 가져오기
			MultipartFile vhclImgPathFile = vhcl.getImgFile(); //MultipartFile
			log.info("vhclImgPathFile : " + vhclImgPathFile);
			
			//넘겨받은 파일 데이터가 존재할 때 
			if(vhclImgPathFile.getOriginalFilename() != null && !vhclImgPathFile.getOriginalFilename().equals("")) {
				String fileName = UUID.randomUUID().toString(); // UUID 파일명 생성
				fileName += "_" + vhclImgPathFile.getOriginalFilename(); // UUID_원본파일명으로 파일명 생성
				uploadPath += "/" + fileName;	// /resources/profile/uuid_원본파일명
				
				vhclImgPathFile.transferTo(new File(uploadPath)); // 해당 위치에 파일 복사
				vhclImgPath = "/resources/vhcl/" + fileName;		// 파일 복사가 일어난 파일의 위치로 접근하기 위한 URI 설정
			}else {
				log.debug("vhclImgPathFile : " + vhclImgPathFile);
			}
			
			vhcl.setVhclImgPath(vhclImgPath); //차량 객체에 차량 이미지 경로를 설정
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		vhclMapper.adminVhclUpdate(vhcl); 
	}

	@Override    // 파일 수정이 없을 땡
	public void adminVhclUpdate2(HttpServletRequest req, Vhcl vhcl) {			
		vhclMapper.adminVhclUpdate(vhcl); 
	}

	
	@Override
	public int adminVhclDelete(String vhclNo) {
		return vhclMapper.adminVhclDelete(vhclNo); 
	}


}
