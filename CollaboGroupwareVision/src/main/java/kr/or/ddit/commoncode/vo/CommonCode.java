package kr.or.ddit.commoncode.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommonCode {
	private String commonCodeGroupId;    // 숫자형 그룹 ID, ex) "100"
    private String commonCodeGroupName;  // 그룹명, ex) "POSITION_CODE"
    private String commonCode;           // 코드, ex) "01"
    private String commonCodeName;       // 코드명, ex) "회장"
}
