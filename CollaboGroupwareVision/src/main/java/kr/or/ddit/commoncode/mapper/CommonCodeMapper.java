package kr.or.ddit.commoncode.mapper;

import java.util.List;

import kr.or.ddit.commoncode.vo.CommonCode;

public interface CommonCodeMapper {

    List<CommonCode> selectAllCodes();
}
