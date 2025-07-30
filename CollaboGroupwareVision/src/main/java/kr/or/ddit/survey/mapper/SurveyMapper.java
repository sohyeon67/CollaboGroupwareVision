package kr.or.ddit.survey.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.board.vo.PaginationInfo;
import kr.or.ddit.survey.vo.Survey;
import kr.or.ddit.survey.vo.SurveyOption;
import kr.or.ddit.survey.vo.SurveyQuestion;

@Mapper
public interface SurveyMapper {

	public int surveyInsert(Survey survey);

	public int surveyQuestionInsert(SurveyQuestion surveyQuestion);

	public int surveyOptionInsert(SurveyQuestion survey);

	public List<Survey> surveyList();

	public Survey surveyDetail(int surveyNo);

	public Object totalEmpNo(int surveyNo);

	public Object selectEmpNo(SurveyOption surveyOption);

	
	
//	public List<Survey> ongoingSurveyList(PaginationInfo<Survey> pagingVO);
//	public int ongoingSurveyListCount(PaginationInfo<Survey> pagingVO);
//	public int closedSurveyListCount(PaginationInfo<Survey> pagingVO);
//	public List<Survey> closedSurveyList(PaginationInfo<Survey> pagingVO);
//	
//	public int surveyInsert(Survey survey);
//	public int surveyQuestionInsert(SurveyQuestion surveyQuestion);
//	public int surveyOptionInsert(SurveyQuestion surveyQuestion);
	
//	public int insert(Board board);
//	public Board detail(int boardNo);
//	public int update(Board board);
//	public int update2(int boardNo);
//	
//	public int insert2(BoardAttach boardAttach);
//	public List<BoardAttach> detail2(int boardNo);
//	
//	public int replyInsert(Reply reply);
//	public List<BoardAttach> selectAttachList(Map<String, Object> paramMap);
//	
//	public int delete(int boardNo);
//	public int updateBoardAttach(Board board);
//	public int updateBoardAttach(BoardAttach boardAttach);
	
	/*
	 * @Delete("deleteBoardAttach") public void deleteBoardAttach(int boardNo);
	 */
	
	/*
	 * @Delete("DELETE FROM board WHERE board_no = #{boardNo}") int deleteBoard(int
	 * boardNo);
	 * 
	 * @Delete("DELETE FROM board_attach WHERE board_no = #{boardNo}") void
	 * deleteBoardAttach(int boardNo);
	 */

	
}
