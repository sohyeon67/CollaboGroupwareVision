package kr.or.ddit.crtf.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.account.vo.Employee;
import kr.or.ddit.crtf.service.CrtfService;
import kr.or.ddit.crtf.vo.CrtfEmp;
import kr.or.ddit.crtf.vo.CrtfPay;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

/**
 * 서류발급 - 재직증명서/급여명세서 컨트롤러
 * @author 김민채
 */

@Slf4j
@Controller
@RequestMapping("/crtf")
public class CrtfController {

	@Inject
	private CrtfService crtfService;

	// 재직증명서
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/crtfemp")
	public String crtfEmp(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "crtfNo") String searchType,
			@RequestParam(required = false) String searchWord, Model model) {
		log.info("crtfemp() 실행..!" + searchType + " mc: " + searchWord);

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info(" 재직증명서 페이지 시큐리티 확인");
		Employee employee = user.getEmployee();

		model.addAttribute("title", "재직증명서");
		model.addAttribute("activeMain", "crtf");
		model.addAttribute("active", "crtfemp");

		PaginationInfoVO<CrtfEmp> pagingVO = new PaginationInfoVO<CrtfEmp>();
		pagingVO.setEmpNo(employee.getEmpNo());

		// 검색기능 추가
		// 검색했을 때의 조건은 키워드(searchWord)가 넘어왔을 때 정확하게 검색을 진행하거니까
		// 이때, 검색을 진행하기 위한 타입과 키워드를 PaginationInfoVO에 셋팅하고 목록을 조회하기 위한 조건으로
		// 쿼리를 조회할 수 있도록 보내준다.
		if (StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}

		// 현재 페이지 전달 후, start/endRow와 start/endPage 설정
		pagingVO.setCurrentPage(currentPage);

		int totalRecord = crtfService.selectEmpCount(pagingVO); // 총 게시글 수 가져오기
		pagingVO.setTotalRecord(totalRecord);
		List<CrtfEmp> dataList = crtfService.selectEmpList(pagingVO);
		pagingVO.setDataList(dataList);
		log.info("empDataList : " + dataList);

		model.addAttribute("pagingVO", pagingVO);

		return "crtf/crtfemp";

	}

	// 재직증명서 - insert
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/crtfempinsert")
	public String crtfEmpInsert(CrtfEmp crtfemp, Model model, RedirectAttributes ra) {
		log.debug("체킁: {}",crtfemp);

		String goPage = ""; // 이동할 페이지 정보

		// 넘겨받은 데이터 검증 후, 에러가 발생한 데이터에 대한 에러정보를 담을 공간
		Map<String, String> errors = new HashMap<String, String>();

		// 제목 데이터가 누락되었을 때 에러 정보 저장(라이브러리 추가 후 작성)
		if (StringUtils.isBlank(crtfemp.getUsePlace())) {
			errors.put("usePlace", "사용처를 입력해주세요.");
		}
		// 기본 데이터의 누락정보에 따른 에러 정보 갯수로 분기 처리
		if (errors.size() > 0) { // 에러 갯수가 0보다 클 때 (에러가 존재)
			model.addAttribute("errors", errors);
			model.addAttribute("crtfemp", crtfemp);
			goPage = "crtf/crtfemp";
		} else { // 에러가 없을 때
			// [스프링 시큐리티] 시큐리티 세션을 활용
			CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			log.info("시큐리티 확인");
			Employee employee = user.getEmployee();

			// 세션 정보에서 꺼낸 회원 데이터가 null이 아닐때 (로그인을 진행)
			if (employee != null) {
				crtfemp.setEmpNo(employee.getEmpNo()); // 로그인한 아이디 설정
				ServiceResult result = crtfService.insertCrtfEmp(crtfemp); //update도 같이 진행

				if (result.equals(ServiceResult.OK)) { // 등록 성공
					goPage = "redirect:/crtf/crtfemp";
					ra.addFlashAttribute("message", "증명서 발급이 완료되었습니다.");

				} else { // 등록 실패
					model.addAttribute("crtfemp", crtfemp);
					model.addAttribute("message", "서버에러, 다시 시도해주세요!");
					goPage = "crtf/crtfemp";
				}
			} else { // 로그인을 진행하지 않았을 때
				// [방법2] - 등록을 진행하기 위해서는 로그인을 필수로 진행해야 합니다. 라는 프로세스 일 때
				ra.addFlashAttribute("message", "로그인 후에 사용 가능합니다!");
				goPage = "redirect:/accounts/login";

			}

		}

		return goPage;

	}
	
		// 재직증명서 PDF 호출
		@PreAuthorize("hasRole('ROLE_USER')")
		@GetMapping("/emppdf")
		public String empPdf(Model model, String crtfEmpNo) {
			// [스프링 시큐리티] 시큐리티 세션을 활용
			CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			log.info("재직증명서 페이지 시큐리티 확인");
			Employee employee = user.getEmployee();

			if (employee != null) {
				log.info("로그인 성공!");
				int idx = 0;
				List<CrtfEmp> crtfemp = crtfService.selectCrtfEmp(employee.getEmpNo());
				for (int i = 0; i < crtfemp.size(); i++) {
					CrtfEmp crtfEmpVO = crtfemp.get(i);
					if (crtfEmpVO.getCrtfEmpNo().equals(crtfEmpNo)) {
						model.addAttribute("crtfEmpVO", crtfEmpVO);
					}
				}
				// 뷰에게 전달할 데이터 저장
			} else {
				log.info("로그인 실패!");
				return "accounts/login";
			}

			return "emppdf";
		}
	
	
	
	
	

	// 급여명세서
	@PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/crtfpay")
	public String crtfPay(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false) String workY,
			@RequestParam(required = false) String workM, Model model) {
		String goPage = "accounts/login";
		log.info("crtfPay() 실행..!");

		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("급여명세서 페이지 시큐리티 확인");
		Employee employee = user.getEmployee();

		
		model.addAttribute("title", "급여명세서");
		model.addAttribute("activeMain", "crtf");
		model.addAttribute("active", "crtfpay");

		PaginationInfoVO<CrtfPay> pagingVO = new PaginationInfoVO<CrtfPay>();
		pagingVO.setEmpNo(employee.getEmpNo());

		if (employee != null) {
			// 검색 시 (급여년, 급여월)
			if(StringUtils.isNotBlank(workY) || StringUtils.isNotBlank(workM)) {
				CrtfPay crtf = new CrtfPay();
				if(StringUtils.isNotBlank(workY)) {
					crtf.setWorkY(workY);
					model.addAttribute("workY", workY);
				}
				if(StringUtils.isNotBlank(workM)) {
					if(Integer.parseInt(workM) < 10) {
						workM = "0" + workM;
					}
					crtf.setWorkM(workM);
					model.addAttribute("workM", workM);
				}
				pagingVO.setSearchVO(crtf);
			}

			// 현재 페이지 전달 후, start/endRow와 start/endPage 설정
			pagingVO.setCurrentPage(currentPage);

			int totalRecord = crtfService.selectPayCount(pagingVO); // 총 게시글 수 가져오기
			pagingVO.setTotalRecord(totalRecord);
			List<CrtfPay> dataList = crtfService.selectPayList(pagingVO);
			pagingVO.setDataList(dataList);
			log.info("dataList : " + dataList);

			model.addAttribute("pagingVO", pagingVO);
			goPage = "crtf/crtfpay";
		}

		return goPage;
	}

	// 급여명세서 PDF 호출
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/paypdf")
	public String payPdf(Model model, String workY, String workM) {
		// [스프링 시큐리티] 시큐리티 세션을 활용
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("급여명세서 페이지 시큐리티 확인");
		Employee employee = user.getEmployee();

		if (employee != null) {
			log.info("로그인 성공!");
			int idx = 0;
			List<CrtfPay> crtfPay = crtfService.selectCrtfPay(employee.getEmpNo());
			for (int i = 0; i < crtfPay.size(); i++) {
				CrtfPay crtfVO = crtfPay.get(i);
				if (crtfVO.getWorkY().equals(workY) && crtfVO.getWorkM().equals(workM)) {
					model.addAttribute("crtfVO", crtfVO);
				}
			}
			// 뷰에게 전달할 데이터 저장
		} else {
			log.info("로그인 실패!");
			return "accounts/login";
		}

		return "paypdf";
	}

}
