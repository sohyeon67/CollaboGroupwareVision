package kr.or.ddit.board.lostItem.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.board.free.service.BoardService;
import kr.or.ddit.board.lostItem.service.LostitemService;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.BoardLostitem;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/board/lostItem")
public class LostitemController {
	
	@Inject
	private BoardService boardService;
	
	@Inject
	private LostitemService lostService;
	
	
	@GetMapping(value = "/list")
	public String lostItemList(Model model) {
		model.addAttribute("title","분실물게시판");
		model.addAttribute("activeMain","board");
		model.addAttribute("active","lost");
		return "board/lostItem/lostItemList";
	}
	
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@GetMapping(value = "/form")
	public String lostItemForm(Model model) {
		model.addAttribute("title","분실물게시판");
		model.addAttribute("activeMain","board");
		model.addAttribute("active","list");
		return "board/lostItem/lostItemForm";
	}
	
	@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')")
	@RequestMapping(value="/insert", method = RequestMethod.POST)
	public String insert(@ModelAttribute Board board, Model model, 
			RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach, 
			@ModelAttribute BoardLostitem boardLostitem ,
			@RequestParam(name = "boFile") MultipartFile[] boFile, HttpServletRequest req) {
		log.info("insert() 실행...!{}",board );
		
		String goPage = "";
		log.info("제목:"+board.getBoardTitle());
		log.info("내용:"+board.getBoardContent());
		log.info("번호:"+board.getBoardNo());
		board.setBoFile(boFile);
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Employee employee = user.getEmployee();
		board.setEmpNo(employee.getEmpNo());
        
		log.info("empNo:"+employee.getEmpNo());
		
        if(employee != null) {
		    board.setBoardCode(5);
			int status = boardService.insert(board, req);
			
			
			if(status > 0) {
				boardLostitem.setBoardNo(board.getBoardNo());
				lostService.lostitemInsert(boardLostitem);
				goPage = "redirect:/board/lostItem/list";
				// goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
			}else {
				model.addAttribute("board", board);
				// goPage = "board/free/form";
				goPage = "board/lostItem/form";
			}
			log.info("Inserting board:"+board);
		}
		return goPage;
	}
	
}
