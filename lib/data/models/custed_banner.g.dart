// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custed_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustedBanner _$CustedBannerFromJson(Map<String, dynamic> json) {
  return CustedBanner()
    ..action = json['action'] == null
        ? null
        : CustedAction.fromJson(json['action'] as Map<String, dynamic>)
    ..image = json['image'] == null
        ? null
        : CustedFile.fromJson(json['image'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CustedBannerToJson(CustedBanner instance) =>
    <String, dynamic>{
      'action': instance.action,
      'image': instance.image,
    };
