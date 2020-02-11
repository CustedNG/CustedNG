import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/extension/datetimex.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/schedule_menu.dart';
import 'package:custed2/ui/schedule_tab/schedule_table.dart';
import 'package:custed2/ui/schedule_tab/schedule_week_navigator.dart';
import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:custed2/ui/widgets/navbar/navbar_title.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ScheduleTab extends StatefulWidget {
  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab>
    with AfterLayoutMixin<ScheduleTab> {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: NavBar.cupertino(
        context: context,
        leading: _buildTitle(context),
        middle: _buildNavbarMiddle(context),
        trailing: scheduleProvider.isBusy
            ? CupertinoActivityIndicator()
            : NavBarMoreBtn(onTap: () => _showMenu(context)),
      ),
      child: ListView(
        children: <Widget>[
          ScheduleWeekNavigator(),
          _buildTable(context),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final user = locator<UserProvider>();
    if (!user.loggedIn) return;

    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    if (scheduleProvider.isBusy) return;
    
    scheduleProvider.updateScheduleData().timeout(Duration(seconds: 10));
  }

  Widget _buildTitle(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final text = scheduleProvider.isBusy ? '更新中' : '课表';
    return NavBarTitle(child: Text(text));
    // return AnimatedSwitcher(
    //   duration: Duration(milliseconds: 300),
    //   child: NavBarTitle(key: Key(text), child: Text(text)),
    // );
  }

  void _showMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => ScheduleMenu(),
    );
  }

  Widget _buildNavbarMiddle(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final hasSchedule = scheduleProvider.schedule != null;
    return NavbarMiddle(
      textAbove: '上次更新',
      textBelow: hasSchedule
          ? scheduleProvider.schedule.createdAt.toHumanReadable()
          : '-',
    );
  }

  Widget _buildTable(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    if (scheduleProvider.schedule == null) {
      return Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 150),
            PlaceholderWidget(text: '无课表信息')
          ],
        ),
      );
    }

    final setting = locator<SettingStore>();

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity > 50) {
          return scheduleProvider.gotoPrevWeek();
        }
        if (details.primaryVelocity < -50) {
          return scheduleProvider.gotoNextWeek();
        }
      },
      child: Container(
        color: CupertinoColors.white,
        child: ScheduleTable(
          scheduleProvider.schedule,
          week: scheduleProvider.selectedWeek,
          showInactive: setting.showInactiveLessons.fetch(),
        ),
      ),
    );
  }
}
