# Tour Gangwon App

강원도 여행 추천 앱입니다.

## 개발 모드 자동 로그인

개발 과정에서 매번 로그인하는 번거로움을 줄이기 위해 자동 로그인 기능이 구현되어 있습니다.

### 기능

- **자동 로그인**: 앱 시작 시 자동으로 로그인 상태가 됩니다
- **개발 모드 표시**: 홈 화면과 마이페이지에서 개발 모드임을 시각적으로 표시
- **토큰 관리**: 마이페이지에서 토큰 정보 확인 및 관리 가능
- **쉬운 전환**: 설정 파일 하나로 개발/프로덕션 모드 전환

### 설정

`lib/constants/app_config.dart` 파일에서 개발 모드를 설정할 수 있습니다:

```dart
class AppConfig {
  // 개발 모드 설정
  // 실제 배포 시에는 이 값을 false로 변경하세요
  static const bool isDevelopmentMode = true;
  
  // 개발 모드에서 자동 로그인 활성화 여부
  static bool get enableAutoLogin => isDevelopmentMode;
}
```

### 사용법

1. **개발 중**: `isDevelopmentMode = true`로 설정
   - 앱 실행 시 자동으로 홈 화면으로 이동
   - 홈 화면에 "DEV MODE" 표시
   - 마이페이지에서 토큰 정보 확인 가능

2. **배포 시**: `isDevelopmentMode = false`로 변경
   - 정상적인 로그인 플로우 사용
   - 자동 로그인 기능 비활성화

### 주의사항

- 개발 모드는 **개발 목적으로만** 사용하세요
- 실제 배포 시에는 반드시 `isDevelopmentMode = false`로 설정하세요
- 개발용 토큰은 실제 서버 인증을 우회하지 않습니다

## 설치 및 실행

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run
```

## 주요 기능

- 여행지 추천
- 즐겨찾기 관리
- 날짜별 추천
- 사용자 인증

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
