package kr.or.ddit.drive.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.View;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.mapper.LoginMapper;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.drive.service.DriveService;
import kr.or.ddit.drive.vo.Drive;
import kr.or.ddit.drive.vo.DriveFolder;
import kr.or.ddit.org.service.OrgService;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/drive")
public class DriveController {
	
	@Inject
	public DriveService driveService;
	
	@Inject
	public LoginMapper loginMapper;
	
	@Inject
	public OrgService orgService;

	// 드라이브 메인 페이지
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/fileManager")
	public String driveFileManager(Model model, String driveStatus) {
		log.info("driveFileManager() 실행..!");
		model.addAttribute("title","Drive");
		model.addAttribute("activeMain","drive");

		// 드라이브 처음 들어왔을 때는 개인문서함으로 들어옴
		if(driveStatus == null) {
			driveStatus = "01";
		}
		model.addAttribute("activeDriveStatus",driveStatus);
		
		// 드라이브 상태에 해당하고 부모폴더가 없는 폴더와 파일폴더번호가 없는 파일 불러오기
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if(employee != null ) {
			List<DriveFolder> driveFolderList = new ArrayList<DriveFolder>();
			List<Drive> driveList = new ArrayList<Drive>();
			
			Integer group = null;
			
			if(driveStatus.equals("03")||driveStatus.equals("04")) {	// 부서문서함일 경우 group에 dept_code를 넣어주기
				Employee myInfo = loginMapper.readByUserId(employee.getEmpNo());
				group = myInfo.getDeptCode();
			}
			
			driveFolderList = driveService.selectDriveFolderList(driveStatus,employee.getEmpNo(), group);
			driveList = driveService.selectDriveList(driveStatus,employee.getEmpNo(), group);
			
			model.addAttribute("driveFolderList",driveFolderList);
			model.addAttribute("driveList",driveList);
		}
		return "drive/fileManager";
	}
	
	// 드라이브 폴더 선택했을 때
	@GetMapping("/driveParent")
	public String selectDriveFolder(Model model, Integer driveFolderNo, String driveStatus) {
		log.info("selectDriveFolder() 실행..!");
		model.addAttribute("activeMain","drive");
		
		// 드라이브 폴더 선택했을 때
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if(employee != null ) {
			List<DriveFolder> driveFolderList = new ArrayList<DriveFolder>();
			List<Drive> driveList = new ArrayList<Drive>();
			
			Integer group = null;
			
			if(driveStatus.equals("03")||driveStatus.equals("04")) {	// 부서문서함일 경우 group에 dept_code를 넣어주기
				Employee myInfo = loginMapper.readByUserId(employee.getEmpNo());
				group = myInfo.getDeptCode();
			}
			
			driveFolderList = driveService.selectDriveFolderChildList(driveFolderNo, driveStatus,employee.getEmpNo(), group);
			driveList = driveService.selectDriveChildList(driveFolderNo, driveStatus,employee.getEmpNo(), group);
			
			model.addAttribute("driveFolderList",driveFolderList);
			model.addAttribute("driveList",driveList);
		}
		model.addAttribute("activeDriveStatus",driveStatus);
		model.addAttribute("driveFolderParent",driveFolderNo);	// 부모폴더 번호

		return "drive/fileManager";
	}
	
	// 드라이브 상위 폴더 선택했을 때
	@GetMapping("/goParentFolder")
	public String goParentFolder(Model model, Integer driveFolderNo, String driveStatus) {
		log.info("goParentFolder() 실행..!");
		model.addAttribute("activeDriveStatus",driveStatus);
		model.addAttribute("driveFolderParent",driveFolderNo);
		
		String goPage = "";
		
		// 넘겨받은 폴더번호를 통하여 해당 폴더번호의 상위 폴더번호 가져오기
		Integer driveFolderParent = driveService.selectDriveFolderParent(driveFolderNo);
		
		if(driveFolderParent == null) {	// 만약 상위 폴더 번호가 null일 경우 드라이브 메인 페이지로 이동
			goPage = "redirect:/drive/fileManager?driveStatus="+driveStatus;
		}else {	// 그 외에는 드라이브 폴더 선택 페이지로 이동
			goPage = "redirect:/drive/driveParent?driveFolderNo="+driveFolderParent+"&driveStatus="+driveStatus;
		}
		
		return goPage;
	}
	
	// 드라이브 폴더 생성, 부서문서함인 경우 부서에 있는 사원들 불러내어 같이 생성
	@PostMapping("/insertFolder")
	public ResponseEntity<ServiceResult> insertFolder(Model model, HttpSession session, String driveStatus, Integer driveFolderParent){
		log.info("insertFolder() 실행..!");
		
		ServiceResult result = null;
		DriveFolder driveFolder = new DriveFolder();
		
		String empNo = (String) session.getAttribute("loginEmpNo");
		if(empNo != null) {
			Integer deptCode = null;
			driveFolder.setDriveFolderName("새폴더");
			driveFolder.setDriveFolderParent(driveFolderParent);
			driveFolder.setDriveStatus(driveStatus);
			driveFolder.setEmpNo(empNo);
			if(driveStatus.equals("03")) {
				Employee myInfo = loginMapper.readByUserId(empNo);
				deptCode = myInfo.getDeptCode();
			}
			driveFolder.setDeptCode(deptCode);
			result = driveService.insertFolder(driveFolder);
		}
		
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
	
	// 드라이브 폴더/파일 이름 수정
	@PostMapping("/updateDriveName")
	public String updateDriveName(
			  Model model				// 모델
			, HttpSession session		// 세션
			, String driveStatus		// 드라이브 상태
			, Integer driveFolderParent // 부모 폴더 번호
			, String driveFolderName	// 폴더 이름
			, String driveFileName		// 파일 이름
			, Integer driveFolderNo		// 폴더 번호
			, Integer driveFileNo		// 파일 번호
			) {
		log.info("updateDriveName() 실행..!");
		
		String goPage = "";
		
		if(driveFolderNo != null && driveFolderNo > 0) {	// 폴더 번호가 넘어오면 폴더 업데이트
			driveService.updateFolderName(driveFolderName, driveFolderNo);
		}else if(driveFileNo != null && driveFileNo > 0) {	// 파일 번호가 넘어오면 파일 업데이트
			List<Drive> driveFileList = new ArrayList<Drive>();
			driveFileList = driveService.selectDriveAllList();
			for(Drive driveFile : driveFileList) {
				if(driveFileNo == driveFile.getDriveFileNo()) {	// 드라이브 리스트 중 파일번호가 일치하는 드라이브 찾기
					
					// 타입 붙여주기
					int idx = driveFile.getDriveFileName().lastIndexOf(".");
					String type = null;
					if(idx > 0) {
						type = driveFile.getDriveFileName().substring(idx);
					}
					driveFileName = driveFileName + type;
					driveService.updateFileName(driveFileName, driveFileNo);
				}
			}
		}
		
		// 페이지 설정
		if(driveFolderParent == null || driveFolderParent == 0) {	// 가장 상위 폴더이면
			goPage = "redirect:/drive/fileManager?driveStatus="+driveStatus;
		}else {	// 그외
			goPage = "redirect:/drive/driveParent?driveFolderNo="+driveFolderParent+"&driveStatus="+driveStatus;
		}
		
		return goPage;
	}
	
	// 드라이브 업로드 페이지
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping(value = "/uploadForm")
	public String driveUploadForm(HttpSession session, Model model, Integer driveFolderNo, String driveStatus) {
		log.info("driveUploadForm() 실행..!");
		
		model.addAttribute("title","Drive");
		model.addAttribute("activeMain","drive");
		model.addAttribute("activeDriveStatus",driveStatus);
		model.addAttribute("driveFolderParent",driveFolderNo);
		
		model.addAttribute("driveFolderNo",driveFolderNo);
		model.addAttribute("driveStatus",driveStatus);
		
		session.setAttribute("driveFolderNo", driveFolderNo);
		session.setAttribute("driveStatus", driveStatus);
		
		return "drive/fileUploadForm";
	}
	
	// 드라이브 파일 업로드 했을 때 이벤트, 부서문서함인 경우 부서에 있는 사원들 불러내어 같이 생성
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/driveFileUplaod")
	public String driveFileUplaod(HttpServletRequest req, MultipartFile[] file) {
		log.info("driveFileUplaod() 실행..!!");
		
		Drive drive = new Drive();
			
		HttpSession session = req.getSession();
		Integer driveFolderNo = (Integer) session.getAttribute("driveFolderNo");
		String driveStatus = (String) session.getAttribute("driveStatus");
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if(employee != null ) {
			if(file != null) {
				// 파일 설정하기
				Integer deptCode = null;
				if(driveStatus.equals("03")) {
					Employee myInfo = loginMapper.readByUserId(employee.getEmpNo());
					deptCode = myInfo.getDeptCode();
				}
				drive.setDriveFile(file, employee.getEmpNo(), driveFolderNo, driveStatus, deptCode);
				
				driveService.insertDriveFile(req, drive);
			}
		}
		return "drive/fileUploadForm";
	}
	
	// 드라이브 파일 이름 클릭했을 때 파일이 다운로드 됨
	@GetMapping("/driveDownload")
	public View driveDownload(int driveFileNo, ModelMap model) {
		Drive drive = driveService.driveDownload(driveFileNo);
		
		Map<String, Object> driveFileMap = new HashMap<String, Object>();
		driveFileMap.put("fileName", drive.getDriveFileName());
		driveFileMap.put("fileSize", drive.getDriveFileSize());
		driveFileMap.put("fileSavepath", drive.getDriveFileSavepath());
		model.addAttribute("driveFileMap", driveFileMap);
		
		return new DriveDownloadView();
	}
	
	// 드라이브 폴더,파일 휴지통으로 이동
	@ResponseBody
	@PostMapping("/tempDelete")
	public ResponseEntity<ServiceResult> tempDelFolder(@RequestBody Map<String, Object> paramMap){
		ServiceResult result = null;
		List<Integer> folderList = (List<Integer>) paramMap.get("folderNos");
		for(Integer folderNo : folderList) {
			result = driveService.tempDelFolder(folderNo);
		}
		
		List<Integer> fildList = (List<Integer>) paramMap.get("fileNos");
		for(Integer fileNo : fildList) {
			result = driveService.tempDelFile(fileNo);
		}
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
	
	// 드라이브 폴더,파일 영구 삭제
	@ResponseBody
	@PostMapping("/delete")
	public ResponseEntity<ServiceResult> DelFolder(@RequestBody Map<String, Object> paramMap){
		ServiceResult result = null;
		List<Integer> folderList = (List<Integer>) paramMap.get("folderNos");
		for(Integer folderNo : folderList) {
			result = driveService.delFolder(folderNo);
		}
		
		List<Integer> fildList = (List<Integer>) paramMap.get("fileNos");
		for(Integer fileNo : fildList) {
			result = driveService.delFile(fileNo);
		}
		
		return new ResponseEntity<ServiceResult>(result,HttpStatus.OK);
	}
	
	// 휴지통에서 폴더,파일 복구
	@ResponseBody
	@PostMapping("/restore")
	public ResponseEntity<ServiceResult> folderMove(@RequestBody Map<String, Object> paramMap){
		ServiceResult result = null;
		List<Integer> folderList = (List<Integer>) paramMap.get("driveFolderNo");
		for(Integer folderNo : folderList) {
			result = driveService.folderMove(folderNo);
		}
		
		List<Integer> fildList = (List<Integer>) paramMap.get("driveFileNo");
		for(Integer fileNo : fildList) {
			result = driveService.fileMove(fileNo);
		}
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}

	// 검색
	@PostMapping("/search")
	public String search(String driveStatus, String searchName, Model model) {
		model.addAttribute("title","Drive");
		model.addAttribute("activeMain","drive");
		model.addAttribute("activeDriveStatus",driveStatus);
		
		List<DriveFolder> driveFolderList = driveService.selectSearchFolder(driveStatus, searchName);
		List<Drive> driveList = driveService.selectSearchDrive(driveStatus, searchName);
		
		model.addAttribute("driveFolderList",driveFolderList);
		model.addAttribute("driveList",driveList);
		
		return "drive/fileManager";
	}
	
	// 사진만 리스트 보여주기
	@GetMapping("/drivePhotos")
	public String drivePhotos(Model model) {
		model.addAttribute("title","Drive");
		model.addAttribute("activeMain","drive");
		model.addAttribute("activeDriveStatus","photo");
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if(employee != null ) {
			List<DriveFolder> driveFolderList = new ArrayList<DriveFolder>();
			List<Drive> driveList = new ArrayList<Drive>();
			
			Employee myInfo = loginMapper.readByUserId(employee.getEmpNo());
			int deptCode = myInfo.getDeptCode();
			driveList = driveService.selectPhotoDrive(employee.getEmpNo(),deptCode);
			
			model.addAttribute("driveFolderList",driveFolderList);
			model.addAttribute("driveList",driveList);
		}
		
		return "drive/fileManager";
	}
	
	// 비디오만 리스트 보여주기
	@GetMapping("/driveVideos")
	public String driveVideos(Model model) {
		model.addAttribute("title","Drive");
		model.addAttribute("activeMain","drive");
		model.addAttribute("activeDriveStatus","video");
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		if(employee != null ) {
			List<DriveFolder> driveFolderList = new ArrayList<DriveFolder>();
			List<Drive> driveList = new ArrayList<Drive>();
			
			Employee myInfo = loginMapper.readByUserId(employee.getEmpNo());
			int deptCode = myInfo.getDeptCode();
			driveList = driveService.selectVideoDrive(employee.getEmpNo(),deptCode);
			
			model.addAttribute("driveFolderList",driveFolderList);
			model.addAttribute("driveList",driveList);
		}
		
		return "drive/fileManager";
	}
}
