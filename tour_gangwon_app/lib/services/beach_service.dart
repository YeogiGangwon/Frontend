import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import '../models/beach_model.dart';
import 'api_client.dart';

class BeachService {
  static List<Beach> _beaches = [];
  static bool _isLoaded = false;
  static final Dio _dio = ApiClient.createDio();

  // 해수욕장 데이터 로드
  static Future<void> loadBeaches() async {
    if (_isLoaded) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/beaches.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      _beaches = jsonData.map((json) => Beach.fromJson(json)).toList();
      _isLoaded = true;

      print('해수욕장 데이터 로드 완료: ${_beaches.length}개');
    } catch (e) {
      print('해수욕장 데이터 로드 실패: $e');
      _beaches = [];
    }
  }

  // 날씨 정보 가져오기
  static Future<Map<String, dynamic>?> getWeatherInfo(
    double lat,
    double lon,
  ) async {
    try {
      final response = await _dio.get(
        '/weather/today',
        queryParameters: {'lat': lat.toString(), 'lon': lon.toString()},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('날씨 정보 가져오기 실패: $e');
    }
    return null;
  }

  // 혼잡도 정보 가져오기
  static Future<Map<String, dynamic>?> getCongestionInfo(
    String beachName,
  ) async {
    try {
      print('혼잡도 정보 요청: $beachName');
      final response = await _dio.get('/congestion');

      print('혼잡도 API 응답 상태: ${response.statusCode}');
      print('혼잡도 API 응답 데이터: ${response.data}');

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> congestionData = response.data;
        print('받은 혼잡도 데이터 개수: ${congestionData.length}');

        // 해수욕장 이름으로 CCTV ID 매핑
        final Map<String, String> beachCctvMap = {
          '남항진': 'cctv001',
          '강문': 'cctv002',
          '경포': 'cctv003',
          '소돌': 'cctv004',
          '염전': 'cctv005',
          '영진': 'cctv006',
          '정동진': 'cctv007',
          '공현진': 'cctv008',
          '교암': 'cctv009',
          '봉포': 'cctv010',
          '초도': 'cctv011',
          '영랑': 'cctv012',
          '하맹방': 'cctv013',
          '원평': 'cctv014',
          '문암·초곡': 'cctv015',
        };

        final cctvId = beachCctvMap[beachName];
        print('해수욕장 "$beachName"에 해당하는 CCTV ID: $cctvId');

        if (cctvId != null) {
          final congestionInfo = congestionData.firstWhere(
            (item) => item['cameraId'] == cctvId,
            orElse: () => null,
          );

          if (congestionInfo != null) {
            print('찾은 혼잡도 정보: $congestionInfo');
            return {
              'score': congestionInfo['score'] ?? 0,
              'level': congestionInfo['level'] ?? 'Low',
              'personCount': congestionInfo['personCount'] ?? 0,
              'timestamp': congestionInfo['timestamp'],
              'dataAvailable': congestionInfo['dataAvailable'] ?? false,
              'location': congestionInfo['location'] ?? '',
              'name': congestionInfo['name'] ?? beachName,
            };
          } else {
            print('해당 CCTV ID로 데이터를 찾을 수 없음');
          }
        } else {
          print('매핑되지 않은 해수욕장 이름: $beachName');
        }
      } else {
        print(
          '혼잡도 API 응답 형태 오류: 상태코드=${response.statusCode}, 데이터타입=${response.data.runtimeType}',
        );
      }
    } catch (e) {
      print('혼잡도 정보 가져오기 실패: $e');
      if (e is DioException) {
        print('Dio 에러 상세정보:');
        print('- 에러 타입: ${e.type}');
        print('- 응답 코드: ${e.response?.statusCode}');
        print('- 에러 메시지: ${e.message}');
        print('- 요청 URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      }
    }
    return null;
  }

  // 모든 해수욕장 목록 반환
  static List<Beach> getAllBeaches() {
    return List.from(_beaches);
  }

  // ID로 해수욕장 찾기
  static Beach? getBeachById(String id) {
    try {
      return _beaches.firstWhere((beach) => beach.id == id);
    } catch (e) {
      return null;
    }
  }

  // 이름으로 해수욕장 찾기
  static Beach? getBeachByName(String name) {
    try {
      return _beaches.firstWhere((beach) => beach.name == name);
    } catch (e) {
      return null;
    }
  }

  // 도시별 해수욕장 목록
  static List<Beach> getBeachesByCity(String city) {
    return _beaches.where((beach) => beach.city == city).toList();
  }

  // 이미지가 있는 해수욕장 목록
  static List<Beach> getBeachesWithImages() {
    return _beaches.where((beach) => beach.tourInfo.hasImages).toList();
  }

  // 상세 정보가 있는 해수욕장 목록
  static List<Beach> getBeachesWithDetailedInfo() {
    return _beaches.where((beach) => beach.hasDetailedInfo).toList();
  }

  // 주차 가능한 해수욕장 목록
  static List<Beach> getBeachesWithParking() {
    return _beaches.where((beach) => beach.tourInfo.hasParking).toList();
  }

  // 검색 기능
  static List<Beach> searchBeaches(String query) {
    if (query.isEmpty) return getAllBeaches();

    final lowerQuery = query.toLowerCase();
    return _beaches.where((beach) {
      return beach.name.toLowerCase().contains(lowerQuery) ||
          beach.city.toLowerCase().contains(lowerQuery) ||
          beach.description.toLowerCase().contains(lowerQuery) ||
          beach.tourInfo.title.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // 도시 목록 반환
  static List<String> getCities() {
    return _beaches.map((beach) => beach.city).toSet().toList()..sort();
  }

  // 통계 정보
  static Map<String, dynamic> getStatistics() {
    return {
      'total': _beaches.length,
      'withImages': getBeachesWithImages().length,
      'withDetailedInfo': getBeachesWithDetailedInfo().length,
      'withParking': getBeachesWithParking().length,
      'cities': getCities().length,
    };
  }
}
