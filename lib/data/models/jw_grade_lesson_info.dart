import 'package:json_annotation/json_annotation.dart';

part 'jw_grade_lesson_info.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwGradeLessonInfo {
  JwGradeLessonInfo();

  /// e.g. "40057ba7-48d9-4536-8994-c69a2635061f"
  String ID;

  /// 同$ID
  /// e.g. "40057ba7-48d9-4536-8994-c69a2635061f"，
  String TPKCXXID;

  /// 课程编号
  /// e.g. "010711010"
  String KCBH;

  /// 课程名称
  /// e.g. "高等数学Ⅱ"
  String KCMC;

  factory JwGradeLessonInfo.fromJson(Map<String, dynamic> json) =>
      _$JwGradeLessonInfoFromJson(json);

  Map<String, dynamic> toJson() => _$JwGradeLessonInfoToJson(this);
}
