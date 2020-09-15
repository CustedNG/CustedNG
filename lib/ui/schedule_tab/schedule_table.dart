import 'package:auto_size_text/auto_size_text.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/core/extension/datetimex.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/schedule_arrow.dart';
import 'package:custed2/ui/schedule_tab/schedule_dates.dart';
import 'package:custed2/ui/schedule_tab/schedule_lesson.dart';
import 'package:flutter/material.dart';

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

  final placeholder = ScheduleLessonWidget(null);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final rows = List.generate(
      6,
      (_) => TableRow(children: List.filled(7, placeholder)),
    );

    _fillActiveLessons(rows);

    if (showInactive) {
      _fillInactiveLessons(rows);
    }

    final rawTable = Table(
      border: TableBorder.all(color: theme.scheduleOutlineColor, width: 2),
      children: rows,
    );

    final showArrow = schedule.calculateWeekSinceStart(DateTime.now()) == week;

    final table = showArrow ? _withArrow(rawTable) : rawTable;

    final settings = locator<SettingStore>();
    final date = ValueListenableBuilder(
      valueListenable: settings.showFestivalAndHoliday.listenable(),
      builder: (context, value, _) {
        return _buildDate(context, value);
      },
    );

    return Column(
      children: <Widget>[
        date,
        table,
      ],
    );
  }

  void _fillActiveLessons(List<TableRow> rows) {
    for (var lesson in schedule.activeLessons(week)) {
      final slotIndex = (lesson.startSection - 1) ~/ 2;
      final weekIndex = lesson.weekday - 1;
      final lessonWidget = rows[slotIndex].children[weekIndex];
      if (lessonWidget == placeholder) {
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
      if (lessonWidget == placeholder) {
        rows[slotIndex].children[weekIndex] =
            ScheduleLessonWidget(lesson, isActive: false);
      }
    }
  }

  Widget _buildDate(BuildContext context, bool showFestivalAndHoliday) {
    final theme = AppTheme.of(context);

    final items = <Widget>[];

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

      final dateOverride = showFestivalAndHoliday
          ? ScheduleDates.getHoliday(date) ?? ScheduleDates.getSolarTerm(date)
          : null;

      items.add(Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          AutoSizeText(
            dateOverride ?? displayDate,
            style: shouldHighlight ? dateStyleHighlight : dateStyle,
            maxLines: 1,
          ),
          AutoSizeText(
            date.weekday.weekdayInChinese(),
            style: shouldHighlight ? chsDateStyleHighlight : chsDateStyle,
            maxLines: 1,
          ),
        ]),
      ));
    }

    final row = TableRow(children: items);
    final border = BorderSide(color: theme.scheduleOutlineColor, width: 2);
    return Table(
      children: [row],
      border: TableBorder(
        top: border,
        left: border,
        right: border,
        verticalInside: border,
      ),
    );
  }

  Widget _withArrow(Widget child) {
    return ScheduleArrow(child: child, schedule: schedule);
  }
}
