package kr.or.ddit.drive.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.drive.vo.Drive;
import kr.or.ddit.drive.vo.DriveFolder;

public interface DriveService {
	public List<Drive> selectDriveList(String driveStatus, String empNo, Integer group);
	public List<DriveFolder> selectDriveFolderList(String driveStatus, String empNo, Integer group);
	public List<DriveFolder> selectDriveFolderChildList(int driveFolderNo, String driveStatus, String empNo, Integer group);
	public List<Drive> selectDriveChildList(int driveFolderNo, String driveStatus, String empNo, Integer group);
	public ServiceResult insertFolder(DriveFolder driveFolder);
	public void updateFolderName(String driveFolderName, int driveFolderNo);
	public void updateFileName(String driveFileName, int driveFileNo);
	public Integer selectDriveFolderParent(int driveFolderNo);
	public void insertDriveFile(HttpServletRequest req, Drive drive);
	public Drive driveDownload(int driveFileNo);
	public ServiceResult tempDelFolder(int folderNo);
	public ServiceResult tempDelFile(int fileNo);
	public ServiceResult delFolder(int folderNo);
	public ServiceResult delFile(int fileNo);
	public List<Drive> selectDriveAllList();
	public ServiceResult folderMove(Integer driveFolderNo);
	public ServiceResult fileMove(int driveFileNo);
	public List<DriveFolder> selectSearchFolder(String driveStatus,String searchName);
	public List<Drive> selectSearchDrive(String driveStatus,String searchName);
	public List<Drive> selectPhotoDrive(String empNo, int deptCode);
	public List<Drive> selectVideoDrive(String empNo, int deptCode);
	
}
