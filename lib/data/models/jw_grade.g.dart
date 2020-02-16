// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_grade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwGrade _$JwGradeFromJson(Map<String, dynamic> json) {
  return JwGrade()
    ..ID = json['ID'] as String
    ..GRCJXXID = json['GRCJXXID'] as String
    ..LessonClass = json['LessonClass'] == null
        ? null
        : JwGradeLessonClass.fromJson(
            json['LessonClass'] as Map<String, dynamic>)
    ..LessonInfo = json['LessonInfo'] == null
        ? null
        : JwGradeLessonInfo.fromJson(json['LessonInfo'] as Map<String, dynamic>)
    ..KSXNXQ = json['KSXNXQ'] as String
    ..KSXZ = json['KSXZ'] as String
    ..KSZT = json['KSZT'] as String
    ..KCXZ = json['KCXZ'] as String
    ..KHFS = json['KHFS'] as String
    ..XS = (json['XS'] as num)?.toDouble()
    ..XF = (json['XF'] as num)?.toDouble()
    ..YXCJLX = (json['YXCJLX'] as num)?.toDouble()
    ..YXCJ = (json['YXCJ'] as num)?.toDouble()
    ..TGZT = (json['TGZT'] as num)?.toDouble()
    ..WXBJ = json['WXBJ'] as bool
    ..ShowYXCJ = json['ShowYXCJ'] as String;
}

Map<String, dynamic> _$JwGradeToJson(JwGrade instance) => <String, dynamic>{
      'ID': instance.ID,
      'GRCJXXID': instance.GRCJXXID,
      'LessonClass': instance.LessonClass,
      'LessonInfo': instance.LessonInfo,
      'KSXNXQ': instance.KSXNXQ,
      'KSXZ': instance.KSXZ,
      'KSZT': instance.KSZT,
      'KCXZ': instance.KCXZ,
      'KHFS': instance.KHFS,
      'XS': instance.XS,
      'XF': instance.XF,
      'YXCJLX': instance.YXCJLX,
      'YXCJ': instance.YXCJ,
      'TGZT': instance.TGZT,
      'WXBJ': instance.WXBJ,
      'ShowYXCJ': instance.ShowYXCJ,
    };
