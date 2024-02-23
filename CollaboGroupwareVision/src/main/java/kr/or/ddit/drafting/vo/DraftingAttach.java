package kr.or.ddit.drafting.vo;


import lombok.Data;

@Data
public class DraftingAttach {

	private int drftFileNo;
	private String drftNo;
	private String drftFileName;
	private long drftFileSize;
	private String drftFileFancysize;
	private String drftFileMime;
	private int drftFileDowncount;
	private String drftFileSavepath;
	
}
