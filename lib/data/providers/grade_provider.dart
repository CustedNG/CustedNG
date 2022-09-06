import 'dart:math';

import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/store/grade_store.dart';
import 'package:custed2/locator.dart';

class GradeProvider extends BusyProvider {
  Grade _grade;
  Grade get grade => _grade;

  Future<void> loadLocalData() async {
    final gradeStore = await locator.getAsync<GradeStore>();
    _grade = gradeStore.head;

    safeOperation();

    if (_grade != null) {
      print('[GRADE] Use cached: $_grade');
      notifyListeners();
    }
  }

  Future<void> safeOperation() async {
    int standardMark = 90;
    final now = DateTime.now();

    if (now.month == 4 && now.day == 1) {
      showSnackBar(locator<AppProvider>().ctx, '叮～触发彩蛋：愚人节快乐');
      print("[GRADE] Happy fools' day!");
      print('''
 _____           _     _       _             
|  ___|__   ___ | |___( )   __| | __ _ _   _ 
| |_ / _ \ / _ \| / __|/   / _` |/ _` | | | |
|  _| (_) | (_) | \__ \   | (_| | (_| | |_| |
|_|  \___/ \___/|_|___/    \__,_|\__,_|\__, |
                                       |___/ 
''');

      for (int i = 0; i < _grade.terms.length; i++) {
        var gradeDetails = _grade.terms[i].grades;
        for (int ii = 0; ii < gradeDetails.length; ii++) {
          _grade.terms[i].averageGradePoint = randomGradePoint;
          _grade.terms[i].averageGradePointNoElectiveCourse = randomGradePoint;
          if (gradeDetails[ii].mark < standardMark) {
            double safeMark = standardMark + Random().nextInt(10) + 0.0;
            _grade.terms[i].grades[ii].mark = safeMark;
            _grade.terms[i].grades[ii].rawMark = safeMark.round().toString();
          }
        }
      }
      _grade.averageGradePoint = randomGradePoint;
    }
  }

  double get randomGradePoint =>
      double.parse((4.0 + Random().nextDouble()).toStringAsFixed(3));

  Future<void> updateGradeData() async {
    await busyRun(_updateGradeData);
  }

  Future<void> _updateGradeData() async {
    final grade = await User().getGrade();
    _grade = grade;

    final gradeStore = await locator.getAsync<GradeStore>();
    gradeStore.checkIn(grade);

    safeOperation();
  }
}
