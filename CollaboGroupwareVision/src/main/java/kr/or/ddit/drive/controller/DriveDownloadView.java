package kr.or.ddit.drive.controller;

import java.io.File;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.view.AbstractView;

public class DriveDownloadView  extends AbstractView{
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Map<String, Object> driveFileMap = (Map<String, Object>) model.get("driveFileMap");
		
		File saveFile = new File(driveFileMap.get("fileSavepath").toString());
		String fileName = driveFileMap.get("fileName").toString();
		String fileSize = driveFileMap.get("fileSize").toString();
		
		// 요청 Header 정보들 중, User-Agent 영역 안에 여러 키워드 정보들을 가지고
		// 특정 키워드가 포함되어 있는지를 체크해서 파일명의 출력 인코딩 부분을 설정한다.
		// 사용 브라우저 도는 현상에 따라 발생하는 알고리즘 이므로, 
		// 내가 사용하게 되는 브라우저의 버전이나 얻어온 header 정보들의 값에 따라 차이가 발생할 수 있다.
		String agent = request.getHeader("User-Agent");
		if(StringUtils.containsIgnoreCase(agent, "msie") || StringUtils.containsIgnoreCase(agent, "trident")) {
			fileName = URLEncoder.encode(fileName, "UTF-8");		// IE, Chrome
		}else {		// firefox, chrome
			fileName = new String(fileName.getBytes(), "ISO-8859-1");
		}
		
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		response.setHeader("Content-Length", fileSize);
		
		// try with resource
		// () 안에 명시한 객체는 finally로 최종 열린 객체에 대한 close를 처리하지 않아도 자동close()가 이루어진다.
		try(
			OutputStream os = response.getOutputStream();
		) {
			FileUtils.copyFile(saveFile, os);	// 파일 다운로드
		} 
	}
}
