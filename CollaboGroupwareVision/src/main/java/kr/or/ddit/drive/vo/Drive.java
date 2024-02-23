package kr.or.ddit.drive.vo;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Drive {
	private MultipartFile item;
	private int driveFileNo;
	private String empNo;
	private Integer driveFolderNo;
	private String driveFileName;
	private long driveFileSize;
	private String driveFileFancysize;
	private String driveFileMimetype;
	private String driveFileSavepath;
	private String driveStatus;
	private String driveFileDate;
	private Integer deptCode;
	private String fixDriveStatus;
	
	public Drive() {}
	
	private MultipartFile[] driveFile;	// 드라이브 파일
	private List<Drive> driveList;		// 드라이브 파일리스트
	
	public void setDriveFile(MultipartFile[] driveFile, String empNo, Integer driveFolderNo, String driveStatus, Integer deptCode) {
		this.driveFile = driveFile;
		this.empNo = empNo;
		this.driveFolderNo = driveFolderNo;
		this.driveStatus = driveStatus;
		if(driveFile != null) {
			List<Drive> driveList = new ArrayList<Drive>();
			for(MultipartFile item : driveFile) {
				if(StringUtils.isBlank(item.getOriginalFilename())) {
					continue;
				}
				
				Drive drive = new Drive(item, empNo, driveFolderNo, driveStatus, deptCode);
				driveList.add(drive);
			}
			this.driveList = driveList;
		}
	}
	
	public Drive(MultipartFile item, String empNo, Integer driveFolderNo, String driveStatus, Integer deptCode) {
		this.item = item;
		this.empNo = empNo;
		this.driveFolderNo = driveFolderNo;
		this.driveStatus = driveStatus;
		this.deptCode = deptCode;
		this.driveFileName = item.getOriginalFilename();
		this.driveFileMimetype = item.getContentType();
		this.driveFileSize = item.getSize();
		this.driveFileFancysize = FileUtils.byteCountToDisplaySize(driveFileSize);
	}

}
