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

  // @HiveField(4)
  int weekCount = 24;

  Iterable<ScheduleLesson> activeLessons(int week) {
    return lessons.where((lesson) => lesson.isActiveInWeek(week));
  }

  int activeLessonCount(int week) {
    return activeLessons(week).length;
  }

  Iterable<ScheduleLesson> inactiveLessons(int week) {
    return lessons.where((lesson) => !lesson.isActiveInWeek(week));
  }

  int calculateWeekSinceStart(DateTime dateTime) {
    final weeks = dateTime
        .difference(startDate)
        .inDays ~/ 7;
    return dateTime.compareTo(startDate) >= 0 ? weeks + 1 : weeks;
  }

  Iterable<ScheduleLesson> activeLessonsIn(DateTime day) {
    final week = calculateWeekSinceStart(day);
    return lessons.where((lesson) =>
        lesson.isActiveInWeek(week) && lesson.weekday == day.weekday);
  }

  ScheduleLesson activeLessonIn(DateTime time) {
    return activeLessonsIn(time).firstWhere((lesson) {
      return lesson.parseStart()?.isBefore(time) == true &&
          lesson.parseEnd()?.isAfter(time) == true;
    }, orElse: () => null);
  }

  Iterable<ScheduleLesson> lessonsSince(DateTime date) sync* {
    int week;
    while (true) {
      final lessons = activeLessonsIn(date).toList();
      lessons.removeWhere((lesson) =>
          lesson.startTime == null || lesson.parseStart().isBefore(date));
      lessons.sort((a, b) => a.startTime.compareTo(b.startTime));
      yield* lessons;

      date = DateTime(date.year, date.month, date.day + 1, 0, 0);
      week = calculateWeekSinceStart(date);
      if (week > weekCount) break;
    }
  }

  DateTime weekStartDate(int week) {
    final dayOffset = (week - 1) * 7;
    return startDate.add(Duration(days: dayOffset));
  }

  Schedule safeCopy() {
    return Schedule()
      ..createdAt = createdAt
      ..startDate = startDate
      ..versionHash = versionHash
      ..lessons = lessons.toList();
  }

  @override
  String toString() {
    return 'Schedule<$versionHash>';
  }
}
