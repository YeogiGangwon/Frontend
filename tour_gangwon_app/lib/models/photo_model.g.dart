// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
  contentId: json['galContentId'] as String,
  contentTypeId: json['galContentTypeId'] as String,
  title: json['galTitle'] as String,
  webImageUrl: json['galWebImageUrl'] as String,
  photographer: json['galPhotographer'] as String,
  searchKeyword: json['galSearchKeyword'] as String,
);

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
  'galContentId': instance.contentId,
  'galContentTypeId': instance.contentTypeId,
  'galTitle': instance.title,
  'galWebImageUrl': instance.webImageUrl,
  'galPhotographer': instance.photographer,
  'galSearchKeyword': instance.searchKeyword,
};

Items _$ItemsFromJson(Map<String, dynamic> json) => Items(
  item: (json['item'] as List<dynamic>)
      .map((e) => Photo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
  'item': instance.item,
};

Body _$BodyFromJson(Map<String, dynamic> json) => Body(
  items: Items.fromJson(json['items'] as Map<String, dynamic>),
  pageNo: (json['pageNo'] as num?)?.toInt(),
  numOfRows: (json['numOfRows'] as num?)?.toInt(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$BodyToJson(Body instance) => <String, dynamic>{
  'items': instance.items,
  'pageNo': instance.pageNo,
  'numOfRows': instance.numOfRows,
  'totalCount': instance.totalCount,
};

ResponseHeader _$ResponseHeaderFromJson(Map<String, dynamic> json) =>
    ResponseHeader(
      resultCode: json['resultCode'] as String,
      resultMsg: json['resultMsg'] as String,
    );

Map<String, dynamic> _$ResponseHeaderToJson(ResponseHeader instance) =>
    <String, dynamic>{
      'resultCode': instance.resultCode,
      'resultMsg': instance.resultMsg,
    };

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) => ApiResponse(
  header: ResponseHeader.fromJson(json['header'] as Map<String, dynamic>),
  body: Body.fromJson(json['body'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) =>
    <String, dynamic>{'header': instance.header, 'body': instance.body};

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
  apiResponse: ApiResponse.fromJson(json['response'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{'response': instance.apiResponse};
