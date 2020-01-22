import 'package:custed2/config/theme.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/ui/dynamic_color.dart';
import 'package:custed2/ui/schedule_tab/schedule_lesson.dart';
import 'package:flutter/cupertino.dart';

class ScheduleTable extends StatelessWidget {
  ScheduleTable(
    this.schedule, {
    this.week = 1,
    this.showInactive = true,
    this.highlight = const {},
  });

  final Schedule schedule;
  final int week;
  final bool showInactive;
  final Set<DateTime> highlight;

  final placeHolder = Container();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final rows = List.generate(
        6, (_) => TableRow(children: List.filled(7, placeHolder)));

    _fillActiveLessons(rows);

    if (showInactive) {
      _fillInactiveLessons(rows);
    }

    rows.insert(0, _buildDate(context));

    return Table(
      border: TableBorder.all(color: theme.scheduleOutlineColor, width: 2),
      children: rows,
    );
  }

  void _fillActiveLessons(List<TableRow> rows) {
    for (var lesson in schedule.activeLessons(week)) {
      final slotIndex = (lesson.startSection - 1) ~/ 2;
      final weekIndex = lesson.weekday - 1;
      final lessonWidget = rows[slotIndex].children[weekIndex];
      if (lessonWidget == placeHolder) {
        rows[slotIndex].children[weekIndex] = ScheduleLessonWidget(lesson);
      } else {
        (lessonWidget as ScheduleLessonWidget).conflict.add(lesson);
      }
    }
  }

  void _fillInactiveLessons(List<TableRow> rows) {
    for (var lesson in schedule.inactiveLessons(week)) {
      final slotIndex = (lesson.startSection - 1) ~/ 2;
      final weekIndex = lesson.weekday - 1;
      final lessonWidget = rows[slotIndex].children[weekIndex];
      if (lessonWidget == placeHolder) {
        rows[slotIndex].children[weekIndex] =
            ScheduleLessonWidget(lesson, isActive: false);
      }
    }
  }

  TableRow _buildDate(BuildContext context) {
    final items = <Widget>[];

    final theme = AppTheme.of(context);

    final dateStyle = TextStyle(
      color: theme.scheduleTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    final chsDateStyle = TextStyle(
      color: theme.scheduleTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    for (var i = 0; i < 7; i++) {
      final dayOffset = (week - 1) * 7 + i;
      final date = schedule.startDate.add(Duration(days: dayOffset));
      final shouldShowMonth = i == 0 || date.day == 1;
      final displayDate =
          shouldShowMonth ? '${date.month}/${date.day}' : '${date.day}';

      items.add(Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          Text(displayDate, style: dateStyle),
          Text(weekdayInChinese(date.weekday), style: chsDateStyle),
        ]),
      ));
    }

    return TableRow(children: items);
  }

  static String weekdayInChinese(int i, [String prefix = '星期']) {
    assert(i != null);
    assert(i >= 1);
    assert(i <= 7);
    final arr = '一二三四五六日';
    return "$prefix${arr[i - 1]}";
  }
}
