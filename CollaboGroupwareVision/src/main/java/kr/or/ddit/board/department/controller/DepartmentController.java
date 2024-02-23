package kr.or.ddit.board.department.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.board.department.service.DepartmentService;
import kr.or.ddit.board.free.controller.FreeController;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.board.vo.Reply;
import kr.or.ddit.org.vo.Dept;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/department")
public class DepartmentController {
	
	@Inject
	private DepartmentService departmentService;
	
//	@Inject
//	private DepartmentReplyService replyService; 
	
	// root-context.xml에서 설정한 uploadPath 빈등록 path 경로를 사용한다.
	@Resource(name="uploadPath")
	private String resourcePath;
	
    @GetMapping("/")
    public String showIndex() {
        return "/department/departmentDetail";
    }
    
	private static final Logger logger = LoggerFactory.getLogger(FreeController.class);
	
	@RequestMapping(value="/departmentForm", method = RequestMethod.GET)
	public String departmentForm(Model model, Board board, Dept dept) {
		model.addAttribute("activeMain","board");
		model.addAttribute("active","department");
		log.info("departmentForm() 실행...!");
		
//		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = (Employee) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    board.setEmpNo(employee.getEmpNo());
	    log.info("empNo:"+employee.getEmpNo());
	    
	    
	    String deptName = employee.getDeptName();
	    model.addAttribute("deptName", deptName);
	    log.info("departmentForm deptName : "+dept.getDeptName());
		
	    String empName = employee.getEmpName();
	    model.addAttribute("empName", empName);
	    log.info("departmentForm empName : "+employee.getEmpName());

	    return "department/departmentForm";
	}
	
	@RequestMapping(value="/departmentInsert", method = RequestMethod.POST)
	public String departmentInsert(@ModelAttribute Board board, Model model, 
	        RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach, 
	        HttpServletRequest req, Dept dept
//	        MultipartFile[] boFile, @RequestParam(name = "departmentSelect", required = true) String departmentSelect
	        ) {
	    log.info("departmentInsert() 실행...!");
		
	    // 넘겨받은 데이터 검증 후, 에러가 발생한 데이터에 대한 에러정보를 담을 공간
	    Map<String, String> errors = new HashMap<String, String>();
	    
	    PaginationInfo<Board> pagingVO = new PaginationInfo<Board>();
//	    int departmentCode = Integer.parseInt(departmentSelect);
//	    pagingVO.setBoardCode(departmentCode);
	    
	    String goPage = "";
//	    board.setBoFile(boFile);

	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    Employee employee = user.getEmployee();
	    board.setEmpNo(employee.getEmpNo());
	    log.info("empNo:"+employee.getEmpNo());
	    
	    
	    
//	    model.addAttribute("empName", employee.getEmpName());
//	    log.info("departmentInsert empName : "+employee.getEmpName());
	    

	    
	    if(employee != null) {
	        board.setBoardCode(4);
	        int status = departmentService.departmentInsert(board, req);
	        if(status > 0) {
	            // 부서 코드를 모델에 추가하여 해당 부서의 리스트를 조회하도록 함
//	            model.addAttribute("departmentCode", departmentCode);
	            goPage = "redirect:/department/departmentDetail?boardNo="+board.getBoardNo();
	        } else {
	            model.addAttribute("board", board);
	            model.addAttribute("activeMain","board");
	    		model.addAttribute("active","department");
	            goPage = "department/departmentForm";
	        }
	    }
	    return goPage;
	}

	
	@RequestMapping(value="/departmentDetail", method = RequestMethod.GET)
	public String departmentDetail(
			int boardNo, Model model, @ModelAttribute Reply reply, BoardAttach boardAttach
//			@RequestParam(name = "departmentSelect") String departmentSelect
			) {
		log.info("departmentDetail() 실행...!");
		model.addAttribute("activeMain","board");
		model.addAttribute("active","department");
		
		departmentService.departmentUpdate2(boardNo);           // 조회수 증가
		
		
		
		Board board = departmentService.departmentDetail(boardNo);
		
//		List<BoardAttach> boardAttachList = departmentService.departmentDetail2(boardNo);
//		model.addAttribute("boardAttachList", boardAttachList);
		
		model.addAttribute("board", board);
		
//		model.addAttribute("replyList", replyService.replyList(board.getBoardNo()));
//		model.addAttribute("reply", reply);
		
//		List<Reply> replyList = replyService.replyList(board.getBoardNo());
//		model.addAttribute("replyList", replyList);
		PaginationInfo<Board> pagingVO = new PaginationInfo<Board>();
//	    int departmentCode = Integer.parseInt(departmentSelect);
//	    pagingVO.setBoardCode(departmentCode);
//		log.info("departmentDetail departmentCode",departmentCode);
		
		return "department/departmentDetail";
	}
	
	@RequestMapping(value="/departmentList",method = RequestMethod.GET)
	public String departmentList(Model model) {
		model.addAttribute("activeMain","board");
		model.addAttribute("active","department");
		
		// 부서게시판 내에서 사용할 각 부서 목록이 필요합니다.
		List<Dept> deptList = departmentService.selectDepartMentList();
		model.addAttribute("deptList", deptList);
		
		
		
		return "department/departmentList";
	}
	
	@RequestMapping(value="/deptBoardList", method = RequestMethod.GET)
	public String deptBoardList(
	        @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
	        @RequestParam(required = false, defaultValue = "title") String searchType,
	        @RequestParam(required = false) String searchWord, HttpSession session,
	        Model model, @RequestParam(name = "code", required = false, defaultValue = "") int deptCode,
	        Authentication authentication, HttpServletRequest request
	) {
	    System.out.println("############## deptCode : " + deptCode);
	    model.addAttribute("activeMain","board");
		model.addAttribute("active","department");
		
	    try {
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    CustomUser customUser = (CustomUser) auth.getPrincipal();
	    Employee loggedInUser = customUser.getEmployee();
	    int loginEmpDeptCode = loggedInUser.getDeptCode();

	    PaginationInfo<Board> pagingVO = new PaginationInfo<Board>();
	    if(StringUtils.isNotBlank(searchWord)) {
	        pagingVO.setSearchType(searchType);
	        pagingVO.setSearchWord(searchWord);
	        model.addAttribute("searchType", searchType);
	        model.addAttribute("searchWord", searchWord);
	    }
	    pagingVO.setDeptCode(deptCode);
	    int boardCode = 4; // 해당 부서의 게시판 코드 (임시로 4로 설정)
	    pagingVO.setBoardCode(boardCode);
	    pagingVO.setCurrentPage(currentPage);

//	    if (deptCode != 0 && loginEmpDeptCode != deptCode) {
//	        // 부서코드가 일치하지 않는 경우 예외 발생
//	        throw new AccessDeniedException("Access Denied: 부서코드가 일치하지 않습니다.");
//	    }
	    
	    int totalRecord = departmentService.listCount(pagingVO);    // 총 게시글 수 가져오기
	    pagingVO.setTotalRecord(totalRecord);

	    List<Board> dataList = departmentService.list(pagingVO);
	    pagingVO.setDataList(dataList);

	    Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.put("boardCode", 4);

	    List<BoardAttach> boardAttachList = departmentService.selectAttachList(paramMap);

	    model.addAttribute("pagingVO", pagingVO);
	    model.addAttribute("boardAttachList", boardAttachList);

	    model.addAttribute("title","부서게시판");
	    model.addAttribute("activeMain","board");
	    model.addAttribute("active","department");

	    if (deptCode != 0 && loginEmpDeptCode != deptCode) {
	        throw new AccessDeniedException("Access Denied: 부서코드가 일치하지 않습니다.");
	    }
	    } catch (AccessDeniedException e) {
	        // 부서코드가 일치하지 않는 예외 발생 시, 에러 대신 알림으로 처리하기 위해 메시지 전달
	        model.addAttribute("alertMessage", "해당 부서게시판은 조회할 수 없습니다.");
	    }
	    return "department/deptBoardList";
	}
	    

	
	@RequestMapping(value="/departmentDelete", method = RequestMethod.POST)
	public String departmentDelete(int boardNo, Principal principal, RedirectAttributes ra) {
		log.info("departmentDelete() 실행...!");
		String goPage = "";
		
		String loggedInEmpNo = principal.getName();
		String empNo = departmentService.getEmpNo(boardNo);
		
		if(loggedInEmpNo.equals(empNo)) {
			int status = departmentService.departmentDelete(boardNo);
			if(status > 0) {
				ra.addFlashAttribute("message", "부서게시글 삭제 완료!");
				goPage = "redirect:/department/departmentList";
			}
		}else {
			ra.addFlashAttribute("message", "부서게시글 삭제권한 없음!");
			goPage = "redirect:/department/departmentDetail?boardNo="+boardNo;
		}
		
		return goPage;
	}
	
	@RequestMapping(value="/departmentUpdate", method = RequestMethod.GET)
	public String departmentUpdateForm(int boardNo, Model model, BoardAttach boardAttach) {
		log.info("departmentUpdateForm() 실행...!");
		model.addAttribute("activeMain","board");
		model.addAttribute("active","department");
		Board board = departmentService.departmentDetail(boardNo);
		List<BoardAttach> boardAttachList = departmentService.departmentBoardAttach(boardNo);
		model.addAttribute("board", board);
		model.addAttribute("status", "u");
		model.addAttribute("boardAttachList", boardAttachList);
		return "department/departmentForm";
	}
	
	@RequestMapping(value="/departmentUpdate", method = RequestMethod.POST)
	public String departmentUpdate(
			@RequestParam("boardNo")int boardNo, @ModelAttribute Board board, Model model,
			RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach,
			MultipartFile[] boFile, HttpServletRequest req, Principal principal
			) throws Exception {
		log.info("departmentUpdate() 실행..!");
		String goPage = "";
		
		List<BoardAttach> boardAttachList = departmentService.departmentBoardAttach(boardNo);
		model.addAttribute("boardAttachList", boardAttachList);
		model.addAttribute("board", board);
		log.info("departmentUpdate boardAttachList : {}",boardAttachList);
		log.info("departmentUpdate board : {}",board);
		
		String loggedInEmpNo = principal.getName();
		String empNo = departmentService.getEmpNo(boardNo);
		
		if(loggedInEmpNo.equals(empNo)) {
			ServiceResult result = departmentService.departmentUpdate(req, board);
			if(result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("message", "부서게시글 수정 완료!");
				goPage = "redirect:/department/departmentDetail?boardNo="+board.getBoardNo();
			}else {
				model.addAttribute("message", "부서게시글 수정 실패!");
				model.addAttribute("board", board);
				model.addAttribute("status", "u");
				model.addAttribute("activeMain","board");
				model.addAttribute("active","department");
				goPage = "department/departmentForm";
			}
		}else {
			ra.addFlashAttribute("message", "부서게시글 수정권한 없음!");
			goPage = "redirect:/department/departmentDetail?boardNo="+board.getBoardNo();
		}
		
		return goPage;
	}
	
	
	
	
	
	
	
}































