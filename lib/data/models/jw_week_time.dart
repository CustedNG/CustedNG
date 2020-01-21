import 'package:custed2/data/models/jw_schedule_for_day.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_week_time.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwWeekTime {
  JwWeekTime();

  int CurWeek;
  String CurWeekMonday;
  String CurWeekSunday;

  factory JwWeekTime.fromJson(Map<String, dynamic> json) =>
      _$JwWeekTimeFromJson(json);

  Map<String, dynamic> toJson() => _$JwWeekTimeToJson(this);

  @override
  String toString() {
    return 'week $CurWeek: $CurWeekMonday -> $CurWeekSunday';
  }
}
