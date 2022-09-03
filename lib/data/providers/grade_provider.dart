import 'dart:math';

import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/store/grade_store.dart';
import 'package:custed2/data/store/setting_store.dart';
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
    int standardMark = 70;
    final settingStore = await locator.get<SettingStore>();

    if (settingStore.gradeSafeMode.fetch()) {
      print('[GRADE] Using safe mode');

      for (int i = 0; i < _grade.terms.length; i++) {
        var gradeDetails = _grade.terms[i].grades;
        for (int ii = 0; ii < gradeDetails.length; ii++) {
          if (gradeDetails[ii].mark < standardMark) {
            double safeMark = standardMark + Random().nextInt(10) + 0.0;
            _grade.terms[i].grades[ii].mark = safeMark;
            _grade.terms[i].grades[ii].rawMark = safeMark.round().toString();
          }
        }
      }
    }
  }

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
