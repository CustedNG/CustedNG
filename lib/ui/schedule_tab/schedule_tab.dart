import 'package:custed2/ui/schedule_tab/schedule_menu.dart';
import 'package:custed2/ui/schedule_tab/schedule_week_selector.dart';
import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:custed2/ui/widgets/navbar/title.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';

class ScheduleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavBarTitle(child: Text('课表')),
        middle: _buildNavbarMiddle(context),
        trailing: NavBarMoreBtn(
          onTap: () => _showMenu(context),
        ),
      ),
      child: ListView(
        children: <Widget>[
          ScheduleWeekSelector(),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 150),
                PlaceholderWidget('无课表信息')
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => ScheduleMenu(),
    );
  }

  Widget _buildNavbarMiddle(BuildContext context) {
    return NavbarMiddle(
      textAbove: '上次更新',
      textBelow: '今天 16:18',
    );
  }
}
