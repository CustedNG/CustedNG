// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_schedule_for_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwScheduleForDay _$JwScheduleForDayFromJson(Map<String, dynamic> json) {
  return JwScheduleForDay()
    ..MN__TimePieces = (json['MN__TimePieces'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleSection.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..AM__TimePieces = (json['AM__TimePieces'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleSection.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..AF__TimePieces = (json['AF__TimePieces'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleSection.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..PM__TimePieces = (json['PM__TimePieces'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleSection.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..EV__TimePieces = (json['EV__TimePieces'] as List)
        ?.map((e) => e == null
            ? null
            : JwScheduleSection.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..EnglishTitle = json['EnglishTitle'] as String
    ..FullTitle = json['FullTitle'] as String
    ..SimpleEnglish = json['SimpleEnglish'] as String
    ..SimpleTitle = json['SimpleTitle'] as String
    ..WIndex = json['WIndex'] as int;
}

Map<String, dynamic> _$JwScheduleForDayToJson(JwScheduleForDay instance) =>
    <String, dynamic>{
      'MN__TimePieces': instance.MN__TimePieces,
      'AM__TimePieces': instance.AM__TimePieces,
      'AF__TimePieces': instance.AF__TimePieces,
      'PM__TimePieces': instance.PM__TimePieces,
      'EV__TimePieces': instance.EV__TimePieces,
      'EnglishTitle': instance.EnglishTitle,
      'FullTitle': instance.FullTitle,
      'SimpleEnglish': instance.SimpleEnglish,
      'SimpleTitle': instance.SimpleTitle,
      'WIndex': instance.WIndex,
    };
