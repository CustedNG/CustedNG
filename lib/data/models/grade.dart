import 'package:custed2/data/models/grade_term.dart';
import 'package:hive/hive.dart';

part 'grade.g.dart';

@HiveType(typeId: 5)
class Grade extends HiveObject {
  @HiveField(0)
  double averageGradePoint;

  @HiveField(1)
  double creditEarned;

  @HiveField(2)
  double creditUnattained;

  @HiveField(3)
  int subjectCount;

  @HiveField(4)
  int subjectPassed;

  @HiveField(5)
  int subjectNotPassed;

  /// 补考
  @HiveField(6)
  int resitCount;

  /// 重修
  @HiveField(7)
  int retakeCount;

  // @HiveField(8)
  // List<GradeDetail> grades;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  String versionHash;

  @HiveField(11)
  List<GradeTerm> terms;

  @override
  String toString() {
    final i =
        terms?.map((e) => '${e.termName}:${e.averageGradePoint}')?.join(', ');
    return 'Grade<$i>($versionHash)';
  }

  double get creditTotal => creditEarned + creditUnattained;
}
