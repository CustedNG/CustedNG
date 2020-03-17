import 'package:custed2/data/models/grade_detail.dart';
import 'package:hive/hive.dart';

part 'grade_term.g.dart';

@HiveType(typeId: 7)
class GradeTerm extends HiveObject {
  @HiveField(0)
  double averageGradePoint;

  @HiveField(1)
  double creditTotal;

  @HiveField(2)
  double creditEarned;

  @HiveField(3)
  int subjectCount;

  @HiveField(4)
  int subjectPassed;

  @HiveField(6)
  List<GradeDetail> grades;

  @HiveField(7)
  String termName;

  @HiveField(8)
  double averageGradePointNoElectiveCourse;

  @override
  String toString() {
    return 'GradeTerm<$termName>';
  }
}
