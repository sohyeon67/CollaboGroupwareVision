package kr.or.ddit.commoncode.service;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;

import org.springframework.stereotype.Service;

import kr.or.ddit.commoncode.mapper.CommonCodeMapper;
import kr.or.ddit.commoncode.vo.CommonCode;

@Service
public class CommonCodeService {

	private final CommonCodeMapper mapper;

	// 공통코드 그룹ID 별로 (코드, 코드명) 맵을 저장하여 캐시
    private final Map<String, Map<String, String>> codeNameCache = new ConcurrentHashMap<>();

    public CommonCodeService(CommonCodeMapper mapper) {
        this.mapper = mapper;
    }

    /**
     * @PostConstruct  어노테이션을 통해 빈 초기화 직후 실행
     * 서버 시작 후 호출되어 공통코드를 DB에서 전부 조회
     * 그룹별로 Map 형태로 가공하여 메모리 캐시에 저장
     */
    @PostConstruct
    public void loadCodeNameCache() {
    	List<CommonCode> allCodes = mapper.selectAllCodes();

        Map<String, Map<String, String>> grouped = allCodes.stream()
            .collect(Collectors.groupingBy(CommonCode::getCommonCodeGroupId,
                Collectors.toMap(CommonCode::getCommonCode, CommonCode::getCommonCodeName)));

        codeNameCache.clear();
        codeNameCache.putAll(grouped);
    }

    /**
     * 특정 공통코드 그룹ID에 해당하는 코드맵 반환
     * @param groupId 공통코드 그룹 ID
     * @return (코드, 코드명) 맵
     */
    public Map<String, String> getCodeMapByGroupId(String groupId) {
        return Optional.ofNullable(codeNameCache.get(groupId))
                       .orElse(Collections.emptyMap());
    }
}
