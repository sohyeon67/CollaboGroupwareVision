 package kr.or.ddit.drafting.vo;

import lombok.Data;

@Data
public class DraftingForm {

	private int drftFormNo;
	private String drftFormName;
	private String drftFormContent;
	private String drftFormCreateDate;
	private String drftFormDeleteDate;
	private String drftFormUseYn;
}
