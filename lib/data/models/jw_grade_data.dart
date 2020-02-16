import 'package:custed2/data/models/jw_grade.dart';
import 'package:custed2/data/models/jw_grade_statistics.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_grade_data.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwGradeData {
  JwGradeData();

  JwGradeStatistics GradeStatistics;

  List<JwGrade> GradeList;

  factory JwGradeData.fromJson(Map<String, dynamic> json) =>
      _$JwGradeDataFromJson(json);

  Map<String, dynamic> toJson() => _$JwGradeDataToJson(this);

  @override
  String toString() {
    return 'JwGradeData<${GradeStatistics.PJJD}:${GradeStatistics.TGMS}:${GradeStatistics.SDXF}>';
  }
}
