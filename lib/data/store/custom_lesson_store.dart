import 'package:custed2/core/store/persistent_store.dart';
import 'package:custed2/data/models/schedule_lesson.dart';

class CustomLessonStore with PersistentStore<ScheduleLesson> {
  @override
  final boxName = 'customLesson';

  void addLesson(ScheduleLesson lesson) {
    box.add(lesson);
  }

  bool deleteLesson(ScheduleLesson lesson) {
    int k = getIndex(lesson);
    if (k == -1) return false;
    box.delete(k);
    return true;
  }

  int getIndex(ScheduleLesson lesson) {
    int k = -1;
    box.toMap().forEach((key, value) {
      if (value.name == lesson.name &&
          value.teacherName == lesson.teacherName &&
          lesson.type == ScheduleLessonType.custom &&
          value.room == lesson.room &&
          value.startSection == lesson.startSection) {
        k = key;
      }
    });
    return k;
  }
}
