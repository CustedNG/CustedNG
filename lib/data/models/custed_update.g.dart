// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custed_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustedUpdate _$CustedUpdateFromJson(Map<String, dynamic> json) {
  return CustedUpdate()
    ..build = json['build'] as int
    ..name = json['name'] as String
    ..changelog = json['changelog'] as String
    ..file = json['file'] == null
        ? null
        : CustedFile.fromJson(json['file'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CustedUpdateToJson(CustedUpdate instance) =>
    <String, dynamic>{
      'build': instance.build,
      'name': instance.name,
      'changelog': instance.changelog,
      'file': instance.file,
    };
