// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_grade_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwGradeData _$JwGradeDataFromJson(Map<String, dynamic> json) {
  return JwGradeData()
    ..GradeStatistics = json['GradeStatistics'] == null
        ? null
        : JwGradeStatistics.fromJson(
            json['GradeStatistics'] as Map<String, dynamic>)
    ..GradeList = (json['GradeList'] as List)
        ?.map((e) =>
            e == null ? null : JwGrade.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$JwGradeDataToJson(JwGradeData instance) =>
    <String, dynamic>{
      'GradeStatistics': instance.GradeStatistics,
      'GradeList': instance.GradeList,
    };
