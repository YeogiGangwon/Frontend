import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../models/place_model.dart';
import 'api_client.dart';

class PlaceService {
  static List<Place>? _cachedPlaces;
  static const String baseUrl = 'http://localhost:3000'; // 백엔드 서버 URL
  static final Dio _dio = ApiClient.createDio(); // 인증 헤더가 포함된 Dio 인스턴스

  static Future<List<Place>> loadPlaces() async {
    if (_cachedPlaces != null) {
      return _cachedPlaces!;
    }

    try {
      // Dio를 사용한 새로운 구현
      final response = await _dio.get('/places');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _cachedPlaces = data.map((json) => Place.fromJson(json)).toList();
        return _cachedPlaces!;
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading places: $e');
      // Dio 요청 실패 시 fallback으로 기존 http 패키지 사용
      return await _loadPlacesWithHttp();
    }
  }

  // 기존 http 패키지를 사용한 fallback 메서드
  static Future<List<Place>> _loadPlacesWithHttp() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/places'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cachedPlaces = data.map((json) => Place.fromJson(json)).toList();
        return _cachedPlaces!;
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading places with http: $e');
      return [];
    }
  }

  static Place? getPlaceById(int id) {
    if (_cachedPlaces == null) return null;
    return _cachedPlaces!.firstWhere(
      (place) => place.id == id,
      orElse: () => _cachedPlaces!.first,
    );
  }

  // 캐시를 강제로 새로고침하는 메서드 추가
  static Future<List<Place>> refreshPlaces() async {
    _cachedPlaces = null;
    return await loadPlaces();
  }
}
