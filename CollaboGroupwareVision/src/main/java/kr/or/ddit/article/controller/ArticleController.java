package kr.or.ddit.article.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/artic")
public class ArticleController {
	
	@GetMapping
	public String article(Model model) {
		model.addAttribute("activeMain","artic");
		return "artic/article";
	}
	
	@GetMapping("/newArticle")
	public ResponseEntity<String> newArticle() {
		StringBuilder result = null;
		try {
            String apiUrl = "https://openapi.naver.com/v1/search/news.json?query=개발자&display=20";
            
            String clientId = "zyp4jbmoX5oEMx9GEKGY";
            String clientSecret = "CUas7SPQPV";
            
            // HTTP request 생성
            HttpClient client = HttpClients.createDefault();
            HttpGet request = new HttpGet(apiUrl);
            
            // Naver API 헤더 설정
            request.addHeader("X-Naver-Client-Id", clientId);
            request.addHeader("X-Naver-Client-Secret", clientSecret);
            
            // HTTP request 실행
            HttpResponse response = client.execute(request);
            
            // API 응답을 문자열로 변환
            BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
            result = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }
            
            log.info("newsData:", result.toString());
            	
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
}
