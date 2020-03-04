import 'package:custed2/core/store/presistent_store.dart';
import 'package:custed2/data/models/schedule_lesson.dart';

class CustomLessonStore with PresistentStore<ScheduleLesson> {
  @override
  final boxName = 'customLesson';

  void addLesson(ScheduleLesson lesson) {
    box.add(lesson);
  }
}
