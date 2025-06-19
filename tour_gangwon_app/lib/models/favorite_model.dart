import 'package:json_annotation/json_annotation.dart';
import 'place_model.dart';

part 'favorite_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteItem {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'place_id')
  final Place place; // 백엔드에서 place_id가 Place 객체로 populate됨
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  FavoriteItem({
    required this.id,
    required this.userId,
    required this.place,
    required this.createdAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemToJson(this);
}

// 즐겨찾기 추가/삭제를 위한 간단한 요청 모델
@JsonSerializable()
class FavoriteRequest {
  @JsonKey(name: 'place_id')
  final int placeId;

  FavoriteRequest({required this.placeId});

  factory FavoriteRequest.fromJson(Map<String, dynamic> json) =>
      _$FavoriteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteRequestToJson(this);
}

// 즐겨찾기 상태 응답 모델
@JsonSerializable()
class FavoriteStatus {
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;

  FavoriteStatus({required this.isFavorite});

  factory FavoriteStatus.fromJson(Map<String, dynamic> json) =>
      _$FavoriteStatusFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteStatusToJson(this);
}
