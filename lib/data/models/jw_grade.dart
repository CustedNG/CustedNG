import 'package:custed2/data/models/jw_grade_lesson_class.dart';
import 'package:custed2/data/models/jw_grade_lesson_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_grade.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwGrade {
  JwGrade();

  /// e.g. "fe9feb18-ebc5-4590-9767-3695cec4c828"
  String ID;

  /// 同$ID
  /// e.g. "fe9feb18-ebc5-4590-9767-3695cec4c828"
  String GRCJXXID;

  JwGradeLessonClass LessonClass;

  JwGradeLessonInfo LessonInfo;

  /// 学期编号
  /// e.g. "20182"
  String KSXNXQ;

  /// 考试性质
  /// e.g. "正常"
  String KSXZ;

  /// 考试状态
  /// e.g. "正常"
  String KSZT;

  /// 课程性质
  /// e.g. "必修"
  String KCXZ;

  /// 考核方式
  /// e.g. "考试"
  String KHFS;

  /// 学时
  /// e.g. 96.0
  double XS;

  /// 学分
  /// e.g. 6.0
  double XF;

  /// 不知道是什么...
  /// e.g. 0
  double YXCJLX;

  /// 有效成绩
  /// e.g. 82.0|null
  double YXCJ;

  /// 通过状态？
  /// e.g. 3
  double TGZT;

  /// 不知道是什么...
  /// e.g. false
  bool WXBJ;

  /// 原始成绩
  /// e.g. "优秀"
  String ShowYXCJ;

  factory JwGrade.fromJson(Map<String, dynamic> json) =>
      _$JwGradeFromJson(json);

  Map<String, dynamic> toJson() => _$JwGradeToJson(this);
}
