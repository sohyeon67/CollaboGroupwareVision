package kr.or.ddit.crtf.controller;

import java.awt.Color;
import java.io.FileOutputStream;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.document.AbstractPdfView;

import com.lowagie.text.Cell;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import kr.or.ddit.crtf.vo.CrtfPay;
import lombok.extern.slf4j.Slf4j;

/**
 * 서류발급 - 급여명세서 PDFView
 * @author 김민채
 */

@Slf4j
public class PdfView extends AbstractPdfView {
	
	@Override
    protected void buildPdfDocument(
            Map<String, Object> model,
            Document doc,
            PdfWriter writer,
            HttpServletRequest request,
            HttpServletResponse response) throws Exception {
		
		//받은 값 가져오기
		//List<CrtfPay> pay = (List<CrtfPay>) model.get("pay");
		CrtfPay crtfVO = (CrtfPay) model.get("crtfVO");
		log.info("crtfVO: {}", crtfVO);

        // 기본 폰트 설정 - 폰트에 따라 한글 출력 여부가 결정된다.
        BaseFont bfKorea = BaseFont.createFont("c:\\windows\\fonts\\batang.ttc,0", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        Font font = new Font(bfKorea, 15);
        // 굵은 글꼴 및 크기 설정
        Font boldFont = new Font(bfKorea, 35, Font.BOLD);
        Font titleFont = new Font(bfKorea, 15, Font.BOLD);
        Font footerFont = new Font(bfKorea, 25, Font.BOLD);

        // 제목 셀 생성
        PdfPCell headerCell = new PdfPCell(new Phrase("급여명세서", boldFont));
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
        //float rowHeight = 15f;
        
        // 각 셀에 높이 설정
        emptyCell.setFixedHeight(emptyHeight);
        footerCell.setFixedHeight(footerHeight);
        

        // 제목 셀을 헤더로 설정
        table.addCell(headerCell);
        // 간격  띄우기
        table.addCell(emptyCell);        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////기본 INFO 행렬 생성///////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // 기준월, 급여지급일(1줄 4칸)
        PdfPTable infoTable1 = new PdfPTable(4);
        infoTable1.setWidthPercentage(100);
                
        // 데이터 출력

            // 각 행당 한 번만 셀 추가
            PdfPCell infocell11 = new PdfPCell(new Phrase("기준월", titleFont));
            infocell11.setBackgroundColor(Color.LIGHT_GRAY);
            
            PdfPCell infocell21 = new PdfPCell(new Phrase(crtfVO.getWorkY() + "-" + crtfVO.getWorkM(), font));
            
            PdfPCell infocell31 = new PdfPCell(new Phrase("급여 지급일", titleFont));
            infocell31.setBackgroundColor(Color.LIGHT_GRAY);
            
            PdfPCell infocell41 = new PdfPCell(new Phrase(crtfVO.getPayDay(), font));
            
            //------------------------------------------------------------------

            PdfPCell infocell12 = new PdfPCell(new Phrase("부서", titleFont));
            infocell12.setBackgroundColor(Color.LIGHT_GRAY);
            
            PdfPCell infocell22 = new PdfPCell(new Phrase(crtfVO.getDeptName(),font));
            
            PdfPCell infocell32 = new PdfPCell(new Phrase("직위", titleFont));
            infocell32.setBackgroundColor(Color.LIGHT_GRAY);
            
            PdfPCell infocell42 = new PdfPCell(new Phrase(crtfVO.getPositionName(), font));
            
            //------------------------------------------------------------------
            
            PdfPCell infocell13 = new PdfPCell(new Phrase("성명", titleFont));
            infocell13.setBackgroundColor(Color.LIGHT_GRAY);
            
            PdfPCell infocell23 = new PdfPCell(new Phrase(crtfVO.getEmpName(), font));
            
            PdfPCell infocell33 = new PdfPCell(new Phrase("사번", titleFont));
            infocell33.setBackgroundColor(Color.LIGHT_GRAY);
            
            PdfPCell infocell43 = new PdfPCell(new Phrase(crtfVO.getEmpNo(), font));
            
            //------------------------------------------------------------------
            
            infoTable1.addCell(infocell11);
            infoTable1.addCell(infocell21);
            infoTable1.addCell(infocell31);
            infoTable1.addCell(infocell41);
            infoTable1.addCell(infocell12);
            infoTable1.addCell(infocell22);
            infoTable1.addCell(infocell32);
            infoTable1.addCell(infocell42);
            infoTable1.addCell(infocell13);
            infoTable1.addCell(infocell23);
            infoTable1.addCell(infocell33);
            infoTable1.addCell(infocell43);
        
        table.addCell(infoTable1);
                
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////지급내역, 공제내역 생성///////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        // 지급내역, 공제네역 (1줄 2칸)
        PdfPTable infoTable2 = new PdfPTable(2);
        infoTable2.setWidthPercentage(100);
        
        // 두개의 값을 담은 1행 2열의 데이터 배열 생성
        String[] dataArray2 = {"지급내역", "공제내역"};
        
        // 데이터 출력
        for (int i = 0; i < dataArray2.length; i++) { 
        	PdfPCell infocell1 = new PdfPCell(new Phrase(dataArray2[i], titleFont));
            infocell1.setBackgroundColor(Color.LIGHT_GRAY);
            infocell1.setHorizontalAlignment(Element.ALIGN_CENTER);
            
            infoTable2.addCell(infocell1);
        }
        
        table.addCell(infoTable2);
        

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////지급내역, 공제내역에 대한 항목, 금액 (x2)//////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        // 항목,금액, 항목, 금액(1줄 4칸)
        PdfPTable infoTable3 = new PdfPTable(4);
        infoTable3.setWidthPercentage(100);
        
        // 두개의 값을 담은 1행 2열의 데이터 배열 생성 
        String[] dataArray3 = {"항목","금액","항목","금액"};
        
        // 데이터 출력
        for (int i = 0; i < dataArray3.length; i++) {
            // 각 행당 한 번만 셀 추가
            PdfPCell infocell1 = new PdfPCell(new Phrase(dataArray3[i], titleFont));
            infocell1.setBackgroundColor(Color.LIGHT_GRAY);
            infocell1.setHorizontalAlignment(Element.ALIGN_CENTER);

            infoTable3.addCell(infocell1);
        }
        
        table.addCell(infoTable3);        
        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////// 세부항목 (4줄 4칸 ) //////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        // 세부항목 (4줄 4칸)
        PdfPTable infoTable4 = new PdfPTable(4);
        infoTable4.setWidthPercentage(100);

            // 각 행당 한 번만 셀 추가
            PdfPCell infocell11111 = new PdfPCell(new Phrase("기본급", font));
            
            PdfPCell infocell22222 = new PdfPCell(new Phrase(crtfVO.getSalary(), font));
            
            PdfPCell infocell33333 = new PdfPCell(new Phrase("국민연금", font));
            
            PdfPCell infocell44444 = new PdfPCell(new Phrase(crtfVO.getNp(), font));

            infoTable4.addCell(infocell11111);
            infoTable4.addCell(infocell22222);
            infoTable4.addCell(infocell33333);
            infoTable4.addCell(infocell44444);
            
           //------------------------------------------------------------------
            
            // 각 행당 한 번만 셀 추가
            PdfPCell infocell111115 = new PdfPCell(new Phrase("식대", font));
            
            PdfPCell infocell222226 = new PdfPCell(new Phrase(crtfVO.getMeals(), font));
            
            PdfPCell infocell333337 = new PdfPCell(new Phrase("건강보험", font));
            
            PdfPCell infocell444448 = new PdfPCell(new Phrase(crtfVO.getNhi(), font));
            
            infoTable4.addCell(infocell111115);
            infoTable4.addCell(infocell222226);
            infoTable4.addCell(infocell333337);
            infoTable4.addCell(infocell444448);
            
            //------------------------------------------------------------------
            
            // 각 행당 한 번만 셀 추가
            PdfPCell infocell111119 = new PdfPCell(new Phrase("비급여", font));
            
            PdfPCell infocell2222210 = new PdfPCell(new Phrase(crtfVO.getNoBnf(), font));
            
            PdfPCell infocell3333311 = new PdfPCell(new Phrase("산재보험", font));
            
            PdfPCell infocell4444412 = new PdfPCell(new Phrase(crtfVO.getNiai(), font));
            
            infoTable4.addCell(infocell111119);
            infoTable4.addCell(infocell2222210);
            infoTable4.addCell(infocell3333311);
            infoTable4.addCell(infocell4444412);
            
            //------------------------------------------------------------------
            
            // 각 행당 한 번만 셀 추가
            PdfPCell infocell1111113 = new PdfPCell(new Phrase());
            
            PdfPCell infocell2222214 = new PdfPCell(new Phrase());
            
            PdfPCell infocell3333315 = new PdfPCell(new Phrase("고용보험", font));
            
            PdfPCell infocell4444416 = new PdfPCell(new Phrase(crtfVO.getNei(), font));
            
            infoTable4.addCell(infocell1111113);
            infoTable4.addCell(infocell2222214);
            infoTable4.addCell(infocell3333315);
            infoTable4.addCell(infocell4444416);
            
            
            

        for(int i = 0; i < 10 ; i++) {
        	// 각 행당 한 번만 셀 추가
        	PdfPCell infocell1 = new PdfPCell(new Phrase(" ", font));
        	
        	PdfPCell infocell2 = new PdfPCell(new Phrase(" ", font));
        	
        	PdfPCell infocell3 = new PdfPCell(new Phrase(" ", font));
        	
        	PdfPCell infocell4 = new PdfPCell(new Phrase(" ", font));
        	
        	infoTable4.addCell(infocell1);
        	infoTable4.addCell(infocell2);
        	infoTable4.addCell(infocell3);
        	infoTable4.addCell(infocell4);
        	
        }
        table.addCell(infoTable4);
        

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////// 합계 (1줄 4칸 ) //////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////       
        
        // 지급합계, 공제합계액(1줄 4칸)
        PdfPTable infoTable5 = new PdfPTable(4);
        infoTable5.setWidthPercentage(100);
        
        // 각 행당 한 번만 셀 추가
        PdfPCell infocell1 = new PdfPCell(new Phrase("지급 합계", font));
        infocell1.setBackgroundColor(Color.LIGHT_GRAY);
        infocell1.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        long hap = Long.parseLong(crtfVO.getSalary()) + 
                Long.parseLong(crtfVO.getMeals()) + 
                Long.parseLong(crtfVO.getNoBnf());
        System.out.println("hap : " + hap);
        String haps = String.valueOf(hap);
        
        PdfPCell infocell2 = new PdfPCell(new Phrase(haps, font));
        
        PdfPCell infocell3 = new PdfPCell(new Phrase("공제합계액", font));
        infocell3.setBackgroundColor(Color.LIGHT_GRAY);
        infocell3.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        long hap2 = Long.parseLong(crtfVO.getNp()) + 
                Long.parseLong(crtfVO.getNhi()) + 
                Long.parseLong(crtfVO.getNiai()) + 
                Long.parseLong(crtfVO.getNei());
        System.out.println("hap2 : " + hap2);
        String hap2s = String.valueOf(hap2);
        
        PdfPCell infocell4 = new PdfPCell(new Phrase(hap2s, font));

        infoTable5.addCell(infocell1);
        infoTable5.addCell(infocell2);
        infoTable5.addCell(infocell3);
        infoTable5.addCell(infocell4);     
        
        table.addCell(infoTable5);
        
        // 실지급액 (1줄 2칸)
        PdfPTable infoTable6 = new PdfPTable(4);
        infoTable5.setWidthPercentage(100);
        
        // 각 행당 한 번만 셀 추가
        PdfPCell infocell5 = new PdfPCell(new Phrase("실 지급액", titleFont));
        infocell5.setBackgroundColor(Color.LIGHT_GRAY);
        infocell5.setHorizontalAlignment(Element.ALIGN_CENTER);
                
        long total = hap-hap2;
        String totals = String.valueOf(total);
        
        PdfPCell infocell6 = new PdfPCell(new Phrase(totals, titleFont));       
        PdfPCell infocell7 = new PdfPCell(new Phrase(" ", font));        
        PdfPCell infocell8 = new PdfPCell(new Phrase(" ", font));
        
        infocell6.setColspan(3);
        
        infoTable6.addCell(infocell5);
        infoTable6.addCell(infocell6);        
        
        table.addCell(infoTable6);
        
        // 비고 (4줄 2칸)
        PdfPTable infoTable7 = new PdfPTable(4);
        infoTable5.setWidthPercentage(100); 
        
        // 각 행당 한 번만 셀 추가
        PdfPCell infocell9 = new PdfPCell(new Phrase("비고", font));
        infocell9.setBackgroundColor(Color.LIGHT_GRAY);
        infocell9.setHorizontalAlignment(Element.ALIGN_CENTER);
        PdfPCell infocell10 = new PdfPCell(new Phrase(" ", font));       
        PdfPCell infocell1111 = new PdfPCell(new Phrase(" ", font));        
        PdfPCell infocell1222 = new PdfPCell(new Phrase(" ", font)); 
        
        infocell10.setColspan(3);
        infoTable7.addCell(infocell9);
        infoTable7.addCell(infocell10);
        
        table.addCell(infoTable7);

        // 간격  띄우기
        table.addCell(footerCell); 
        
        // 하단 셀 생성
        PdfPCell footerCell1 = new PdfPCell(new Phrase("귀하의 노고에 감사드립니다.", titleFont));
        footerCell1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        footerCell1.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        footerCell1.setBorder(0); // 테두리 없음
        //footerCell.setFixedHeight(footerHeight);
        
        table.addCell(footerCell1);
        
        // 간격  띄우기
        table.addCell(footerCell); 
        
        PdfPCell footerCell2 = new PdfPCell(new Phrase("재단법인 DD인재개발원", footerFont));
        footerCell2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        footerCell2.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        footerCell2.setBorder(0); // 테두리 없음      
        
        table.addCell(footerCell2);

        
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
        //phrase.add(new Chunk(" ", footerFont));
        phrase.add(new Chunk(image, -40, -40));

        PdfPCell footerCell3 = new PdfPCell(phrase);

        footerCell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        footerCell3.setBorder(0); // 테두리 없음

        table.addCell(footerCell3);

        // 문서에 테이블 추가
        doc.add(table);
        
        
    }

}
