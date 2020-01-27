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
    return dateTime.compareTo(startDate) >= 0 ? weeks + 1 : weeks;
  }

  Iterable<ScheduleLesson> activeLessonsIn(DateTime day) {
    final week = calculateWeekSinceStart(day);
    return lessons.where((lesson) =>
        lesson.isActiveInWeek(week) && lesson.weekday == day.weekday);
  }

  Iterable<ScheduleLesson> lessonsSince(DateTime date, int maxWeek) sync* {
    int week;
    while (true) {
      final lessons = activeLessonsIn(date).toList();
      lessons.removeWhere((lesson) => lesson.parseStart().isBefore(date));
      lessons.sort((a, b) => a.startTime.compareTo(b.startTime));
      yield* lessons;

      date = DateTime(date.year, date.month, date.day + 1, 0, 0);
      week = calculateWeekSinceStart(date);
      if (week > maxWeek) break;
    }
  }

  @override
  String toString() {
    return 'Schedule<$versionHash>';
  }
}
