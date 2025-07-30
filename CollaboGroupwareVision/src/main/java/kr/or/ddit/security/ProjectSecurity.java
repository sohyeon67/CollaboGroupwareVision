package kr.or.ddit.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import kr.or.ddit.project.service.ProjectService;

@Component("projectSecurity")
public class ProjectSecurity {

    @Autowired
    private ProjectService projectService;

    public boolean check(String projectId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        CustomUser user = (CustomUser) auth.getPrincipal();

        String empNo = user.getEmployee().getEmpNo();
        return projectService.isProjectMember(empNo, projectId);
    }
}