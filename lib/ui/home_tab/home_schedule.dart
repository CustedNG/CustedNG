import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/extension/iterablex.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeSchedule extends StatelessWidget {
  static const platform = MethodChannel('custed2.xuty.cc/notification');

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final lesson = scheduleProvider.lessonsSince(DateTime.now()).firstIfExist;

    return GestureDetector(
      onTap: () => appProvider.setTab(AppProvider.scheduleTab),
      child: HomeCard(
        title: _buildTitle(context, lesson),
        trailing: _buildArrow(),
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
    platform.invokeMethod('notifyNextCourse', {"content": detail});

    return Text(title, style: style);
  }

  Widget _buildArrow() {
    return Icon(
      CupertinoIcons.right_chevron,
      color: CupertinoColors.black.withAlpha(100),
    );
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
