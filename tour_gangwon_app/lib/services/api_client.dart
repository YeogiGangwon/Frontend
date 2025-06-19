import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_config.dart';

class ApiClient {
  static String get baseUrl => AppConfig.apiBaseUrl;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // 개발용 자동 로그인 토큰 생성
  static const String _devToken = AppConfig.devToken;

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
        receiveTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 요청 인터셉터 - 모든 요청에 Authorization 헤더 자동 추가
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 저장된 토큰을 읽어와서 헤더에 추가
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('API Request: ${options.method} ${options.path}');
          return handler.next(options); // 요청 계속 진행
        },
        onError: (error, handler) async {
          print('API Error: ${error.response?.statusCode} - ${error.message}');

          // 401 에러 발생 시 토큰 만료로 간주하고 저장된 토큰 삭제
          if (error.response?.statusCode == 401) {
            await _storage.delete(key: 'jwt_token');
            print('Token expired, removed from storage');
          }

          // 네트워크 에러인 경우 재시도 로직
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError) {
            print('Network error detected, retrying...');
            // 재시도 로직은 별도로 구현
          }

          return handler.next(error);
        },
        onResponse: (response, handler) {
          print(
            'API Response: ${response.statusCode} - ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
      ),
    );

    // 로깅 인터셉터 (디버그 모드에서만)
    if (AppConfig.logLevel == 'debug') {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => print(obj),
        ),
      );
    }

    return dio;
  }

  // 재시도 로직이 포함된 API 호출
  static Future<Map<String, dynamic>> apiCallWithRetry(
    Future<Map<String, dynamic>> Function() apiCall,
  ) async {
    int retryCount = 0;
    while (retryCount < AppConfig.maxRetries) {
      try {
        return await apiCall();
      } catch (e) {
        retryCount++;
        print('API call failed, retry $retryCount/${AppConfig.maxRetries}');

        if (retryCount >= AppConfig.maxRetries) {
          return {
            'success': false,
            'message': '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
          };
        }

        // 재시도 전 잠시 대기
        await Future.delayed(Duration(seconds: retryCount));
      }
    }
    return {'success': false, 'message': '알 수 없는 오류가 발생했습니다.'};
  }

  // 토큰 저장
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // 토큰 가져오기
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // 토큰 삭제 (로그아웃 시)
  static Future<void> removeToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  // 토큰 존재 여부 확인
  static Future<bool> hasToken() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }

  // 개발용 자동 로그인 (토큰이 없으면 자동으로 생성)
  static Future<void> ensureDevLogin() async {
    // 개발 모드가 비활성화되어 있으면 아무것도 하지 않음
    if (!AppConfig.enableAutoLogin) {
      return;
    }

    final hasExistingToken = await hasToken();
    if (!hasExistingToken) {
      // 개발용 토큰 자동 생성 및 저장
      await saveToken(_devToken);
      print('Development mode: Auto-generated token for convenience');
    }
  }

  // 개발용 토큰인지 확인
  static Future<bool> isDevToken() async {
    final token = await getToken();
    return token == _devToken;
  }

  // 서버 연결 상태 확인
  static Future<bool> checkServerConnection() async {
    try {
      final dio = createDio();
      final response = await dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      print('Server connection check failed: $e');
      return false;
    }
  }

  // 회원가입 API
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String nickname,
    required String password,
  }) async {
    return apiCallWithRetry(() async {
      try {
        final dio = createDio();
        final response = await dio.post(
          '/users/signup',
          data: {'email': email, 'nickname': nickname, 'password': password},
        );
        return {'success': true, 'data': response.data};
      } catch (e) {
        if (e is DioException) {
          return {
            'success': false,
            'message': e.response?.data['message'] ?? '회원가입에 실패했습니다.',
          };
        }
        return {'success': false, 'message': '네트워크 오류가 발생했습니다.'};
      }
    });
  }

  // 로그인 API
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return apiCallWithRetry(() async {
      try {
        final dio = createDio();
        final response = await dio.post(
          '/users/login',
          data: {'email': email, 'password': password},
        );

        if (response.data['token'] != null) {
          await saveToken(response.data['token']);
        }

        return {'success': true, 'data': response.data};
      } catch (e) {
        if (e is DioException) {
          return {
            'success': false,
            'message': e.response?.data['message'] ?? '로그인에 실패했습니다.',
          };
        }
        return {'success': false, 'message': '네트워크 오류가 발생했습니다.'};
      }
    });
  }
}
