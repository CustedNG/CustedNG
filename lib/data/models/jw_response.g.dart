// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwResponse _$JwResponseFromJson(Map<String, dynamic> json) {
  return JwResponse()
    ..state = json['state'] as int
    ..message = json['message'] as String
    ..data = json['data'] as Map<String, dynamic>;
}

Map<String, dynamic> _$JwResponseToJson(JwResponse instance) =>
    <String, dynamic>{
      'state': instance.state,
      'message': instance.message,
      'data': instance.data,
    };
