package kr.or.ddit.chat.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.chat.mapper.ChatMapper;
import kr.or.ddit.chat.vo.Chat;
import kr.or.ddit.chat.vo.ChatAttach;
import kr.or.ddit.chat.vo.ChatMem;
import kr.or.ddit.chat.vo.ChatRoom;

@Service
public class ChatServiceImpl implements ChatService{
	
	@Inject
	private ChatMapper chatMapper;
	
	// 채팅방 조회
	@Override
	public List<ChatRoom> listChatRoom(String empNo) {
		return chatMapper.listChatRoom(empNo);
	}
	
	// 채팅방 생성하기
	@Override
	public ServiceResult createChatRoom(ChatRoom chatroom){
		ServiceResult result = null;
		
		// 채팅방 생성하기
		int status = chatMapper.createChatRoom(chatroom);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		System.out.println("chatroom.getChatMemList():"+chatroom.getChatMemList());
		// 채팅 멤버 생성하기
		ChatMem chatmem = new ChatMem();
		for(int i=0; i<chatroom.getChatMemList().size(); i++) {
			chatmem.setChatroomNo(chatroom.getChatroomNo());	// 채팅방번호 설정
			chatmem.setEmpNo(chatroom.getChatMemList().get(i).getEmpNo().trim());	// 사원번호 설정
			chatMapper.createChatMember(chatmem);
		}
				
		return result;
	}

	@Override
	public List<Chat> selectChatList(int chatroomNo) {
		return chatMapper.selectChatList(chatroomNo);
	}

	@Override
	public ServiceResult createChatMessage(Chat chat) {
		ServiceResult result = null;
		
		int status = chatMapper.createChatMessage(chat);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public void deleteChatMember(int chatroomNo, String empNo) {
		int status = chatMapper.deleteChatMember(chatroomNo,empNo);
		if(status > 0) {
			chatMapper.updateChatroomMemCount(chatroomNo);
		}
	}

	@Override
	public ServiceResult deleteChat(HttpServletRequest req, int chatNo) {
		ServiceResult result = null;
	
		Chat chat = chatMapper.selectChat(chatNo);
		chatMapper.deleteChatFileByChatNo(chatNo);
		System.out.println("chat:"+chat);
		int status = chatMapper.deleteChat(chatNo);
		if(status > 0) {
			List<ChatAttach> chatAttachList = new ArrayList<ChatAttach>();
			
			if(chatAttachList != null && chatAttachList.size() > 0) {
				chatAttachList = chat.getChatAttachList();
				String[] filePath = chatAttachList.get(0).getChatFileSavepath().split("/");
				String path = filePath[0];
				deleteFolder(req, path);
			}
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	private void deleteFolder(HttpServletRequest req, String path) {
		/// UUID+원본파일명 전 폴더경로를 folder 배열객체로 잡는다.
		File folder = new File(path);
		
		if(folder.exists()) {	// 경로가 존재한다면
			File[] folderList = folder.listFiles();	// 폴더 안에 있는 파일들의 목록을 가져온다.
			
			for(int i = 0; i <folderList.length; i++) {
				if(folderList[i].isFile()) {	// 폴더 안에 파일이 파일일 때
					// 폴더 안에 파일을 차례대로 삭제
					folderList[i].delete();
				}else {
					// 폴더 안에 있는 파일이 폴더 일때 재귀함수로 호출(폴더 안으로 들어가서 새 처리할 수 있도록)
					deleteFolder(req, folderList[i].getPath());
				}
			}
			folder.delete();	// 폴더 삭제
		}
		
	}

	private void chatFileUpload(List<ChatAttach> chatAttachList, int chatNo, HttpServletRequest req) throws IOException {
		String savePath = "/resources/chat/";
		
		if(chatAttachList != null) {	//넘겨받은 파일 데이터가 존재할 때
			if(chatAttachList.size() > 0) {
				for(ChatAttach chatAttach : chatAttachList) {
					String saveName = UUID.randomUUID().toString();	// UUID의 랜덤 파일명 생성
					
					// 파일명을 설정할 때, 원본 파일명의 공백을 "_"로 변경한다.
					saveName = saveName + "_" + chatAttach.getChatFileName().replaceAll(" ", "_");
					// 디버깅 및 확장자 추출 참고
					String endFilename = chatAttach.getChatFileName().split("\\.")[1];	
					
					String saveLocate = req.getServletContext().getRealPath(savePath + chatNo);
					File file = new File(saveLocate);
					if(!file.exists()) {
						file.mkdirs();
					}
					saveLocate += "/" + saveName;
					
					chatAttach.setChatNo(chatNo);
					chatAttach.setChatFileSavepath(saveLocate);	// 파일 업로드 경로 설정
					chatMapper.insertChatFile(chatAttach);	// 게시글 파일 데이터 추가
				
					File saveFile = new File(saveLocate);
					chatAttach.getItem().transferTo(saveFile); 	// 파일 복사
				}
			}
		}
	}

	@Override
	public List<Chat> selectChatAllList() {
		return chatMapper.selectChatAllList();
	}

	@Override
	public ServiceResult createChatAttach(HttpServletRequest req, Chat chat) {
		ServiceResult result = null;
		
		int status = chatMapper.createChatMessage(chat);
		if(status > 0) {	// 게시글 등록이 성공햇을 때
			List<ChatAttach> chatAttachList = chat.getChatAttachList();
			
			try {
				 //공지사항 파일 업로드
				chatFileUpload(chatAttachList, chat.getChatNo(), req);
			} catch (IOException e) {
				e.printStackTrace();
			}
			 
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
		
	}

	@Override
	public List<ChatRoom> selectChatRoom(int chatroomNo) {
		return chatMapper.selectChatRoom(chatroomNo);
	}




}
