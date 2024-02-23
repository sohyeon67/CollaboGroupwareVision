package kr.or.ddit.survey.service;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.survey.mapper.SurveyMapper;
import kr.or.ddit.survey.vo.Survey;
import kr.or.ddit.survey.vo.SurveyOption;
import kr.or.ddit.survey.vo.SurveyQuestion;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class SurveyServiceImpl {

	@Inject
	private SurveyMapper surveyMapper;

	public int surveyInsert(Survey survey) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		CustomUser cus = (CustomUser) auth.getPrincipal();
		Employee emp = cus.getEmployee();
		
		survey.setEmpNo(emp.getEmpNo());
		
		int rlt = this.surveyMapper.surveyInsert(survey);
		
		List<SurveyQuestion> qItemList = survey.getSurveyQuestionList();
		
		for(int i=0; i<qItemList.size();i++) {
			rlt += this.surveyMapper.surveyQuestionInsert(qItemList.get(i));
			rlt += this.surveyMapper.surveyOptionInsert(qItemList.get(i));
		}
		
		log.info("result>> "+rlt);
		
		return rlt;
	}

	public List<Survey> surveyList() {
		return this.surveyMapper.surveyList();
	}

	public Survey surveyDetail(int surveyNo) {
		//설문지 받아오기
		Survey survey = this.surveyMapper.surveyDetail(surveyNo);
		//전체 인원 수 받아오기
		survey.setTotalEmpNo((int) this.surveyMapper.totalEmpNo(surveyNo));
		log.info("survey>> "+survey);
		
		//가라 List
		List<SurveyQuestion> questionItemList = survey.getSurveyQuestionList();
		List<SurveyQuestion> temp = new ArrayList<SurveyQuestion>();
		//전체 설문질문 받아오기
		for(SurveyQuestion surveyQuestion:questionItemList) {
			log.info("surveyQuestion>> "+surveyQuestion);
			//설문질문 속 각각의 질문으로, 설문질문 받아오고 vo 속에 보기 넣기
			for(SurveyOption surveyOption:surveyQuestion.getSurveyOptionList()) {
				surveyOption.setSelectEmpNo((int) this.surveyMapper.selectEmpNo(surveyOption));
				log.info("sOption>> "+surveyOption);
			}
			//설문지에 대한 전체 설문질문과 각각의 질문에 맞는 문항 세팅이 끝난 것은 List<ServeyQItemVO> temp 속에 담기
			temp.add(surveyQuestion);
		}
		log.info("temp>> "+temp);
		//설문지 완성!
		survey.setSurveyQuestionList(temp);
		return survey;
	}

	
	
//	@Override
//	public List<Survey> ongoingSurveyList(PaginationInfo<Survey> pagingVO) {
//		return mapper.ongoingSurveyList(pagingVO);
//	}
//	@Override
//	public int ongoingSurveyListCount(PaginationInfo<Survey> pagingVO) {
//		log.info("BoardServiceImpl listCount() 실행...!");
//		return mapper.ongoingSurveyListCount(pagingVO);
//	}
//	@Override
//	public int closedSurveyListCount(PaginationInfo<Survey> pagingVO) {
//		return mapper.closedSurveyListCount(pagingVO);
//	}
//	@Override
//	public List<Survey> closedSurveyList(PaginationInfo<Survey> pagingVO) {
//		return mapper.closedSurveyList(pagingVO);
//	}
//	@Override
//	public int surveyInsert(Survey survey) {
//		return mapper.surveyInsert(survey);
//	}
//	@Override
//	public int surveyQuestionInsert(SurveyQuestion surveyQuestion) {
//		return mapper.surveyQuestionInsert(surveyQuestion);
//	}
//	@Override
//	public int surveyOptionInsert(SurveyQuestion surveyQuestion) {
//		return mapper.surveyOptionInsert(surveyQuestion);
//	}
	
	
	
//	@Override
//	public List<Survey> selectAttachList(Map<String, Object> paramMap) {
//		// TODO Auto-generated method stub
//		return null;
//	}
	
//	@Override
//	public int insert(Board board, HttpServletRequest req) {
//		log.info("BoardServiceImpl insert() 실행...!");
//		int status = mapper.insert(board);
//		if(status > 0) {	// 게시글 등록이 성공햇을 때
//			List<BoardAttach> boardAttachList = board.getBoardAttachList();			
//			log.debug("체킁 1: {}",boardAttachList);
//			
//			 try {
//				 //공지사항 파일 업로드
//				boardFileUpload(boardAttachList, board.getBoardNo(), req);
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		}
//		
//		return status;
//	}
//	
//	private void boardFileUpload(List<BoardAttach> boardAttachList, int boardNo, HttpServletRequest req) throws IOException {
//		log.info("BoardServiceImpl boardFileUpload() 실행...!");
//		String savePath = "/resources/free/" + boardNo;
//		
//		String saveUploadPath = req.getServletContext().getRealPath(savePath);
//		String saveLocate = "";	// 최종적으로 저장하게될 경로 
//		
//		log.debug("체킁 2: {}",boardAttachList);
//		
//		File saveUploadFolder = new File(saveUploadPath);
//		if(!saveUploadFolder.exists()) {
//			saveUploadFolder.mkdirs();
//		}
//		
//		if(boardAttachList != null) {	//넘겨받은 파일 데이터가 존재할 때
//			if(boardAttachList.size() > 0) {
//				for(BoardAttach boardAttach : boardAttachList) {
//					String saveName = UUID.randomUUID().toString();	// UUID의 랜덤 파일명 생성
//					
//					// 파일명을 설정할 때, 원본 파일명의 공백을 "_"로 변경한다.
//					saveName = saveName + "_" + boardAttach.getFileName().replaceAll(" ", "_");
//					// 디버깅 및 확장자 추출 참고
//					String endFilename = boardAttach.getFileName().split("\\.")[1];	
//
//					saveLocate = saveUploadPath + "/" + saveName;
//
//					boardAttach.setBoardNo(boardNo);// 게시글 번호 설정
//					boardAttach.setFileSavepath(saveLocate);	// 파일 업로드 경로 설정
//					mapper.insert2(boardAttach);	// 게시글 파일 데이터 추가
//					
//					
//					log.debug("요긴강:" + saveLocate);
//					
//					// 방법 1
//					File saveFile = new File(saveLocate);
////					InputStream is = noticeFileVO.getItem().getInputStream();
////					FileUtils.copyInputStreamToFile(is, saveFile);
//					
//					log.debug("요긴강2:" + saveFile);
//					// 방법2
//					boardAttach.getItem().transferTo(saveFile); 	// 파일 복사
//				}
//			}
//		}
//	}
//
//	@Override
//	public Board detail(int boardNo) {
//		log.info("BoardServiceImpl detail() 실행...!");
//		return mapper.detail(boardNo);
//	}
//
//	@Override
//	public int update(Board board) {
//		log.info("BoardServiceImpl update() 실행...!");
//		return mapper.update(board);
//	}
//
//	@Override
//	public int update2(int boardNo) {
//		log.info("BoardServiceImpl update2() 실행...!");
//		return mapper.update2(boardNo);
//	}
//
//	@Override
//	public int delete(int boardNo) {
//		log.info("BoardServiceImpl delete() 실행...!");
//		return mapper.delete(boardNo);
//	}
//
//
//	@Override
//	public int insert2(BoardAttach boardAttach) {
//		log.info("BoardServiceImpl insert2() 실행...!");
//		return mapper.insert2(boardAttach);
//	}
//	
//	@Transactional
//	public void insertBoardWithFile(Board board, BoardAttach boardAttach) {
//		log.info("BoardServiceImpl insertBoardWithFile() 실행...!");
//	    // 부모 테이블에 데이터 삽입
//	    int status = mapper.insert(board);
//	    log.info("board:"+board);
//	    if(status > 0) {
//	    	// 부모 테이블의 BOARD_NO 값을 자식 테이블에 설정
//	    	boardAttach.setBoardNo(board.getBoardNo());
//	    	
//	    	// 자식 테이블에 데이터 삽입
//	    	mapper.insert2(boardAttach);
//	    }
//	    
//	}
//
//	@Override
//	public List<BoardAttach> detail2(int boardNo) {
//		log.info("BoardServiceImpl detail2() 실행...!");
//		return mapper.detail2(boardNo);
//	}
//
//	@Override
//	public BoardAttach getBoardAttach(int boardNo) {
//		log.info("BoardServiceImpl getBoardAttach() 실행...!");
//		return null;
//	}
//	
//	
//
//	@Override
//	public int replyInsert(Reply reply) {
//		return mapper.replyInsert(reply);
//	}
//	
//	@Override
//	@Transactional
//	public int updateBoardAttach(Board board, BoardAttach boardAttach) {
//	    try {
//	        // 게시글 정보 업데이트
//	        int updatedBoard = mapper.update(board);
//
//	        // 첨부 파일 정보 업데이트
//	        int updatedBoardAttach = mapper.updateBoardAttach(boardAttach);
//
//	        return updatedBoard + updatedBoardAttach; // 성공하면 2, 실패하면 0
//	    } catch (Exception e) {
//	        // 예외 발생 시 롤백
//	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
//	        throw e;
//	    }
//	}
//
//	@Override
//	public int updateBoardAttach(Board board) {
//		return mapper.updateBoardAttach(board);
//	}









	




	/*
	 * @Transactional public void deleteBoard(int boardNo) { // 자식 테이블 레코드 삭제
	 * mapper.deleteBoardAttach(boardNo);
	 * 
	 * // 부모 테이블 레코드 삭제 mapper.deleteBoard(boardNo); }
	 */


}
