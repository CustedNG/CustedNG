import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/store/grade_store.dart';
import 'package:custed2/locator.dart';

class GradeProvider extends BusyProvider {
  Grade _grade;
  Grade get grade => _grade;

  Future<void> loadLocalData() async {
    final gradeStore = await locator.getAsync<GradeStore>();
    _grade = gradeStore.head;

    if (_grade != null) {
      print('[GRADE] Use cached: $_grade');
      notifyListeners();
    }
  }

  Future<void> updateGradeData() async {
    final grade = await User().getGrade();
    _grade = grade;

    final gradeStore = await locator<GradeStore>();
    gradeStore.checkIn(grade);
  }
}
