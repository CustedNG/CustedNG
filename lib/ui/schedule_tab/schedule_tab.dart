import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/extension/datetimex.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/schedule_title_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_page.dart';
import 'package:custed2/ui/schedule_tab/schedule_table.dart';
import 'package:custed2/ui/schedule_tab/schedule_title.dart';
import 'package:custed2/ui/schedule_tab/schedule_week_navigator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/utils.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
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
          leading: ScheduleTitle(),
          middle: _buildNavbarMiddle(context),
          trailing: <Widget>[
            scheduleProvider.isBusy ? Container() : _showMenu(context),
          ]),
      body: ListView(
        controller: scrollController,
        children: <Widget>[
          _buildCloseAutoUpdateTip(),
          ScheduleWeekNavigator(),
          _buildTable(context),
        ],
      ),
    );
  }

  Widget _buildCloseAutoUpdateTip(){
    return !settings.autoUpdateSchedule.fetch() ? Center(
      child: Text(
        '温馨提示：课表已关闭自动更新',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5)
        ),
      ),
    ) : Container();
  }

  SelectView(IconData icon, String text, String id) {
    return PopupMenuItem<String>(
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
            ],
        onSelected: (String action) async {
          switch (action) {
            case 'A':
              showCatchSnackBar(
                  context,
                  () async => await scheduleProvider.updateScheduleData(),
                  '教务超时');
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

    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    if (scheduleProvider.isBusy || BuildMode.isDebug) return;

    if(settings.autoUpdateSchedule.fetch()){
      scheduleProvider.updateScheduleData().timeout(Duration(seconds: 20));
    }
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
            PlaceholderWidget(text: '无课表信息'),
            PlaceholderWidget(text: '如遇无法更新，请尝试使用4G更新课表')
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
