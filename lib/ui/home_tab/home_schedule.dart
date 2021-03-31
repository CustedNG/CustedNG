import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/extension/iterablex.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/schedule_tab/lesson_preview.dart';
import 'package:flutter/material.dart';

class HomeSchedule extends StatelessWidget {
  final scheduleProvider = locator<ScheduleProvider>();
  
  @override
  Widget build(BuildContext context) {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
        return GestureDetector(
          child: HomeCard(
            title: Text('你还没有登录', style: TextStyle(color: Colors.redAccent)),
            content: Text('点击登录'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          onTap: () => Scaffold.of(context).openDrawer(),
      );
    }

    final lesson = scheduleProvider.lessonsSince(DateTime.now()).firstIfExist;
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return LessonPreview(lesson);
        },
      ),
      child: HomeCard(
        title: _buildTitle(context, lesson),
        content: _buildContent(context),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black87),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ScheduleLesson lesson) {
    final style = TextStyle(
      color: Color(0xFF889CC3),
    );

    final detail = lesson == null
        ? ''
        : '${lesson.weekday.weekdayInChinese('周')} '
            '${lesson.startTime} ~ ${lesson.endTime}';

    final title = '下节 $detail';

    return Text(title, style: style);
  }

  Widget _buildContent(BuildContext context) {
    if (scheduleProvider.schedule == null) return Text('无课表数据');

    final lesson = scheduleProvider.lessonsSince(DateTime.now()).firstIfExist;
    return lesson == null
        ? const Text('本学期没有课了')
        : Text('${lesson.name}@${lesson.roomRaw}');
  }
}
