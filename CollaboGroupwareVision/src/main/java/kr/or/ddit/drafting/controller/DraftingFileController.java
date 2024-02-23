package kr.or.ddit.drafting.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.drafting.service.DraftingService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/drafting")
public class DraftingFileController {

	@Inject
	private DraftingService draftingService;
	
	@ResponseBody
    @PostMapping(value="/uploadAjax")
    public ResponseEntity<Map<String, Object>> uploadAjax(HttpServletRequest req, 
    		@RequestParam MultipartFile file, 
    		@RequestParam String drftNo) throws Exception {   // 키 이름이 file
       log.info("originalName : " + file.getOriginalFilename());
       
       String originalName = file.getOriginalFilename();
       String savePath = "/resources/drafting/";
       String resourcePath = req.getServletContext().getRealPath(savePath + drftNo); 
       String drftSavePath = drftUploadFile(resourcePath, file.getOriginalFilename(), file.getBytes());
       String mime = file.getContentType();
       long fileSize = file.getSize();
       String fancySize = FileUtils.byteCountToDisplaySize(fileSize);
       String dbPath = "";
       
	   if (drftSavePath.indexOf("/resources") != -1) {
		   int startIndex = drftSavePath.indexOf("/resources");
		   dbPath = drftSavePath.substring(startIndex);
	    }
    		   
    		   
       log.debug("resourcePath 값 "+ resourcePath);
       //D:\A_TeachingMaterial\07_JSP_Spring\workspace\workspace_spring2\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\CollaboGroupwareVision\resources\drafting
       log.debug("drftSavePath 값 "+drftSavePath);
       // /2024/01/25/69e0577f-bdbf-4655-8386-f32308a5ff17_참고.txt
       log.debug("drftNo 값" + drftNo); // 20240125-0008
       log.debug("mime 값" + mime); // text/plain
       log.debug("fileSize 값" + fileSize); // 749
       log.debug("fancySize 값" + fancySize); // 749 bytes
       log.debug("dbPath 값: " + dbPath); // /resources/~~
       
       Map<String, Object> responseMap = new HashMap<>();
       
       responseMap.put("mime", mime);
       responseMap.put("drftNo", drftNo);
       responseMap.put("originalName", originalName);
       responseMap.put("fileSize", fileSize);
       responseMap.put("fancySize", fancySize);
       responseMap.put("dbPath", dbPath);
       
       return new ResponseEntity<>(responseMap, HttpStatus.OK);
    }
	
	
    public static String drftUploadFile(String uploadPath, String originalName, byte[] fileData) throws Exception {
			// UUID 생성
			UUID uuid = UUID.randomUUID();
			
			// UUID_원본파일명
			// 원본 파일명 공백을 '_'로 변경.
			String savedName = uuid.toString() + "_" + originalName.replace(" ", "_");
			
			File file = new File(uploadPath);
			if(!file.exists()) {
				file.mkdirs();
			}
			
			// 배포된 서버 업로드 경로 + /2023/12/04/ + UUID_원본파일명으로 File target을 하나 만들어준다.
			File target = new File(uploadPath, savedName);
			FileCopyUtils.copy(fileData, target);	// 위에서 만들어진 경로와 파일명을 가지고 파일 복사를 진행한다.

			// \2023\12\04 경로를 '/' 경로로 변경 후 원본 파일명을 붙인다.
			String uploadedFileName = uploadPath.replace(File.separatorChar, '/') + "/" + savedName;
			
			
			return uploadedFileName;
		}
	
    /* Util 패키지로 이동
	 @ResponseBody
	 @RequestMapping(value="/displayFile", method = RequestMethod.GET)
	 public ResponseEntity<byte[]> display(HttpServletRequest req, String drftSavePath) throws Exception {
		  InputStream in = null;
		  ResponseEntity<byte[]> entity = null;
	      
	      log.debug("drftSavePath : " + drftSavePath);
	      
	      String resourcePath = req.getServletContext().getRealPath(drftSavePath);
	      log.debug("resourcePath : " + resourcePath);
	      
	      // 파일 이름 추출
	      String fileName = drftSavePath.substring(drftSavePath.indexOf("_") + 1);
	      try {
	         HttpHeaders headers = new HttpHeaders();
	         in = new FileInputStream(resourcePath);
	         	
	         resourcePath = resourcePath.substring(resourcePath.indexOf("_") + 1);
	         headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
	         headers.add("Content-Disposition", "attachment; filename=\"" + 
	                        new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
	         entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
	      } catch (Exception e) {
	         e.printStackTrace();
	         entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
	      } finally {
	         in.close();
	      }
	      return entity;
	   }
     */

}
