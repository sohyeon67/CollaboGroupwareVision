package kr.or.ddit.board.free.controller;

import java.io.FileInputStream;
import java.io.InputStream;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.board.free.service.BoardService;
import kr.or.ddit.board.service.ReplyService;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.board.vo.Reply;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.MediaUtils;
import kr.or.ddit.util.UploadFileUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/board")
public class FreeController {
	
	@Inject
	private BoardService boardService;
	
	@Inject
	private ReplyService replyService; 
	
	// root-context.xml에서 설정한 uploadPath 빈등록 path 경로를 사용
	@Resource(name="uploadPath")
	private String resourcePath;
	
    @GetMapping("/")
    public String showIndex() {
        return "/free/detail";
    }
	
	private static final Logger logger = LoggerFactory.getLogger(FreeController.class);
	
	@RequestMapping(value="/free/list",method = RequestMethod.GET)
	public String list(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model, Employee employee, String empName
		) {
		
		PaginationInfo<Board> pagingVO = new PaginationInfo<Board>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		pagingVO.setBoardCode(2);
		pagingVO.setCurrentPage(currentPage);
		
		int totalRecord = boardService.listCount(pagingVO);	// 총 게시글 수 가져오기
		pagingVO.setTotalRecord(totalRecord);
		
		List<Board> dataList = boardService.list(pagingVO);
		pagingVO.setDataList(dataList);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("boardCode", 2);
		
		List<BoardAttach> boardAttachList = boardService.selectAttachList(paramMap);
		
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("boardAttachList", boardAttachList);
		
		model.addAttribute("title","자유게시판");
		model.addAttribute("activeMain","board");
		model.addAttribute("active","free");
		
		return "board/free/list";
	}
	
	@RequestMapping(value="/form", method = RequestMethod.GET)
	public String form() {
		log.info("form() 실행...!");
		return "board/free/form";
	}
	
	@RequestMapping(value="/insert", method = RequestMethod.POST)
	public String insert(@ModelAttribute Board board, Model model, 
			RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach, 
			@RequestParam(name = "boFile") MultipartFile[] boFile, HttpServletRequest req) {
		log.info("insert() 실행...!{}",board );
		
		// 넘겨받은 데이터 검증 후, 에러가 발생한 데이터에 대한 에러정보를 담을 공간
		Map<String, String> errors = new HashMap<String, String>();
		
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
		    board.setBoardCode(2);
			int status = boardService.insert(board, req);
			if(status > 0) {
				
				goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
			}else {
				model.addAttribute("board", board);
				goPage = "board/free/form";
			}
			log.info("Inserting board:"+board);
		}
		return goPage;
	}
	
	@RequestMapping(value="/detail", method = RequestMethod.GET)
	public String detail(
			int boardNo, Model model, @ModelAttribute Reply reply, BoardAttach boardAttach,
			Employee employee, String empName
			) {
		log.info("detail() 실행...!");
//		log.debug("bno"+boardNo);
		boardService.update2(boardNo);           // 조회수 증가
		
		Board board = boardService.detail(boardNo);
		
		List<BoardAttach> boardAttachList = boardService.detail2(boardNo);
		model.addAttribute("boardAttachList", boardAttachList);
		
//		boardService.insert2(boardAttach);
//		model.addAttribute("boardAttach", boardAttach);
		model.addAttribute("board", board);
		
		model.addAttribute("replyList", replyService.replyList(board.getBoardNo()));
		model.addAttribute("reply", reply);
		
		List<Reply> replyList = replyService.replyList(board.getBoardNo());
		model.addAttribute("replyList", replyList);
		
		log.info("board : "+board);
		log.info("boardAttachList : "+boardAttachList);
		log.info("reply : "+reply);
		log.info("replyList : "+replyList);
		
		return "board/free/detail";
	}
	
	@RequestMapping(value="/update", method = RequestMethod.GET)
	public String updateForm(int boardNo, Model model, BoardAttach boardAttach ) {
		log.info("updateform() 실행...!");
		Board board = boardService.detail(boardNo);
		List<BoardAttach> boardAttachList = boardService.detail2(boardNo);
		model.addAttribute("board", board);
		model.addAttribute("status", "u");
		model.addAttribute("boardAttachList", boardAttachList);
		return "board/free/form";
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
		List<BoardAttach> boardAttachList = boardService.detail2(boardNo);
		model.addAttribute("boardAttachList", boardAttachList);
		model.addAttribute("board", board);
		log.info("update boardAttachList : ", boardAttachList);

		String loggedInEmpNo = principal.getName();
		String empNo = boardService.getEmpNo(boardNo);

		if(loggedInEmpNo.equals(empNo)) {
			ServiceResult result = boardService.update(req, board);
		
			if(result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("message", "수정이 완료되었습니다!");
				goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
			}else {
				model.addAttribute("message", "수정에 실패하였습니다!");
				model.addAttribute("board", board);
				model.addAttribute("status", "u");
				goPage = "board/free/form";
			}
		}else {
			log.info("수정권한이 없습니다 메시지 실행...!");
			ra.addFlashAttribute("message", "수정권한이 없습니다!");
			goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
		}
		
		log.info("update board : "+board);
		log.info("update boardAttachList : "+boardAttachList);
		
		return goPage;
		}
	
	
	@RequestMapping(value="/delete", method = RequestMethod.POST)
	public String delete(int boardNo, Principal principal, RedirectAttributes ra) {
		log.info("delete() 실행...!");
		String goPage = "";
		
		String loggedInEmpNo = principal.getName();
		String empNo = boardService.getEmpNo(boardNo);
		
	if(loggedInEmpNo.equals(empNo)) {
		int status = boardService.delete(boardNo);
		
		if(status > 0) {
			log.info("삭제가 완료되었습니다 메시지 실행...!");
			ra.addFlashAttribute("message", "삭제가 완료되었습니다!");
			goPage = "redirect:/board/free/list";
		}else {
			log.info("삭제 중 오류가 발생했습니다 메시지 실행...!");
			ra.addFlashAttribute("message", "삭제 중 오류가 발생했습니다!");
			goPage = "redirect:/board/detail?boardNo="+boardNo;
		}
	}else {
		log.info("삭제권한이 없습니다 메시지 실행...!");
		ra.addFlashAttribute("message", "삭제권한이 없습니다!");
		goPage = "redirect:/board/detail?boardNo="+boardNo;
	}
		
		return goPage;
	}
	
	
	@RequestMapping(value="/updateBoardAttach", method = RequestMethod.POST)
	public String updateBoardAttach(Board board, Model model, BoardAttach boardAttach) {
		log.info("updateBoardAttach() 실행...!");
		String goPage = "";
		
		ModelAndView mav = new ModelAndView("redirect:/board/updateBoardAttach");
		mav.addObject("idx", board.getBoardNo());
		
		int status = boardService.updateBoardAttach(board, boardAttach);
		if(status > 0) {
			goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
		}else {
			model.addAttribute("board", board);
			model.addAttribute("status", "u");
			goPage = "board/free/form";
		}
		return goPage;
	}
	

	
    @PostMapping("/deleteFile")
    @ResponseBody
    public ResponseEntity<String> deleteFile(@RequestParam("fileNo") int fileNo) {
        try {
            // 파일 삭제 로직을 작성 (파일 번호를 이용하여 삭제)
            // ...

            return new ResponseEntity<>("File deleted successfully", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Error deleting file", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
	
	//========================================파일업로드========================================
	
	@RequestMapping(value="/download.do", method = RequestMethod.GET)
	public ResponseEntity<byte[]> fileDownload(@RequestParam(name = "fileNo") Optional<Integer> fileNo) throws Exception {
		
	    Integer fileId = fileNo.get();
	    InputStream in = null;
	    ResponseEntity<byte[]> entity = null;

	    try {
	        String fileName = null;
	        BoardAttach fileVO = boardService.selectFileInfo(fileId);
	        log.info("==============");
	        log.info(fileVO.getFileName());
	        log.info("==============");
	        
	        if (fileVO != null) {
	            fileName = fileVO.getFileName();
	            String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
	            MediaType mType = MediaUtils.getMediaType(formatName);
	            HttpHeaders headers = new HttpHeaders();
	            in = new FileInputStream(fileVO.getFileSavepath());

	            fileName = fileName.substring(fileName.indexOf("_") + 1);
	            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
	            headers.add("Content-Disposition", "attachment; filename=\"" +
	                    new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");

	            entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
	        } else {
	            // 파일이 존재하지 않는 경우
	            entity = new ResponseEntity<>(HttpStatus.NOT_FOUND);
	        }
	    } catch (Exception e) {
	        // 예외 처리
	        e.printStackTrace();
	        entity = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	    } finally {
	        if (in != null) {
	            in.close();
	        }
	    }

	    return entity;
	}
	
	@ResponseBody
	@RequestMapping(value="/uploadAjax", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	public ResponseEntity<String> uploadAjax(MultipartFile file) throws Exception{
		log.info("uploadAjax() 실행...!");
		log.info("originalName : " + file.getOriginalFilename());
		
		// savedName은 /2023/12/04/UUID_원본파일명을 리턴한다.
		String savedName = UploadFileUtils.uploadFile(resourcePath, file.getOriginalFilename(), file.getBytes());
		
		return new ResponseEntity<String>(savedName, HttpStatus.OK);
	}
	
	@ResponseBody
	@RequestMapping(value="/displayFile", method = RequestMethod.GET)
	public ResponseEntity<byte[]> display(String fileName) throws Exception{
		log.info("display() 실행...!");
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		log.info("fileName : " + fileName);
		
		try {
			String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
			MediaType mType = MediaUtils.getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(resourcePath + "/" + fileName);
			
			if(mType != null) {	// 이미지 파일일때
				headers.setContentType(mType);
			}else {				// 이미지 파일이 아닐때
				fileName = fileName.substring(fileName.indexOf("_") + 1);
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				headers.add("Content-Disposition", "attachment; filename=\"" +
						new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
			}
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}finally {
			in.close();
		}
		return entity;
	}
	
	//========================================댓글기능========================================
	
	@RequestMapping(value="/replyInsert", method = RequestMethod.POST)
	public String replyInsert(@ModelAttribute Reply reply, Model model) {
	    log.info("replyInsert() 실행...!");
		
		log.info("replyInsert reply : " + reply);

	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    Employee employee = user.getEmployee();
		String goPage = "";

	    log.info("replyContent: " + reply.getReplyContent());
	    log.info("empNo: " + reply.getEmpNo());
	    log.info("boardNo: " + reply.getBoardNo());
	    
	    if(employee != null) {
	    	reply.setEmpNo(employee.getEmpNo());
	    	int status = replyService.replyInsert(reply);
	    	if(status > 0) {
	    		goPage = "redirect:/board/detail?boardNo="+reply.getBoardNo();
	    		log.info("==========");
	    		log.info(goPage);
	    		log.info("==========");
	    	}else {
	    		
	    		goPage = "redirect:/board/detail?boardNo="+reply.getBoardNo() + "&error=true";
	    	}
	    	log.info("Inserting board reply:"+reply);
	    }
	    return goPage;
	}
	
	@ResponseBody
	@RequestMapping(value="/replyDelete", method = RequestMethod.POST)
	public String replyDelete(@RequestBody Map<String, String> paramMap) {
	    log.info("replyDelete() 실행...!");
	    ServiceResult result = null;
	    // Optional의 값이 존재할 경우에만 삭제 로직을 수행
	    String replyNo = paramMap.get("replyNo");
	    if (replyNo != null) {
	        int status = replyService.replyDelete(Integer.parseInt(replyNo));
	        if(status > 0) {
	        	result = ServiceResult.OK;
	        }else {
	        	result = ServiceResult.FAILED;
	        }
	    }
	    return result.toString();
	}

	@RequestMapping(value="/replyUpdate", method = RequestMethod.GET)
	public String replyUpdateForm(int boardNo, Model model ) {
		log.info("replyUpdateForm() 실행...!");
		Board board = replyService.replyDetail(boardNo);
		model.addAttribute("board", board);
		model.addAttribute("status", "u");
		return "board/free/form";
	}
	
	@RequestMapping(value="/replyUpdate", method = RequestMethod.POST)
	public String replyUpdate(Board board, Model model, int boardNo) {
		log.info("replyUpdate() 실행...!");
		List<BoardAttach> boardAttachList = boardService.detail2(boardNo);
		
		String goPage = "";
		int status = replyService.replyUpdate(board);
		if(status > 0) {
			goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
		}else {
			model.addAttribute("board", board);
			model.addAttribute("status", "u");
			goPage = "board/free/form";
		}
		return goPage;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}























