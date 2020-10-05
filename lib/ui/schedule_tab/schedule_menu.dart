import 'package:custed2/core/route.dart';
import 'package:custed2/core/script.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_page.dart';
import 'package:flutter/cupertino.dart';

class ScheduleMenu extends StatelessWidget {
  ScheduleMenu();

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = locator<ScheduleProvider>();
    final settings = locator<SettingStore>();

    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('更新课表'),
          onPressed: () {
            Navigator.of(context).pop();
            final snakebar = locator<SnakebarProvider>();
            snakebar.catchAll(() async {
              await scheduleProvider.updateScheduleData();
            }, message: '教务系统超时 :(', duration: Duration(seconds: 7));
            // Future.sync(() async {
            //   await scheduleProvider.updateScheduleData();
            // }).catchError((e) => _showJwTimeoutNewNotice(context));
          },
        ),
        CupertinoActionSheetAction(
          child: Text('添加课程'),
          onPressed: () {
            Navigator.of(context).pop();
            AppRoute(
              title: '添加课程',
              page: AddLessonPage(),
            ).popup(context);
          },
        ),
        CupertinoActionSheetAction(
          child: ValueListenableBuilder(
            valueListenable: settings.showFestivalAndHoliday.listenable(),
            builder: (context, value, _) {
              return Text(value ? "不显示节假日" : "显示节假日");
            },
          ),
          onPressed: () {
            settings.showFestivalAndHoliday.put(
              !settings.showFestivalAndHoliday.fetch(),
            );
          },
        ),
        CupertinoActionSheetAction(
          child: Text('常见问题&Tips'),
          onPressed: () {
            Navigator.of(context).pop();
            runScript('schedule_wrong.cl', context);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('取消'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showJwTimeoutNewNotice(context) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('更新课表失败'),
              content: Text('这可能是校园网的连接问题。请尝试使用移动数据。'),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('好'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ));
  }
}
