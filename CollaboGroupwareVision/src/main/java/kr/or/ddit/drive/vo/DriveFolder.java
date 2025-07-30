package kr.or.ddit.drive.vo;

import lombok.Data;

@Data
public class DriveFolder {
	private int driveFolderNo;
	private String driveFolderName;
	private Integer driveFolderParent;
	private String driveFolderDate;
	private String empNo;
	private String driveStatus;
	private Integer deptCode;
	private String fixDriveStatus;
}