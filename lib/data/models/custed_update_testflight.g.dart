// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custed_update_testflight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustedUpdateTestflight _$CustedUpdateTestflightFromJson(
    Map<String, dynamic> json) {
  return CustedUpdateTestflight()
    ..min = json['min'] as int
    ..newest = json['newest'] as int
    ..url = json['url'] as String;
}

Map<String, dynamic> _$CustedUpdateTestflightToJson(
        CustedUpdateTestflight instance) =>
    <String, dynamic>{
      'min': instance.min,
      'newest': instance.newest,
      'url': instance.url,
    };
