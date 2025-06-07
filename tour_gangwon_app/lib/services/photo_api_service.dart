// tour_gangwon_app/lib/services/photo_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_gangwon_app/models/photo_model.dart'; // 모델 파일 경로 확인

class PhotoApiService {
  // TODO: 발급받은 실제 서비스 키를 URL 인코딩하여 여기에 입력하세요.
  // 예시: Uri.encodeComponent("실제 인증키")
  static const String _serviceKey = 'rsX3tRPhgMdmmvUniwYGbjXzRdXB9i67XpqgnTdIgomCg/fu3S0E8pArOo28a7Vfr/tJzwdvp7oIrPxDPuQSXA==';
  static const String _baseUrl = 'http://apis.data.go.kr/B551011/PhotoGalleryService1';

  Future<List<Photo>> fetchPhotos({
    int numOfRows = 10,
    int pageNo = 1,
    String mobileOS = 'AND', // 또는 'IOS'
    String mobileApp = 'TourGangwonApp', // 본인 앱 이름으로 변경
    String? keyword, // 검색 키워드 (선택 사항)
  }) async {
    String url = '$_baseUrl/galleryList1' // 또는 gallerySearchList1 등 API 가이드에 명시된 메소드
        '?serviceKey=$_serviceKey'
        '&numOfRows=$numOfRows'
        '&pageNo=$pageNo'
        '&MobileOS=$mobileOS'
        '&MobileApp=${Uri.encodeComponent(mobileApp)}'
        '&_type=json'; // JSON 응답 형식 요청

    if (keyword != null && keyword.isNotEmpty) {
      // API 가이드에 따라 검색 키워드 파라미터 이름 확인 (galSearchKeyword 등)
      // 대부분의 경우 `keyword` 파라미터는 `gallerySearchList1` 엔드포인트에서 사용됩니다.
      // 현재는 `galleryList1`에 키워드 파라미터가 없다고 가정합니다.
      // 만약 `galleryList1`에서도 키워드 검색이 가능하다면 여기에 추가.
      // url += '&galSearchKeyword=${Uri.encodeComponent(keyword)}';
    }

    print('Request URL: $url'); // 디버깅을 위해 요청 URL 출력

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('API Response: $jsonResponse'); // 디버깅을 위해 응답 출력

        // 정의한 데이터 모델에 따라 파싱
        final BaseResponse baseResponse = BaseResponse.fromJson(jsonResponse);
        
        if (baseResponse.apiResponse.header.resultCode.startsWith('00')) {
          return baseResponse.apiResponse.body.items.item;
        } else {
          throw Exception('API Error: ${baseResponse.apiResponse.header.resultMsg}');
        }
      } else {
        throw Exception('Failed to load photos: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching photos: $e');
    }
  }
}