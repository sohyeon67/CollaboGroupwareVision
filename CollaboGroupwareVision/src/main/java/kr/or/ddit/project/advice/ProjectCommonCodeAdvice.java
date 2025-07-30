package kr.or.ddit.project.advice;

import java.util.Map;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import kr.or.ddit.commoncode.service.CommonCodeService;

@ControllerAdvice(basePackages = "kr.or.ddit.project.controller")
public class ProjectCommonCodeAdvice {

	private final CommonCodeService commonCodeService;

    public ProjectCommonCodeAdvice(CommonCodeService commonCodeService) {
        this.commonCodeService = commonCodeService;
    }

    @ModelAttribute("projectStatusMap")
    public Map<String, String> projectStatusMap() {
        return commonCodeService.getCodeMapByGroupId("1000");
    }
    
    @ModelAttribute("issuePriorityMap")
    public Map<String, String> issuePriorityMap() {
        return commonCodeService.getCodeMapByGroupId("900");
    }
    
    @ModelAttribute("issueTypeMap")
    public Map<String, String> issueTypeMap() {
        return commonCodeService.getCodeMapByGroupId("901");
    }
    
    @ModelAttribute("issueStatusMap")
    public Map<String, String> issueStatusMap() {
        return commonCodeService.getCodeMapByGroupId("902");
    }

    
}
