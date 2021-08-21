import 'package:json_annotation/json_annotation.dart';

part 'jw_grade_statistics.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwGradeStatistics {
  JwGradeStatistics();

  /// * '3.51'
  double PJJD;

  /// * '45.0'
  double SDXF;

  /// * '0.0'
  double WTGXF;

  /// * '19'
  int SXMS;

  /// * '19'
  int TGMS;

  /// * '0'
  int WTGMS;

  /// * '0'
  int BKCS;

  /// * '0'
  int CXCS;

  factory JwGradeStatistics.fromJson(Map<String, dynamic> json) =>
      _$JwGradeStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$JwGradeStatisticsToJson(this);
}
