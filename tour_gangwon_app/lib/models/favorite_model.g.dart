// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteItem _$FavoriteItemFromJson(Map<String, dynamic> json) => FavoriteItem(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  place: Place.fromJson(json['place_id'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$FavoriteItemToJson(FavoriteItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'place_id': instance.place.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
    };

FavoriteRequest _$FavoriteRequestFromJson(Map<String, dynamic> json) =>
    FavoriteRequest(placeId: json['place_id'] as String);

Map<String, dynamic> _$FavoriteRequestToJson(FavoriteRequest instance) =>
    <String, dynamic>{'place_id': instance.placeId};

FavoriteStatus _$FavoriteStatusFromJson(Map<String, dynamic> json) =>
    FavoriteStatus(isFavorite: json['is_favorite'] as bool);

Map<String, dynamic> _$FavoriteStatusToJson(FavoriteStatus instance) =>
    <String, dynamic>{'is_favorite': instance.isFavorite};
