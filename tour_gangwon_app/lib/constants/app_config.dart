class AppConfig {
  // 개발 모드 설정
  // 실제 배포 시에는 이 값을 false로 변경하세요
  static const bool isDevelopmentMode = true;

  // API 기본 URL - 환경에 따라 자동 선택
  static String get apiBaseUrl {
    if (isDevelopmentMode) {
      // 개발 환경: 로컬 서버
      return 'http://10.0.2.2:8080/api';
    } else {
      // 프로덕션 환경: 실제 서버 URL
      return 'https://your-production-server.com/api';
    }
  }

  // 개발용 자동 로그인 토큰
  static const String devToken = 'dev_auto_login_token_for_development_only';

  // 앱 버전
  static const String appVersion = '1.0.0';

  // 개발 모드에서 자동 로그인 활성화 여부
  static bool get enableAutoLogin => isDevelopmentMode;

  // 로그 레벨 (개발 모드에서는 상세 로그, 프로덕션에서는 최소 로그)
  static String get logLevel => isDevelopmentMode ? 'debug' : 'error';

  // API 타임아웃 설정 (초)
  static const int apiTimeoutSeconds = 30;

  // 재시도 횟수
  static const int maxRetries = 3;
}
