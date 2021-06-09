import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/theme_colors.dart';
import 'package:custed2/ui/dynamic_color.dart';
import 'package:custed2/ui/schedule_tab/lesson_preview.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/material.dart';

class ScheduleLessonWidget extends StatelessWidget {
  ScheduleLessonWidget(
    this.lesson,
    {this.isActive = true, 
    this.occupancyRate = 1.0, 
    this.themeIdx = 0, 
    this.useGradient = true}
  );
  
  final ScheduleLesson lesson;
  final List<ScheduleLesson> conflict = [];
  final bool isActive;
  final double occupancyRate;
  final int themeIdx;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      return _buildLessonCell(context);
    }

    return GestureDetector(
      onTap: () => _showLessonPreview(context),
      onLongPress: addToCalendar,
      child: _buildLessonCell(context),
    );
  }

  Widget _buildLessonCell(BuildContext context) {
    List<Color> colors = selectColorForLesson(context);
    final cell = _buildCellContent(context);
    return DarkModeFilter(
      child:  Container(
        margin: EdgeInsets.all(2.5),
        constraints: BoxConstraints(maxWidth: 70, maxHeight: 100),
        decoration: BoxDecoration(
          color: useGradient ? null : colors[0],
          gradient: useGradient ?? true ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors ?? [Colors.transparent, Colors.transparent]
          ) : null,
          borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        padding: EdgeInsets.all(4.0),
        child: cell,
      ),
      level: 200,
    );
  }

  Widget _buildCellContent(BuildContext context) {
    if (lesson == null) {
      return null;
    }

    final textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: isActive ? Colors.white : (isDark(context) ? Colors.white24 : Colors.grey)
    );

    final content = <Widget>[];
    content.add(
      SizedBox(
        height: 37,
        child: Center(
          child: Text(
            lesson.name, 
            maxLines: 2, 
            style: textStyle, 
            textAlign: TextAlign.center
          )
        )
      )
    );
    addDivider(content);
    final displayLesson = lesson.roomRaw.replaceFirst('[理论]', '理')
                                        .replaceFirst('[实验]', '实');
    content.add(
      SizedBox(
        height: 37,
        child: Center(
          child: Text(
            displayLesson, 
            maxLines: 2, 
            softWrap: true,
            style: textStyle, 
            textAlign: TextAlign.center
          ),
        ),
      )
    );

    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: content,
    );

    if (conflict.isEmpty) {
      return child;
    } else {
      return Stack(
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Icon(Icons.report_problem, size: 17, color: Colors.red)
          )
        ],
      );
    }
  }

  void addDivider(List<Widget> content) {
    final divider = Divider(height: 2, color: Colors.white70);
    content.add(
      SizedBox(
        height: 17,
        child: Column(
        children: [
          SizedBox(height: 5),
          divider,
          SizedBox(height: 5)
        ],
      ),
      )
    );
  }

  int _interpolate(int lower, int higher, double interpolateValue) {
    int range = higher - lower;
    interpolateValue = max(0, interpolateValue);
    interpolateValue = min(1, interpolateValue);
    return lower + (range * interpolateValue).toInt();
  }
  
  Color _interpolateColor(Color lower, Color higher, double interpolateValue) {
    return Color.fromARGB(
        lower.alpha,
        _interpolate(lower.red, higher.red, interpolateValue),
        _interpolate(lower.green, higher.green, interpolateValue),
        _interpolate(lower.blue, higher.blue, interpolateValue));
  }

  List<Color> selectColorForLesson(BuildContext context) {
    if (lesson == null) {
      return null;
    }

    final inactiveColorLight = DynamicColor(Color(0xFFFAFAFAFA), Colors.grey[900]);
    final inactiveColorDense = DynamicColor(Colors.grey[400], Colors.grey[700]);

    if (!isActive) {
      return [_interpolateColor(inactiveColorLight.resolve(context),
          inactiveColorDense.resolve(context), occupancyRate)];
    }

    final colors = scheduleThemes[themeIdx];
    final index = [
      lesson.hashCode % colors.length,
      lesson.displayName.hashCode % colors.length,
      lesson.teacherName.hashCode % colors.length,
      lesson.roomRaw.hashCode % colors.length
    ];

    int idx1 = 0, idx2 = 0;
    while (true) {
      idx2++;
      final diff = (idx1 - idx2).abs();
      if (idx1 != idx2 && diff < 3) {
        return [colors[index[min(idx1, idx2)]], colors[index[max(idx1, idx2)]]];
      }
      idx1++;
    }
  }

  void _showLessonPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LessonPreview(lesson, conflict: conflict);
      },
    );
  }

  void addToCalendar() {
    if (!isActive) return;
    final schedule = locator<ScheduleProvider>();
    final day = schedule.schedule
        .weekStartDate(schedule.selectedWeek)
        .add((lesson.weekday - 1).days);

    final start = day.add(lesson.parseStart().sinceDayStart);
    final end = day.add(lesson.parseEnd().sinceDayStart);

    final description = '教师: ${lesson.teacherName}';

    final event = Event(
      title: lesson.displayName,
      description: description,
      location: lesson.roomRaw,
      startDate: start,
      endDate: end,
    );
    Add2Calendar.addEvent2Cal(event);
  }
}
