import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/dynamic_color.dart';
import 'package:custed2/ui/schedule_tab/lesson_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleLessonWidget extends StatelessWidget {
  ScheduleLessonWidget(
    this.lesson, {
    this.isActive = true,
  });

  final ScheduleLesson lesson;
  final List<ScheduleLesson> conflict = [];
  final bool isActive;

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
    return Container(
      margin: EdgeInsets.all(2.5),
      constraints: BoxConstraints(maxWidth: 70, maxHeight: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: selectColorForLesson(context),
      ),
      padding: EdgeInsets.all(4.0),
      child: _buildCellContent(context),
    );
  }

  Widget _buildCellContent(BuildContext context) {
    if (lesson == null) {
      return null;
    }

    final content = <Widget>[];
    content.add(Text(lesson.name, maxLines: 2));

    if (conflict.isEmpty) {
      content.add(SizedBox(height: 2));
      content.add(Text('@' + lesson.roomRaw, maxLines: 3));
    } else {
      for (var lesson in conflict) {
        content.add(SizedBox(height: 5));
        content.add(Divider(
          height: 1,
          color: CupertinoColors.white,
        ));
        content.add(SizedBox(height: 5));
        content.add(Text(lesson.name, maxLines: 2));
      }
    }

    final textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: isActive ? CupertinoColors.white : Color(0xFF9C9C9C),
    );

    return DefaultTextStyle(
      style: textStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: content,
      ),
    );
  }

  Color selectColorForLesson(BuildContext context) {
    if (lesson == null) {
      return null;
    }

    const colors = [
      DynamicColor(Color(0xFFED4239), Color(0xFF847577)),
      DynamicColor(Color(0xFF3EC9FE), Color(0xFF4c6f73)),
      DynamicColor(Color(0xFF7B8AFF), Color(0xFF3c535e)),
      DynamicColor(Color(0xFFFFA988), Color(0xFF3f422e)),
      DynamicColor(Color(0xFF33C2FF), Color(0xFF525174)),
      DynamicColor(Color(0xFFFC789C), Color(0xFF364958)),
      DynamicColor(Color(0xFF7786FE), Color(0xFFa2a573)),
    ];

    final inactiveColor =
        DynamicColor(Color(0xFFEBEFF5), Colors.grey[800]);

    if (!isActive) {
      return inactiveColor.resolve(context);
    }

    return colors[lesson.name.hashCode % colors.length].resolve(context);
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
