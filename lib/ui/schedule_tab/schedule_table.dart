import 'package:custed2/config/theme.dart';
import 'package:custed2/core/extension/datetimex.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/ui/schedule_tab/schedule_lesson.dart';
import 'package:flutter/cupertino.dart';

class ScheduleTable extends StatelessWidget {
  ScheduleTable(
    this.schedule, {
    this.week = 1,
    this.showInactive = true,
    this.highLightToday = true,
  });

  final Schedule schedule;
  final int week;
  final bool showInactive;
  final bool highLightToday;

  final placeHolder = ScheduleLessonWidget(null);

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
        final lw = (lessonWidget as ScheduleLessonWidget);
        lw.conflict.add(lesson);
        print('Conflict Detected: ${lw.lesson} -> ${lw.conflict}');
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

    final dateStyleHighlight = dateStyle.copyWith(color: theme.textColor);
    final chsDateStyleHighlight = chsDateStyle.copyWith(color: theme.textColor);

    final today = DateTime.now();
    for (var i = 0; i < 7; i++) {
      final dayOffset = (week - 1) * 7 + i;
      final date = schedule.startDate.add(Duration(days: dayOffset));
      final shouldShowMonth = i == 0 || date.day == 1;
      final displayDate =
          shouldShowMonth ? '${date.month}/${date.day}' : '${date.day}';
      final shouldHighlight =
          highLightToday ? date.isInSameDayAs(today) : false;

      items.add(Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          Text(displayDate,
              style: shouldHighlight ? dateStyleHighlight : dateStyle),
          Text(date.weekday.weekdayInChinese(),
              style: shouldHighlight ? chsDateStyleHighlight : chsDateStyle),
        ]),
      ));
    }

    return TableRow(children: items);
  }
}
