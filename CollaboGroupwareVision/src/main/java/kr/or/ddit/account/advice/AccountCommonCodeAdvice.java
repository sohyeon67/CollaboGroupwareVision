package kr.or.ddit.account.advice;

import java.util.Map;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import kr.or.ddit.commoncode.service.CommonCodeService;

@ControllerAdvice(basePackages = "kr.or.ddit.account.controller")
public class AccountCommonCodeAdvice {

	private final CommonCodeService commonCodeService;

    public AccountCommonCodeAdvice(CommonCodeService commonCodeService) {
        this.commonCodeService = commonCodeService;
    }
    
    @ModelAttribute("positionMap")
    public Map<String, String> positionMap() {
        return commonCodeService.getCodeMapByGroupId("100");
    }

    @ModelAttribute("dutyMap")
    public Map<String, String> dutyMap() {
        return commonCodeService.getCodeMapByGroupId("101");
    }

    @ModelAttribute("bankMap")
    public Map<String, String> bankMap() {
        return commonCodeService.getCodeMapByGroupId("103");
    }

    @ModelAttribute("hffcMap")
    public Map<String, String> hffcMap() {
        return commonCodeService.getCodeMapByGroupId("104");
    }

    @ModelAttribute("genderMap")
    public Map<String, String> genderMap() {
        return commonCodeService.getCodeMapByGroupId("102");
    }
    
}
