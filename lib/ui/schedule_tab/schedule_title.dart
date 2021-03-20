import 'package:custed2/core/route.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/schedule_title_provider.dart';
import 'package:custed2/ui/schedule_tab/select_schedule_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ScheduleTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final scheduleTitleProvider = Provider.of<ScheduleTitleProvider>(context);

    var title = '课表';
    var key = title;
    
    if (scheduleProvider.isBusy) {
      title = '更新中';
      key = title;
    } else if (scheduleTitleProvider.showWeekInTitle) {
      title = '第${scheduleProvider.selectedWeek}周';
      key = '第x周';
    }

    // return Text(title);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: Container(
        child: GestureDetector(
            onDoubleTap: () {
              AppRoute(
                title: '添加课程',
                page: SelectSchedulePage(),
              ).popup(context);
            },
            child: Text(title)),
        alignment: Alignment.centerLeft,
        key: Key(key),
      ),
    );
  }
}
