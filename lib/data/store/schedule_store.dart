import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/models/schedule.dart';

class ScheduleStore with PersistentStore<Schedule> {
  @override
  final boxName = 'schedule';

  void checkIn(Schedule schedule) {
    if (schedule == null) {
      return;
    }

    final shouldAddToBox =
        head == null || schedule.versionHash != head.versionHash;

    if (shouldAddToBox) {
      box.add(schedule);
    } else {
      head.createdAt = schedule.createdAt;
      head.save();
    }
  }

  Schedule get head {
    if (box.isEmpty) return null;
    return box.getAt(box.length - 1);
  }
}
