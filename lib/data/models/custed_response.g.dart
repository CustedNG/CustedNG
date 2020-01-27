// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustedResponse _$CustedResponseFromJson(Map<String, dynamic> json) {
  return CustedResponse()
    ..ok = json['ok'] as bool
    ..data = json['data']
    ..error = json['error'] as String;
}

Map<String, dynamic> _$CustedResponseToJson(CustedResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'data': instance.data,
      'error': instance.error,
    };
