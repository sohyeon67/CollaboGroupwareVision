package kr.or.ddit.suggestion.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.board.service.ReplyService;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.board.vo.Reply;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.suggestion.service.SuggestionService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/suggestion")
public class SuggestionController {
	
	@Inject
	private SuggestionService suggestionservice;
	
	@Inject
	private ReplyService replyService; 
	
	@GetMapping("/")
    public String showIndex() {
        return "/suggestion/detail";
    }
	
	// 관리자 연결
	
	/* @PreAuthorize("hasRole('ROLE_USER')") */
	@RequestMapping(value="/adsuggestionlist", method = RequestMethod.GET)
	public String adsuggestionlist(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model, Employee employee, String empName
		) {
		
		PaginationInfo<Board> pagingVO = new PaginationInfo<Board>();

		pagingVO.setBoardCode(3);
		pagingVO.setCurrentPage(currentPage);
		
		int totalRecord = suggestionservice.listCount(pagingVO);	// 총 게시글 수 가져오기
		pagingVO.setTotalRecord(totalRecord);
		
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("boardCode", 3);
		
		
		
		//관리자는 모든 목록 확인 가능
		List<Board> boardlist = suggestionservice.suggestionlist(pagingVO);
		pagingVO.setDataList(boardlist);
		
		List<BoardAttach> boardAttachList = suggestionservice.selectAttachList(paramMap);
		
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("boardAttachList", boardAttachList);
		
			model.addAttribute("adminMenu", "y");
			model.addAttribute("title","건의게시판");
			model.addAttribute("activeMain","board");
			model.addAttribute("boardlist", boardlist);
			
		
		return "board/suggestion/adsuggestionlist";
	}							
	
	// 관리자 디테일
	@RequestMapping(value ="/adsuggestiondetail", method = RequestMethod.GET)
	public String adsuggestiondetail(
			int boardNo, Model model, @ModelAttribute Reply reply, BoardAttach boardAttach,
			Employee employee, String empName
			) {
		log.info("detail() 실행...!");
		
		Board board = suggestionservice.suggestiondetail(boardNo);
		
		List<BoardAttach> boardAttachList = suggestionservice.detail2(boardNo);
		model.addAttribute("boardAttachList", boardAttachList);
		
//		suggestionservice.insert2(boardAttach);
		model.addAttribute("adminMenu", "y");
		model.addAttribute("boardAttach", boardAttach);
		model.addAttribute("board", board);
		
		
		model.addAttribute("replyList", replyService.replyList(board.getBoardNo()));
		model.addAttribute("reply", reply);
		
		List<Reply> replyList = replyService.replyList(board.getBoardNo());
		model.addAttribute("replyList", replyList);
		
		
		log.info("board : "+board);
		log.info("boardAttachList : "+boardAttachList);
		log.info("reply : "+reply);
		log.info("replyList : "+replyList);
		
		return "board/suggestion/adsuggestiondetail";
		
	}
	// 일반 리스트
	
	/* @PreAuthorize("hasRole('ROLE_USER')") */
	@RequestMapping(value="/suggestionlist", method = RequestMethod.GET)
	public String suggestionlist(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model, Employee employee, String empName,
			Principal principal
		) {
		
		//로그인한 아이디
		String empNo = principal.getName();
		log.info("suggestionlist->empNo : " + empNo);
		
		PaginationInfo<Board> pagingVO = new PaginationInfo<Board>();

		pagingVO.setBoardCode(3);
		pagingVO.setCurrentPage(currentPage);
		
		int totalRecord = suggestionservice.listCount(pagingVO);	// 총 게시글 수 가져오기
		pagingVO.setTotalRecord(totalRecord);
		
		pagingVO.setEmpNo(empNo);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("boardCode", 3);
		
		/*
		 PaginationInfo(totalRecord=6, totalPage=1, currentPage=1, screenSize=10, blockSize=5
		 , startRow=1, endRow=10, startPage=1, endPage=5, dataList=null, searchType=null
		 , searchWord=null, boardCode=3, deptCode=0, empNo=2322000)
		 */
		log.info("suggestionlist->pagingVO : " + pagingVO);
		
//		List<Board> dataList = suggestionservice.list(pagingVO);
		List<Board> boardlist = suggestionservice.list(pagingVO);
		pagingVO.setDataList(boardlist);
		
		List<BoardAttach> boardAttachList = suggestionservice.selectAttachList(paramMap);
		
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("boardAttachList", boardAttachList);
		
			
			model.addAttribute("title","건의게시판");
			model.addAttribute("activeMain","board");
			model.addAttribute("boardlist", boardlist);
					
			
		return "board/suggestion/suggestionlist";
	}
	

	
	// 일반 폼
	
	@RequestMapping(value ="/suggestionform", method = RequestMethod.GET )
	public String suggestionform() {
		
		return "board/suggestion/suggestionform";
	}
	
	// 일반 인서트 
	
	@RequestMapping(value = "/suggestioninsert", method = RequestMethod.POST)
	public String suggestioninsert(@ModelAttribute Board board, Model model,
			RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach,
			@RequestParam(name = "boFile") MultipartFile[] boFile, HttpServletRequest req) {
		
		Map<String, String> errors = new HashMap<String, String>();
		
		
		String goPage = "";
		log.info("제목: "+ board.getBoardTitle());
		log.info("내용: "+ board.getBoardContent());
		log.info("번호: "+ board.getBoardNo());
		board.setBoFile(boFile);
		
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		
	
		int boardNo = suggestionservice.getBoardNo();

		board.setEmpNo(employee.getEmpNo());
		board.setBoardNo(boardNo);

		if(employee != null) {
			board.setBoardCode(3);
			int status = suggestionservice.insert(board, req);
			
			if(status > 0) {
				
				goPage = "redirect:/suggestion/suggestiondetail?boardNo="+boardNo;
			}else {
				model.addAttribute("board", board);
				
				goPage = "suggestion/suggestionform";
			}
			log.info(" 잘가나?:"+ board);
		}
		
		return goPage;
	}
	
	// 일반 디테일
	@RequestMapping(value ="/suggestiondetail", method = RequestMethod.GET)
	public String suggestiondetail(
			int boardNo, Model model, @ModelAttribute Reply reply, BoardAttach boardAttach,
			Employee employee, String empName
			) {
		log.info("detail() 실행...!");
		
		Board board = suggestionservice.suggestiondetail(boardNo);
		
		List<BoardAttach> boardAttachList = suggestionservice.detail2(boardNo);
		model.addAttribute("boardAttachList", boardAttachList);
		
//		suggestionservice.insert2(boardAttach);
		model.addAttribute("boardAttach", boardAttach);
		model.addAttribute("board", board);
		
		model.addAttribute("replyList", replyService.replyList(board.getBoardNo()));
		model.addAttribute("reply", reply);
		
		List<Reply> replyList = replyService.replyList(board.getBoardNo());
		model.addAttribute("replyList", replyList);
		
		log.info("board : "+board);
		log.info("boardAttachList : "+boardAttachList);
		log.info("reply : "+reply);
		log.info("replyList : "+replyList);
		
		return "board/suggestion/suggestiondetail";
		
	}
	
	@RequestMapping(value="/update", method = RequestMethod.GET)
	public String updateForm(int boardNo, Model model, BoardAttach boardAttach ) {
		log.info("updateform() 실행...!");
		Board board = suggestionservice.suggestiondetail(boardNo);
		List<BoardAttach> boardAttachList = suggestionservice.detail2(boardNo);
		model.addAttribute("board", board);
		model.addAttribute("status", "u");
		model.addAttribute("boardAttachList", boardAttachList);
		return "board/suggestion/suggestionform";
	}
	
	@Transactional
	@RequestMapping(value="/update", method = RequestMethod.POST)
	public String update(
			int boardNo, @ModelAttribute Board board, Model model, 
			RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach, 
			MultipartFile[] boFile, HttpServletRequest req, Principal principal
			) throws Exception {
		log.info("update() 실행...!");
		String goPage = "";
		
		//기존파일조회
		List<BoardAttach> boardAttachList = suggestionservice.detail2(boardNo);
		model.addAttribute("boardAttachList", boardAttachList);
		model.addAttribute("board", board);
		log.info("update boardAttachList : ", boardAttachList);

		String loggedInEmpNo = principal.getName();
		String empNo = suggestionservice.getEmpNo(boardNo);

		if(loggedInEmpNo.equals(empNo)) {
			ServiceResult result = suggestionservice.update(req, board);
		
			if(result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("message", "수정이 완료되었습니다!");
				goPage = "redirect:/suggestion/suggestiondetail?boardNo="+board.getBoardNo();
			}else {
				model.addAttribute("message", "수정에 실패하였습니다!");
				model.addAttribute("board", board);
				model.addAttribute("status", "u");
				goPage = "board/suggestion/suggestionform";
			}
		}else {
			log.info("수정권한이 없습니다 메시지 실행...!");
			ra.addFlashAttribute("message", "수정권한이 없습니다!");
			goPage = "redirect:/suggestion/suggestiondetail?boardNo="+board.getBoardNo();
		}
		
		log.info("update board : "+board);
		log.info("update boardAttachList : "+boardAttachList);
		
		return goPage;
		}
	
	
	// 일반 삭제
	
	@RequestMapping(value="/suggestiondelete", method = RequestMethod.POST)
	public String suggestiondelete(int boardNo, Principal principal, RedirectAttributes ra) {
		log.info("suggestiondelete() 실행...!");
		String goPage = "";
		
		String loggedInEmpNo = principal.getName();
		String empNo = suggestionservice.getEmpNo(boardNo);
		
	if(loggedInEmpNo.equals(empNo)) {
		int status = suggestionservice.suggestiondelete(boardNo);
		
		if(status > 0) {
			log.info("삭제가 완료되었습니다 메시지 실행...!");
			ra.addFlashAttribute("message", "삭제가 완료되었습니다!");
			goPage = "redirect:/suggestion/suggestionlist";
		}else {
			log.info("삭제 중 오류가 발생했습니다 메시지 실행...!");
			ra.addFlashAttribute("message", "삭제 중 오류가 발생했습니다!");
			goPage = "redirect:/suggestion/suggestiondetail?boardNo="+boardNo;
		}
	}else {
		log.info("삭제권한이 없습니다 메시지 실행...!");
		ra.addFlashAttribute("message", "삭제권한이 없습니다!");
		goPage = "redirect:/suggestion/suggestiondetail?boardNo="+boardNo;
	}
		
		return goPage;
	}
	
	@RequestMapping(value="/updateBoardAttach", method = RequestMethod.POST)
	public String updateBoardAttach(Board board, Model model, BoardAttach boardAttach) {
		log.info("updateBoardAttach() 실행...!");
		String goPage = "";
		
		ModelAndView mav = new ModelAndView("redirect:/suggestion/updateBoardAttach");
		mav.addObject("idx", board.getBoardNo());
		
		int status = suggestionservice.updateBoardAttach(board, boardAttach);
		if(status > 0) {
			goPage = "redirect:/suggestion/suggestiondetail?boardNo="+board.getBoardNo();
		}else {
			model.addAttribute("board", board);
			model.addAttribute("status", "u");
			goPage = "board/suggestion/suggestionform";
		}
		return goPage;
	}
	
	@PostMapping("/replyInsert")
	public String replyInsert(Reply reply, Principal principal) {
		//Reply(replyNo=0, boardNo=512, empNo=null, replyContent=safdfsda, regDate=null, modDate=null, employee=null)
		log.info("replyInsert->reply : " + reply);
		
		//로그인한 아이디
		String empNo = principal.getName();
		log.info("replyInsert->empNo : " + empNo);
		
		//Reply(replyNo=0, boardNo=512, empNo=2400000, replyContent=safdfsda, regDate=null, modDate=null, employee=null)
		reply.setEmpNo(empNo);
		
		int result = this.replyService.replyInsert(reply);
		log.info("replyInsert->result : " + result);
		
		
		return "redirect:/suggestion/adsuggestiondetail?boardNo="+reply.getBoardNo();
	}
	
}
