import 'package:custed2/data/models/jw_schedule_lesson.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_schedule_section.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwScheduleSection {
  JwScheduleSection();

  /// e.g. "18:00"
  String StartTime;

  /// e.g. "19:35"
  String EndTime;

  /// e.g. 9
  int StartSection;

  /// e.g. 10
  int EndSection;

  /// e.g. "第9-10节"
  String Title;

  /// e.g. "第9-10节"
  String PrintTitle;

  /// e.g. "0910"
  String Section;

  List<JwScheduleLesson> Dtos;

  factory JwScheduleSection.fromJson(Map<String, dynamic> json) =>
      _$JwScheduleSectionFromJson(json);

  Map<String, dynamic> toJson() => _$JwScheduleSectionToJson(this);

  @override
  String toString() {
    return '$Title: ' + Dtos.map((l) => l.toString()).join(' | ');
  }
}
