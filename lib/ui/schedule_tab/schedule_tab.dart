import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/extension/datetimex.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/schedule_title_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/schedule_menu.dart';
import 'package:custed2/ui/schedule_tab/schedule_table.dart';
import 'package:custed2/ui/schedule_tab/schedule_title.dart';
import 'package:custed2/ui/schedule_tab/schedule_week_navigator.dart';
import 'package:custed2/ui/theme.dart';
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
  final scrollController = ScrollController();
  var showWeekInTitle = false;

  @override
  void initState() {
    scrollController.addListener(onScroll);
    super.initState();
  }

  void onScroll() {
    final titleProvider = locator<ScheduleTitleProvider>();

    if (scrollController.offset >= 30 &&
        titleProvider.showWeekInTitle == false) {
      titleProvider.setShowWeekInTitle(true);
      return;
    }

    if (scrollController.offset < 30 && titleProvider.showWeekInTitle == true) {
      titleProvider.setShowWeekInTitle(false);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final theme = AppTheme.of(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scheduleBackgroundColor,
      navigationBar: NavBar.cupertino(
        context: context,
        leading: _buildTitle(context),
        middle: _buildNavbarMiddle(context),
        trailing: scheduleProvider.isBusy
            ? Container(
                width: 100,
                alignment: Alignment.centerRight,
                child: CupertinoActivityIndicator(),
              )
            : NavBarMoreBtn(onTap: () => _showMenu(context)),
      ),
      child: ListView(
        controller: scrollController,
        children: <Widget>[
          ScheduleWeekNavigator(),
          _buildTable(context),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    final user = locator<UserProvider>();
    await user.initialized;
    if (!user.loggedIn) return;

    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    if (scheduleProvider.isBusy) return;

    scheduleProvider.updateScheduleData().timeout(Duration(seconds: 20));
    final setting = locator<SettingStore>();
    if(setting.showTipOnViewingExam.fetch()){
      locator<SnakebarProvider>().info('主页可查看考试安排了');
      setting.showTipOnViewingExam.put(false);
    }
  }

  Widget _buildTitle(BuildContext context) {
    // final scheduleProvider = Provider.of<ScheduleProvider>(context);
    // final text = scheduleProvider.isBusy ? '更新中' : '课表';
    // final text1 = showWeekInTitle ? 'lalala' : text;
    return NavBarTitle(child: ScheduleTitle());
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
    final theme = AppTheme.of(context);

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
        color: theme.scheduleBackgroundColor,
        child: ScheduleTable(
          scheduleProvider.schedule,
          week: scheduleProvider.selectedWeek,
          showInactive: setting.showInactiveLessons.fetch(),
        ),
      ),
    );
  }
}
