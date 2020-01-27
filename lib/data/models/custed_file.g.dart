// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custed_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustedFile _$CustedFileFromJson(Map<String, dynamic> json) {
  return CustedFile()
    ..size = (json['size'] as num)?.toDouble()
    ..url = json['url'] as String
    ..sha256 = json['sha256'] as String;
}

Map<String, dynamic> _$CustedFileToJson(CustedFile instance) =>
    <String, dynamic>{
      'size': instance.size,
      'url': instance.url,
      'sha256': instance.sha256,
    };
