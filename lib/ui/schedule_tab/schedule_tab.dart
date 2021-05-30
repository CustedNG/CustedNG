import 'package:custed2/core/extension/datetimex.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/schedule_title_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/schedule_tab/add_lesson_page.dart';
import 'package:custed2/ui/schedule_tab/schedule_table.dart';
import 'package:custed2/ui/schedule_tab/schedule_week_navigator.dart';
import 'package:custed2/ui/schedule_tab/select_schedule_page.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScheduleTab extends StatefulWidget {
  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab>
    with AutomaticKeepAliveClientMixin<ScheduleTab> {
  final scrollController = ScrollController();
  var showWeekInTitle = false;
  final scheduleProvider = locator<ScheduleProvider>();
  final settings = locator<SettingStore>();
  final _refreshController = RefreshController(initialRefresh: false);

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

    return Scaffold(
      appBar: NavBar.material(
          context: context,
          needPadding: true,
          leading: IconButton(
            onPressed: () => AppRoute(page: SelectSchedulePage()).go(context),
            icon: Icon(Icons.switch_account),
          ),
          middle: _buildNavbarMiddle(context),
          trailing: <Widget>[
            scheduleProvider.isBusy ? Container() : IconButton(
              onPressed: () => AppRoute(
                title: '添加课程',
                page: AddLessonPage(),
              ).go(context), 
              icon: Icon(Icons.bookmark_add)
            ),
          ]
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        physics: BouncingScrollPhysics(),
        header: MaterialClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          controller: scrollController,
          children: <Widget>[
              _buildCloseAutoUpdateTip(),
              ScheduleWeekNavigator(),
              _buildTable(context),
            ],
          ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    try {
      if(!Provider.of<UserProvider>(context, listen: false).loggedIn) {
        showSnackBar(context, '请登录');
        _refreshController.refreshFailed();
        return;
      }
      await scheduleProvider.updateScheduleData();
      _refreshController.refreshCompleted();
      showSnackBar(context, '更新成功');
    } catch (e) {
      print(e);
      showSnackBar(context, '更新失败');
      _refreshController.refreshFailed();
    }
  }

  Widget _buildCloseAutoUpdateTip(){
    return !settings.autoUpdateSchedule.fetch() ? Center(
      child: Text(
        '鉴于教务验证机制，已关闭自动更新',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5)
        ),
      ),
    ) : Container();
  }

  // @override
  // void afterFirstLayout(BuildContext context) async {
  //   final user = locator<UserProvider>();
  //   await user.initialized;
  //   if (!user.loggedIn) return;

  //   if (scheduleProvider.isBusy || BuildMode.isDebug) return;

  //   if(settings.autoUpdateSchedule.fetch()){
  //     scheduleProvider.updateScheduleData().timeout(Duration(seconds: 20));
  //   }
  // }

  Widget _buildNavbarMiddle(BuildContext context) {
    final scheduleTitleProvider = Provider.of<ScheduleTitleProvider>(context);

    var display;

    if (scheduleProvider.isBusy) {
      display = ['更新中'];
    } else if (scheduleTitleProvider.showWeekInTitle) {
      display = ['第${scheduleProvider.selectedWeek}周'];
    } else {
      display = [
        '上次更新', 
        scheduleProvider.schedule != null ? 
          scheduleProvider.schedule.createdAt.toHumanReadable() 
          : '-'
      ];
    }

    // return Text(title);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 233),
      child: display.length == 1 ? NavbarText(display[0]) : 
        NavbarMiddle(textAbove: display[0], textBelow: display[1],
      ),
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
        child: ScheduleTable(
          scheduleProvider.schedule,
          week: scheduleProvider.selectedWeek,
          showInactive: setting.showInactiveLessons.fetch(),
          themeIdx: setting.scheduleTheme.fetch(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
