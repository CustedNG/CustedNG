import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/schedule.dart';

class ScheduleProvider extends ProviderBase {
  Schedule _schedule;
  Schedule get schedule => _schedule;

  int _selectedWeek;
  int get selectedWeek => _selectedWeek;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void selectWeek(int week) {
    _selectedWeek = week;
    notifyListeners();
  }

  Future<void> updateScheduleData() async {
    _isBusy = true;
    notifyListeners();

    try {
      await _updateScheduleData();
    } catch (e) {
      print(e);
    }

    _isBusy = false;
    notifyListeners();
  }

  Future<void> _updateScheduleData() async {
    final schedule = await User().getSchdeule();
    print(schedule.startDate);
    print(schedule.versionHash);
  }


}