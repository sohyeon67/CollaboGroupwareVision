package kr.or.ddit.drafting.vo;

import java.util.List;

import lombok.Data;

@Data
public class ApprovalBookmark {

	private int apprvBookmarkNo;
	private String apprvBookmarkEmpNo;
	private String apprvBookmarkName;
	private List<String> empNoList;
}
