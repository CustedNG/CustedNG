import 'package:custed2/ui/theme.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:flutter/material.dart';

class LessonDetailPage extends StatelessWidget {
  LessonDetailPage(this.lesson);

  final ScheduleLesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // final classes = lesson.classes?.toList();
    // classes?.sort();

    return Scaffold(
      appBar: NavBar.material(
        middle: NavbarText('课程详情')
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          color: theme.textColor,
        ),
        child: ListView(
          children: <Widget>[
            _LessonInfo({
              '课程名称': lesson.name,
              '上课地点': lesson.roomRaw,
              '上课时间': '${lesson.startTime ?? ''}~${lesson.endTime ?? ''}',
              '任课教师': lesson.teacherName ?? '',
              '上课周数': lesson.weeks.join(','),
              // if (classes != null) '上课班级': classes.join('\n'),
              if (lesson.classRaw != null) '上课班级': lesson.classRaw,
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
