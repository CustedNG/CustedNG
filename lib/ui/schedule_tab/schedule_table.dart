import 'dart:math';

import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/schedule_arrow.dart';
import 'package:custed2/ui/schedule_tab/schedule_dates.dart';
import 'package:custed2/ui/schedule_tab/schedule_lesson.dart';
import 'package:custed2/ui/theme.dart';
import 'package:flutter/material.dart';

class ScheduleTable extends StatelessWidget {
  ScheduleTable(
    this.schedule, {
    this.week = 1,
    this.showInactive = true,
    this.highLightToday = true,
    this.themeIdx = 0,
  });

  final Schedule schedule;
  final int week;
  final bool showInactive;
  final bool highLightToday;
  final int themeIdx;

  final placeholder = ScheduleLessonWidget(null);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final settings = locator<SettingStore>();
    final hideWeekend = settings.scheduleHideWeekend.fetch();
    final useGradient = settings.scheduleUseGradient.fetch();

    final rows = List.generate(
      6,
      (_) => TableRow(children: List.filled(hideWeekend ? 5 : 7, placeholder)),
    );

    _fillActiveLessons(rows, useGradient, hideWeekend);

    if (showInactive) {
      _fillInactiveLessons(rows, hideWeekend);
    }

    final rawTable = Table(
      border: TableBorder.all(color: theme.scheduleOutlineColor, width: 1),
      children: rows,
    );

    final showArrow = schedule.calculateWeekSinceStart(DateTime.now()) == week;

    final table = showArrow ? _withArrow(rawTable, hideWeekend) : rawTable;

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

  void _fillActiveLessons(
    List<TableRow> rows,
    bool useGradient,
    bool hideWeekend,
  ) {
    for (var lesson in schedule.activeLessons(week)) {
      final weekIndex = lesson.weekday - 1;
      if (lesson.weekday > 5 && hideWeekend) return;
      final slotIndex = (lesson.startSection - 1) ~/ 2;
      final elotIndex = (lesson.endSection - 1) ~/ 2;
      for (var i = slotIndex; i <= elotIndex; i++) {
        final lessonWidget = rows[slotIndex].children[weekIndex];
        if (lessonWidget == placeholder) {
          rows[slotIndex].children[weekIndex] = ScheduleLessonWidget(
            lesson,
            themeIdx: themeIdx,
            useGradient: useGradient,
          );
        } else {
          final lw = (lessonWidget as ScheduleLessonWidget);
          lw.conflict.add(lesson);
          print('[SCHEDULE] Conflict: ${lw.lesson} -> ${lw.conflict}');
        }
      }
    }
  }

  void _fillInactiveLessons(List<TableRow> rows, bool hideWeekend) {
    final inactiveLessons = schedule.inactiveLessons(week);

    final int maxLessonCount = schedule.lessonCountMap.values.fold(1, max);
    final int minLessonCount = schedule.lessonCountMap.values.fold(128, min);
    final int interval = maxLessonCount - minLessonCount;

    for (var lesson in inactiveLessons) {
      final slotIndex = (lesson.startSection - 1) ~/ 2;
      final weekIndex = lesson.weekday - 1;
      if (lesson.weekday > 5 && hideWeekend) return;
      final lessonWidget = rows[slotIndex].children[weekIndex];
      if (lessonWidget == placeholder) {
        rows[slotIndex].children[weekIndex] = ScheduleLessonWidget(lesson,
            isActive: false,
            occupancyRate:
                (schedule.lessonCount(weekIndex, slotIndex) - minLessonCount) /
                    interval);
      }
    }
  }

  Widget _buildDate(BuildContext context, bool showFestivalAndHoliday) {
    final theme = AppTheme.of(context);
    final hideWeekend = locator<SettingStore>().scheduleHideWeekend.fetch();

    final items = <Widget>[];

    final dateStyle = TextStyle(
      color: theme.scheduleTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      height: 1.2,
    );

    final chsDateStyle = TextStyle(
      color: theme.scheduleTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 15,
      height: 1.2,
    );

    for (var i = 0; i < (hideWeekend ? 5 : 7); i++) {
      final dayOffset = (week - 1) * 7 + i;
      final date = schedule.startDate.add(Duration(days: dayOffset));
      final shouldShowMonth = i == 0 || date.day == 1;
      final displayDate =
          shouldShowMonth ? '${date.month}/${date.day}' : '${date.day}';

      final dateOverride = showFestivalAndHoliday
          ? ScheduleDates.getHoliday(date) : null;

      items.add(Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          Text(
            dateOverride ?? displayDate,
            style: dateStyle,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
          Text(
            date.weekday.weekdayInChinese(),
            style: chsDateStyle,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ]),
      ));
    }

    final row = TableRow(children: items);
    final border = BorderSide(color: theme.scheduleOutlineColor, width: 1);
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

  Widget _withArrow(Widget child, bool hideWeekend) {
    return ScheduleArrow(
      child: child,
      schedule: schedule,
      hideWeekend: hideWeekend,
    );
  }
}
