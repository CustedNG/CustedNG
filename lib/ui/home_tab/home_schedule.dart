import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/extension/iterablex.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final lesson = scheduleProvider.lessonsSince(DateTime.now()).firstIfExist;

    return GestureDetector(
      child: HomeCard(
        title: _buildTitle(context, lesson),
        content: _buildContent(context),
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
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    if (scheduleProvider.isBusy) return Text('加载中...');
    if (scheduleProvider.schedule == null) return Text('无课表数据');

    final lesson = scheduleProvider.lessonsSince(DateTime.now()).firstIfExist;
    return lesson == null
        ? Text('本学期没有课了')
        : Text('${lesson.name}@${lesson.roomRaw}');
  }
}
