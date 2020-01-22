import 'package:custed2/config/theme.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:flutter/cupertino.dart';

class LessonDetailPage extends StatelessWidget {
  LessonDetailPage(this.lesson);

  final ScheduleLesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.textColor,
        ),
        child: ListView(
          children: <Widget>[
            _LessonInfo({
              '课程名称': lesson.name,
              '上课地点': lesson.roomRaw,
              '上课时间': '${lesson.startTime}~${lesson.endTime}',
              '任课教师': lesson.teacherName,
              '上课周数': lesson.weeks.join(','),
              '上课班级': lesson.classes.join('\n'),
            }),
          ],
        ),
      ),
    );
  }
}

class _LessonInfo extends StatelessWidget {
  _LessonInfo(this.items);

  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    const keyFont = TextStyle(
      fontWeight: FontWeight.bold,
    );

    const valueFont = TextStyle(
      fontWeight: FontWeight.normal,
    );

    final lines = <Widget>[];
    
    for (var item in items.entries) {
      lines.add(Text(
        item.key,
        style: keyFont,
      ));
      lines.add(SizedBox(
        height: 2,
      ));
      lines.add(Text(
        item.value,
        style: valueFont,
      ));
      lines.add(SizedBox(
        height: 15,
      ));
    }
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: lines,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
