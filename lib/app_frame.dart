import 'package:after_layout/after_layout.dart';
import 'package:custed2/core/hotfix.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/core/update.dart';
import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/grade_tab/grade_legacy.dart';
import 'package:custed2/ui/home_tab/home_tab.dart';
import 'package:custed2/ui/schedule_tab/schedule_tab.dart';
import 'package:custed2/ui/user_tab/user_tab.dart';
import 'package:custed2/ui/widgets/snakebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppFrame extends StatefulWidget {
  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> with AfterLayoutMixin<AppFrame> {
  int _selectIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    GradeReportLegacy(),
    ScheduleTab(),
    UserTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
            child: Scaffold(
          body: _widgetOptions.elementAt(_selectIndex),
          bottomNavigationBar: _buildScaffold(context),
        )),
        Snakebar(),
      ],
    );
  }

  Widget _buildScaffold(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        _selectIndex = index;
      });
    }

    return BottomAppBar(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 25,
              ),
              title: Text('主页'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.pending_actions,
                size: 25,
              ),
              title: Text('成绩'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.schedule,
                size: 25,
              ),
              title: Text('课表'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 25,
              ),
              title: Text('账户'),
            ),
          ],
          currentIndex: _selectIndex,
          onTap: onItemTapped,
        ));
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
