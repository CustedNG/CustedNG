// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custed_update_ios.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustedUpdateiOS _$CustedUpdateiOSFromJson(Map<String, dynamic> json) {
  return CustedUpdateiOS()
    ..min = json['min'] as int
    ..newest = json['newest'] as int
    ..urls = (json['urls'] as List)?.map((e) => e as String)?.toList()
    ..title = json['title'] as String
    ..content = json['content'] as String;
}

Map<String, dynamic> _$CustedUpdateiOSToJson(CustedUpdateiOS instance) =>
    <String, dynamic>{
      'min': instance.min,
      'newest': instance.newest,
      'urls': instance.urls,
      'title': instance.title,
      'content': instance.content,
    };
