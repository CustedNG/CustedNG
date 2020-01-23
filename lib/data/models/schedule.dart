import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:hive/hive.dart';

part 'schedule.g.dart';

@HiveType(typeId: 3)
class Schedule extends HiveObject {
  @HiveField(0)
  List<ScheduleLesson> lessons;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  String versionHash;

  @HiveField(3)
  DateTime startDate;

  Iterable<ScheduleLesson> activeLessons(int week) {
    return lessons.where((lesson) => lesson.isActiveInWeek(week));
  }

  Iterable<ScheduleLesson> inactiveLessons(int week) {
    return lessons.where((lesson) => !lesson.isActiveInWeek(week));
  }

  int calculateWeekSinceStart(DateTime dateTime) {
    final weeks = dateTime.difference(startDate).inDays ~/ 7;
    return dateTime.isAfter(startDate) ? weeks + 1 : weeks;
  }

  @override
  String toString() {
    return 'Schedule<$versionHash>';
  }
}
