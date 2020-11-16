import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/hotfix.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/core/update.dart';
import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/grade_tab/grade_legacy.dart';
import 'package:custed2/ui/home_tab/home_tab.dart';
import 'package:custed2/ui/schedule_tab/schedule_tab.dart';
import 'package:custed2/ui/nav_tab/nav_tab.dart';
import 'package:custed2/ui/user_tab/user_tab.dart';
import 'package:custed2/ui/widgets/snakebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _tab4NavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

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
      case 4:
        return _tab4NavKey;
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
    bool isAndroid = Platform.isAndroid;

    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        currentIndex: app.tabIndex,
        onTap: (n) {
          app.setTab(n, refresh: false);
        },
        items: [
          BottomNavigationBarItem(
            icon: isAndroid
                ? Icon(Icons.home, size: 27)
                : Icon(CupertinoIcons.home, size: 27)
            ,
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: isAndroid
                ? Icon(Icons.navigation, size: 26)
                : Icon(
                const IconData(
                  0xf428,
                  fontFamily: 'CupertinoIcons',
                  fontPackage: 'cupertino_icons',
                ), size: 34
            ),
            label: '导航',
          ),
          BottomNavigationBarItem(
            icon: isAndroid
                ? Icon(Icons.bar_chart, size: 31)
                : Icon(CupertinoIcons.tags, size: 25)
            ,
            label: '成绩',
          ),
          BottomNavigationBarItem(
            icon: isAndroid
                ? Icon(Icons.calendar_today, size: 23)
                : Icon(CupertinoIcons.bell, size: 27)
            ,
            label: '课表',
          ),
          BottomNavigationBarItem(
            icon: isAndroid
                ? Icon(Icons.settings,size: 27)
                : Icon(CupertinoIcons.settings, size: 27)
            ,
            label: '账户',
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
              defaultTitle: '导航',
              builder: (context) {
                return NavTab();
              },
            );
          case 2:
            return CupertinoTabView(
              navigatorKey: _tab2NavKey,
              defaultTitle: '成绩',
              builder: (context) {
                return GradeReportLegacy();
              },
            );
          case 3:
            return CupertinoTabView(
              navigatorKey: _tab3NavKey,
              defaultTitle: '课表',
              builder: (context) {
                return ScheduleTab();
              },
            );
          case 4:
            return CupertinoTabView(
              navigatorKey: _tab4NavKey,
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
    if (BuildMode.isDebug) {
      print('Debug mode detected, create interface by default.');
      locator<TTYExecuter>().execute('(debug)', context, quiet: true);
    }

    // call updateCheck to ensure navigator exists in context
    updateCheck(context);

    doHotfix(context);
  }
}
