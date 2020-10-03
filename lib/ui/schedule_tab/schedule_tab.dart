import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/extension/datetimex.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/script.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/schedule_title_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_page.dart';
import 'package:custed2/ui/schedule_tab/schedule_table.dart';
import 'package:custed2/ui/schedule_tab/schedule_title.dart';
import 'package:custed2/ui/schedule_tab/schedule_week_navigator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:custed2/ui/widgets/navbar/navbar_title.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleTab extends StatefulWidget {
  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab>
    with AfterLayoutMixin, AutomaticKeepAliveClientMixin<ScheduleTab> {
  final scrollController = ScrollController();
  var showWeekInTitle = false;
  final scheduleProvider = locator<ScheduleProvider>();
  final settings = locator<SettingStore>();

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
    super.build(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.scheduleBackgroundColor,
      appBar: NavBar.material(
          context: context,
          needPadding: true,
          leading: _buildTitle(context),
          middle: _buildNavbarMiddle(context),
          trailing: <Widget>[
            scheduleProvider.isBusy ? Container() : _showMenu(context),
          ]),
      body: ListView(
        controller: scrollController,
        children: <Widget>[
          ScheduleWeekNavigator(),
          _buildTable(context),
        ],
      ),
    );
  }

  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon, color: Colors.blue),
            SizedBox(width: 5.0),
            Text(text),
          ],
        ));
  }

  Widget _showMenu(BuildContext context) {
    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              this.SelectView(Icons.update, '更新课表', 'A'),
              this.SelectView(Icons.add_alert, '添加课程', 'C'),
              this.SelectView(Icons.group_add, '常见问题', 'B'),
            ],
        onSelected: (String action) {
          switch (action) {
            case 'A':
              final snakeBar = locator<SnakebarProvider>();
              snakeBar.catchAll(() async {
                await scheduleProvider.updateScheduleData();
              }, message: '教务系统超时 :(', duration: Duration(seconds: 7));
              break;
            case 'B':
              runScript('schedule_wrong.cl', context);
              break;
            case 'C':
              AppRoute(
                title: '添加课程',
                page: AddLessonPage(),
              ).popup(context);
              break;
          }
        });
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    final user = locator<UserProvider>();
    await user.initialized;
    if (!user.loggedIn) return;
  }

  Widget _buildTitle(BuildContext context) {
    // final scheduleProvider = Provider.of<ScheduleProvider>(context);
    // final text = scheduleProvider.isBusy ? '更新中' : '课表';
    // final text1 = showWeekInTitle ? 'lalala' : text;
    return NavBarTitle(child: ScheduleTitle());
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

  @override
  bool get wantKeepAlive => true;
}
