import 'dart:math' as math;

import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/store/schedule_store.dart';
import 'package:custed2/locator.dart';

class ScheduleProvider extends ProviderBase {
  Schedule _schedule;
  Schedule get schedule => _schedule;

  int _selectedWeek = 1;
  int get selectedWeek => _selectedWeek;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  final int minWeek = 1;
  final int maxWeek = 24;

  int get currentWeek => _schedule?.calculateWeekSinceStart(DateTime.now());

  void selectWeek(int week) {
    if (week < minWeek || week > maxWeek) {
      return;
    }

    _selectedWeek = week;
    notifyListeners();
  }

  Future<void> loadLocalData() async {
    final scheduleStore = await locator.getAsync<ScheduleStore>();
    _schedule = scheduleStore.head;

    if (_schedule != null) {
      print('use cached schedule: $_schedule');
      notifyListeners();
    }
  }

  Future<void> updateScheduleData() async {
    _isBusy = true;
    notifyListeners();
    try {
      await _updateScheduleData();
    } catch (e) {
      rethrow;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> _updateScheduleData() async {
    final schedule = await User().getSchdeule();
    _schedule = schedule;
    final scheduleStore = await locator.getAsync<ScheduleStore>();
    scheduleStore.checkIn(schedule);
    // print(schedule.startDate);
    // print(schedule.versionHash);
  }

  void gotoNextWeek() {
    if (_schedule != null && _selectedWeek < maxWeek) {
      _selectedWeek++;
      notifyListeners();
    }
  }

  void gotoPrevWeek() {
    final minAllowedWeek = math.min(currentWeek, minWeek);
    if (_schedule != null && _selectedWeek > minAllowedWeek) {
      _selectedWeek--;
      notifyListeners();
    }
  }

  void gotoCurrentWeek() {
    _selectedWeek = currentWeek;
    notifyListeners();
  }
}
