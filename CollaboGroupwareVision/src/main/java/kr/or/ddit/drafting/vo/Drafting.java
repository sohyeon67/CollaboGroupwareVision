package kr.or.ddit.drafting.vo;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Drafting {

	private String drftNo;
	private String empNo;
	private int drftFormNo;
	private String drftFormName;
	private String drftTitle;
	private String drftContent;
	private String drftWriterName;
	private String drftWriterDeptName;
	private String drftWriterPositionName;
	private String drftDate;
	private String drftStatus;
	private byte[] drftWriterSignImg;
	
	private List<Approval> approvalList;
	private List<DraftingAttach> draftingAttachList;
}
