import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/extension/iterablex.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/ui/home_tab/home_card.dart';
import 'package:custed2/ui/pages/login_page_legacy.dart';
import 'package:custed2/ui/schedule_tab/lesson_preview.dart';
import 'package:custed2/ui/webview/webview_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSchedule extends StatefulWidget {
  @override
  _HomeScheduleState createState() => _HomeScheduleState();
}

class _HomeScheduleState extends State<HomeSchedule> {
  ScheduleProvider scheduleProvider;

  @override
  Widget build(BuildContext context) {
    final user = locator<UserProvider>();
    scheduleProvider = Provider.of<ScheduleProvider>(context);
    if (!user.loggedIn) {
      return GestureDetector(
        child: HomeCard(
          title: Text('你还没有登录', style: TextStyle(color: Colors.redAccent)),
          content: Text('点击登录'),
          trailing: true,
        ),
        onTap: () {
          if (Provider.of<AppProvider>(context, listen: false).config.notShowRealUi.contains(BuildData.build)) {
            WebviewLogin.begin(context, back2PrePage: true);
          } else {
            AppRoute(page: LoginPageLegacy()).go(context);
          }
        },
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
        child: card);
  }

  Widget _buildTitle(BuildContext context, ScheduleLesson lesson) {
    final style = TextStyle(
        color: resolveWithBackground(context), fontWeight: FontWeight.bold);

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
