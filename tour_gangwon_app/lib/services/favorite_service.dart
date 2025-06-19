import 'package:dio/dio.dart';
import '../models/favorite_model.dart';
import 'api_client.dart';

class FavoriteService {
  final Dio _dio = ApiClient.createDio(); // 인증 헤더가 포함된 Dio 인스턴스 사용

  /// 즐겨찾기 목록 조회
  Future<List<FavoriteItem>> getFavorites() async {
    try {
      final response = await _dio.get('/favorites');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => FavoriteItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
        }
        throw Exception('즐겨찾기 목록을 불러오는데 실패했습니다: ${e.message}');
      }
      throw Exception('즐겨찾기 목록을 불러오는데 실패했습니다.');
    }
  }

  /// 즐겨찾기 추가
  Future<FavoriteItem> addFavorite(String placeId) async {
    try {
      final request = FavoriteRequest(placeId: placeId);
      final response = await _dio.post('/favorites', data: request.toJson());

      if (response.statusCode == 201) {
        return FavoriteItem.fromJson(response.data);
      } else {
        throw Exception('Failed to add favorite: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding favorite: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
        } else if (e.response?.statusCode == 409) {
          throw Exception('이미 즐겨찾기에 추가된 장소입니다.');
        }
        throw Exception('즐겨찾기 추가에 실패했습니다: ${e.message}');
      }
      throw Exception('즐겨찾기 추가에 실패했습니다.');
    }
  }

  /// 즐겨찾기 삭제
  Future<void> removeFavorite(String placeId) async {
    try {
      final response = await _dio.delete('/favorites/place/$placeId');

      if (response.statusCode != 200) {
        throw Exception('Failed to remove favorite: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing favorite: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
        } else if (e.response?.statusCode == 404) {
          throw Exception('즐겨찾기에서 찾을 수 없는 장소입니다.');
        }
        throw Exception('즐겨찾기 삭제에 실패했습니다: ${e.message}');
      }
      throw Exception('즐겨찾기 삭제에 실패했습니다.');
    }
  }

  /// 특정 장소의 즐겨찾기 상태 확인
  Future<bool> getFavoriteStatus(String placeId) async {
    try {
      print('즐겨찾기 상태 확인 요청: placeId=$placeId');
      final response = await _dio.get('/favorites/status/$placeId');

      print('즐겨찾기 상태 확인 응답: ${response.statusCode}');
      print('응답 데이터: ${response.data}');

      if (response.statusCode == 200) {
        final status = FavoriteStatus.fromJson(response.data);
        return status.isFavorite;
      } else {
        throw Exception(
          'Failed to get favorite status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting favorite status: $e');
      if (e is DioException) {
        print('DioException 상세:');
        print('  - statusCode: ${e.response?.statusCode}');
        print('  - data: ${e.response?.data}');
        print('  - message: ${e.message}');
        print('  - type: ${e.type}');

        if (e.response?.statusCode == 401) {
          throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
        } else if (e.response?.statusCode == 500) {
          final errorData = e.response?.data;
          if (errorData is Map && errorData['error'] != null) {
            throw Exception('서버 오류: ${errorData['error']}');
          } else {
            throw Exception('서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
          }
        }
        throw Exception('즐겨찾기 상태 확인에 실패했습니다: ${e.message}');
      }
      throw Exception('즐겨찾기 상태 확인에 실패했습니다.');
    }
  }

  /// 즐겨찾기 토글 (추가/삭제)
  Future<bool> toggleFavorite(String placeId) async {
    try {
      final isCurrentlyFavorite = await getFavoriteStatus(placeId);

      if (isCurrentlyFavorite) {
        await removeFavorite(placeId);
        return false;
      } else {
        await addFavorite(placeId);
        return true;
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }
}
