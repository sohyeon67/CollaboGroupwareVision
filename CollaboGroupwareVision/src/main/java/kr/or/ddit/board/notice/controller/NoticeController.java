package kr.or.ddit.board.notice.controller;

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
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Auth;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.board.notice.service.NoticeService;
import kr.or.ddit.board.service.ReplyService;
import kr.or.ddit.board.vo.Board;
import kr.or.ddit.board.vo.BoardAttach;
import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.board.vo.Reply;
import kr.or.ddit.community.controller.CommunityController;
import kr.or.ddit.community.service.CmnyService;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.MediaUtils;
import kr.or.ddit.util.UploadFileUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/notice")
public class NoticeController {
	
	@Inject
	private NoticeService noticeService;
	
	@Inject
	private ReplyService replyService;
	
	// root-context.xml에서 설정한 uploadPath 빈등록 path 경로를 사용한다.
	@Resource(name="uploadPath")
	private String resourcePath;
	
	@RequestMapping(value="/noticeList",method = RequestMethod.GET)
	public String noticeList(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			Model model, Employee employee, String empName
			
		) {
		log.info("noticeList() 실행...!");

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		System.out.println("Authorities: " + authentication.getAuthorities());

	    if (authentication != null && authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
	        // ROLE_ADMIN 권한이 있는 경우
	        model.addAttribute("isAdmin", true);
	        log.info("isAdmin 권한 있음");
	    } else {
	        // ROLE_ADMIN 권한이 없는 경우
	        model.addAttribute("isAdmin", false);
	        log.info("isAdmin 권한 없음");
	    }
	    
		// 페이징 처리 시작
		PaginationInfo<Board> pagingVO = new PaginationInfo<Board>();
		
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
		pagingVO.setBoardCode(1);
		pagingVO.setCurrentPage(currentPage);
		
		int totalRecord = noticeService.noticeListCount(pagingVO);	// 총 게시글 수 가져오기
		pagingVO.setTotalRecord(totalRecord);
		
		log.info("=================");
		log.info(Integer.toString(pagingVO.getBoardCode()));
		log.info("=================");
		List<Board> dataList = noticeService.noticeList(pagingVO);
		log.info("=================");
		log.info("2222222222222");
		log.info("=================");
		pagingVO.setDataList(dataList);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("boardCode", 1);
		
		// 페이징VO를 구성하면서 얻어온 ScreenSize만큼의 게시글 데이터중에서 startRow에 해당하는 글번호와 endRow에 해당하는 글번호 사이에 있는 파일들을 전부 가져온다
		List<BoardAttach> boardAttachList = noticeService.noticeSelectAttachList(paramMap);
		
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("boardAttachList", boardAttachList);
		// 페이징 처리 끝
		
		model.addAttribute("title","자유게시판");
		model.addAttribute("activeMain","board");
		model.addAttribute("active","notice");
		
		// 상품 분류별 거래처 목록 행의 수
		log.info("currentPage:"+currentPage);
		log.info("searchType:"+searchType);
		log.info("searchWord:"+searchWord);
		log.info("pagingVO:"+pagingVO);
		
		return "notice/list";
	}
	
	@RequestMapping(value="/form", method = RequestMethod.GET)
	public String form() {
		log.info("form() 실행...!");
		return "notice/form";
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@RequestMapping(value="/insert", method = RequestMethod.POST)
	public String noticeInsert(@ModelAttribute Board board, Model model, 
			RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach, MultipartFile[] boFile,
			HttpServletRequest req, Auth auth, Principal principal, Integer noticeNo
			) {
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
        
		log.info("============================");
		log.info("test", board.getBoardCode());
		log.info("============================");

        if(employee != null) {
		    board.setBoardCode(1);
			int status = noticeService.noticeInsert(board, req);
			if(status > 0) {
				goPage = "redirect:/notice/detail?boardNo="+board.getBoardNo();
			}else {
				model.addAttribute("board", board);
				goPage = "notice/form";
			}
			log.info("Inserting board:"+board);
		}else {
	        model.addAttribute("errorMessage", "작성 권한이 없습니다.");
	        goPage = "errorPage"; // errorPage는 실제로 띄워줄 에러 페이지의 이름에 해당
		}
		return goPage;
	}
	
	@RequestMapping(value="/detail", method = RequestMethod.GET)
	public String noticeDetail(
			int boardNo, Model model, BoardAttach boardAttach,
			Employee employee, String empName
			) {
		log.info("detail() 실행...!");
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		System.out.println("Authorities: " + authentication.getAuthorities());

	    if (authentication != null && authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
	        // ROLE_ADMIN 권한이 있는 경우
	        model.addAttribute("isAdmin", true);
	        log.info("isAdmin 권한 있음");
	    } else {
	        // ROLE_ADMIN 권한이 없는 경우
	        model.addAttribute("isAdmin", false);
	        log.info("isAdmin 권한 없음");
	    }
		
//		log.debug("bno"+boardNo);
		noticeService.noticeUpdate2(boardNo);           // 조회수 증가
		
		Board board = noticeService.noticeDetail(boardNo);
		List<BoardAttach> boardAttachList = noticeService.noticeDetail2(boardNo);
		model.addAttribute("board", board);
		model.addAttribute("boardAttachList", boardAttachList);
		
//		model.addAttribute("replyList", replyService.replyList(board.getBoardNo()));
//		model.addAttribute("reply", reply);
		
//		List<Reply> replyList = replyService.replyList(board.getBoardNo());
//		model.addAttribute("replyList", replyList);
		
		log.info("board : "+board);
		log.info("boardAttachList : "+boardAttachList);
//		log.info("reply : "+reply);
//		log.info("replyList : "+replyList);
		
		return "notice/detail";
	}
	
	@RequestMapping(value="/noticeUpdate", method = RequestMethod.GET)
	public String noticeUpdateForm(int boardNo, Model model, BoardAttach boardAttach ) {
		log.info("noticeUpdateForm() 실행...!");
		Board board = noticeService.noticeDetail(boardNo);
		List<BoardAttach> boardAttachList = noticeService.noticeDetail2(boardNo);
		model.addAttribute("board", board);
		model.addAttribute("status", "u");
		model.addAttribute("boardAttachList", boardAttachList);
		return "notice/form";
	}
	
	@Transactional
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@RequestMapping(value="/noticeUpdate", method = RequestMethod.POST)
	public String noticeUpdate(
			int boardNo, @ModelAttribute Board board, Model model, 
			RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach, 
			MultipartFile[] boFile, HttpServletRequest req, Principal principal
			) throws Exception {
		log.info("noticeUpdate() 실행...!");
		String goPage = "";
		
		List<BoardAttach> boardAttachList = noticeService.noticeDetail2(boardNo);
		model.addAttribute("boardAttachList", boardAttachList);
		model.addAttribute("board", board);
		log.info("update boardAttachList : ", boardAttachList);
		
		ServiceResult result = noticeService.noticeUpdate(req, board);
		if(result.equals(ServiceResult.OK)) {
			goPage = "redirect:/notice/detail?boardNo="+board.getBoardNo();
		}else {
			model.addAttribute("board", board);
			model.addAttribute("status", "u");
			goPage = "notice/form";
		}
		return goPage;
	}
	
	@RequestMapping(value="/noticeUpdateBoardAttach", method = RequestMethod.POST)
	public String noticeUpdateBoardAttach(Board board, Model model, BoardAttach boardAttach) {
		log.info("noticeUpdateBoardAttach() 실행...!");
		String goPage = "";
		
		ModelAndView mav = new ModelAndView("redirect:/notice/noticeUpdateBoardAttach");
		mav.addObject("idx", board.getBoardNo());
		
		int status = noticeService.noticeUpdateBoardAttach(board, boardAttach);
		if(status > 0) {
			goPage = "redirect:/notice/detail?boardNo="+board.getBoardNo();
		}else {
			model.addAttribute("board", board);
			model.addAttribute("status", "u");
			goPage = "notice/form";
		}
		return goPage;
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@RequestMapping(value="/delete", method = RequestMethod.POST)
	public String noticeDelete(
			int boardNo, Board board
			) {
		log.info("delete() 실행...!");
		String goPage = "";
		
		int status = noticeService.noticeDelete(boardNo);
		if(status > 0) {
			goPage = "redirect:/notice/noticeList";
		}else {
			goPage = "redirect:/notice/detail?boardNo="+boardNo;
		}
		return goPage;
	}
	
	//========================================파일업로드========================================
	
	@RequestMapping(value="/download.do", method = RequestMethod.GET)
	public ResponseEntity<byte[]> fileDownload(@RequestParam(name = "fileNo") Optional<Integer> fileNo) throws Exception {
		
	    Integer fileId = fileNo.get();
	    InputStream in = null;
	    ResponseEntity<byte[]> entity = null;

	    try {
	        String fileName = null;
	        BoardAttach fileVO = noticeService.selectFileInfo(fileId);
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

