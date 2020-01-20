import 'package:custed2/data/models/jw_schedule_for_day.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_schedule_lesson_prop.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwScheduleLessonProperty {
  JwScheduleLessonProperty();
  
  String ID;
  String Key;
  String Name;

  factory JwScheduleLessonProperty.fromJson(Map<String, dynamic> json) =>
      _$JwScheduleLessonPropertyFromJson(json);

  Map<String, dynamic> toJson() => _$JwScheduleLessonPropertyToJson(this);
}
