package kr.or.ddit.drive.service;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.drive.mapper.DriveMapper;
import kr.or.ddit.drive.vo.Drive;
import kr.or.ddit.drive.vo.DriveFolder;

@Service
public class DriveServiceImpl implements DriveService {

	@Inject
	private DriveMapper driveMapper;
	
	@Override
	public List<Drive> selectDriveList(String driveStatus, String empNo, Integer group) {
		return driveMapper.selectDriveList(driveStatus, empNo, group);
	}

	@Override
	public List<DriveFolder> selectDriveFolderList(String driveStatus, String empNo, Integer group) {
		return driveMapper.selectDriveFolderList(driveStatus, empNo, group);
	}
	
	@Override
	public List<DriveFolder> selectDriveFolderChildList(int driveFolderNo, String driveStatus, String empNo, Integer group) {
		return driveMapper.selectDriveFolderChildList(driveFolderNo, driveStatus, empNo, group);
	}

	@Override
	public List<Drive> selectDriveChildList(int driveFolderNo, String driveStatus, String empNo, Integer group) {
		return driveMapper.selectDriveChildList(driveFolderNo, driveStatus, empNo, group);
	}

	@Override
	public ServiceResult insertFolder(DriveFolder driveFolder) {
		ServiceResult result = null;
		
		int status = driveMapper.insertFolder(driveFolder);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public void updateFolderName(String driveFolderName, int driveFolderNo) {
		driveMapper.updateFolderName(driveFolderName, driveFolderNo);
	}

	@Override
	public void updateFileName(String driveFileName, int driveFileNo) {
		driveMapper.updateFileName(driveFileName, driveFileNo);
	}

	@Override
	public Integer selectDriveFolderParent(int driveFolderNo) {
		return driveMapper.selectDriveFolderParent(driveFolderNo);
	}

	@Override
	public void insertDriveFile(HttpServletRequest req, Drive drive) {
		List<Drive> driveList = drive.getDriveList();
		System.out.println("driveList:"+driveList);
		try {
			driveFileUpload(driveList, drive.getDriveFolderNo(), req);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void driveFileUpload(List<Drive> driveList, Integer driveFolderNo, HttpServletRequest req) throws Exception {
		String savePath = "/resources/drive/";
		
		if(driveList != null) {	//넘겨받은 파일 데이터가 존재할 때
			if(driveList.size() > 0) {
				for(Drive drive : driveList) {
					String saveName = UUID.randomUUID().toString();	// UUID의 랜덤 파일명 생성
					
					// 파일명을 설정할 때, 원본 파일명의 공백을 "_"로 변경한다.
					saveName = saveName + "_" + drive.getDriveFileName().replaceAll(" ", "_");
					// 디버깅 및 확장자 추출 참고
					String endFilename = drive.getDriveFileName().split("\\.")[1];	
					
					if(driveFolderNo == null) {
						driveFolderNo = 0;
					}
					String saveLocate = req.getServletContext().getRealPath(savePath + driveFolderNo);
					File file = new File(saveLocate);
					if(!file.exists()) {
						file.mkdirs();
					}
					saveLocate += "/" + saveName;
					
					drive.setDriveFileSavepath(saveLocate);
					driveMapper.insertDriveFile(drive);	
				
					File saveFile = new File(saveLocate);
					drive.getItem().transferTo(saveFile); 	// 파일 복사
				}
			}
		}
	}

	@Override
	public Drive driveDownload(int driveFileNo) {
		Drive drive = driveMapper.driveDownload(driveFileNo);
		if(drive == null) {
			throw new RuntimeException();
		}
		return drive;
	}

	@Override
	public ServiceResult tempDelFolder(int folderNo) {
		ServiceResult result = null;
		int status = driveMapper.tempDelFolder(folderNo);
		int fNo = 0;
		if(status > 0) {
			List<DriveFolder> driveFolderList = driveMapper.selectDriveFolderAllList();
			if(driveFolderList != null) {
				for(DriveFolder driveFolder : driveFolderList) {
					if((Integer) folderNo == driveFolder.getDriveFolderParent()) {
						driveMapper.tempDelFolder(driveFolder.getDriveFolderParent());
						fNo = driveFolder.getDriveFolderNo();
					}
				}
			}
			List<Drive> driveList = driveMapper.selectDriveAllList();
			if(driveList != null) {
				for(Drive drive : driveList) {
					if((Integer) folderNo == drive.getDriveFolderNo()) {
						driveMapper.tempDelFile(drive.getDriveFileNo());
					}
				}
			}
			tempDelFolder(fNo);
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult tempDelFile(int fileNo) {
		ServiceResult result = null;
		int status = driveMapper.tempDelFile(fileNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult delFolder(int folderNo) {
		ServiceResult result = null;
		int status = driveMapper.delFolder(folderNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult delFile(int fileNo) {
		ServiceResult result = null;
		int status = driveMapper.delFile(fileNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public List<Drive> selectDriveAllList() {
		return driveMapper.selectDriveAllList();
	}

	@Override
	public ServiceResult folderMove(Integer driveFolderNo) {
		ServiceResult result = null;
		int fNo = 0;
		int status = driveMapper.folderMove(driveFolderNo);
		if(status > 0) {
			List<DriveFolder> driveFolderList = driveMapper.selectDriveFolderAllList();
			if(driveFolderList != null) {
				for(DriveFolder driveFolder : driveFolderList) {
					if(driveFolderNo == driveFolder.getDriveFolderParent()) {
						driveMapper.folderMove(driveFolder.getDriveFolderParent());
						fNo = driveFolder.getDriveFolderNo();
					}
				}
			}
			List<Drive> driveList = driveMapper.selectDriveAllList();
			if(driveList != null) {
				for(Drive drive : driveList) {
					if(driveFolderNo == drive.getDriveFolderNo()) {
						driveMapper.fileMove(drive.getDriveFileNo());
					}
				}
			}
			folderMove(fNo);
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult fileMove(int driveFileNo) {
		ServiceResult result = null;
		int status = driveMapper.fileMove(driveFileNo);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public List<DriveFolder> selectSearchFolder(String driveStatus, String searchName) {
		return driveMapper.selectSearchFolder(driveStatus, searchName);
	}

	@Override
	public List<Drive> selectSearchDrive(String driveStatus, String searchName) {
		return driveMapper.selectSearchDrive(driveStatus, searchName);
	}

	@Override
	public List<Drive> selectPhotoDrive(String empNo, int deptCode) {
		return driveMapper.selectPhotoDrive(empNo,deptCode);
	}

	@Override
	public List<Drive> selectVideoDrive(String empNo, int deptCode) {
		return driveMapper.selectVideoDrive(empNo,deptCode);
	}



}
