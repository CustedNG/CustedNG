import 'dart:math' as math;

import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/store/custom_lesson_store.dart';
import 'package:custed2/data/store/schedule_store.dart';
import 'package:custed2/locator.dart';

class ScheduleProvider extends BusyProvider {
  Schedule _schedule;
  Schedule get schedule => _schedule;

  int _selectedWeek = 1;
  int get selectedWeek => _selectedWeek;

  final int minWeek = 1;
  int get maxWeek => _schedule?.weekCount;

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
    final head = scheduleStore.head;
    await _useSchedule(head);

    if (head != null) {
      print('use cached schedule: $head');
      resetWeekToCurrentWeek();
      notifyListeners();
    }
  }

  Future<void> updateScheduleData({bool reset = false}) async {
    await busyRun(_updateScheduleData);
    if (reset) resetWeekToCurrentWeek();
  }

  Future<void> _updateScheduleData() async {
    final schedule = await User().getSchdeule();
    _schedule = schedule;
    final scheduleStore = await locator.getAsync<ScheduleStore>();
    scheduleStore.checkIn(schedule);
    _useSchedule(schedule);
  }

  Future<void> _useSchedule(Schedule schedule) async {
    if (schedule == null) return;

    final newSchedule = schedule.safeCopy();
    final customLessonStore = await locator.getAsync<CustomLessonStore>();
    newSchedule.lessons.addAll(customLessonStore.box.values);
    _schedule = newSchedule;
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

  void resetWeekToCurrentWeek() {
    _selectedWeek = currentWeek ?? 1;
  }

  void gotoCurrentWeek() {
    _selectedWeek = currentWeek;
    notifyListeners();
  }

  Iterable<ScheduleLesson> lessonsSince(DateTime dateTime) {
    return _schedule?.lessonsSince(dateTime);
  }
}
