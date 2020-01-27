import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final lesson = scheduleProvider.lessonsSince(DateTime.now()).first;

    return GestureDetector(
      onTap: () => appProvider.setTab(AppProvider.scheduleTab),
      child: HomeCard(
        title: _buildTitle(context, lesson),
        trailing: _buildArrow(),
        content: _buildContent(lesson),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ScheduleLesson lesson) {
    final style = TextStyle(
      color: Color(0xFF889CC3),
    );

    final title = '下节 '
        '${lesson.weekday.weekdayInChinese('周')} '
        '${lesson.startTime} ~ ${lesson.endTime}';
    return Text(title, style: style);
  }

  Widget _buildArrow() {
    return Icon(
      CupertinoIcons.right_chevron,
      color: CupertinoColors.black.withAlpha(100),
    );
  }

  Widget _buildContent(ScheduleLesson lesson) {
    return lesson == null
        ? Text('本学期没有课了')
        : Text('${lesson.name}@${lesson.roomRaw}');
  }
}
