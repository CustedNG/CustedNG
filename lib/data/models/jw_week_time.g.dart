// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_week_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwWeekTime _$JwWeekTimeFromJson(Map<String, dynamic> json) {
  return JwWeekTime()
    ..CurWeek = json['CurWeek'] as int
    ..CurWeekMonday = json['CurWeekMonday'] as String
    ..CurWeekSunday = json['CurWeekSunday'] as String;
}

Map<String, dynamic> _$JwWeekTimeToJson(JwWeekTime instance) =>
    <String, dynamic>{
      'CurWeek': instance.CurWeek,
      'CurWeekMonday': instance.CurWeekMonday,
      'CurWeekSunday': instance.CurWeekSunday,
    };
