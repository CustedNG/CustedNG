// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_schedule_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwScheduleSection _$JwScheduleSectionFromJson(Map<String, dynamic> json) {
  return JwScheduleSection()
    ..StartTime = json['StartTime'] as String
    ..EndTime = json['EndTime'] as String
    ..StartSection = json['StartSection'] as int
    ..EndSection = json['EndSection'] as int
    ..Title = json['Title'] as String
    ..PrintTitle = json['PrintTitle'] as String
    ..Section = json['Section'] as String
    ..Dtos = (json['Dtos'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleLesson.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$JwScheduleSectionToJson(JwScheduleSection instance) =>
    <String, dynamic>{
      'StartTime': instance.StartTime,
      'EndTime': instance.EndTime,
      'StartSection': instance.StartSection,
      'EndSection': instance.EndSection,
      'Title': instance.Title,
      'PrintTitle': instance.PrintTitle,
      'Section': instance.Section,
      'Dtos': instance.Dtos,
    };
