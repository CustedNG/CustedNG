import 'package:hive/hive.dart';

part 'grade_detail.g.dart';

@HiveType(typeId: 6)
class GradeDetail extends HiveObject {
  @HiveField(0)
  String year;

  @HiveField(1)
  String testStatus;

  @HiveField(2)
  String lessonType;

  @HiveField(3)
  double schoolHour;

  @HiveField(4)
  double credit;

  @HiveField(5)
  double mark;

  @HiveField(6)
  String rawMark;

  @HiveField(7)
  String lessonName;

  @HiveField(8)
  String testType;

  @HiveField(9)
  String lessonCategory;

  @override
  String toString() {
    return 'GradeDetail<>';
  }
}
