import 'package:json_annotation/json_annotation.dart';

part 'jw_schedule_class.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwScheduleClass {
  JwScheduleClass();
  
  String ID;
  String Name;

  factory JwScheduleClass.fromJson(Map<String, dynamic> json) =>
      _$JwScheduleClassFromJson(json);

  Map<String, dynamic> toJson() => _$JwScheduleClassToJson(this);
}
