package kr.or.ddit.survey.controller;

import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.survey.service.SurveyServiceImpl;
import kr.or.ddit.survey.vo.Survey;
import kr.or.ddit.survey.vo.SurveyOption;
import kr.or.ddit.survey.vo.SurveyQuestion;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/survey")
public class SurveyController {
	
	@Inject
	private SurveyServiceImpl surveyServiceImpl;
	
	/**
	 * 설문조사 등록
	 * @return 설문작성 페이지로 이동
	 */
	@GetMapping("/surveyRegister")
	public String surveyRegister() {
		
		return "/survey/surveyRegister";
	}
	
	/**
	 * 설문조사 등록
	 * @param s 설문지 작성 내용(제목, 기간, 문항, 보기 등)
	 * @return 성공 메시지
	 */
	@ResponseBody
	@PostMapping("/surveySave")
	public String surveySave(@RequestBody Survey survey) {
		log.info("survey "+survey);
		
		this.surveyServiceImpl.surveyInsert(survey);
		
		return "success";
	}
	
	/**
	 * 설문조사 
	 * @param model JSP화면으로 넘겨주기 위함
	 * @return 설문조사 목록 페이지로 이동
	 */
	@GetMapping("/surveyList")
	public String surveyList(Model model){
		List<Survey> survey =  this.surveyServiceImpl.surveyList();
		model.addAttribute("data",survey);
		
		Date currentDate = new Date();
		model.addAttribute("date",currentDate);
		
		
		return "survey/surveyList";
	}
	
	/**
	 * 설문조사 내역 확인
	 * @param model JSP화면으로 넘겨주기 위함
	 * @return 설문조사 상세내역 리스트 화면 이동
	 */
	@GetMapping("/surveyListEmployee")
	public String surveyListEmployee(Model model){
		List<Survey> survey =  this.surveyServiceImpl.surveyList();
		model.addAttribute("data",survey);
		
		return "survey/surveyListEmployee";
	}
	
	/**
	 * 설문 조사 상세 내역 확인
	 * @param srvyNo 설문지 번호를 받아와 해당 설문에 대한 내역을 보여주기 위함
	 * @param model JSP화면으로 넘겨주기 위함
	 * @param serveyVO 설문의 제목과 기간 유형 안내문구 등
	 * @param serveyQItemVO 설문 질문 문항
	 * @param serveyOptionVO 설문 보기 문항
	 * @return
	 */
	@GetMapping("/surveyDetail")
	public String surveyDetail(@RequestParam("surveyNo") int surveyNo, Model model, Survey survey, SurveyQuestion surveyQuestion, SurveyOption surveyOption) {
		log.info("surveyDetail에 왔다!");
		
		Survey survey1 = this.surveyServiceImpl.surveyDetail(surveyNo);
		log.info("survey1"+survey1);
		model.addAttribute("data",survey1);
		
	
		return "survey/surveyDetail";
		
	}
	
	/**
	 * 설문조사 상세 내역 확인
	 * @param srvyNo 설문 번호
	 * @param model JSP화면으로 넘겨주기 위함
	 * @param serveyVO 해당 설문번호에 해당하는 제목, 기간, 안내 문구 등을 받아옴
	 * @param serveyQItemVO 해당 설문번호에 해당하는 질문 항목 받아옴
	 * @param serveyOptionVO 해당 설문번호에 해당하고 해당 질문 내역에 해당하는 보기정보와 해당 보기 정보 선택한 사람의 수등을 받아옴
	 * @return
	 */
	@GetMapping("/surveyDetailEmployee")
	public String surveyDetailEmployee(@RequestParam("surveyNo") int surveyNo, Model model, Survey survey, SurveyQuestion surveyQuestion, SurveyOption surveyOption) {
		log.info("surveyDetailEmployee에 왔다!");
		
		Survey survey1 = this.surveyServiceImpl.surveyDetail(surveyNo);
		model.addAttribute("data",survey1);
		
		return "survey/surveyDetailEmployee";
		
	}
	
//	@Inject
//	private SurveyService surveyService;
//	
////	// root-context.xml에서 설정한 uploadPath 빈등록 path 경로를 사용한다.
////	@Resource(name="uploadPath")
////	private String resourcePath;
////	
////	private static final Logger logger = LoggerFactory.getLogger(SurveyController.class);
////	
//	@RequestMapping(value="/ongoingSurvey", method = RequestMethod.GET)
//	public String ongoingSurveyList(
//			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
//			@RequestParam(required = false, defaultValue = "title") String searchType,
//			@RequestParam(required = false) String searchWord,
//			Model model
//			
//		) {
//		// 페이징 처리 시작
//		PaginationInfo<Survey> pagingVO = new PaginationInfo<Survey>();
//		
//		if(StringUtils.isNotBlank(searchWord)) {
//			pagingVO.setSearchType(searchType);
//			pagingVO.setSearchWord(searchWord);
//			model.addAttribute("searchType", searchType);
//			model.addAttribute("searchWord", searchWord);
//		}
//		pagingVO.setCurrentPage(currentPage);
//		
//		int totalRecord = surveyService.ongoingSurveyListCount(pagingVO);	// 총 게시글 수 가져오기
//		pagingVO.setTotalRecord(totalRecord);
//		
//		List<Survey> dataList = surveyService.ongoingSurveyList(pagingVO);
//		pagingVO.setDataList(dataList);
//		
//		Map<String, Object> paramMap = new HashMap<String, Object>();
//		// 페이징VO를 구성하면서 얻어온 ScreenSize만큼의 게시글 데이터중에서 startRow에 해당하는 글번호와 endRow에 해당하는 글번호 사이에 있는 파일들을 전부 가져온다
//		
//		model.addAttribute("pagingVO", pagingVO);
//		// 페이징 처리 끝
//		
//		model.addAttribute("title","자유게시판");
//		model.addAttribute("activeMain","board");
//		model.addAttribute("active","free");
//		
//		// 상품 분류별 거래처 목록 행의 수
//		log.info("currentPage:"+currentPage);
//		log.info("searchType:"+searchType);
//		log.info("searchWord:"+searchWord);
//		log.info("pagingVO:"+pagingVO);
//		
//		return "survey/ongoingSurvey";
//	}
//	
//	@RequestMapping(value="/closedSurvey", method = RequestMethod.GET)
//	public String closedSurveyList(
//			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
//			@RequestParam(required = false, defaultValue = "title") String searchType,
//			@RequestParam(required = false) String searchWord,
//			Model model
//			
//			) {
//		// 페이징 처리 시작
//		PaginationInfo<Survey> pagingVO = new PaginationInfo<Survey>();
//		
//		if(StringUtils.isNotBlank(searchWord)) {
//			pagingVO.setSearchType(searchType);
//			pagingVO.setSearchWord(searchWord);
//			model.addAttribute("searchType", searchType);
//			model.addAttribute("searchWord", searchWord);
//		}
//		pagingVO.setCurrentPage(currentPage);
//		
//		int totalRecord = surveyService.closedSurveyListCount(pagingVO);	// 총 게시글 수 가져오기
//		pagingVO.setTotalRecord(totalRecord);
//		
//		List<Survey> dataList = surveyService.closedSurveyList(pagingVO);
//		pagingVO.setDataList(dataList);
//		
//		Map<String, Object> paramMap = new HashMap<String, Object>();
//		// 페이징VO를 구성하면서 얻어온 ScreenSize만큼의 게시글 데이터중에서 startRow에 해당하는 글번호와 endRow에 해당하는 글번호 사이에 있는 파일들을 전부 가져온다
//		
//		model.addAttribute("pagingVO", pagingVO);
//		// 페이징 처리 끝
//		
//		model.addAttribute("title","자유게시판");
//		model.addAttribute("activeMain","board");
//		model.addAttribute("active","free");
//		
//		// 상품 분류별 거래처 목록 행의 수
//		log.info("currentPage:"+currentPage);
//		log.info("searchType:"+searchType);
//		log.info("searchWord:"+searchWord);
//		log.info("pagingVO:"+pagingVO);
//		
//		return "survey/closedSurvey";
//	}
//	
//	@RequestMapping(value="/form", method = RequestMethod.GET)
//	public String surveyForm() {
//		log.info("surveyForm() 실행...!");
//		return "survey/form";
//	}
//	
//	@GetMapping("/surveyInsert")
//	public String surveyInsert(Survey survey, Model model) {
//		
//		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
//		CustomUser cus = (CustomUser) auth.getPrincipal();
//		Employee emp = cus.getEmployee();
//		
//		survey.setEmpNo(emp.getEmpNo());
//		
//		int result = this.surveyService.surveyInsert(survey);
//		
//		List<SurveyQuestion> questionList = survey.getSurveyQuestionList();
//		
//		for(int i=0; i<questionList.size();i++) {
//			result += this.surveyService.surveyQuestionInsert(questionList.get(i));
//			result += this.surveyService.surveyOptionInsert(questionList.get(i));
//		}
//		
//		return "/survey/surveyInsert";
//	}
	
//	@RequestMapping(value="/insert", method = RequestMethod.POST)
//	public String insert(@ModelAttribute Board board, Model model, 
//			RedirectAttributes ra, @ModelAttribute BoardAttach boardAttach, MultipartFile[] boFile,
//			HttpServletRequest req) {
//		log.info("insert() 실행...!{}",board );
//		
//		// 넘겨받은 데이터 검증 후, 에러가 발생한 데이터에 대한 에러정보를 담을 공간
//		Map<String, String> errors = new HashMap<String, String>();
//		
//		String goPage = "";
//		log.info("제목:"+board.getBoardTitle());
//		log.info("내용:"+board.getBoardContent());
//		log.info("번호:"+board.getBoardNo());
//		board.setBoFile(boFile);
//		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//		Employee employee = user.getEmployee();
//		board.setEmpNo(employee.getEmpNo());
//        
//        if(employee != null) {
//		    board.setBoardCode(2);
//			int status = boardService.insert(board, req);
//			if(status > 0) {
//				
//				goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
//			}else {
//				model.addAttribute("board", board);
//				goPage = "board/free/form";
//			}
//			log.info("Inserting board:"+board);
//		} /*
//			 * else { ra.addFlashAttribute("message","로그인 후에 사용이 가능합니다!"); goPage =
//			 * "/accounts/login"; }
//			 */
//		return goPage;
//	}
//	
//	@RequestMapping(value="/detail", method = RequestMethod.GET)
//	public String detail(int boardNo, Model model, @ModelAttribute Reply reply) {
//		log.info("detail() 실행...!");
////		log.debug("bno"+boardNo);
//		boardService.update2(boardNo);           // 조회수 증가
//		Board board = boardService.detail(boardNo);
//		List<BoardAttach> boardAttachList = boardService.detail2(boardNo);
//		model.addAttribute("board", board);
//		model.addAttribute("boardAttachList", boardAttachList);
//		
//		model.addAttribute("replyList", replyService.replyList(board.getBoardNo()));
//		model.addAttribute("reply", reply);
//		
//		List<Reply> replyList = replyService.replyList(board.getBoardNo());
//		model.addAttribute("replyList", replyList);
//		
//		log.info("board : "+board);
//		log.info("boardAttachList : "+boardAttachList);
//		log.info("reply : "+reply);
//		log.info("replyList : "+replyList);
//		
//		return "board/free/detail";
//	}
//	
//	@RequestMapping(value="/update", method = RequestMethod.GET)
//	public String updateForm(int boardNo, Model model ) {
//		log.info("updateform() 실행...!");
//		Board board = boardService.detail(boardNo);
//		model.addAttribute("board", board);
//		model.addAttribute("status", "u");
//		return "board/free/form";
//	}
//	
//	@RequestMapping(value="/update", method = RequestMethod.POST)
//	public String update(Board board, Model model, int boardNo) {
//		log.info("update() 실행...!");
//		List<BoardAttach> boardAttachList = boardService.detail2(boardNo);
//		
//		String goPage = "";
//		int status = boardService.update(board);
//		if(status > 0) {
//			goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
//		}else {
//			model.addAttribute("board", board);
//			model.addAttribute("status", "u");
//			goPage = "board/free/form";
//		}
//		return goPage;
//	}
//	
//	@RequestMapping(value="/updateBoardAttach", method = RequestMethod.POST)
//	public String updateBoardAttach(Board board, Model model, BoardAttach boardAttach) {
//		log.info("updateBoardAttach() 실행...!");
//		String goPage = "";
//		
//		ModelAndView mav = new ModelAndView("redirect:/board/updateBoardAttach");
//		mav.addObject("idx", board.getBoardNo());
//		
//		int status = boardService.updateBoardAttach(board, boardAttach);
//		if(status > 0) {
//			goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
//		}else {
//			model.addAttribute("board", board);
//			model.addAttribute("status", "u");
//			goPage = "board/free/form";
//		}
//		return goPage;
//	}
//	
//	@RequestMapping(value="/delete", method = RequestMethod.POST)
//	public String delete(int boardNo) {
//		log.info("delete() 실행...!");
//		String goPage = "";
//		int status = boardService.delete(boardNo);
//		if(status > 0) {
//			goPage = "redirect:/board/free/list";
//		}else {
//			goPage = "redirect:/board/detail?boardNo="+boardNo;
//		}
//		return goPage;
//	}
//	
//	@ResponseBody
//	@RequestMapping(value="/uploadAjax", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
//	public ResponseEntity<String> uploadAjax(MultipartFile file) throws Exception{
//		log.info("uploadAjax() 실행...!");
//		log.info("originalName : " + file.getOriginalFilename());
//		
//		// savedName은 /2023/12/04/UUID_원본파일명을 리턴한다.
//		String savedName = UploadFileUtils.uploadFile(resourcePath, file.getOriginalFilename(), file.getBytes());
//		
//		return new ResponseEntity<String>(savedName, HttpStatus.OK);
//	}
//	
//	@ResponseBody
//	@RequestMapping(value="/displayFile", method = RequestMethod.GET)
//	public ResponseEntity<byte[]> display(String fileName) throws Exception{
//		log.info("display() 실행...!");
//		InputStream in = null;
//		ResponseEntity<byte[]> entity = null;
//		
//		log.info("fileName : " + fileName);
//		
//		try {
//			String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
//			MediaType mType = MediaUtils.getMediaType(formatName);
//			HttpHeaders headers = new HttpHeaders();
//			in = new FileInputStream(resourcePath + "/" + fileName);
//			
//			if(mType != null) {	// 이미지 파일일때
//				headers.setContentType(mType);
//			}else {				// 이미지 파일이 아닐때
//				fileName = fileName.substring(fileName.indexOf("_") + 1);
//				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
//				headers.add("Content-Disposition", "attachment; filename=\"" +
//						new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
//			}
//			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
//		} catch (Exception e) {
//			e.printStackTrace();
//			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
//		}finally {
//			in.close();
//		}
//		return entity;
//	}
//	
//	//========================================댓글기능========================================
//	
//	@RequestMapping(value="/replyInsert", method = RequestMethod.POST)
//	public String replyInsert(@ModelAttribute Reply reply, Model model) {
//	    log.info("replyInsert() 실행...!");
//		
//		log.info("replyInsert reply : " + reply);
//
//	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//	    Employee employee = user.getEmployee();
//		String goPage = "";
//
//	    log.info("replyContent: " + reply.getReplyContent());
//	    log.info("empNo: " + reply.getEmpNo());
//	    log.info("boardNo: " + reply.getBoardNo());
//	    
//	    if(employee != null) {
//	    	reply.setEmpNo(employee.getEmpNo());
//	    	int status = replyService.replyInsert(reply);
//	    	if(status > 0) {
//	    		goPage = "redirect:/board/detail?boardNo="+reply.getBoardNo();
//	    		log.info("==========");
//	    		log.info(goPage);
//	    		log.info("==========");
//	    	}else {
//	    		
//	    		goPage = "redirect:/board/detail?boardNo="+reply.getBoardNo() + "&error=true";
//	    	}
//	    	log.info("Inserting board reply:"+reply);
//	    }
//	    return goPage;
//	}
//	
////	@RequestMapping(value="/replyDelete", method = RequestMethod.POST)
////	public String replyDelete(int boardNo) {
////		log.info("replyDelete() 실행...!");
////		String goPage = "";
////		int status = replyService.noticeReplyDelete(boardNo);
////		if(status > 0) {
////			goPage = "redirect:/board/free/list";
////		}else {
////			goPage = "redirect:/board/detail?boardNo="+boardNo;
////		}
////		return goPage;
////	}
//	
//	@RequestMapping(value="/replyDelete", method = RequestMethod.POST)
//	public String replyDelete(@RequestParam(name = "replyNo") Optional<Integer> replyNo) {
//	    log.info("replyDelete() 실행...!");
//	    String goPage = "";
//	    
//	    // Optional의 값이 존재할 경우에만 삭제 로직을 수행
//	    if (replyNo.isPresent()) {
//	    	log.info(Integer.toString(replyNo.get()));
//	        int status = replyService.replyDelete(replyNo.get());
//	        goPage = "redirect:/board/detail?boardNo="+ 270;
//	    }
//	    return goPage;
//	}
//
//	@RequestMapping(value="/replyUpdate", method = RequestMethod.GET)
//	public String replyUpdateForm(int boardNo, Model model ) {
//		log.info("replyUpdateForm() 실행...!");
//		Board board = replyService.replyDetail(boardNo);
//		model.addAttribute("board", board);
//		model.addAttribute("status", "u");
//		return "board/free/form";
//	}
//	
//	@RequestMapping(value="/replyUpdate", method = RequestMethod.POST)
//	public String replyUpdate(Board board, Model model, int boardNo) {
//		log.info("replyUpdate() 실행...!");
//		List<BoardAttach> boardAttachList = boardService.detail2(boardNo);
//		
//		String goPage = "";
//		int status = replyService.replyUpdate(board);
//		if(status > 0) {
//			goPage = "redirect:/board/detail?boardNo="+board.getBoardNo();
//		}else {
//			model.addAttribute("board", board);
//			model.addAttribute("status", "u");
//			goPage = "board/free/form";
//		}
//		return goPage;
//	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}























