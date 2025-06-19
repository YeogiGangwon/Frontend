class AppConfig {
  // 개발 모드 설정
  // 실제 배포 시에는 이 값을 false로 변경하세요
  static const bool isDevelopmentMode = false;

  // API 기본 URL - 백엔드 서버 포트(8080)로 설정
  // Docker Compose 환경에서는 localhost:8080으로 접근
  static String get apiBaseUrl => 'http://localhost:8080/api';

  // 개발용 자동 로그인 토큰
  static const String devToken = 'dev_auto_login_token_for_development_only';

  // 앱 버전
  static const String appVersion = '1.0.0';

  // 개발 모드에서 자동 로그인 활성화 여부
  static bool get enableAutoLogin => isDevelopmentMode;

  // 로그 레벨 (개발 모드에서는 상세 로그, 프로덕션에서는 최소 로그)
  static String get logLevel => isDevelopmentMode ? 'debug' : 'error';

  // API 타임아웃 설정 (초) - Docker 환경을 고려하여 60초로 증가
  static const int apiTimeoutSeconds = 60;

  // 재시도 횟수
  static const int maxRetries = 3;
}
