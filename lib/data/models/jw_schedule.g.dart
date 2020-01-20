// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwSchedule _$JwScheduleFromJson(Map<String, dynamic> json) {
  return JwSchedule()
    ..AdjustDays = (json['AdjustDays'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleForDay.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$JwScheduleToJson(JwSchedule instance) =>
    <String, dynamic>{
      'AdjustDays': instance.AdjustDays,
    };
