package kr.or.ddit.drive.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.drive.vo.Drive;
import kr.or.ddit.drive.vo.DriveFolder;


@Mapper
public interface DriveMapper {
	public List<Drive> selectDriveList(@Param("driveStatus")String driveStatus,@Param("empNo") String empNo,@Param("group") Integer group);
	public List<DriveFolder> selectDriveFolderList(@Param("driveStatus")String driveStatus,@Param("empNo") String empNo,@Param("group") Integer group);
	public List<DriveFolder> selectDriveFolderChildList(@Param("driveFolderNo") int driveFolderNo,@Param("driveStatus") String driveStatus,@Param("empNo") String empNo,@Param("group") Integer group);
	public List<Drive> selectDriveChildList(@Param("driveFolderNo") int driveFolderNo,@Param("driveStatus") String driveStatus,@Param("empNo") String empNo,@Param("group") Integer group);
	public int insertFolder(DriveFolder driveFolder);
	public void updateFolderName(@Param("driveFolderName") String driveFolderName,@Param("driveFolderNo") int driveFolderNo);
	public void updateFileName(@Param("driveFileName") String driveFileName,@Param("driveFileNo") int driveFileNo);
	public Integer selectDriveFolderParent(int driveFolderNo);
	public void insertDriveFile(Drive drive);
	public Drive driveDownload(int driveFileNo);
	public int tempDelFolder(int folderNo);
	public int tempDelFile(int fileNo);
	public int delFolder(int folderNo);
	public int delFile(int fileNo);
	public List<Drive> selectDriveAllList();
	public List<DriveFolder> selectDriveFolderAllList();
	public int folderMove(Integer driveFolderNo);
	public int fileMove(int driveFileNo);
	public List<DriveFolder> selectSearchFolder(@Param("driveStatus")String driveStatus,@Param("searchName") String searchName);
	public List<Drive> selectSearchDrive(@Param("driveStatus")String driveStatus,@Param("searchName") String searchName);
	public List<Drive> selectPhotoDrive(@Param("empNo") String empNo,@Param("deptCode") int deptCode);
	public List<Drive> selectVideoDrive(@Param("empNo") String empNo,@Param("deptCode") int deptCode);
	
	
}
