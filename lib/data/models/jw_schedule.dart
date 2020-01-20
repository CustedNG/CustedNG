import 'package:custed2/data/models/jw_schedule_for_day.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_schedule.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwSchedule {
  JwSchedule();

  List<JwScheduleForDay> AdjustDays;

  factory JwSchedule.fromJson(Map<String, dynamic> json) =>
      _$JwScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$JwScheduleToJson(this);

  @override
  String toString() {
    return AdjustDays.map((d) => d.toString()).join('\n');
  }
}
