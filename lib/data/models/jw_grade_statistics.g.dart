// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_grade_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwGradeStatistics _$JwGradeStatisticsFromJson(Map<String, dynamic> json) {
  return JwGradeStatistics()
    ..PJJD = (json['PJJD'] as num)?.toDouble()
    ..SDXF = (json['SDXF'] as num)?.toDouble()
    ..WTGXF = (json['WTGXF'] as num)?.toDouble()
    ..SXMS = json['SXMS'] as int
    ..TGMS = json['TGMS'] as int
    ..WTGMS = json['WTGMS'] as int
    ..BKCS = json['BKCS'] as int
    ..CXCS = json['CXCS'] as int;
}

Map<String, dynamic> _$JwGradeStatisticsToJson(JwGradeStatistics instance) =>
    <String, dynamic>{
      'PJJD': instance.PJJD,
      'SDXF': instance.SDXF,
      'WTGXF': instance.WTGXF,
      'SXMS': instance.SXMS,
      'TGMS': instance.TGMS,
      'WTGMS': instance.WTGMS,
      'BKCS': instance.BKCS,
      'CXCS': instance.CXCS,
    };
