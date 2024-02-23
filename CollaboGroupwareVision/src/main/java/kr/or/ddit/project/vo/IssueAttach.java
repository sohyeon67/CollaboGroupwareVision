package kr.or.ddit.project.vo;

import lombok.Data;

@Data
public class IssueAttach {

	private int issueFileNo;
    private int issueNo;
    private String issueFileName;
    private long issueFileSize;
    private String issueFileFancysize;
    private String issueFileMime;
    private String issueFileSavepath;
    
}