// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_schedule_lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwScheduleLesson _$JwScheduleLessonFromJson(Map<String, dynamic> json) {
  return JwScheduleLesson()
    ..BeginLessonID = json['BeginLessonID'] as String
    ..LessonObjName = json['LessonObjName'] as String
    ..LessonOccupyID = json['LessonOccupyID'] as String
    ..Classs = (json['Classs'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleClass.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..Content = (json['Content'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleLessonProperty.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..QueryType = json['QueryType'] as int;
}

Map<String, dynamic> _$JwScheduleLessonToJson(JwScheduleLesson instance) =>
    <String, dynamic>{
      'BeginLessonID': instance.BeginLessonID,
      'LessonObjName': instance.LessonObjName,
      'LessonOccupyID': instance.LessonOccupyID,
      'Classs': instance.Classs,
      'Content': instance.Content,
      'QueryType': instance.QueryType,
    };
