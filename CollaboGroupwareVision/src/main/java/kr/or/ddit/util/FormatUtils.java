package kr.or.ddit.util;

public class FormatUtils {

    /**
     * 전화번호를 010-1111-2222 형식으로 포맷팅합니다.
     * 입력값이 null이거나 11자리가 아니면 원본을 반환합니다.
     *
     * @param number 포맷할 전화번호 문자열 (숫자만)
     * @return 포맷된 전화번호 문자열
     */
    public static String formatPhone(String number) {
        if (number == null || number.length() != 11) {
            return number;
        }
        return number.substring(0, 3) + "-" + number.substring(3, 7) + "-" + number.substring(7);
    }
    
    /**
     * 날짜를 20240324 -> 2024-03-24 형식으로 포맷팅합니다.
     * 입력값이 null이거나 8자리가 아니면 원본을 반환합니다.
     *
     * @param date 날짜 문자열 (yyyyMMdd)
     * @return 포맷된 날짜 문자열 (yyyy-MM-dd)
     */
    public static String formatDate(String date) {
        if (date == null || date.length() != 8) {
            return date;
        }
        return date.substring(0, 4) + "-" + date.substring(4, 6) + "-" + date.substring(6);
    }
}
