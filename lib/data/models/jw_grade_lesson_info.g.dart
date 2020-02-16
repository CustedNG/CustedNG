// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_grade_lesson_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwGradeLessonInfo _$JwGradeLessonInfoFromJson(Map<String, dynamic> json) {
  return JwGradeLessonInfo()
    ..ID = json['ID'] as String
    ..TPKCXXID = json['TPKCXXID'] as String
    ..KCBH = json['KCBH'] as String
    ..KCMC = json['KCMC'] as String;
}

Map<String, dynamic> _$JwGradeLessonInfoToJson(JwGradeLessonInfo instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'TPKCXXID': instance.TPKCXXID,
      'KCBH': instance.KCBH,
      'KCMC': instance.KCMC,
    };
