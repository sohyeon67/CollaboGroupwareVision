package kr.or.ddit.email.vo;

import java.util.List;

import lombok.Data;

@Data
public class MailPaginationInfo<T> {
	//클래스명<T> : 기본 8개 타입, String, 각종 객체들 모두 넣을 수 있는 것
	//자료형이 Object인 대신 사용하는 키워드 T(Type)
	//어떠한 자료형도 다 수용해주겠다는 표시
	
	private String empNo; //시큐리티 활용
	
	private int totalRecord;	//총 게시글 수
	private int totalPage;		//총 페이지 수
	private int currentPage;	//현재 페이지
	private int screenSize = 10;	//페이지 당 게시글 수
	private int blockSize = 5;		//페이지 블록 수
	private int startRow;		//시작 row
	private int endRow;			//끝 row
	private int startPage;		//시작 페이지
	private int endPage;		//끝 페이지
	private List<T> dataList;	//결과를 넣을 데이터 리스트
	private String searchType;	//검색 타입(제목, 작성자, 제목+작성자 등등)
	private String searchWord;	//검색 단어(키워드)
	
	
	public MailPaginationInfo() {} //기본 생성자
	public MailPaginationInfo(int screenSize, int blockSize) {
		super();
		this.screenSize = screenSize;
		this.blockSize = blockSize;
		
	} 
	
	//@Data를 통해 이미 만들어져 있지만.. 별도로 만들어서 사용
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
		// ceil은 올림에 해당한다.
		// 총 게시글 수가 121개 일때, screenSize로 나누게 되면 몫은 12이지만 나머지가 존재한다.
		// 이때, 올림을 하게 되면 나머지에 대한 부분이 몫으로 올림이 되므로 13이 된다.
		totalPage = (int)Math.ceil( totalRecord / (double)screenSize );
	}
	
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage; //현재 페이지
		endRow = currentPage * screenSize; // 끝 row = 현재 페이지 * 한 페이지 당 게시글 수
		startRow = endRow - (screenSize - 1);// 시작 row = 끝 row - (한 페이지 당 게시글 수 -1)
		//마지막 페이지 = (현재 페이지 + (페이지 블록 사이즈 -1)) / 페이지 블록 사이즈 * 페이지 블록 사이즈
		//blockSize * blockSize는 1,2,3,4.... 페이지마다 실수 계산이 아닌 정수 계산을 이용해 endPage를 구한다.
		endPage = (currentPage + (blockSize - 1)) / blockSize * blockSize;
		startPage = endPage - (blockSize - 1);
	}
	
	
	//페이징 CSS
	public String getPagingHTML() {
		StringBuffer html = new StringBuffer();
		html.append("<ul class='pagination justify-content-center'>");
	
		if(startPage > 1) {
			html.append("<li class='page-item'><a href='' class='page-link' data-page='" +
					(startPage - blockSize) + "'>Prev</a></li>");
		}
		
		//현재 페이지부터 blockSize에 해당하는 페이지 정보를 출력할 반복문
		for(int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
			if(i == currentPage) {
				html.append("<li class='page-item active'><span class='page-link'>" + i + "</span></li>");
			}else {
				html.append("<li class='page-item'><a href='' class='page-link' data-page='"+i+"'>" + i + "</a></li>");
				
			}
		}
	
		if(endPage < totalPage) {
			html.append("<li class='page-item'><a href='' class='page-link' data-page='"+(endPage+1)+"'>Next</a></li>");
		}
		
		html.append("</ul>");
		return html.toString();
	}
}
