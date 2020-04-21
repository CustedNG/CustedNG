// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custed_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustedAction _$CustedActionFromJson(Map<String, dynamic> json) {
  return CustedAction()
    ..link = json['link'] == null
        ? null
        : CustedLink.fromJson(json['link'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CustedActionToJson(CustedAction instance) =>
    <String, dynamic>{
      'link': instance.link,
    };
