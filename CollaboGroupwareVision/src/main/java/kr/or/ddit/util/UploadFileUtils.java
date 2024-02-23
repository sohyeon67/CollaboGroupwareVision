package kr.or.ddit.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.imgscalr.Scalr;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UploadFileUtils {
	
	// 썸네일 생성 안하고 파일 업로드
	public static String uploadFileNotMakeThumbnail(String uploadPath, String originalName, byte[] fileData) throws Exception {
		// UUID 생성
		UUID uuid = UUID.randomUUID();
		
		// UUID_원본파일명
		String savedName = uuid.toString() + "_" + originalName;
		
		// 2023/12/04 폴더 경로를 만들고, /2023/12/04 폴더 경로를 리턴한다.
		String savedPath = calcPath(uploadPath);
		
		// 배포된 서버 업로드 경로 + /2023/12/04/ + UUID_원본파일명으로 File target을 하나 만들어준다.
		File target = new File(uploadPath + savedPath, savedName);
		FileCopyUtils.copy(fileData, target);	// 위에서 만들어진 경로와 파일명을 가지고 파일 복사를 진행한다.
		
		// \2023\12\04 경로를 '/' 경로로 변경 후 원본 파일명을 붙인다.
		String uploadedFileName = savedPath.replace(File.separatorChar, '/') + "/" + savedName;
		
		return uploadedFileName;
	}

	public static String uploadFile(String uploadPath, String originalName, byte[] fileData) throws Exception {
		// UUID 생성
		UUID uuid = UUID.randomUUID();
		
		// UUID_원본파일명
		String savedName = uuid.toString() + "_" + originalName;
		
		// 2023/12/04 폴더 경로를 만들고, /2023/12/04 폴더 경로를 리턴한다.
		String savedPath = calcPath(uploadPath);
		
		// 배포된 서버 업로드 경로 + /2023/12/04/ + UUID_원본파일명으로 File target을 하나 만들어준다.
		File target = new File(uploadPath + savedPath, savedName);
		FileCopyUtils.copy(fileData, target);	// 위에서 만들어진 경로와 파일명을 가지고 파일 복사를 진행한다.
		
		String formatName = originalName.substring(originalName.lastIndexOf(".") + 1);	// 확장자 추출
		
		// \2023\12\04 경로를 '/' 경로로 변경 후 원본 파일명을 붙인다.
		String uploadedFileName = savedPath.replace(File.separatorChar, '/') + "/" + savedName;
		
		// 확장자가 이미지 파일이면 s_가 붙은 파일의 썸네일 이미지 파일을 생성한다.
		if(MediaUtils.getMediaType(formatName) != null) {	// 확장자를 통한 이미지 파일인지 검증
			makeThumbnail(uploadPath, savedPath, savedName);	// 썸네일 이미지 생성
		}
		
		return uploadedFileName;
	}
	
	// 썸네일 이미지 만들기
	private static void makeThumbnail(String uploadPath, String path, String fileName) throws Exception {
		// 썸네일 이미지를 만들기 위해 원본 이미지를 읽는다.
		BufferedImage sourceImg = ImageIO.read(new File(uploadPath + path, fileName));
		
		// 썸네일 이미지를 만들기 위한 설정
		// Method.AUTOMATIC : 최소 시간 내에 가장 잘 보이는 이미지를 얻기 위한 사용 방식
		// Mode.FIT_TO_HEIGHT : 이미지 방향과 상관없이 주어진 높이 내에서 가장 잘 맞는 이미지로 계산
		// targetSize : 값 100, 정사각형 사이즈로 100x100
		BufferedImage destImg = Scalr.resize(sourceImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, 100);
		
		// 업로드 한 원본 이미지를 가지고 's_'를 붙여서 임시 파일로 만들기 위해 썸네일 경로+파일명을 작성한다.
		String thumbnailName = uploadPath + path + File.separator + "s_" + fileName;
		
		File newFile = new File(thumbnailName);
		String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
		
		// 's_'가 붙은 썸네일 이미지를 만든다.
		ImageIO.write(destImg, formatName.toUpperCase(), newFile);
	}
	
	// /2023/12/04/ 경로 생성
	private static String calcPath(String uploadPath) {
		Calendar cal = Calendar.getInstance();
		String yearPath = File.separator + cal.get(Calendar.YEAR);	// 2023
		
		// DecimalFormat("00") :: 두자리에서 빈자리는 0으로 채움
		String monthPath = yearPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);	// /2023/12
		String datePath = monthPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));		// /2023/12/04
		
		// 년월일 폴더 구조에 의한 폴더 생성
		makeDir(uploadPath, yearPath, monthPath, datePath);
		return datePath;
	}
	
	// 가변인자
	// 키워드 '...'를 사용한다.
	// [사용법] 타입...변수명 형태로 사용
	// 순서대로 yearPath, monthPath, datePath가 배열로 들어가 처리
	private static void makeDir(String uploadPath, String ...paths) {
		// /2023/12/04 폴더 구조가 존재한다면 return
		// 만들려던 폴더 구조가 이미 만들어져 있는 형태니까 return
		if(new File(paths[paths.length - 1]).exists()) {
			return;
		}
		
		for(String path : paths) {
			File dirPath = new File(uploadPath + path);
			
			// /2023/12/04 와 같은 경로에 각 폴더가 없으면 각각 만들어준다.
			if(!dirPath.exists()) {
				dirPath.mkdirs();
			}
		}
	}
	
	// 비동기 업로드한 파일 다운로드
	@ResponseBody
	@RequestMapping(value = "/downloadFile", method = RequestMethod.GET)
	public ResponseEntity<byte[]> downloadFile(HttpServletRequest req, String savePath) throws Exception {
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		log.debug("경로" + savePath);
		
		String resourcePath = req.getServletContext().getRealPath(savePath);

		// 파일 이름 추출
		String fileName = savePath.substring(savePath.indexOf("_") + 1);
		try {
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(resourcePath);

			resourcePath = resourcePath.substring(resourcePath.indexOf("_") + 1);
			headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			headers.add("Content-Disposition",
					"attachment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		} finally {
			in.close();
		}
		return entity;
	}
	
	
}
