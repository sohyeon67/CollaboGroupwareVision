package kr.or.ddit.board.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.board.free.mapper.BoardMapper;
import kr.or.ddit.board.notice.mapper.NoticeMapper;
import kr.or.ddit.board.vo.BoardAttach;

public class FileUploadUtils {

	public static void boardFileUpload(List<BoardAttach> boardFileList, int boardNo, HttpServletRequest req,
			BoardMapper mapper) throws Exception {
		String savePath = "/resources/free/";
		
		if(boardFileList != null && boardFileList.size() > 0) {
			for(BoardAttach boardAttach : boardFileList) {
				String saveName = UUID.randomUUID().toString();
				saveName = saveName + "_" + boardAttach.getFileName().replaceAll(" ", "_");
				
				// 업로드 서버경로 + /resources/board/10
				String saveLocate = req.getServletContext().getRealPath(savePath + boardNo);
				File file = new File(saveLocate);
				if(!file.exists()) {
					file.mkdirs();
				}
				
				// saveLocate + "/" + UUID_원본파일명
				saveLocate += "/" + saveName;
				boardAttach.setBoardNo(boardNo);					// 게시글 번호 설정
				boardAttach.setFileSavepath(saveLocate);	// 파일 업로드 경로 설정
				mapper.insertBoardAttach(boardAttach);		// 공지사항 게시글 파일 데이터 추가
				
				File saveFile = new File(saveLocate);
				boardAttach.getItem().transferTo(saveFile);	// 파일복사
			}
		}
	}

	public static void noticeBoardFileUpload(List<BoardAttach> boardFileList, int boardNo, HttpServletRequest req,
			NoticeMapper mapper) throws Exception {
		String savePath = "/resources/notice/";
		
		if(boardFileList != null && boardFileList.size() > 0) {
			for(BoardAttach boardAttach : boardFileList) {
				String saveName = UUID.randomUUID().toString();
				saveName = saveName + "_" + boardAttach.getFileName().replaceAll(" ", "_");
				
				// 업로드 서버경로 + /resources/board/10
				String saveLocate = req.getServletContext().getRealPath(savePath + boardNo);
				File file = new File(saveLocate);
				if(!file.exists()) {
					file.mkdirs();
				}
				
				// saveLocate + "/" + UUID_원본파일명
				saveLocate += "/" + saveName;
				boardAttach.setBoardNo(boardNo);					// 게시글 번호 설정
				boardAttach.setFileSavepath(saveLocate);	// 파일 업로드 경로 설정
				mapper.noticeInsertBoardAttach(boardAttach);		// 공지사항 게시글 파일 데이터 추가
				
				File saveFile = new File(saveLocate);
				boardAttach.getItem().transferTo(saveFile);	// 파일복사
			}
		}

	}
	}
