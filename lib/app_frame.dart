import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/hotfix.dart';
import 'package:custed2/core/update.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/ui/grade_tab/grade_tab.dart';
import 'package:custed2/ui/home_tab/home_tab.dart';
import 'package:custed2/ui/schedule_tab/schedule_tab.dart';
import 'package:custed2/ui/user_tab/user_tab.dart';
import 'package:custed2/ui/widgets/snakebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppFrame extends StatefulWidget {
  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> with AfterLayoutMixin<AppFrame> {
  // 处理多 Navigator 情况下安卓返回键行为
  // See: https://github.com/flutter/flutter/issues/24105#issuecomment-530222677
  final _tabController = CupertinoTabController();
  final _tab0NavKey = GlobalKey<NavigatorState>();
  final _tab1NavKey = GlobalKey<NavigatorState>();
  final _tab2NavKey = GlobalKey<NavigatorState>();
  final _tab3NavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await _currentNavigatorKey().currentState.maybePop();
      },
      child: _buildFrame(context),
    );
  }

  GlobalKey<NavigatorState> _currentNavigatorKey() {
    switch (_tabController.index) {
      case 0:
        return _tab0NavKey;
      case 1:
        return _tab1NavKey;
      case 2:
        return _tab2NavKey;
      case 3:
        return _tab3NavKey;
    }
    throw 'unreachable';
  }

  Widget _buildFrame(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: _buildScaffold(context),
        ),
        Snakebar(),
      ],
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    _tabController.index = app.tabIndex;

    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        currentIndex: app.tabIndex,
        onTap: (n) {
          app.setTab(n, refresh: false);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('主页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tags),
            title: Text('成绩'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            title: Text('课表'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            title: Text('账户'),
          ),
        ],
      ),
      tabBuilder: (context, i) {
        switch (i) {
          case 0:
            return CupertinoTabView(
              navigatorKey: _tab0NavKey,
              defaultTitle: '主页',
              builder: (context) {
                return HomeTab();
              },
            );
          case 1:
            return CupertinoTabView(
              navigatorKey: _tab1NavKey,
              defaultTitle: '成绩',
              builder: (context) {
                return GradeTab();
              },
            );
          case 2:
            return CupertinoTabView(
              navigatorKey: _tab2NavKey,
              defaultTitle: '课表',
              builder: (context) {
                return ScheduleTab();
              },
            );
          case 3:
            return CupertinoTabView(
              navigatorKey: _tab3NavKey,
              defaultTitle: '账户',
              builder: (context) {
                return UserTab();
              },
            );
        }
        throw 'unreachable';
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // call updateCheck to ensure navigator exists in context
    updateCheck(context);
    doHotfix(context);
  }
}
