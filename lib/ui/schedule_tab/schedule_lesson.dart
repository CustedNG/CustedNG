import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/ui/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

class ScheduleLessonWidget extends StatelessWidget {
  ScheduleLessonWidget(
    this.lesson, {
    this.isActive = true,
    this.conflict = const [],
  });

  final ScheduleLesson lesson;
  final List<ScheduleLesson> conflict; // TODO: handle conflict
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: isActive ? CupertinoColors.white : Color(0xFF9C9C9C),
    );

    return Container(
      margin: EdgeInsets.all(2),
      constraints: BoxConstraints(maxWidth: 70, maxHeight: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: selectColorForLesson(context),
      ),
      padding: EdgeInsets.all(4.0),
      child: DefaultTextStyle(
        style: textStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(lesson.name, maxLines: 2),
            SizedBox(height: 2),
            Text('@' + lesson.roomRaw, maxLines: 3),
          ],
        ),
      ),
    );
  }

  Color selectColorForLesson(BuildContext context) {
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
        DynamicColor(Color(0xFFEBEFF5), material.Colors.grey[800]);

    if (!isActive) {
      return inactiveColor.resolve(context);
    }

    return colors[lesson.name.hashCode % colors.length].resolve(context);
  }
}
