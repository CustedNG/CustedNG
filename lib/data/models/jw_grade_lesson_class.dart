import 'package:json_annotation/json_annotation.dart';

part 'jw_grade_lesson_class.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwGradeLessonClass {
  JwGradeLessonClass();

  /// e.g. "d55ad6b8-345e-4977-b837-272f1ec626a9"
  String ID;

  /// 同$ID
  /// e.g. "d55ad6b8-345e-4977-b837-272f1ec626a9"，
  String TPKCLBID;

  /// 分类编号
  /// e.g. "02"
  String FLBH;

  /// 分类名称
  /// e.g. "公共基础课"
  String FLMC;

  factory JwGradeLessonClass.fromJson(Map<String, dynamic> json) =>
      _$JwGradeLessonClassFromJson(json);

  Map<String, dynamic> toJson() => _$JwGradeLessonClassToJson(this);
}
