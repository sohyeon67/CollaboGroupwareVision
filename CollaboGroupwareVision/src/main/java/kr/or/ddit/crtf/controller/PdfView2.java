package kr.or.ddit.crtf.controller;

import java.awt.Color;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.servlet.view.document.AbstractPdfView;

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import kr.or.ddit.crtf.vo.CrtfEmp;
import lombok.extern.slf4j.Slf4j;

/**
 * 서류발급 - 재직증명서 PDFView
 * @author 김민채
 */

@Slf4j
public class PdfView2 extends AbstractPdfView {

	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document doc, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 받은 값 가져오기
		CrtfEmp crtfEmpVO = (CrtfEmp) model.get("crtfEmpVO");
		log.info("crtfEmpVO: {}", crtfEmpVO);

		// 기본 폰트 설정 - 폰트에 따라 한글 출력 여부가 결정된다.
		BaseFont bfKorea = BaseFont.createFont("c:\\windows\\fonts\\batang.ttc,0", BaseFont.IDENTITY_H,
				BaseFont.EMBEDDED);
		Font font = new Font(bfKorea, 15);
		// 굵은 글꼴 및 크기 설정
		Font boldFont = new Font(bfKorea, 35, Font.BOLD);
		Font titleFont = new Font(bfKorea, 15, Font.BOLD);
		Font footerFont = new Font(bfKorea, 25, Font.BOLD);

		// 제목 셀 생성
		PdfPCell headerCell = new PdfPCell(new Phrase("재 직 증 명 서", boldFont));
		headerCell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		headerCell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		headerCell.setBorder(0); // 테두리 없음

		// 빈 셀 추가하여 간격 띄우기
		PdfPCell emptyCell = new PdfPCell();
		emptyCell.setBorder(0); // 테두리 없음

		// footer 간격 띄우기
		PdfPCell footerCell = new PdfPCell();
		footerCell.setBorder(0); // 테두리 없음

		// 테이블 생성
		PdfPTable table = new PdfPTable(1);
		table.setWidthPercentage(100);

		// 전체 행 높이 설정
		float emptyHeight = 30f;
		float footerHeight = 15f;

		// 각 셀에 높이 설정
		emptyCell.setFixedHeight(emptyHeight);
		footerCell.setFixedHeight(footerHeight);

		// 제목 셀을 헤더로 설정
		table.addCell(headerCell);
		// 간격 띄우기
		table.addCell(emptyCell);

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////// 인적사항 생성////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// 인적사항 (3행)
		PdfPTable infoTable1 = new PdfPTable(4);
		infoTable1.setWidthPercentage(100);

		// 데이터 출력

		// 인적사항 타이틀
		PdfPCell infoTitle1 = new PdfPCell(new Phrase("인적사항", titleFont));
		infoTitle1.setBackgroundColor(Color.LIGHT_GRAY);
		infoTitle1.setPadding(10);

		PdfPCell infoTitle2 = new PdfPCell(new Phrase("", titleFont));

		PdfPCell infoTitle3 = new PdfPCell(new Phrase("", titleFont));

		PdfPCell infoTitle4 = new PdfPCell(new Phrase("", titleFont));
		
		infoTitle1.setColspan(4);
		
		// ------------------------------------------------------------------
		// 성명, 주민번호 (1행 4열)
		
		PdfPCell nameCell1 = new PdfPCell(new Phrase("성 명", titleFont));
		nameCell1.setBackgroundColor(Color.LIGHT_GRAY);
		nameCell1.setPadding(10);

		PdfPCell nameCell2 = new PdfPCell(new Phrase(crtfEmpVO.getEmpName(), font));
		nameCell2.setPadding(10);

		PdfPCell nameCell3 = new PdfPCell(new Phrase("주민등록번호", titleFont));
		nameCell3.setBackgroundColor(Color.LIGHT_GRAY);
		nameCell3.setPadding(10);

		PdfPCell nameCell4 = new PdfPCell(new Phrase(crtfEmpVO.getEmpRrn(), font));
		nameCell4.setPadding(10);
		

		// ------------------------------------------------------------------
		// 주소 (1행)
		
		PdfPCell addr1 = new PdfPCell(new Phrase("주 소", titleFont));
		addr1.setBackgroundColor(Color.LIGHT_GRAY);
		addr1.setPadding(10);
		
		PdfPCell addr2 = new PdfPCell(new Phrase(crtfEmpVO.getAddr(), font));
		addr2.setPadding(10);
		
		PdfPCell addr3 = new PdfPCell(new Phrase("", titleFont));
		
		PdfPCell addr4 = new PdfPCell(new Phrase("", titleFont));
		
		addr2.setColspan(3);
		
		// ------------------------------------------------------------------

		infoTable1.addCell(infoTitle1);
		infoTable1.addCell(nameCell1);
		infoTable1.addCell(nameCell2);
		infoTable1.addCell(nameCell3);
		infoTable1.addCell(nameCell4);
		infoTable1.addCell(addr1);
		infoTable1.addCell(addr2);

		// 전체 테이블에 인적사항 테이블 추가
		table.addCell(infoTable1);
		
		// 간격 띄우기
		table.addCell(emptyCell);

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////// 재직사항 생성////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
		// 재직사항 (4행)
		PdfPTable hffcTable1 = new PdfPTable(4);
		hffcTable1.setWidthPercentage(100);
		
		// 데이터 출력
		
		// 재직사항 타이틀
		PdfPCell hffcTitle1 = new PdfPCell(new Phrase("재직사항", titleFont));
		hffcTitle1.setBackgroundColor(Color.LIGHT_GRAY);
		hffcTitle1.setPadding(10);
		
		PdfPCell hffcTitle2 = new PdfPCell(new Phrase("", titleFont));
		
		PdfPCell hffcTitle3 = new PdfPCell(new Phrase("", titleFont));
		
		PdfPCell hffcTitle4 = new PdfPCell(new Phrase("", titleFont));
		
		hffcTitle1.setColspan(4);		
		
		// ------------------------------------------------------------------
		// 사번 (1행)
		
		PdfPCell infoEmpNo1 = new PdfPCell(new Phrase("사 번", titleFont));
		infoEmpNo1.setBackgroundColor(Color.LIGHT_GRAY);
		infoEmpNo1.setPadding(10);

		PdfPCell infoEmpNo2 = new PdfPCell(new Phrase(crtfEmpVO.getEmpNo(), font));
		infoEmpNo2.setPadding(10);

		PdfPCell infoEmpNo3 = new PdfPCell(new Phrase("", titleFont));

		PdfPCell infoEmpNo4 = new PdfPCell(new Phrase("", titleFont));
		
		infoEmpNo2.setColspan(3);		
		
		// ------------------------------------------------------------------
		// 부서 (1행)
		
		PdfPCell deptCell1 = new PdfPCell(new Phrase("부 서", titleFont));
		deptCell1.setBackgroundColor(Color.LIGHT_GRAY);
		deptCell1.setPadding(10);
		
		PdfPCell deptCell2 = new PdfPCell(new Phrase(crtfEmpVO.getDeptName(), font));
		deptCell2.setPadding(10);
		
		PdfPCell deptCell3 = new PdfPCell(new Phrase("", titleFont));
		
		PdfPCell deptCell4 = new PdfPCell(new Phrase("", titleFont));
		
		deptCell2.setColspan(3);
		
		// ------------------------------------------------------------------
		// 직위 (1행)
		
		PdfPCell posi1 = new PdfPCell(new Phrase("직 위", titleFont));
		posi1.setBackgroundColor(Color.LIGHT_GRAY);
		posi1.setPadding(10);
		
		PdfPCell posi2 = new PdfPCell(new Phrase(crtfEmpVO.getPositionName(), font));
		posi2.setPadding(10);
		
		PdfPCell posi3 = new PdfPCell(new Phrase("", titleFont));
		
		PdfPCell posi4 = new PdfPCell(new Phrase("", titleFont));
		
		posi2.setColspan(3);
		
		// ------------------------------------------------------------------
		// 재직기간 (1행)
		
		PdfPCell hffcDate1 = new PdfPCell(new Phrase("재직기간", titleFont));
		hffcDate1.setBackgroundColor(Color.LIGHT_GRAY);
		hffcDate1.setPadding(10);
		
		PdfPCell hffcDate2 = new PdfPCell(new Phrase(crtfEmpVO.getJoinDay(), font));
		hffcDate2.setPadding(10);
		
		PdfPCell hffcDate3 = new PdfPCell(new Phrase("", titleFont));
		
		PdfPCell hffcDate4 = new PdfPCell(new Phrase("", titleFont));
		
		hffcDate2.setColspan(3);
		
		// ------------------------------------------------------------------
		// 재직사항 테이블에 각 셀 추가
		hffcTable1.addCell(hffcTitle1);
		hffcTable1.addCell(infoEmpNo1);
		hffcTable1.addCell(infoEmpNo2);
		hffcTable1.addCell(deptCell1);
		hffcTable1.addCell(deptCell2);
		hffcTable1.addCell(posi1);
		hffcTable1.addCell(posi2);
		hffcTable1.addCell(hffcDate1);
		hffcTable1.addCell(hffcDate2);
		
		// 전체 테이블에 재직사항 테이블 추가
		table.addCell(hffcTable1);
		
		// 간격 띄우기
		table.addCell(emptyCell);

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////// 사용처 생성////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// 사용처 (1행)
		PdfPTable usePlaceTable1 = new PdfPTable(4);
		usePlaceTable1.setWidthPercentage(100);
		
		PdfPCell usePlace1 = new PdfPCell(new Phrase("사용처", titleFont));
		usePlace1.setBackgroundColor(Color.LIGHT_GRAY);
		usePlace1.setPadding(10);
		
		PdfPCell usePlace2 = new PdfPCell(new Phrase(crtfEmpVO.getUsePlace(), font));
		usePlace2.setPadding(10);
		
		PdfPCell usePlace3 = new PdfPCell(new Phrase("", titleFont));
		
		PdfPCell usePlace4 = new PdfPCell(new Phrase("", titleFont));
		
		usePlace2.setColspan(3);
		
		// 사용처 테이블에 셀 추가
		usePlaceTable1.addCell(usePlace1);
		usePlaceTable1.addCell(usePlace2);
				
		// 전체 테이블에 사용처 테이블 추가
		table.addCell(usePlaceTable1);
		

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////// 하단 생성////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// 간격 띄우기
		table.addCell(footerCell);

		// 하단셀 1 생성
		PdfPCell footerCell1 = new PdfPCell(new Phrase("위와 같이 재직하고 있음을 증명합니다.", titleFont));
		footerCell1.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		footerCell1.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		footerCell1.setBorder(0); // 테두리 없음

		table.addCell(footerCell1);
		
		// 간격 띄우기
		table.addCell(footerCell);

		// 하단 셀2 생성
		// DateTimeFormat YYYY년 MM월 DD일
		
		PdfPCell footerCell2 = new PdfPCell(new Phrase(crtfEmpVO.getCrtfEmpDocDate(), titleFont));
		footerCell2.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		footerCell2.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		footerCell2.setBorder(0); // 테두리 없음
		
		table.addCell(footerCell2);
		
		// 간격 띄우기
		table.addCell(footerCell);

		PdfPCell footerCell3 = new PdfPCell(new Phrase("재단법인 DD인재개발원", footerFont));
		footerCell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		footerCell3.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		footerCell3.setBorder(0); // 테두리 없음

		table.addCell(footerCell3);

		// 이미지 추가
		String filename = request.getSession().getServletContext().getRealPath("/resources/img/crtf/sign.png");
		Image image = Image.getInstance(filename);

		// 이미지 정렬 및 크기 조절 (선택 사항)
		image.setAlignment(Element.ALIGN_RIGHT);
		image.scaleToFit(100, 100);

		Phrase phrase = new Phrase();
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk("회장 이재용", footerFont));
		// 직접 공백 추가
		// phrase.add(new Chunk(" ", footerFont));
		phrase.add(new Chunk(image, -40, -40));

		PdfPCell footerCell4 = new PdfPCell(phrase);

		footerCell4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		footerCell4.setBorder(0); // 테두리 없음

		table.addCell(footerCell4);

		// 문서에 테이블 추가
		doc.add(table);

	}

}
