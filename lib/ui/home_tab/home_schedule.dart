import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/extension/iterablex.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/schedule_tab/lesson_preview.dart';
import 'package:flutter/material.dart';

class HomeSchedule extends StatefulWidget {
  @override
  _HomeScheduleState createState() => _HomeScheduleState();
}

class _HomeScheduleState extends State<HomeSchedule> {
  final scheduleProvider = locator<ScheduleProvider>();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async => await scheduleProvider.loadLocalData();

  @override
  Widget build(BuildContext context) {
    final user = locator<UserProvider>();
    if (!user.loggedIn) {
        return GestureDetector(
          child: HomeCard(
            title: Text('你还没有登录', style: TextStyle(color: Colors.redAccent)),
            content: Text('点击登录'),
            trailing: true,
          ),
          onTap: () => Scaffold.of(context).openDrawer(),
      );
    }

    final lesson = scheduleProvider.lessonsSince(DateTime.now()).firstIfExist;
    final card = HomeCard(
      title: _buildTitle(context, lesson),
      content: _buildContent(context),
      trailing: lesson != null,
    );
    
    if (lesson == null) return card;
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return LessonPreview(lesson);
        },
      ),
      child: card
    );
  }

  Widget _buildTitle(BuildContext context, ScheduleLesson lesson) {
    final style = TextStyle(
      color: Color(0xFF889CC3),
      fontWeight: FontWeight.bold
    );

    final detail = lesson == null
        ? ''
        : '${lesson.weekday.weekdayInChinese('周')} '
            '${lesson.startTime} ~ ${lesson.endTime}';

    final title = '下节 $detail';

    return Text(title, style: style);
  }

  Widget _buildContent(BuildContext context) {
    final style = TextStyle(fontSize: 13);
    if (scheduleProvider.schedule == null) return Text('无课表数据', style: style);

    final lesson = scheduleProvider.lessonsSince(DateTime.now()).firstIfExist;
    return lesson == null
        ? Text('本学期没有课了', style: style)
        : Text('${lesson.name}@${lesson.roomRaw}', style: style);
  }
}
