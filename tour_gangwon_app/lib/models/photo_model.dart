// tour_gangwon_app/lib/models/photo_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'photo_model.g.dart'; // 이 파일은 나중에 자동 생성됩니다.

@JsonSerializable()
class Photo {
  @JsonKey(name: 'galContentId')
  final String contentId;
  @JsonKey(name: 'galContentTypeId')
  final String contentTypeId;
  @JsonKey(name: 'galTitle')
  final String title;
  @JsonKey(name: 'galWebImageUrl')
  final String webImageUrl;
  @JsonKey(name: 'galPhotographer')
  final String photographer;
  @JsonKey(name: 'galSearchKeyword')
  final String searchKeyword;

  Photo({
    required this.contentId,
    required this.contentTypeId,
    required this.title,
    required this.webImageUrl,
    required this.photographer,
    required this.searchKeyword,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

// API 응답의 전체 구조에 맞춰 모델을 정의해야 합니다.
// 한국관광공사 API의 응답은 보통 { "response": { "header": {}, "body": { "items": { "item": [...] } } } } 형태입니다.

@JsonSerializable()
class Items {
  final List<Photo> item;

  Items({required this.item});

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class Body {
  final Items items;
  // pageNo, numOfRows, totalCount 등도 추가할 수 있습니다.
  final int? pageNo;
  final int? numOfRows;
  final int? totalCount;

  Body({required this.items, this.pageNo, this.numOfRows, this.totalCount});

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);
  Map<String, dynamic> toJson() => _$BodyToJson(this);
}

@JsonSerializable()
class ResponseHeader {
  final String resultCode;
  final String resultMsg;

  ResponseHeader({required this.resultCode, required this.resultMsg});

  factory ResponseHeader.fromJson(Map<String, dynamic> json) => _$ResponseHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseHeaderToJson(this);
}

@JsonSerializable()
class ApiResponse {
  final ResponseHeader header;
  final Body body;

  ApiResponse({required this.header, required this.body});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: 'response')
  final ApiResponse apiResponse;

  BaseResponse({required this.apiResponse});

  factory BaseResponse.fromJson(Map<String, dynamic> json) => _$BaseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}